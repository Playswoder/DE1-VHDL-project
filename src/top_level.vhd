library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port (
        CLK100MHZ  : in  std_logic; -- Clock 10 ns
        BTNA : in std_logic;
        BTNB : in std_logic;
        BTNC : in std_logic;
        SW: in std_logic_vector(1 downto 0);
        LED16_B : out std_logic;
        CA: out std_logic;
        CB: out std_logic;
        CC: out std_logic;
        CD: out std_logic;
        CE: out std_logic;
        CF: out std_logic;
        CG: out std_logic;
        DP: out std_logic;
        AN: out std_logic_vector(7 downto 0)
    );
end entity top_level;

architecture behavioral of top_level is

    component BinTo7seg is
            port (
                clk : in std_logic;
                HH : in std_logic_vector(7 downto 0); -- all will have united length
                MM : in std_logic_vector(7 downto 0);
                SS : in std_logic_vector(7 downto 0);
                seg : out std_logic_vector(6 downto 0) := "0000000"; -- used to forward singular numbers out
                POS_OUT : out std_logic_vector(7 downto 0) := "00000000" -- position of each 7seg disp (should cycle between them)
            );
    end component;

    component stopwatch_logic is
        port (
            clk        : in  std_logic; -- Clock 10 ns
            reset      : in  std_logic; -- Global reset
            mode       : in  std_logic_vector(1 downto 0); -- Mode: "10" for counting
            start_stop : in  std_logic; -- Toggle signal for start/stop
            svv        : out std_logic_vector(7 downto 0); -- Centiseconds (00-99)
            sss        : out std_logic_vector(7 downto 0); -- Seconds (00-59)
            smm        : out std_logic_vector(7 downto 0)  -- Minutes (00-59)
        );
    end component;

    component hodiny is
    Port (
        clk100MHz : in  std_logic;
        A         : in  std_logic;
        B         : in  std_logic;
        C         : in  std_logic;
        mode      : in std_logic_vector(1 downto 0);
        HH        : out std_logic_vector(7 downto 0);
        MM        : out std_logic_vector(7 downto 0);
        SS        : out std_logic_vector(7 downto 0)
    );
    end component;

    component Alarm is
       Port ( hh : in STD_LOGIC_VECTOR (7 downto 0);
           mm : in STD_LOGIC_VECTOR (7 downto 0);
           mode : in STD_LOGIC_VECTOR (1 downto 0);
           A : in STD_LOGIC;
           B : in STD_LOGIC;
           CLK100MHZ : in STD_LOGIC;
           ahh : out STD_LOGIC_VECTOR (7 downto 0);
           amm : out STD_LOGIC_VECTOR (7 downto 0);
           alarm_out : out STD_LOGIC);
    end component;

    component switch is
     Port ( hh       : in STD_LOGIC_VECTOR (7 downto 0);
           mm       : in STD_LOGIC_VECTOR (7 downto 0);
           ss       : in STD_LOGIC_VECTOR (7 downto 0);
           D        : in std_logic_vector (1 downto 0); 
           ahh      : in STD_LOGIC_VECTOR (7 downto 0);
           amm      : in STD_LOGIC_VECTOR (7 downto 0);
           smm      : in STD_LOGIC_VECTOR (7 downto 0);
           sss      : in STD_LOGIC_VECTOR (7 downto 0);
           svv      : in STD_LOGIC_VECTOR (7 downto 0);
           
           fhh      : out STD_LOGIC_VECTOR (7 downto 0);
           fmm      : out STD_LOGIC_VECTOR (7 downto 0);
           fss      : out STD_LOGIC_VECTOR (7 downto 0)
           );
    end component;
    
    component debounce is
    generic (
        DB_TIME : time := 25 ms
    );
    port (
        clk     : in    std_logic;
        btn_in  : in    std_logic; -- Asynchronous and noisy input
        btn_out : out   std_logic; -- Synchronised, debounced and filtered output
        edge    : out   std_logic;
        rise    : out   std_logic;
        fall    : out   std_logic
    );
