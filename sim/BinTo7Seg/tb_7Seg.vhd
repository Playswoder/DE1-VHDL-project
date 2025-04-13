library ieee;
use ieee.std_logic_1164.all;

entity tb_BinTo7seg is
end tb_BinTo7seg;

architecture tb of tb_BinTo7seg is

    component BinTo7seg
        port (clk     : in std_logic;
              HH      : in std_logic_vector (7 downto 0);
              MM      : in std_logic_vector (7 downto 0);
              SS      : in std_logic_vector (7 downto 0);
              seg     : out std_logic_vector (6 downto 0);
              POS_OUT : out std_logic_vector (5 downto 0));
    end component;

    signal clk     : std_logic;
    signal HH      : std_logic_vector (7 downto 0);
    signal MM      : std_logic_vector (7 downto 0);
    signal SS      : std_logic_vector (7 downto 0);
    signal seg     : std_logic_vector (6 downto 0);
    signal POS_OUT : std_logic_vector (5 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : BinTo7seg
    port map (clk     => clk,
              HH      => HH,
              MM      => MM,
              SS      => SS,
              seg     => seg,
              POS_OUT => POS_OUT);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        HH <= (others => '0');
        MM <= (others => '0');
        SS <= (others => '0');
        
        wait for 100 ns;
        HH <= "00001100";
        MM <= "00100010";
        SS <= "00111000";

        -- Reset generation
        --  ***EDIT*** Replace YOURRESETSIGNAL below by the name of your reset as I haven't guessed it
        wait for 10 ms;
            HH <= "00000000";
            MM <= "00000000";
            SS <= "00000000";
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_BinTo7seg of tb_BinTo7seg is
    for tb
    end for;
end cfg_tb_BinTo7seg;