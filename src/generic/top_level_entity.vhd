library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity digital_clock_stopwatch_alarm is
    port (
        -- System Inputs
        clk_in      : in  std_logic; -- Main clock (e.g., 50MHz)
        reset_in    : in  std_logic; -- Main reset button
        -- Control Buttons (Assume Active High after debouncing)
        btn_mode        : in std_logic; -- Cycle through modes
        btn_inc_start   : in std_logic; -- Increment / Stopwatch Start/Stop
        btn_dec_reset   : in std_logic; -- Decrement / Stopwatch Reset
        btn_alarm_en    : in std_logic; -- Enable/Disable Alarm toggle
        -- Outputs
        segment_out : out std_logic_vector(6 downto 0); -- To 7-seg segments (a-g)
        anode_out   : out std_logic_vector(5 downto 0); -- To 6 digit anodes (active low)
        alarm_led   : out std_logic  -- Output for alarm indicator
    );
end entity digital_clock_stopwatch_alarm;

architecture structure of digital_clock_stopwatch_alarm is

    -- Component Declarations for all sub-modules...
    component clk_divider is -- ports...
    end component;
    component time_counter is -- ports...
    end component;
    component alarm_logic is -- ports...
    end component;
    component stopwatch_logic is -- ports...
    end component;
    component button_debouncer is -- ports...
    end component;
    component display_multiplexer is -- ports...
    end component;

    -- Internal Signals
    signal clk_1Hz, clk_100Hz, clk_mux : std_logic; -- From clk_divider
    signal reset_sync : std_logic; -- Synchronized reset

    -- Debounced Button Signals (Pulses or Levels depending on debouncer output)
    signal btn_mode_db, btn_inc_start_db, btn_dec_reset_db, btn_alarm_en_db : std_logic;

    -- Time Counter Outputs (BCD)
    signal time_hh_bcd, time_mm_bcd, time_ss_bcd : std_logic_vector(7 downto 0);

    -- Alarm Logic Signals
    signal alarm_set_mode   : std_logic := '0';
    signal alarm_inc_hour   : std_logic := '0';
    signal alarm_inc_minute : std_logic := '0';
    signal alarm_enable     : std_logic := '0'; -- Registered enable signal
    signal alarm_hh_set_bcd, alarm_mm_set_bcd : std_logic_vector(7 downto 0);
    signal alarm_active     : std_logic;

    -- Stopwatch Logic Signals
    signal sw_start_stop    : std_logic := '0'; -- Pulse signal
    signal sw_reset         : std_logic := '0'; -- Pulse signal
    signal sw_cs_bcd, sw_ss_bcd, sw_mm_bcd : std_logic_vector(7 downto 0);

    -- Display Multiplexer Inputs
    signal disp_dig5, disp_dig4, disp_dig3, disp_dig2, disp_dig1, disp_dig0 : std_logic_vector(3 downto 0);

    -- Mode Control State Machine
    type T_MODE is (MODE_CLOCK, MODE_ALARM_SET_H, MODE_ALARM_SET_M, MODE_STOPWATCH);
    signal current_mode : T_MODE := MODE_CLOCK;

