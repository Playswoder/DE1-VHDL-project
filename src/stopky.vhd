library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stopwatch_logic is
    port (
        clk        : in  std_logic; -- Clock 10 ns
        reset      : in  std_logic; -- Global reset
        mode       : in  std_logic_vector(1 downto 0); -- Mode: "10" for counting
        start_stop : in  std_logic; -- Toggle signal for start/stop
        svv        : out std_logic_vector(6 downto 0); -- Centiseconds (00-99)
        sss        : out std_logic_vector(5 downto 0); -- Seconds (00-59)
        smm        : out std_logic_vector(5 downto 0)  -- Minutes (00-59)
    );
end entity stopwatch_logic;

architecture behavioral of stopwatch_logic is -- Fixed name match

    -- Constants for counter limits
    constant CENTISECOND_TC : natural := 1_000_000; -- 1 centisecond tick
    constant CS_LIMIT       : natural := 99;
    constant SEC_MIN_LIMIT  : natural := 59;

    -- Internal counter signals
    signal cs_reg : unsigned(6 downto 0) := (others => '0');
    signal s_reg  : unsigned(5 downto 0) := (others => '0');
    signal m_reg  : unsigned(5 downto 0) := (others => '0');

    -- Control signals
    signal running         : std_logic := '0';
    signal start_stop_prev : std_logic := '0';
    signal enable_counting : std_logic := '0';

    -- Tick generation signals
    signal clk_counter      : natural range 0 to CENTISECOND_TC - 1 := 0;
    signal centisecond_tick : std_logic := '0';

begin

    -- Enable counting logic
    enable_counting <= '1' when mode = "10" else '0';

    -- Start/Stop Control Logic
    control_proc : process(clk, reset)
    begin
        if reset = '1' then
            running <= '0';
            start_stop_prev <= '0';
        elsif rising_edge(clk) then
            start_stop_prev <= start_stop; -- Edge detection
            if enable_counting = '1' then
                if start_stop = '1' and start_stop_prev = '0' then
                    running <= not running; -- Toggle state
                end if;
            else
                running <= '0';
            end if;
        end if;
    end process control_proc;

    -- Tick generation process
    tick_gen_proc : process(clk, reset)
    begin
        if reset = '1' then
            clk_counter <= 0;
            centisecond_tick <= '0';
        elsif rising_edge(clk) then
            centisecond_tick <= '0';
            if running = '1' then
                if clk_counter = CENTISECOND_TC - 1 then
                    clk_counter <= 0;
                    centisecond_tick <= '1';
                else
                    clk_counter <= clk_counter + 1;
                end if;
            else
                clk_counter <= 0;
            end if;
        end if;
    end process tick_gen_proc;

    -- Stopwatch counter logic
    counter_proc : process(clk, reset)
    begin
        if reset = '1' then
            cs_reg <= (others => '0');
            s_reg  <= (others => '0');
            m_reg  <= (others => '0');
        elsif rising_edge(clk) then
            if centisecond_tick = '1' and running = '1' then
                if cs_reg = CS_LIMIT then
                    cs_reg <= (others => '0');
                    if s_reg = SEC_MIN_LIMIT then
                        s_reg <= (others => '0');
                        if m_reg = SEC_MIN_LIMIT then
                            m_reg <= (others => '0');
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

    -- Assign outputs
    svv <= std_logic_vector(cs_reg);
    sss <= std_logic_vector(s_reg);
    smm <= std_logic_vector(m_reg);

end architecture behavioral;
