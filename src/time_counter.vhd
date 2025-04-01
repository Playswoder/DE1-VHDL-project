library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity time_counter is
    port (
        clk         : in  std_logic; -- Should be the 1Hz tick signal
        reset       : in  std_logic;
        -- Add load inputs if time setting is implemented
        -- load_en   : in std_logic;
        -- hh_in     : in unsigned(7 downto 0); -- BCD HH
        -- mm_in     : in unsigned(7 downto 0); -- BCD MM
        -- ss_in     : in unsigned(7 downto 0); -- BCD SS
        hh_bcd_out  : out std_logic_vector(7 downto 0); -- HH (BCD: H_tens, H_units)
        mm_bcd_out  : out std_logic_vector(7 downto 0); -- MM (BCD: M_tens, M_units)
        ss_bcd_out  : out std_logic_vector(7 downto 0)  -- SS (BCD: S_tens, S_units)
    );
end entity time_counter;

architecture behavioral of time_counter is
    signal ss_tens, ss_units : integer range 0 to 9 := 0;
    signal mm_tens, mm_units : integer range 0 to 9 := 0;
    signal hh_tens, hh_units : integer range 0 to 9 := 0;

begin
    process(clk, reset)
    begin
        if reset = '1' then
            ss_tens <= 0; ss_units <= 0;
            mm_tens <= 0; mm_units <= 0;
            hh_tens <= 0; hh_units <= 0;
        elsif rising_edge(clk) then -- Use the 1Hz TICK signal here!
            -- Increment Seconds
            if ss_units = 9 then
                ss_units <= 0;
                if ss_tens = 5 then
                    ss_tens <= 0;
                    -- Increment Minutes
                    if mm_units = 9 then
                        mm_units <= 0;
                        if mm_tens = 5 then
                            mm_tens <= 0;
                            -- Increment Hours
                            if hh_units = 9 then
                                hh_units <= 0;
                                if hh_tens = 2 then -- Rollover at 23:59:59
                                   hh_tens <= 0; -- Actually 23->00
                                else
                                   hh_tens <= hh_tens + 1;
                                end if;
                            elsif hh_tens = 2 and hh_units = 3 then -- Check for 23
                                hh_units <= 0;
                                hh_tens <= 0; -- Rollover 23 -> 00
                            else
                                hh_units <= hh_units + 1;
                            end if;
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
            -- Add load logic here if implementing time set
            -- if load_en = '1' then ... load hh_in, mm_in, ss_in ...
        end if;
    end process;

    -- Convert internal integer digits to BCD std_logic_vector outputs
    ss_bcd_out <= std_logic_vector(to_unsigned(ss_tens, 4)) & std_logic_vector(to_unsigned(ss_units, 4));
    mm_bcd_out <= std_logic_vector(to_unsigned(mm_tens, 4)) & std_logic_vector(to_unsigned(mm_units, 4));
    hh_bcd_out <= std_logic_vector(to_unsigned(hh_tens, 4)) & std_logic_vector(to_unsigned(hh_units, 4));

end architecture behavioral;