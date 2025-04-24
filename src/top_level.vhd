LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY top_level IS
	PORT (
		CLK100MHZ : IN std_logic; -- Clock 10 ns
		BTNA : IN std_logic;
		BTNB : IN std_logic;
		BTNC : IN std_logic;
		SW : IN std_logic_vector(1 DOWNTO 0);
		LED16_B : OUT std_logic;
		CA : OUT std_logic;
		CB : OUT std_logic;
		CC : OUT std_logic;
		CD : OUT std_logic;
		CE : OUT std_logic;
		CF : OUT std_logic;
		CG : OUT std_logic;
		DP : OUT std_logic;
		AN : OUT std_logic_vector(7 DOWNTO 0)
	);
END ENTITY top_level;

ARCHITECTURE behavioral OF top_level IS

	COMPONENT BinTo7seg IS
		PORT (
			clk : IN std_logic;
			HH : IN std_logic_vector(7 DOWNTO 0); -- all will have united length
			MM : IN std_logic_vector(7 DOWNTO 0);
			SS : IN std_logic_vector(7 DOWNTO 0);
			seg : OUT std_logic_vector(6 DOWNTO 0) := "0000000"; -- used to forward singular numbers out
			POS_OUT : OUT std_logic_vector(7 DOWNTO 0) := "00000000"; -- position of each 7seg disp (should cycle between them)
			DP : OUT std_logic
		);
	END COMPONENT;

	COMPONENT stopwatch_logic IS
		PORT (
			clk : IN std_logic; -- Clock 10 ns
			reset : IN std_logic; -- Global reset
			mode : IN std_logic_vector(1 DOWNTO 0); -- Mode: "10" for counting
			start_stop : IN std_logic; -- Toggle signal for start/stop
			svv : OUT std_logic_vector(7 DOWNTO 0); -- Centiseconds (00-99)
			sss : OUT std_logic_vector(7 DOWNTO 0); -- Seconds (00-59)
			smm : OUT std_logic_vector(7 DOWNTO 0) -- Minutes (00-59)
		);
	END COMPONENT;

	COMPONENT hodiny IS
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
	END COMPONENT;

	COMPONENT Alarm IS
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
	END COMPONENT;

	COMPONENT switch IS
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
            clk : in STD_LOGIC;
			fhh : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			fmm : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			fss : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;
 
	COMPONENT debounce IS
		GENERIC (
			DB_TIME : TIME := 25 ms
		);
		PORT (
			clk : IN std_logic;
			btn_in : IN std_logic; -- Asynchronous and noisy input
			btn_out : OUT std_logic; -- Synchronised, debounced and filtered output
			edge : OUT std_logic;
			rise : OUT std_logic;
			fall : OUT std_logic
		);
	END COMPONENT debounce;

	-- signals for buttons
	SIGNAL SIG_OPEN : std_logic;
	SIGNAL SIG_BTNA : std_logic;
	SIGNAL SIG_BTNB : std_logic;
	SIGNAL SIG_BTNC : std_logic;
	-- signal rise btn
	SIGNAL SIG_BTNARise : std_logic;
	SIGNAL SIG_BTNBRise : std_logic;
	SIGNAL SIG_BTNCRise : std_logic;
 

	-- signals for Switch to B27S
	SIGNAL SIG_S2BHH : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL SIG_S2BMM : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL SIG_S2BSS : STD_LOGIC_VECTOR(7 DOWNTO 0);
	-- Mode signal
	SIGNAL SIG_MODE : STD_LOGIC_VECTOR(1 DOWNTO 0);

	-- signal for stopwatch to Switch
	SIGNAL SIG_SW2SMM : std_logic_vector(7 DOWNTO 0);
	SIGNAL SIG_SW2SSS : std_logic_vector(7 DOWNTO 0);
	SIGNAL SIG_SW2SCS : std_logic_vector(7 DOWNTO 0);

	-- signal for clock to Switch
	SIGNAL SIG_C2SHH : std_logic_vector(7 DOWNTO 0);
	SIGNAL SIG_C2SMM : std_logic_vector(7 DOWNTO 0);
	SIGNAL SIG_C2SSS : std_logic_vector(7 DOWNTO 0);

	-- signal for alarm to Switch
	SIGNAL SIG_A2SHH : std_logic_vector (7 DOWNTO 0);
	SIGNAL SIG_A2SMM : std_logic_vector (7 DOWNTO 0);
BEGIN
	SIG_MODE <= SW;

	B27S : BinTo7seg
	PORT MAP(
		clk => CLK100MHZ, 
		HH => SIG_S2BHH, 
		MM => SIG_S2BMM, 
		SS => SIG_S2BSS, 
		seg(6) => CA, 
		seg(5) => CB, 
		seg(4) => CC, 
		seg(3) => CD, 
		seg(2) => CE, 
		seg(1) => CF, 
		seg(0) => CG, 
		POS_OUT => AN, 
		DP => DP
	);

	stopwatch : stopwatch_logic
	PORT MAP(
		clk => CLK100MHZ, 
		reset => SIG_BTNA, 
		mode => SIG_MODE, 
		start_stop => SIG_BTNB, -- *EDIT
		svv => SIG_SW2SCS, -- Centiseconds (00-99)
		sss => SIG_SW2SSS, -- Seconds (00-59)
		smm => SIG_SW2SMM -- Minutes (00-59)
	);

	clock : hodiny
	PORT MAP(
		clk100MHz => CLK100MHZ, 
		A => SIG_BTNARise, 
		B => SIG_BTNBRise, 
		C => SIG_BTNCRise, 
		mode => SIG_MODE, 
		HH => SIG_C2SHH, 
		MM => SIG_C2SMM, 
		SS => SIG_C2SSS
	);

	switch_block : switch
	PORT MAP(
		hh => SIG_C2SHH, 
		mm => SIG_C2SMM, 
		ss => SIG_C2SSS, 
		D => SW, 
		ahh => SIG_A2SHH, 
		amm => SIG_A2SMM, 
		smm => SIG_SW2SMM, 
		sss => SIG_SW2SSS, 
		svv => SIG_SW2SCS, 
        clk => CLK100MHZ,
		fhh => SIG_S2BHH, 
		fmm => SIG_S2BMM, 
		fss => SIG_S2BSS
	);
 
	Alarm_block : Alarm
	PORT MAP(
		CLK100MHZ => CLK100MHZ, 
		hh => SIG_C2SHH, 
		mm => SIG_C2SMM, 
		mode => SIG_MODE, 
		A => SIG_BTNARise, 
		B => SIG_BTNBRise, 
		ahh => SIG_A2SHH, 
		amm => SIG_A2SMM, 
		alarm_out => LED16_B
	);
 
	Debounce_BTNA : debounce
	PORT MAP(
		clk => CLK100MHZ, 
		btn_in => BTNA, 
		btn_out => SIG_BTNA, 
		edge => SIG_OPEN, 
		rise => SIG_BTNARise, 
		fall => SIG_OPEN
	);

	Debounce_BTNB : debounce
	PORT MAP(
		clk => CLK100MHZ, 
		btn_in => BTNB, 
		btn_out => SIG_BTNB, 
		edge => SIG_OPEN, 
		rise => SIG_BTNBRise, 
		fall => SIG_OPEN
	);

	Debounce_BTNC : debounce
	PORT MAP(
		clk => CLK100MHZ, 
		btn_in => BTNC, 
		btn_out => SIG_BTNC, 
		edge => SIG_OPEN, 
		rise => SIG_BTNCRise, 
		fall => SIG_OPEN
	);
END ARCHITECTURE behavioral;