LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_Alarm IS
END tb_Alarm;

ARCHITECTURE tb OF tb_Alarm IS

	COMPONENT Alarm
		PORT (
			hh : IN std_logic_vector (7 DOWNTO 0);
			mm : IN std_logic_vector (7 DOWNTO 0);
			mode : IN std_logic_vector (1 DOWNTO 0);
			A : IN std_logic;
			B : IN std_logic;
			CLK100MHZ : IN std_logic;
			ahh : OUT std_logic_vector (7 DOWNTO 0);
			amm : OUT std_logic_vector (7 DOWNTO 0);
			alarm_out : OUT std_logic
		);
	END COMPONENT;

	SIGNAL hh : std_logic_vector (7 DOWNTO 0);
	SIGNAL mm : std_logic_vector (7 DOWNTO 0);
	SIGNAL mode : std_logic_vector (1 DOWNTO 0);
	SIGNAL A : std_logic;
	SIGNAL B : std_logic;
	SIGNAL CLK100MHZ : std_logic;
	SIGNAL ahh : std_logic_vector (7 DOWNTO 0);
	SIGNAL amm : std_logic_vector (7 DOWNTO 0);
	SIGNAL alarm_out : std_logic;

	CONSTANT TbPeriod : TIME := 10 ns; -- ***EDIT*** Put right period here
	SIGNAL TbClock : std_logic := '0';
	SIGNAL TbSimEnded : std_logic := '0';

BEGIN
	dut : Alarm
	PORT MAP(
		hh => hh, 
		mm => mm, 
		mode => mode, 
		A => A, 
		B => B, 
		CLK100MHZ => CLK100MHZ, 
		ahh => ahh, 
		amm => amm, 
		alarm_out => alarm_out
	);

	-- Clock generation
	TbClock <= NOT TbClock AFTER TbPeriod/2 WHEN TbSimEnded /= '1' ELSE '0';

	-- ***EDIT*** Check that CLK100MHZ is really your main clock signal
	CLK100MHZ <= TbClock;

	stimuli : PROCESS
	BEGIN
		-- ***EDIT*** Adapt initialization as needed
		hh <= (OTHERS => '0');
		mm <= (OTHERS => '0');
		mode <= (OTHERS => '0');
		A <= '0';
		B <= '0';

		-- ***EDIT*** Add stimuli here
		WAIT FOR 30 ns;
 
		REPORT "==== START ====";

		WAIT FOR 30 ns;
 
		mode <= "01"; -- mode ====================
		A <= '1';
 
 
		WAIT FOR 5 ns;
 
		B <= '1';
 
		WAIT FOR 5 ns;
 
		A <= '0';
 
		WAIT FOR 5 ns;
 
		B <= '0';
 
		WAIT FOR 30 ns;
 
		B <= '1';
 
		WAIT FOR 10 ns;
 
		B <= '0';
 
		WAIT FOR 30 ns;
 
		B <= '1';
 
		WAIT FOR 10 ns;
 
		B <= '0';
		hh <= "00000000";
		mm <= "00000010";
 
		WAIT FOR 200 ns;
 
		mm <= "00000011";
 
		WAIT FOR 30 ns;

		mode <= "10"; -- mode =====================
 
		WAIT FOR 30 ns;
 
		A <= '1';
		mm <= "00000010";
 
		WAIT FOR 30 ns;
 
		B <= '1';
 
		WAIT FOR 30 ns;
 
		A <= '0';
 
		WAIT FOR 30 ns;
 
		B <= '0';
 
		mode <= "01"; -- mode ======================
 
		WAIT FOR 30 ns;
 
		A <= '1';
 
		WAIT FOR 10 ns;
 
		A <= '0';

		REPORT "==== STOP ====";
		WAIT;
 
 
 
 
 
 
 
 

		-- Stop the clock and hence terminate the simulation
		TbSimEnded <= '1';
		WAIT;
	END PROCESS;

	END tb;

	-- Configuration block below is required by some simulators. Usually no need to edit.

	CONFIGURATION cfg_tb_Alarm OF tb_Alarm IS
		FOR tb
		END FOR;
END cfg_tb_Alarm;