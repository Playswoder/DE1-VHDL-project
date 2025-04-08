library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stopwatch_logic is
    port (
        clk       : in  std_logic; -- Clock 10 ns
        reset     : in  std_logic; -- Global reset
        mode : in  std_logic_vector(2 downto 0); -- Defines wheter or it should count and react to buttons (Mode = 2 to count and react)
        start_stop: in  std_logic; -- Toggle signal/pulse for start/stop
        svv: out std_logic_vector(7 downto 0); -- Centiseconds (00-99)
        sss: out std_logic_vector(7 downto 0); -- Seconds (00-59)
        smm: out std_logic_vector(7 downto 0)  -- Minutes (00-59)
    );
end entity stopwatch_logic;

architecture behavioral of stopky is

begin

        -- Constants for counter limits
    -- NOTE: To get a 1 centisecond (1/100 s) tick from a 100 MHz clock (10 ns period),
    -- we need to count: 10 ms / 10 ns = 0.01 s / (10e-9 s) = 1,000,000 cycles.
    constant CENTISECOND_TC : natural := 1_000_000; -- Terminal Count for 10ms tick
    constant CS_LIMIT      : natural := 99;
    constant SEC_MIN_LIMIT : natural := 59;

    -- Internal signals for counters
    signal cs_reg : unsigned(7 downto 0) := (others => '0'); -- Centiseconds register
    signal s_reg  : unsigned(7 downto 0) := (others => '0'); -- Seconds register
    signal m_reg  : unsigned(7 downto 0) := (others => '0'); -- Minutes register

    -- Internal signals for control logic
    signal running         : std_logic := '0'; -- Internal state: '1' = counting, '0' = stopped
    signal start_stop_prev : std_logic := '0'; -- Previous state of start_stop for edge detection
    signal enable_counting : std_logic := '0'; -- Derived from mode input

    -- Internal signals for tick generation
    signal clk_counter     : natural range 0 to CENTISECOND_TC - 1 := 0;
    signal centisecond_tick: std_logic := '0'; -- Pulse generated every centisecond   

begin

    -- Determine if the stopwatch logic should be active based on mode
    enable_counting <= '1' when mode = "010" else '0';

    -- Process for Start/Stop Control Logic
    control_proc : process(clk, reset)
    begin
        if reset = '1' then
            running <= '0';
            start_stop_prev <= '0';
        elsif rising_edge(clk) then
            -- Store previous start_stop state for edge detection
            start_stop_prev <= start_stop;
            
            -- Check if mode enables operation
            if enable_counting = '1' then
                -- Detect rising edge on start_stop
                if start_stop = '1' and start_stop_prev = '0' then
                    running <= not running; -- Toggle running state
                end if;
            else
                -- If mode is not "010", force stopwatch to stopped state
                running <= '0';
            end if;
        end if;
    end process control_proc;

    -- Process for generating the centisecond tick
    tick_gen_proc : process(clk, reset)
    begin
        if reset = '1' then
            clk_counter <= 0;
            centisecond_tick <= '0';
        elsif rising_edge(clk) then
            -- Default tick to '0'
            centisecond_tick <= '0';

            -- Only count clock cycles if the stopwatch is enabled and running
            if running = '1' then -- We only need the tick when running
                if clk_counter = CENTISECOND_TC - 1 then
                    clk_counter <= 0;
                    centisecond_tick <= '1'; -- Generate a 1-cycle tick
                else
                    clk_counter <= clk_counter + 1;
                end if;
            else
                 -- Reset clock counter when not running to start cleanly
                 clk_counter <= 0;
            end if;
        end if;
    end process tick_gen_proc;

    -- Process for the main stopwatch counters (cs, s, m)
    counter_proc : process(clk, reset)
    begin
        if reset = '1' then
            cs_reg <= (others => '0');
            s_reg  <= (others => '0');
            m_reg  <= (others => '0');
        elsif rising_edge(clk) then
            -- Only update counters on the centisecond tick when running
            if centisecond_tick = '1' and running = '1' then
                -- Increment Centiseconds
                if cs_reg = CS_LIMIT then
                    cs_reg <= (others => '0');
                    -- Increment Seconds
                    if s_reg = SEC_MIN_LIMIT then
                        s_reg <= (others => '0');
                        -- Increment Minutes
                        if m_reg = SEC_MIN_LIMIT then
                            m_reg <= (others => '0'); -- Rollover minutes
                        else
                            m_reg <= m_reg + 1;
                        end if;
                    else
                        s_reg <= s_reg + 1;
                    end if;
                else
                    cs_reg <= cs_reg + 1;
                end if;
            end if;
        end if;
    end process counter_proc;

    -- Assign internal counter registers to outputs (type conversion)
    svv <= std_logic_vector(cs_reg);
    sss <= std_logic_vector(s_reg);
    smm <= std_logic_vector(m_reg);

end architecture behavioral;

