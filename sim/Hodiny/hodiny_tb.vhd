LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY hodiny_tb IS
END ENTITY hodiny_tb;

ARCHITECTURE Behavioral OF hodiny_tb IS

	COMPONENT hodiny

		PORT (
			clk100MHz : IN std_logic;
			A : IN std_logic;
			B : IN std_logic;
			C : IN std_logic;
			mode : IN std_logic_vector(1 DOWNTO 0) := "00";
			HH : OUT std_logic_vector(7 DOWNTO 0);
			MM : OUT std_logic_vector(7 DOWNTO 0);
			SS : OUT std_logic_vector(7 DOWNTO 0)
		);
	END COMPONENT;
 
	SIGNAL clk100MHz_tb : std_logic := '0';
	SIGNAL A_tb : std_logic := '0';
	SIGNAL B_tb : std_logic := '0';
	SIGNAL C_tb : std_logic := '0';
	SIGNAL HH_tb : std_logic_vector(7 DOWNTO 0);
	SIGNAL MM_tb : std_logic_vector(7 DOWNTO 0);
	SIGNAL SS_tb : std_logic_vector(7 DOWNTO 0);

 
	CONSTANT clk_period : TIME := 10 ns;
BEGIN
	uut : hodiny
	PORT MAP(
		clk100MHz => clk100MHz_tb, 
		A => A_tb, 
		B => B_tb, 
		C => C_tb, 
 
		HH => HH_tb, 
		MM => MM_tb, 
		SS => SS_tb
	);
 

 
	clk_process : PROCESS
	BEGIN
		LOOP
		clk100MHz_tb <= '0';
		WAIT FOR clk_period / 2;
		clk100MHz_tb <= '1';
		WAIT FOR clk_period / 2;
	END LOOP;
	END PROCESS;

 
	stimulus_process : PROCESS
	BEGIN
		A_tb <= '0';
		B_tb <= '0';
		C_tb <= '0';
		WAIT FOR 20 ns;

		WAIT FOR 5000 ms;

		C_tb <= '1';
		WAIT FOR clk_period;
		C_tb <= '0';
		WAIT FOR 20 ns;

		FOR i IN 1 TO 5 LOOP
			A_tb <= '1';
			WAIT FOR clk_period;
			A_tb <= '0';
			WAIT FOR 2 * clk_period;
		END LOOP;
		WAIT FOR 1000 ms;
 
		A_tb <= '1';
		WAIT FOR 5 * clk_period;
		A_tb <= '0';

		B_tb <= '1';
		WAIT FOR clk_period;
		B_tb <= '0';
		WAIT FOR 2 * clk_period;
		WAIT FOR 1000 ms;

		C_tb <= '1';
		WAIT FOR clk_period;
		C_tb <= '0';
		WAIT FOR 5000 ms;
 
		WAIT;

 
	END PROCESS;
END ARCHITECTURE Behavioral;