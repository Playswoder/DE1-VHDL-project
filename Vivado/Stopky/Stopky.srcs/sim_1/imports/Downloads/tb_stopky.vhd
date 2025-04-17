library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_stopwatch_logic is
end entity tb_stopwatch_logic;

architecture sim of tb_stopwatch_logic is

    -- Component declaration for stopwatch_logic
    component stopwatch_logic
        port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            mode      : in  std_logic_vector(1 downto 0);
            start_stop: in  std_logic;
            svv       : out std_logic_vector(7 downto 0);
            sss       : out std_logic_vector(7 downto 0);
            smm       : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Testbench signals
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal mode      : std_logic_vector(1 downto 0) := "00";
    signal start_stop: std_logic := '0';
    signal svv       : std_logic_vector(7 downto 0);
    signal sss       : std_logic_vector(7 downto 0);
    signal smm       : std_logic_vector(7 downto 0);

    -- Clock period constant (10 ns)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate stopwatch_logic
    uut: stopwatch_logic
        port map (
            clk       => clk,
            reset     => reset,
            mode      => mode,
            start_stop=> start_stop,
            svv       => svv,
            sss       => sss,
            smm       => smm
        );

    -- Clock generation
    clk_gen: process
    begin
        while true loop
            clk <= not clk;
            wait for clk_period / 2;
        end loop;
    end process clk_gen;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset and initialize signals
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        -- Set mode to enable counting
        mode <= "10";

	   wait for 1 ms;

        -- Toggle start/stop signal t   o start the stopwatch
        start_stop <= '1';
        wait for clk_period * 2;
        start_stop <= '0';

        -- Observe the output for a short time
        -- End simulation
        wait;
    end process stim_proc;

end architecture sim;
