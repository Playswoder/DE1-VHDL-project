LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY hodiny IS
	PORT (
		clk100MHz : IN std_logic;
		A : IN std_logic;
		B : IN std_logic;
		C : IN std_logic;
		mode : IN std_logic_vector(1 DOWNTO 0);
		HH : OUT std_logic_vector(7 DOWNTO 0);
		MM : OUT std_logic_vector(7 DOWNTO 0);
		SS : OUT std_logic_vector(7 DOWNTO 0)
	);
END ENTITY hodiny;

ARCHITECTURE Behavioral OF hodiny IS
	SIGNAL s_sekundy : INTEGER RANGE 0 TO 59 := 0;
	SIGNAL s_minuty : INTEGER RANGE 0 TO 59 := 0;
	SIGNAL s_hodiny : INTEGER RANGE 0 TO 23 := 0;

	CONSTANT SECOND_TC : NATURAL := 100_000_000;
	SIGNAL count : NATURAL RANGE 0 TO SECOND_TC - 1;
	SIGNAL second_tick : std_logic := '0';
 
BEGIN
	tick_gen_proc : PROCESS (clk100MHz)
	BEGIN
		IF rising_edge(clk100MHz) THEN
			IF count = SECOND_TC - 1 THEN
				count <= 0;
				second_tick <= '1';
			ELSE
				count <= count + 1;
				second_tick <= '0';
			END IF;
		END IF;
	END PROCESS;

 
	Clock : PROCESS (clk100MHz)
	BEGIN
		IF rising_edge(clk100MHz) THEN
 
 
			IF second_tick = '1' THEN
				IF s_sekundy = 59 THEN
					s_sekundy <= 0;
					IF s_minuty = 59 THEN
						s_minuty <= 0;
						IF s_hodiny = 23 THEN
							s_hodiny <= 0;
						ELSE
							s_hodiny <= s_hodiny + 1;
						END IF;
					ELSE
						s_minuty <= s_minuty + 1;
					END IF;
				ELSE
					s_sekundy <= s_sekundy + 1;
				END IF;
			END IF;

 
			CASE mode IS
 
				WHEN "00" => 
 
					IF A = '1' THEN
						IF s_hodiny = 23 THEN
							s_hodiny <= 0;
						ELSE
							s_hodiny <= s_hodiny + 1;
						END IF;
					END IF;

					IF B = '1' THEN
						IF s_minuty = 59 THEN
							s_minuty <= 0;
						ELSE
							s_minuty <= s_minuty + 1;
						END IF;
					END IF;

 

				WHEN OTHERS => NULL;

			END CASE;
		END IF;
	END PROCESS;
	SS <= std_logic_vector(TO_UNSIGNED(s_sekundy, 8));
	MM <= std_logic_vector(TO_UNSIGNED(s_minuty, 8));
	HH <= std_logic_vector(TO_UNSIGNED(s_hodiny, 8));
 
END Behavioral;