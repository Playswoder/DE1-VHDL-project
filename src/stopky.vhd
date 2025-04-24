LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY stopwatch_logic IS
	PORT (
		clk : IN std_logic; -- Clock 10 ns
		reset : IN std_logic; -- Global reset
		mode : IN std_logic_vector(1 DOWNTO 0); -- Mode: "10" for counting
		start_stop : IN std_logic; -- Toggle signal for start/stop
		svv : OUT std_logic_vector(7 DOWNTO 0); -- Centiseconds (00-99)
		sss : OUT std_logic_vector(7 DOWNTO 0); -- Seconds (00-59)
		smm : OUT std_logic_vector(7 DOWNTO 0) -- Minutes (00-59)
	);
END ENTITY stopwatch_logic;

ARCHITECTURE behavioral OF stopwatch_logic IS -- Fixed name match

	-- Constants for counter limits
	CONSTANT CENTISECOND_TC : NATURAL := 1_000_000; -- 1 centisecond tick
	CONSTANT CS_LIMIT : NATURAL := 99;
	CONSTANT SEC_MIN_LIMIT : NATURAL := 59;

	-- Internal counter signals
	SIGNAL cs_reg : unsigned(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL s_reg : unsigned(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL m_reg : unsigned(7 DOWNTO 0) := (OTHERS => '0');

	-- Control signals
	SIGNAL running : std_logic := '0';
	SIGNAL start_stop_prev : std_logic := '0';
	SIGNAL enable_counting : std_logic := '0';

	-- Tick generation signals
	SIGNAL clk_counter : NATURAL RANGE 0 TO CENTISECOND_TC - 1 := 0;
	SIGNAL centisecond_tick : std_logic := '0';

BEGIN
	-- Enable counting logic
	enable_counting <= '1' WHEN mode = "10" ELSE '0';

	-- Start/Stop Control Logic
	control_proc : PROCESS (clk, reset)
	BEGIN
		IF rising_edge(clk) THEN
			IF reset = '1' AND mode = "10" THEN
				running <= '0';
				start_stop_prev <= '0';
			ELSE
				start_stop_prev <= start_stop; -- Edge detection
				IF enable_counting = '1' THEN
					IF start_stop = '1' AND start_stop_prev = '0' THEN
						running <= NOT running; -- Toggle state
					END IF;
				ELSE
					running <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS control_proc;

	-- Tick generation process
	tick_gen_proc : PROCESS (clk, reset)
	BEGIN
		IF rising_edge(clk) THEN
			IF reset = '1' AND mode = "10" THEN
				clk_counter <= 0;
				centisecond_tick <= '0';
			ELSE
				IF running = '1' THEN
					IF clk_counter = CENTISECOND_TC - 1 THEN
						clk_counter <= 0;
						centisecond_tick <= '1'; -- Generate tick
					ELSE
						clk_counter <= clk_counter + 1;
						centisecond_tick <= '0'; -- Ensure tick remains low
					END IF;
				ELSE
					clk_counter <= 0; -- Reset counter if not running
					centisecond_tick <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS tick_gen_proc;

	-- Stopwatch counter logic
	counter_proc : PROCESS (clk, reset)
	BEGIN
		IF rising_edge(clk) THEN
			IF reset = '1' AND mode = "10" THEN
				cs_reg <= (OTHERS => '0'); -- Reset centisecond counter
				s_reg <= (OTHERS => '0'); -- Reset second counter
				m_reg <= (OTHERS => '0'); -- Reset minute counter
			ELSE
				IF centisecond_tick = '1' AND running = '1' THEN
					IF cs_reg = CS_LIMIT THEN
						cs_reg <= (OTHERS => '0');
						IF s_reg = SEC_MIN_LIMIT THEN
							s_reg <= (OTHERS => '0');
							IF m_reg = SEC_MIN_LIMIT THEN
								m_reg <= (OTHERS => '0'); -- Overflow minute counter
							ELSE
								m_reg <= m_reg + 1; -- Increment minutes
							END IF;
						ELSE
							s_reg <= s_reg + 1; -- Increment seconds
						END IF;
					ELSE
						cs_reg <= cs_reg + 1; -- Increment centiseconds
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS counter_proc;

	-- Assign outputs
	svv <= std_logic_vector(cs_reg);
	sss <= std_logic_vector(s_reg);
	smm <= std_logic_vector(m_reg);

END ARCHITECTURE behavioral;