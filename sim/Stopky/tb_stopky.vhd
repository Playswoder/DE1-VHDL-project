LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_stopwatch_logic IS
END ENTITY tb_stopwatch_logic;

ARCHITECTURE sim OF tb_stopwatch_logic IS

	-- Component declaration for stopwatch_logic
	COMPONENT stopwatch_logic
		PORT (
			clk : IN std_logic;
			reset : IN std_logic;
			mode : IN std_logic_vector(1 DOWNTO 0);
			start_stop : IN std_logic;
			svv : OUT std_logic_vector(7 DOWNTO 0);
			sss : OUT std_logic_vector(7 DOWNTO 0);
			smm : OUT std_logic_vector(7 DOWNTO 0)
		);
	END COMPONENT;

	-- Testbench signals
	SIGNAL clk : std_logic := '0';
	SIGNAL reset : std_logic := '0';
	SIGNAL mode : std_logic_vector(1 DOWNTO 0) := "00";
	SIGNAL start_stop : std_logic := '0';
	SIGNAL svv : std_logic_vector(7 DOWNTO 0);
	SIGNAL sss : std_logic_vector(7 DOWNTO 0);
	SIGNAL smm : std_logic_vector(7 DOWNTO 0);

	-- Clock period constant (10 ns)
	CONSTANT clk_period : TIME := 10 ns;

BEGIN
	-- Instantiate stopwatch_logic
	uut : stopwatch_logic
	PORT MAP(
		clk => clk, 
		reset => reset, 
		mode => mode, 
		start_stop => start_stop, 
		svv => svv, 
		sss => sss, 
		smm => smm
	);

	-- Clock generation
	clk_gen : PROCESS
	BEGIN
		WHILE true LOOP
		clk <= NOT clk;
		WAIT FOR clk_period / 2;
	END LOOP;
	END PROCESS clk_gen;

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
		-- Reset and initialize signals
		reset <= '1';
		WAIT FOR 20 ns;
		reset <= '0';
 
		-- Set mode to enable counting
		mode <= "10";

		WAIT FOR 1 ms;

		-- Toggle start/stop signal to start the stopwatch
		start_stop <= '1';
		WAIT FOR clk_period * 2;
		start_stop <= '0';

		-- Observe the output for a short time
		WAIT FOR 21 ms;
		reset <= '1';
		WAIT FOR 20 ns;
		reset <= '0';
		-- End simulation
		WAIT;
	END PROCESS stim_proc;

END ARCHITECTURE sim;