end component debounce;

-- signals for buttons
signal SIG_OPEN : std_logic;
signal SIG_BTNA : std_logic;
signal SIG_BTNB : std_logic;
signal SIG_BTNC : std_logic; 
    

-- signals for Switch to B27S
signal SIG_S2BHH : STD_LOGIC_VECTOR(7 downto 0);
signal SIG_S2BMM : STD_LOGIC_VECTOR(7 downto 0);
signal SIG_S2BSS : STD_LOGIC_VECTOR(7 downto 0);

-- Mode signal
signal SIG_MODE : STD_LOGIC_VECTOR(1 downto 0);

-- signal for stopwatch to Switch
signal SIG_SW2SMM : std_logic_vector(7 downto 0);
signal SIG_SW2SSS : std_logic_vector(7 downto 0);
signal SIG_SW2SCS : std_logic_vector(7 downto 0);

-- signal for clock to Switch
signal SIG_C2SHH : std_logic_vector(7 downto 0);
signal SIG_C2SMM : std_logic_vector(7 downto 0);
signal SIG_C2SSS : std_logic_vector(7 downto 0);

-- signal for alarm to Switch
signal  SIG_A2SHH : std_logic_vector (7 downto 0);
signal  SIG_A2SMM : std_logic_vector (7 downto 0);

begin

SIG_MODE <= SW;

B27S : BinTo7seg
port map(
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
    POS_OUT => AN
);

stopwatch : stopwatch_logic
port map(
    clk => CLK100MHZ,
    reset => SIG_BTNA,
    mode => SIG_MODE,
    start_stop => SIG_BTNB, -- *EDIT
    svv => SIG_SW2SCS, -- Centiseconds (00-99)
    sss => SIG_SW2SSS, -- Seconds (00-59)
    smm => SIG_SW2SMM  -- Minutes (00-59)
);

clock : hodiny
    port map (
        clk100MHz => CLK100MHZ,
        A => SIG_BTNA,
        B => SIG_BTNB,
        C => SIG_BTNC,
        mode => SIG_MODE,
        HH => SIG_C2SHH,
        MM => SIG_C2SMM,
        SS => SIG_C2SSS
    );

switch_block : switch
     port map(
           hh   => SIG_C2SHH,
           mm  => SIG_C2SMM,
           ss => SIG_C2SSS,
           D  => SW, 
           ahh => SIG_A2SHH,
           amm => SIG_A2SMM,
           smm  => SIG_SW2SMM,
           sss => SIG_SW2SSS,
           svv  => SIG_SW2SCS,
           
           fhh => SIG_S2BHH,    
           fmm => SIG_S2BMM,
           fss => SIG_S2BSS
           );
           
 Alarm_block : Alarm
     Port map ( 
           CLK100MHZ => CLK100MHZ,      
           hh => SIG_C2SHH,
           mm => SIG_C2SMM,
           mode => SIG_MODE,
           A => SIG_BTNA,
           B => SIG_BTNB,
           ahh => SIG_A2SHH,
           amm => SIG_A2SMM,
           alarm_out => LED16_B
           );
           
 Debounce_BTNA : debounce
    port map (
        clk  => CLK100MHZ,
        btn_in  => BTNA,
        btn_out => SIG_BTNA,
        edge =>  SIG_OPEN,
        rise =>  SIG_OPEN,
        fall => SIG_OPEN
    );

 Debounce_BTNB : debounce
    port map (
        clk  => CLK100MHZ,
        btn_in  => BTNB,
        btn_out => SIG_BTNB,
        edge =>  SIG_OPEN,
        rise =>  SIG_OPEN,
        fall => SIG_OPEN
    );

 Debounce_BTNC : debounce
    port map (
        clk  => CLK100MHZ,
        btn_in  => BTNC,
        btn_out => SIG_BTNC,
        edge =>  SIG_OPEN,
        rise =>  SIG_OPEN,
        fall => SIG_OPEN
    );

DP <= '1';

end architecture behavioral;