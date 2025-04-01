library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stopwatch_logic is
    port (
        clk       : in  std_logic; -- Should be the 100Hz tick signal
        reset     : in  std_logic; -- Global reset
        sw_reset  : in  std_logic; -- Specific stopwatch reset pulse
        start_stop: in  std_logic; -- Toggle signal/pulse for start/stop
        cs_bcd_out: out std_logic_vector(7 downto 0); -- Centiseconds (00-99)
        ss_bcd_out: out std_logic_vector(7 downto 0); -- Seconds (00-59)
        mm_bcd_out: out std_logic_vector(7 downto 0)  -- Minutes (00-59)
    );
end entity stopwatch_logic;

architecture behavioral of stopwatch_logic is
    signal running    : std_logic := '0';
    signal cs_tens, cs_units : integer range 0 to 9 := 0; -- 00-99
    signal ss_tens, ss_units : integer range 0 to 9 := 0; -- 00-59
    signal mm_tens, mm_units : integer range 0 to 9 := 0; -- 00-59

begin
    process(clk, reset, start_stop) -- Use clock tick (100Hz)
    begin
        if reset = '1' or sw_reset = '1' then
            cs_tens <= 0; cs_units <= 0;
            ss_tens <= 0; ss_units <= 0;
            mm_tens <= 0; mm_units <= 0;
            running <= '0';
        elsif rising_edge(clk) then -- Use 100Hz TICK signal!

            -- Toggle running state on start_stop pulse (needs careful implementation)
            -- This simple toggle might need debouncing/edge detection on start_stop input
            if start_stop = '1' then -- Assuming start_stop is a clean pulse
                 running <= not running;
            end if;

            if running = '1' then
                -- Increment Centiseconds
                if cs_units = 9 then
                    cs_units <= 0;
                    if cs_tens = 9 then
                        cs_tens <= 0;
                        -- Increment Seconds
                        if ss_units = 9 then
                           ss_units <= 0;
                           if ss_tens = 5 then
                              ss_tens <= 0;
                              -- Increment Minutes
                               if mm_units = 9 then
                                   mm_units <= 0;
                                   if mm_tens = 5 then
                                      mm_tens <= 0; -- Stop at 59:59.99 or wrap? Wrap here.
                                   else
                                      mm_tens <= mm_tens + 1;
                                   end if;
                               else
                                   mm_units <= mm_units + 1;
                               end if;
                           else
                              ss_tens <= ss_tens + 1;
                           end if;
                        else
                            ss_units <= ss_units + 1;
                        end if;
                    else
                        cs_tens <= cs_tens + 1;
                    end if;
                else
                    cs_units <= cs_units + 1;
                end if;
            end if; -- end if running
        end if; -- end rising_edge(clk)
    end process;

    -- BCD Outputs
    cs_bcd_out <= std_logic_vector(to_unsigned(cs_tens, 4)) & std_logic_vector(to_unsigned(cs_units, 4));
    ss_bcd_out <= std_logic_vector(to_unsigned(ss_tens, 4)) & std_logic_vector(to_unsigned(ss_units, 4));
    mm_bcd_out <= std_logic_vector(to_unsigned(mm_tens, 4)) & std_logic_vector(to_unsigned(mm_units, 4));

end architecture behavioral;