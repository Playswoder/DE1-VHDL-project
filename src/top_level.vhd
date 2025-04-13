library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port (
        CLK100MHz  : in  std_logic; -- Clock 10 ns
        BTNA : in std_logic;
        BTNB : in std_logic;
        BTNC : in std_logic;
        BTND : in std_logic;
        CA: out std_logic;
        CB: out std_logic;
        CC: out std_logic;
        CD: out std_logic;
        CE: out std_logic;
        CF: out std_logic;
        CG: out std_logic;
        DP: out std_logic;
        AN: out std_logic_vector(7 downto 0);
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
    Port ( clk100MHz : in  std_logic;
           A         : in  std_logic;
           B         : in  std_logic;
           C         : in  std_logic;
           mode      : in std_logic_vector(1 downto 0);
           HH        : out std_logic_vector(4 downto 0); 
           MM        : out std_logic_vector(5 downto 0); 
           SS        : out std_logic_vector(5 downto 0)  
         );
    end component;

    component alarm is
    Port ( clk100MHz : in  std_logic;
           A         : in  std_logic; -- co to dělá ten čudlík
           B         : in  std_logic;
           C         : in  std_logic; -- confirm třeba
           mode      : in std_logic_vector(1 downto 0);
           HH        : out std_logic_vector(4 downto 0); 
           MM        : out std_logic_vector(5 downto 0); 
           SS        : out std_logic_vector(5 downto 0)  
         );
    end component;

    component switch is
    Port ( hh       : in STD_LOGIC_VECTOR (4 downto 0);
           mm       : in STD_LOGIC_VECTOR (5 downto 0);
           ss       : in STD_LOGIC_VECTOR (5 downto 0);
           D        : in STD_LOGIC_VECTOR (1 downto 0); -- co je D, jesli je to čudlík proč je zapsaný jako vector?
           ahh      : in STD_LOGIC_VECTOR (4 downto 0);
           amm      : in STD_LOGIC_VECTOR (5 downto 0);
           smm      : in STD_LOGIC_VECTOR (5 downto 0);
           sss      : in STD_LOGIC_VECTOR (5 downto 0);
           svv      : in STD_LOGIC_VECTOR (6 downto 0);
          
           fhh      : out STD_LOGIC_VECTOR (4 downto 0);
           fmm      : out STD_LOGIC_VECTOR (5 downto 0);
           fss      : out STD_LOGIC_VECTOR (5 downto 0);
           fvv      : out STD_LOGIC_VECTOR (6 downto 0);
           mode     : out STD_LOGIC_VECTOR (1 downto 0)
           );   
    end component;

-- signals for Switch to B27S
signal SIG_S2BHH std_logic_vector(7 downto 0);
signal SIG_S2BMM STD_LOGIC_VECTOR(7 downto 0);
signal SIG_S2BSS STD_LOGIC_VECTOR(7 downto 0);

-- Mode signal
signal SIG_MODE STD_LOGIC_VECTOR(1 downto 0);

-- signal for stopwatch to Switch
signal SIG_SW2SMM std_logic_vector(7 downto 0);
signal SIG_SW2SSS std_logic_vector(7 downto 0);
signal SIG_SW2SCS std_logic_vector(7 downto 0);

begin

B27S : BinTo7seg
port map(
    clk => CLK100MHz,
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
    clk => CLK100MHz,
    reset => BTNA,
    mode => SIG_MODE,
    start_stop => BTNB,
    svv => SIG_SW2SCS, -- Centiseconds (00-99)
    sss => SIG_SW2SSS, -- Seconds (00-59)
    smm => SIG_SW2SMM  -- Minutes (00-59)
);






end architecture behavioral;