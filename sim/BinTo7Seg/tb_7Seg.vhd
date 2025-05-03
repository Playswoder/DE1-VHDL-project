LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_BinTo7seg IS
END tb_BinTo7seg;

ARCHITECTURE tb OF tb_BinTo7seg IS

	COMPONENT BinTo7seg
		PORT (
			clk : IN std_logic;
			HH : IN std_logic_vector (7 DOWNTO 0);
			MM : IN std_logic_vector (7 DOWNTO 0);
			SS : IN std_logic_vector (7 DOWNTO 0);
			seg : OUT std_logic_vector (6 DOWNTO 0);
			POS_OUT : OUT std_logic_vector (7 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL clk : std_logic;
	SIGNAL HH : std_logic_vector (7 DOWNTO 0);
	SIGNAL MM : std_logic_vector (7 DOWNTO 0);
	SIGNAL SS : std_logic_vector (7 DOWNTO 0);
	SIGNAL seg : std_logic_vector (6 DOWNTO 0);
	SIGNAL POS_OUT : std_logic_vector (7 DOWNTO 0);

	CONSTANT TbPeriod : TIME := 10 ns; -- ***EDIT*** Put right period here
	SIGNAL TbClock : std_logic := '0';
	SIGNAL TbSimEnded : std_logic := '0';

BEGIN
	dut : BinTo7seg
	PORT MAP(
		clk => clk, 
		HH => HH, 
		MM => MM, 
		SS => SS, 
		seg => seg, 
		POS_OUT => POS_OUT
	);

	-- Clock generation
	TbClock <= NOT TbClock AFTER TbPeriod/2 WHEN TbSimEnded /= '1' ELSE '0';

	-- ***EDIT*** Check that clk is really your main clock signal
	clk <= TbClock;

	stimuli : PROCESS
	BEGIN
		-- ***EDIT*** Adapt initialization as needed
		HH <= (OTHERS => '0');
		MM <= (OTHERS => '0');
		SS <= (OTHERS => '0');
 
		WAIT FOR 100 ns;
		HH <= "00001100";
		MM <= "00100010";
		SS <= "00111000";

		-- Reset generation
		-- ***EDIT*** Replace YOURRESETSIGNAL below by the name of your reset as I haven't guessed it
		WAIT FOR 10 ms;
		HH <= "00000000";
		MM <= "00000000";
		SS <= "00000000";
		-- ***EDIT*** Add stimuli here
		WAIT FOR 100 * TbPeriod;

		-- Stop the clock and hence terminate the simulation
		TbSimEnded <= '1';
		WAIT;
	END PROCESS;

	END tb;

	-- Configuration block below is required by some simulators. Usually no need to edit.

	CONFIGURATION cfg_tb_BinTo7seg OF tb_BinTo7seg IS
		FOR tb
		END FOR;
END cfg_tb_BinTo7seg;