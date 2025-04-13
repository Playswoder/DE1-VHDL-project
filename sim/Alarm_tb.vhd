-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 10 Apr 2025 08:10:39 GMT
-- Request id : cfwk-fed377c2-67f77cff4f19f

library ieee;
use ieee.std_logic_1164.all;

entity tb_Alarm is
end tb_Alarm;

architecture tb of tb_Alarm is

    component Alarm
        port (hh    : in std_logic_vector (7 downto 0);
              mm    : in std_logic_vector (7 downto 0);
              mode  : in std_logic_vector (1 downto 0);
              A     : in std_logic;
              B     : in std_logic;
              C     : in std_logic;
              ahh   : out std_logic_vector (7 downto 0);
              amm   : out std_logic_vector (7 downto 0);
              alarm_out : out std_logic);
    end component;

    signal hh    : std_logic_vector (7 downto 0);
    signal mm    : std_logic_vector (7 downto 0);
    signal mode  : std_logic_vector (1 downto 0);
    signal A     : std_logic;
    signal B     : std_logic;
    signal C     : std_logic;
    signal ahh   : std_logic_vector (7 downto 0);
    signal amm   : std_logic_vector (7 downto 0);
    signal alarm_out : std_logic;

begin

    dut : Alarm
    port map (hh    => hh,
              mm    => mm,
              mode  => mode,
              A     => A,
              B     => B,
              C     => C,
              ahh   => ahh,
              amm   => amm,
              alarm_out => alarm_out
              );

    stimuli : process
    begin
    
        report "==== START ====";
        -- ***EDIT*** Adapt initialization as needed
        hh <= (others => '0');
        mm <= (others => '0');
        mode <= (others => '0');
        A <= '0';
        B <= '0';
        C <= '0';
        

        -- ***EDIT*** Add stimuli here
        
        wait for 30 ns;
        
        mode <= "01";
        A <= '1';
        
        
        wait for 30 ns;
        
        B <= '1';
        
        wait for 10 ns;
        
        A <= '0';
        
        wait for 10 ns;
        
        A <= '1';


        report "==== STOP ====";
        wait;
        
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Alarm of tb_Alarm is
    for tb
    end for;
end cfg_tb_Alarm;