LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY debounce IS
	GENERIC (
		DB_TIME : TIME := 25 ms
	);
	PORT (
		clk : IN std_logic;
		btn_in : IN std_logic; -- Asynchronous and noisy input
		btn_out : OUT std_logic := '0'; -- Synchronised, debounced and filtered output
		edge : OUT std_logic := '0';
		rise : OUT std_logic := '0';
		fall : OUT std_logic := '0'
	);
END ENTITY debounce;

ARCHITECTURE v1 OF debounce IS
	CONSTANT CLK_PERIOD : TIME := 10 ns;
	CONSTANT MAX_COUNT : NATURAL := DB_TIME / CLK_PERIOD;
	CONSTANT SYNC_BITS : POSITIVE := 2; -- Number of bits in the synchronisation buffer (2 minimum)

	SIGNAL sync_buffer : std_logic_vector(SYNC_BITS - 1 DOWNTO 0);
	ALIAS sync_input : std_logic IS sync_buffer(SYNC_BITS - 1);
	SIGNAL sig_count : NATURAL RANGE 0 TO MAX_COUNT - 1;
	SIGNAL sig_btn : std_logic := '0';

BEGIN
	p_debounce : PROCESS (clk) IS
		VARIABLE edge_internal : std_logic;
		VARIABLE rise_internal : std_logic;
		VARIABLE fall_internal : std_logic;

	BEGIN
		IF rising_edge(clk) THEN
			-- Synchronise the asynchronous input
			-- MSB of sync_buffer is the synchronised input
			sync_buffer <= sync_buffer(SYNC_BITS - 2 DOWNTO 0) & btn_in;

			edge <= '0';
			rise <= '0';
			fall <= '0';

			-- If successfully debounced, notify what happened, and reset the sig_count
			IF (sig_count = MAX_COUNT - 1) THEN
				sig_btn <= sync_input;
				edge <= edge_internal;
				rise <= rise_internal;
				fall <= fall_internal;
				sig_count <= 0;
			ELSIF (sync_input /= sig_btn) THEN
				sig_count <= sig_count + 1;
			ELSE
				sig_count <= 0;
			END IF;
		END IF;

		-- Edge detection
		edge_internal := sync_input XOR sig_btn;
		rise_internal := sync_input AND NOT sig_btn;
		fall_internal := NOT sync_input AND sig_btn;
		btn_out <= sig_btn;

	END PROCESS p_debounce;

END ARCHITECTURE v1;