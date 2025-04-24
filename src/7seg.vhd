LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY BinTo7seg IS
	PORT (
		clk : IN std_logic;
		HH : IN std_logic_vector(7 DOWNTO 0); -- all will have united length
		MM : IN std_logic_vector(7 DOWNTO 0);
		SS : IN std_logic_vector(7 DOWNTO 0);
		--SVV : in std_logic_vector(7 downto 0); -- just port it to the SS terminal
		--MODE : in std_logic_vector(1 downto 0); -- will ignore
		seg : OUT std_logic_vector(6 DOWNTO 0) := "0000000"; -- used to forward singular numbers out
		POS_OUT : OUT std_logic_vector(7 DOWNTO 0) := "00000000"; -- position of each 7seg disp (should cycle between them)
		DP : OUT std_logic
		-- common anode, so diplay turned on should have value '0' at its anode
	);
END ENTITY BinTo7seg;

ARCHITECTURE behavioral OF BinTo7seg IS
	SIGNAL digit0 : INTEGER RANGE 0 TO 9;

	SIGNAL POS_reg : unsigned(2 DOWNTO 0) := (OTHERS => '0');
 
	CONSTANT n7SegDisp : INTEGER := 6;
	CONSTANT MILISECOND_TC : NATURAL := 25_000; -- should not be <25_000 default(100_000)

	SIGNAL clk_counter : NATURAL RANGE 0 TO MILISECOND_TC - 1 := 0;
	SIGNAL milisecond_tick : std_logic := '0';

BEGIN
	-- tick generating process if necessary, skip otherwise
	tick_gen : PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF clk_counter = MILISECOND_TC - 1 THEN
				clk_counter <= 0;
				milisecond_tick <= '1'; -- Generate tick
			ELSE
				clk_counter <= clk_counter + 1;
				milisecond_tick <= '0'; -- Ensure tick remains low
			END IF;
		END IF;
	END PROCESS tick_gen;
	Position_counter : PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN -- could be done at slower rate tho (not necessary hopefully, manual suggests 1 ms per each refresh)
			IF milisecond_tick = '1' THEN -- milisec. tick rate
				IF POS_reg = 5 THEN
					POS_reg <= (OTHERS => '0');
				ELSE
					POS_reg <= POS_reg + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS Position_counter;

	digit_sep : PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			CASE TO_INTEGER(POS_reg) IS
				WHEN 5 => digit0 <= to_integer(unsigned(HH)) / 10; -- Convert to integer before dividing
				WHEN 4 => digit0 <= to_integer(unsigned(HH)) MOD 10; -- Convert to integer before modulus
				WHEN 3 => digit0 <= to_integer(unsigned(MM)) / 10;
				WHEN 2 => digit0 <= to_integer(unsigned(MM)) MOD 10;
				WHEN 1 => digit0 <= to_integer(unsigned(SS)) / 10;
				WHEN 0 => digit0 <= to_integer(unsigned(SS)) MOD 10;
				WHEN OTHERS => digit0 <= 0;
			END CASE;
		END IF;
	END PROCESS digit_sep;
	Pos_converter : PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			CASE TO_INTEGER(POS_reg) IS
				WHEN 5 => POS_OUT <= "01111111"; -- display lights on '0'
				WHEN 4 => POS_OUT <= "10111111";
				WHEN 3 => POS_OUT <= "11011111";
				WHEN 2 => POS_OUT <= "11101111";
				WHEN 1 => POS_OUT <= "11110111";
				WHEN 0 => POS_OUT <= "11111011";
				WHEN OTHERS => POS_OUT <= "11111111"; -- all off
			END CASE;
		END IF;
	END PROCESS Pos_converter;
	-- will take in digit0 (0 - 9)
	BinToSeg : PROCESS (clk)
	BEGIN
		-- code that lights individual segments (labs)
		-- make it synchronous
		IF rising_edge(clk) THEN
			CASE digit0 IS -- change the conditions to unsigned
				WHEN 0 => -- x"0" means "0000" in hexadecimal
					seg <= "0000001";
				WHEN 1 => 
					seg <= "1001111";

				WHEN 2 => -- Display 2
					seg <= "0010010"; -- segments a, b, d, e, g on

				WHEN 3 => -- Display 3
					seg <= "0000110"; -- segments a, b, c, d, g on

				WHEN 4 => -- Display 4
					seg <= "1001100"; -- segments b, c, f, g on

				WHEN 5 => -- Display 5
					seg <= "0100100"; -- segments a, c, d, f, g on

				WHEN 6 => -- Display 6
					seg <= "0100000"; -- segments a, c, d, e, f, g on

				WHEN 7 => 
					seg <= "0001111";
				WHEN 8 => 
					seg <= "0000000";

				WHEN 9 => -- Display 9
					seg <= "0000100"; -- segments a, b, c, d, f, g on
 
				WHEN OTHERS => 
					seg <= "0111000";
			END CASE;
		END IF;
	END PROCESS;

	Dec_point : PROCESS (clk)
	BEGIN
		if rising_edge(clk) THEN
			CASE TO_INTEGER (pos_reg) IS
				WHEN 4 => DP <= '0';
				WHEN 2 => DP <= '0';
				WHEN OTHERS => DP <= '1';
			END CASE;
		end if;
	END PROCESS;

END ARCHITECTURE behavioral;