begin

    -- Reset Synchronizer (Simple 2-FF synchronizer recommended)
    -- ... VHDL for synchronizer ... assign to reset_sync

    -- Instantiate Clock Divider
    divider_inst : clk_divider
        generic map ( CLK_IN_HZ => 50_000_000 ) -- Adjust as needed
        port map (
            clk_in => clk_in, reset => reset_sync,
            clk_1Hz_out => clk_1Hz, -- Use tick output if available/preferred
            clk_100Hz_out => clk_100Hz, -- Use tick output if available/preferred
            clk_mux_out => clk_mux -- Use tick output if available/preferred
        );

    -- Instantiate Button Debouncers (one for each button)
    debounce_mode : button_debouncer port map (clk=>clk_in, reset=>reset_sync, button_in=>btn_mode, button_out=>btn_mode_db);
    debounce_inc_start : button_debouncer port map (clk=>clk_in, reset=>reset_sync, button_in=>btn_inc_start, button_out=>btn_inc_start_db);
    debounce_dec_reset : button_debouncer port map (clk=>clk_in, reset=>reset_sync, button_in=>btn_dec_reset, button_out=>btn_dec_reset_db);
    debounce_alarm_en : button_debouncer port map (clk=>clk_in, reset=>reset_sync, button_in=>btn_alarm_en, button_out=>btn_alarm_en_db);

    -- Instantiate Time Counter
    time_counter_inst : time_counter
        port map (
            clk => clk_1Hz, reset => reset_sync, -- Connect 1Hz tick!
            hh_bcd_out => time_hh_bcd, mm_bcd_out => time_mm_bcd, ss_bcd_out => time_ss_bcd
        );

    -- Instantiate Alarm Logic
    alarm_logic_inst : alarm_logic
        port map (
            clk => clk_in, reset => reset_sync, -- Use system clock for internal registers
            set_mode => alarm_set_mode, inc_hour => alarm_inc_hour, inc_minute => alarm_inc_minute,
            alarm_enable_in => alarm_enable, -- Connect registered enable signal
            current_hh_bcd => time_hh_bcd, current_mm_bcd => time_mm_bcd,
            alarm_hh_bcd_out => alarm_hh_set_bcd, alarm_mm_bcd_out => alarm_mm_set_bcd,
            alarm_active_out => alarm_active
        );

    -- Instantiate Stopwatch Logic
    stopwatch_inst : stopwatch_logic
        port map (
            clk => clk_100Hz, reset => reset_sync, -- Connect 100Hz tick!
            sw_reset => sw_reset, start_stop => sw_start_stop,
            cs_bcd_out => sw_cs_bcd, ss_bcd_out => sw_ss_bcd, mm_bcd_out => sw_mm_bcd
        );

    -- Instantiate Display Multiplexer
    display_mux_inst : display_multiplexer
        generic map ( NUM_DIGITS => 6 )
        port map (
            clk => clk_mux, reset => reset_sync, -- Connect MUX clock tick!
            digit5_bcd => disp_dig5, digit4_bcd => disp_dig4, digit3_bcd => disp_dig3,
            digit2_bcd => disp_dig2, digit1_bcd => disp_dig1, digit0_bcd => disp_dig0,
            anode_select => anode_out, segment_out => segment_out
        );

    -- Mode Control State Machine and Logic Process
    process(clk_in, reset_sync)
    begin
        if reset_sync = '1' then
            current_mode <= MODE_CLOCK;
            alarm_enable <= '0';
            -- Reset pulse signals
            alarm_inc_hour <= '0';
            alarm_inc_minute <= '0';
            sw_start_stop <= '0';
            sw_reset <= '0';
            alarm_set_mode <= '0';

        elsif rising_edge(clk_in) then
            -- Default assignments (important for pulse generation)
            alarm_inc_hour <= '0';
            alarm_inc_minute <= '0';
            sw_start_stop <= '0';
            sw_reset <= '0';
            alarm_set_mode <= '0';

            -- Register alarm enable toggle
            if btn_alarm_en_db = '1' then -- Assumes debouncer gives a pulse
                alarm_enable <= not alarm_enable;
            end if;

            -- State Transitions
            if btn_mode_db = '1' then -- Assumes debouncer gives a pulse
                case current_mode is
                    when MODE_CLOCK => current_mode <= MODE_ALARM_SET_H;
                    when MODE_ALARM_SET_H => current_mode <= MODE_ALARM_SET_M;
                    when MODE_ALARM_SET_M => current_mode <= MODE_STOPWATCH;
                    when MODE_STOPWATCH => current_mode <= MODE_CLOCK;
                end case;
            end if;

            -- Actions within States
            case current_mode is
                when MODE_CLOCK =>
                    -- No specific actions on inc/dec buttons in this simple version
                    alarm_set_mode <= '0';

                when MODE_ALARM_SET_H =>
                    alarm_set_mode <= '1';
                    if btn_inc_start_db = '1' then
                        alarm_inc_hour <= '1'; -- Generate pulse for alarm logic
                    end if;
                    -- Add decrement logic if btn_dec_reset is used for that

                when MODE_ALARM_SET_M =>
                    alarm_set_mode <= '1';
                     if btn_inc_start_db = '1' then
                        alarm_inc_minute <= '1'; -- Generate pulse for alarm logic
                    end if;
                    -- Add decrement logic if btn_dec_reset is used for that

                when MODE_STOPWATCH =>
                     alarm_set_mode <= '0';
                     if btn_inc_start_db = '1' then
                         sw_start_stop <= '1'; -- Pulse to stopwatch start/stop logic
                     end if;
                     if btn_dec_reset_db = '1' then
                         sw_reset <= '1'; -- Pulse to stopwatch reset logic
                     end if;
            end case;
        end if;
    end process;

    -- Display Data Selector (Combinatorial)
    process(current_mode, time_hh_bcd, time_mm_bcd, time_ss_bcd,
            alarm_hh_set_bcd, alarm_mm_set_bcd,
            sw_mm_bcd, sw_ss_bcd, sw_cs_bcd)
    begin
        -- Default to showing current time
        disp_dig5 <= time_hh_bcd(7 downto 4); -- H tens
        disp_dig4 <= time_hh_bcd(3 downto 0); -- H units
        disp_dig3 <= time_mm_bcd(7 downto 4); -- M tens
        disp_dig2 <= time_mm_bcd(3 downto 0); -- M units
        disp_dig1 <= time_ss_bcd(7 downto 4); -- S tens
        disp_dig0 <= time_ss_bcd(3 downto 0); -- S units

        case current_mode is
            when MODE_CLOCK =>
                 -- Already set by default
                 null;
            when MODE_ALARM_SET_H | MODE_ALARM_SET_M => -- Show alarm time when setting
                disp_dig5 <= alarm_hh_set_bcd(7 downto 4);
                disp_dig4 <= alarm_hh_set_bcd(3 downto 0);
                disp_dig3 <= alarm_mm_set_bcd(7 downto 4);
                disp_dig2 <= alarm_mm_set_bcd(3 downto 0);
                disp_dig1 <= "1010"; -- Display 'A' for Alarm Tens
                disp_dig0 <= "1010"; -- Display 'A' for Alarm Units (or similar indication)
                -- Could add blinking logic here for H or M digits being set.
            when MODE_STOPWATCH =>
                disp_dig5 <= sw_mm_bcd(7 downto 4); -- SW M tens
                disp_dig4 <= sw_mm_bcd(3 downto 0); -- SW M units
                disp_dig3 <= sw_ss_bcd(7 downto 4); -- SW S tens
                disp_dig2 <= sw_ss_bcd(3 downto 0); -- SW S units
                disp_dig1 <= sw_cs_bcd(7 downto 4); -- SW CS tens
                disp_dig0 <= sw_cs_bcd(3 downto 0); -- SW CS units
        end case;
    end process;

    -- Connect alarm output to LED (can add blinking logic if desired)
    alarm_led <= alarm_active;

end architecture structure;