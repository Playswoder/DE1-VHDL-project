library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alarm_logic is
    port (
        clk             : in std_logic; -- System clock for register updates
        reset           : in std_logic;
        -- Inputs from top level FSM / Buttons
        set_mode        : in std_logic; -- '1' when in alarm set mode
        inc_hour        : in std_logic; -- Pulse to increment alarm hour
        inc_minute      : in std_logic; -- Pulse to increment alarm minute
        alarm_enable_in : in std_logic; -- Level signal, '1' = alarm enabled
        -- Current Time Input (BCD)
        current_hh_bcd  : in std_logic_vector(7 downto 0);
        current_mm_bcd  : in std_logic_vector(7 downto 0);
        -- Outputs
        alarm_hh_bcd_out: out std_logic_vector(7 downto 0); -- For display during set mode
        alarm_mm_bcd_out: out std_logic_vector(7 downto 0); -- For display during set mode
        alarm_active_out: out std_logic -- Goes high when alarm should sound
    );
end entity alarm_logic;

architecture behavioral of alarm_logic is
    signal alarm_hh_reg : unsigned(7 downto 0) := (others => '0'); -- BCD
    signal alarm_mm_reg : unsigned(7 downto 0) := (others => '0'); -- BCD
    signal alarm_enabled_reg : std_logic := '0';
    signal match        : std_logic;

    -- Internal helper signals/variables for BCD increment (or use integer conversion)
    signal alarm_hh_tens, alarm_hh_units: integer range 0 to 9 := 0;
    signal alarm_mm_tens, alarm_mm_units: integer range 0 to 9 := 0;

begin
    -- Register for storing alarm time and enable status
    process(clk, reset)
    begin
        if reset = '1' then
            alarm_hh_tens <= 0; alarm_hh_units <= 0;
            alarm_mm_tens <= 0; alarm_mm_units <= 0;
            alarm_enabled_reg <= '0';
        elsif rising_edge(clk) then
            -- Latch enable signal
            alarm_enabled_reg <= alarm_enable_in;

            if set_mode = '1' then
                -- Increment Hour Logic (Handle 23->00 rollover)
                if inc_hour = '1' then
                    if alarm_hh_units = 9 then
                         alarm_hh_units <= 0;
                         if alarm_hh_tens = 2 then
                            alarm_hh_tens <= 0; -- 29 -> invalid, treat as 23->00? Simplification: go to 00
                         else
                            alarm_hh_tens <= alarm_hh_tens + 1;
                         end if;
                    elsif alarm_hh_tens = 2 and alarm_hh_units = 3 then -- at 23
                        alarm_hh_units <= 0;
                        alarm_hh_tens <= 0; -- rollover 23 -> 00
                    else
                        alarm_hh_units <= alarm_hh_units + 1;
                    end if;
                end if;

                -- Increment Minute Logic (Handle 59->00 rollover)
                if inc_minute = '1' then
                     if alarm_mm_units = 9 then
                         alarm_mm_units <= 0;
                         if alarm_mm_tens = 5 then
                            alarm_mm_tens <= 0; -- rollover 59 -> 00
                         else
                            alarm_mm_tens <= alarm_mm_tens + 1;
                         end if;
                    else
                        alarm_mm_units <= alarm_mm_units + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Combine internal digits to BCD register signals
    alarm_hh_reg <= to_unsigned(alarm_hh_tens, 4) & to_unsigned(alarm_hh_units, 4);
    alarm_mm_reg <= to_unsigned(alarm_mm_tens, 4) & to_unsigned(alarm_mm_units, 4);

    -- Output alarm time for display
    alarm_hh_bcd_out <= std_logic_vector(alarm_hh_reg);
    alarm_mm_bcd_out <= std_logic_vector(alarm_mm_reg);

    -- Alarm Match Comparison Logic (combinatorial)
    match <= '1' when (current_hh_bcd = std_logic_vector(alarm_hh_reg) and current_mm_bcd = std_logic_vector(alarm_mm_reg)) else '0';

    -- Alarm Output Logic (combinatorial or registered)
    alarm_active_out <= match and alarm_enabled_reg; -- Active only if time matches AND enabled

end architecture behavioral;