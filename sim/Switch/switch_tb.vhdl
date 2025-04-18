library ieee;
use ieee.std_logic_1164.all;

entity tb_switch is
end tb_switch;

architecture tb of tb_switch is

    component switch
        port (hh   : in std_logic_vector (7 downto 0);
              mm   : in std_logic_vector (7 downto 0);
              ss   : in std_logic_vector (7 downto 0);
              D    : in std_logic_vector (1 downto 0);
              ahh  : in std_logic_vector (7 downto 0);
              amm  : in std_logic_vector (7 downto 0);
              smm  : in std_logic_vector (7 downto 0);
              sss  : in std_logic_vector (7 downto 0);
              svv  : in std_logic_vector (7 downto 0);
              fhh  : out std_logic_vector (7 downto 0);
              fmm  : out std_logic_vector (7 downto 0);
              fss  : out std_logic_vector (7 downto 0));
    end component;

    signal hh   : std_logic_vector (7 downto 0);
    signal mm   : std_logic_vector (7 downto 0);
    signal ss   : std_logic_vector (7 downto 0);
    signal D    : std_logic_vector (1 downto 0);
    signal ahh  : std_logic_vector (7 downto 0);
    signal amm  : std_logic_vector (7 downto 0);
    signal smm  : std_logic_vector (7 downto 0);
    signal sss  : std_logic_vector (7 downto 0);
    signal svv  : std_logic_vector (7 downto 0);
    signal fhh  : std_logic_vector (7 downto 0);
    signal fmm  : std_logic_vector (7 downto 0);
    signal fss  : std_logic_vector (7 downto 0);

begin

    dut : switch
    port map (hh   => hh,
              mm   => mm,
              ss   => ss,
              D    => D,
              ahh  => ahh,
              amm  => amm,
              smm  => smm,
              sss  => sss,
              svv  => svv,
              fhh  => fhh,
              fmm  => fmm,
              fss  => fss);

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        hh <= (others => '0');
        mm <= (others => '0');
        ss <= (others => '0');
        D <= (others => '0');
        ahh <= (others => '0');
        amm <= (others => '0');
        smm <= (others => '0');
        sss <= (others => '0');
        svv <= (others => '0');

        -- ***EDIT*** Add stimuli here

        hh <= "00001001";     -- 9
        mm <= "00101000";    -- 40
        ss <= "00001111";    -- 15

        ahh <= "00000011";    -- 3
        amm <= "00001100";   -- 12

        smm <= "00010010";   -- 18
        sss <= "00010101";   -- 21
        svv <= "01001001";  -- 73

        wait for 10 ns;

        D <= "00";
        wait for 10 ns;

        D <= "01";
        wait for 10 ns;

        D <= "10";
        wait for 10 ns;

        D <= "10";
        wait for 10 ns;

        wait;



        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_switch of tb_switch is
    for tb
    end for;
end cfg_tb_switch;
