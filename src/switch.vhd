LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

ENTITY switch IS

	PORT (
		hh : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		mm : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		ss : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		D : IN std_logic_vector (1 DOWNTO 0);
		ahh : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		amm : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		smm : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		sss : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		svv : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clk : IN STD_LOGIC;
		fhh : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		fmm : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		fss : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
 
END switch;

ARCHITECTURE Behavioral OF switch IS
 
	SIGNAL sig_mode : unsigned(1 DOWNTO 0) := "00";
	SIGNAL D_prev : std_logic := '0';
BEGIN
	Switch_proc : PROCESS (clk, hh, mm, ss, D, ahh, amm, smm, sss, svv, sig_mode)
	BEGIN
		IF rising_edge(clk) THEN
			CASE D IS
				WHEN "00" => 
					fhh <= hh;
					fmm <= mm;
					fss <= ss;
				WHEN "01" => 
					fhh <= ahh;
					fmm <= amm;
					fss <= "00000000";
				WHEN "10" => 
					fhh <= smm;
					fmm <= sss;
					fss <= svv;
				WHEN OTHERS => 
					fhh <= (OTHERS => '0');
					fmm <= (OTHERS => '0');
					fss <= (OTHERS => '0');
			END CASE;
		END IF;
	END PROCESS Switch_proc;
END Behavioral;