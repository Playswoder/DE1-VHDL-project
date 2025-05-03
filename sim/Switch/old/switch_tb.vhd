LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_switch IS
END tb_switch;

ARCHITECTURE tb OF tb_switch IS

	COMPONENT switch
		PORT (
			hh : IN std_logic_vector (7 DOWNTO 0);
			mm : IN std_logic_vector (7 DOWNTO 0);
			ss : IN std_logic_vector (7 DOWNTO 0);
			D : IN std_logic_vector (1 DOWNTO 0);
			ahh : IN std_logic_vector (7 DOWNTO 0);
			amm : IN std_logic_vector (7 DOWNTO 0);
			smm : IN std_logic_vector (7 DOWNTO 0);
			sss : IN std_logic_vector (7 DOWNTO 0);
			svv : IN std_logic_vector (7 DOWNTO 0);
			fhh : OUT std_logic_vector (7 DOWNTO 0);
			fmm : OUT std_logic_vector (7 DOWNTO 0);
			fss : OUT std_logic_vector (7 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL hh : std_logic_vector (7 DOWNTO 0);
	SIGNAL mm : std_logic_vector (7 DOWNTO 0);
	SIGNAL ss : std_logic_vector (7 DOWNTO 0);
	SIGNAL D : std_logic_vector (1 DOWNTO 0);
	SIGNAL ahh : std_logic_vector (7 DOWNTO 0);
	SIGNAL amm : std_logic_vector (7 DOWNTO 0);
	SIGNAL smm : std_logic_vector (7 DOWNTO 0);
	SIGNAL sss : std_logic_vector (7 DOWNTO 0);
	SIGNAL svv : std_logic_vector (7 DOWNTO 0);
	SIGNAL fhh : std_logic_vector (7 DOWNTO 0);
	SIGNAL fmm : std_logic_vector (7 DOWNTO 0);
	SIGNAL fss : std_logic_vector (7 DOWNTO 0);

BEGIN
	dut : switch
	PORT MAP(
		hh => hh, 
		mm => mm, 
		ss => ss, 
		D => D, 
		ahh => ahh, 
		amm => amm, 
		smm => smm, 
		sss => sss, 
		svv => svv, 
		fhh => fhh, 
		fmm => fmm, 
		fss => fss
	);

	stimuli : PROCESS
	BEGIN
		-- ***EDIT*** Adapt initialization as needed
		hh <= (OTHERS => '0');
		mm <= (OTHERS => '0');
		ss <= (OTHERS => '0');
		D <= (OTHERS => '0');
		ahh <= (OTHERS => '0');
		amm <= (OTHERS => '0');
		smm <= (OTHERS => '0');
		sss <= (OTHERS => '0');
		svv <= (OTHERS => '0');

		-- ***EDIT*** Add stimuli here

		hh <= "00001001"; -- 9
		mm <= "00101000"; -- 40
		ss <= "00001111"; -- 15

		ahh <= "00000011"; -- 3
		amm <= "00001100"; -- 12

		smm <= "00010010"; -- 18
		sss <= "00010101"; -- 21
		svv <= "01001001"; -- 73

		WAIT FOR 10 ns;

		D <= "00";
		WAIT FOR 10 ns;

		D <= "01";
		WAIT FOR 10 ns;

		D <= "10";
		WAIT FOR 10 ns;

		D <= "10";
		WAIT FOR 10 ns;

		WAIT;

		WAIT;
	END PROCESS;

	END tb;

	-- Configuration block below is required by some simulators. Usually no need to edit.

	CONFIGURATION cfg_tb_switch OF tb_switch IS
		FOR tb
		END FOR;
END cfg_tb_switch;