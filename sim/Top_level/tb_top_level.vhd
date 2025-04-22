library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

    component top_level
        port (CLK100MHZ : in std_logic;
              BTNA      : in std_logic;
              BTNB      : in std_logic;
              BTNC      : in std_logic;
              SW        : in std_logic_vector (1 downto 0);
              LED16_B   : out std_logic;
              CA        : out std_logic;
              CB        : out std_logic;
              CC        : out std_logic;
              CD        : out std_logic;
              CE        : out std_logic;
              CF        : out std_logic;
              CG        : out std_logic;
              DP        : out std_logic;
              AN        : out std_logic_vector (7 downto 0));
    end component;

    signal CLK100MHZ : std_logic;
    signal BTNA      : std_logic;
    signal BTNB      : std_logic;
    signal BTNC      : std_logic;
    signal SW        : std_logic_vector (1 downto 0);
    signal LED16_B   : std_logic;
    signal CA        : std_logic;
    signal CB        : std_logic;
    signal CC        : std_logic;
    signal CD        : std_logic;
    signal CE        : std_logic;
    signal CF        : std_logic;
    signal CG        : std_logic;
    signal DP        : std_logic;
    signal AN        : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top_level
    port map (CLK100MHZ => CLK100MHZ,
              BTNA      => BTNA,
              BTNB      => BTNB,
              BTNC      => BTNC,
              SW        => SW,
              LED16_B   => LED16_B,
              CA        => CA,
              CB        => CB,
              CC        => CC,
              CD        => CD,
              CE        => CE,
              CF        => CF,
              CG        => CG,
              DP        => DP,
              AN        => AN);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK100MHZ is really your main clock signal
    CLK100MHZ <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        BTNA <= '0';
        BTNB <= '0';
        BTNC <= '0';
        SW <= (others => '0');
        wait for 10 ns;
        

        
        
        

        SW <= "10";
        wait for 10 ns;
        BTNB <= '1';
        wait for 25.1 ms;
        BTNB <= '0';
        wait for 1 ms;
        
        
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
       -- TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;