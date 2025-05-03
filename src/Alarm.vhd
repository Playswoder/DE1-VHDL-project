----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/10/2025 09:18:46 AM
-- Design Name:
-- Module Name: Alarm - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Alarm IS
	PORT (
		hh : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		mm : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		mode : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		A : IN STD_LOGIC;
		B : IN STD_LOGIC;
		CLK100MHZ : IN STD_LOGIC;
		ahh : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		amm : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		alarm_out : OUT STD_LOGIC
	);
END Alarm;

ARCHITECTURE Behavioral OF Alarm IS

	SIGNAL alarm_hh : std_logic_vector(7 DOWNTO 0) := "00010111";
	SIGNAL alarm_mm : std_logic_vector(7 DOWNTO 0) := "00111011";

BEGIN
	-- default value for clock
	--alarm_hh <= x"17";
	--alarm_mm <= x"3b";
 
	-- setting alarm time
	PROCESS (mode, A, CLK100MHZ)
	BEGIN
		IF (mode = "01" AND rising_edge (CLK100MHZ)) THEN
 
			IF (A = '1') THEN
				IF (alarm_hh = x"17") THEN
					alarm_hh <= x"00";
				ELSE
					alarm_hh <= std_logic_vector(unsigned(alarm_hh) + 1);
				END IF;
			ELSE 
 
				alarm_hh <= alarm_hh;
 
			END IF;
 
		ELSE
 
			alarm_hh <= alarm_hh;
 
		END IF;
 
 
	END PROCESS;
 
	PROCESS (mode, B, CLK100MHZ)
		BEGIN
			IF (mode = "01" AND rising_edge (CLK100MHZ)) THEN
 
				IF (B = '1') THEN
					IF (alarm_mm = x"3b") THEN
						alarm_mm <= x"00";
					ELSE
						alarm_mm <= std_logic_vector(unsigned(alarm_mm) + 1);
					END IF;
 
				ELSE 
 
					alarm_mm <= alarm_mm;
 
				END IF;
 
			ELSE 
				alarm_mm <= alarm_mm;
 
			END IF;
 
 
		END PROCESS;
		-- Output the alarm set values
		ahh <= alarm_hh;
		amm <= alarm_mm;
 

 
		-- launch alarm if time matches
		alarm_out <= '1' WHEN (hh = alarm_hh AND mm = alarm_mm) ELSE '0';
END Behavioral;