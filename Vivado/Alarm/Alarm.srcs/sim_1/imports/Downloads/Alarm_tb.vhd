-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 17 Apr 2025 08:41:14 GMT
-- Request id : cfwk-fed377c2-6800beaae6149

library ieee;
use ieee.std_logic_1164.all;

entity tb_Alarm is
end tb_Alarm;

architecture tb of tb_Alarm is

    component Alarm
        port (hh        : in std_logic_vector (7 downto 0);
              mm        : in std_logic_vector (7 downto 0);
              mode      : in std_logic_vector (1 downto 0);
              A         : in std_logic;
              B         : in std_logic;
              CLK100MHZ : in std_logic;
              ahh       : out std_logic_vector (7 downto 0);
              amm       : out std_logic_vector (7 downto 0);
              alarm_out : out std_logic);
    end component;

    signal hh        : std_logic_vector (7 downto 0);
    signal mm        : std_logic_vector (7 downto 0);
    signal mode      : std_logic_vector (1 downto 0);
    signal A         : std_logic;
    signal B         : std_logic;
    signal CLK100MHZ : std_logic;
    signal ahh       : std_logic_vector (7 downto 0);
    signal amm       : std_logic_vector (7 downto 0);
    signal alarm_out : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Alarm
    port map (hh        => hh,
              mm        => mm,
              mode      => mode,
              A         => A,
              B         => B,
              CLK100MHZ => CLK100MHZ,
              ahh       => ahh,
              amm       => amm,
              alarm_out => alarm_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK100MHZ is really your main clock signal
    CLK100MHZ <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        hh <= (others => '0');
        mm <= (others => '0');
        mode <= (others => '0');
        A <= '0';
        B <= '0';

        -- ***EDIT*** Add stimuli here
        wait for 30 ns;
        
        report "==== START ====";

        wait for 30 ns;
        
        mode <= "01"; -- mode ====================
        A <= '1';
        
        
        wait for 5 ns;
        
        B <= '1';
        
        wait for 5 ns;
        
        A <= '0';
        
        wait for 5 ns;
        
        B <= '0';
        
        wait for 30 ns;
        
        B <= '1';
        
        wait for 10 ns;
        
        B <= '0';
        
        wait for 30 ns;
        
        B <= '1';
        
        wait for 10 ns;
        
        B <= '0';


        hh <= "00000000";
        mm <= "00000010";
        
        wait for 200 ns;
        
        mm <= "00000011"; 
        
        wait for 30 ns;

        mode <= "10"; -- mode =====================
        
        wait for 30 ns;
        
        A <= '1';
        mm <= "00000010";
        
        wait for 30 ns;
        
        B <= '1';
        
        wait for 30 ns;
        
        A <= '0';
        
        wait for 30 ns;
        
        B <= '0';
        
        mode <= "01"; -- mode ======================
        
        wait for 30 ns;
        
        A <= '1';
        
        wait for 10 ns;
        
        A <= '0';

        report "==== STOP ====";
        wait;
        
        
        
        
        
        
        
        

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Alarm of tb_Alarm is
    for tb
    end for;
end cfg_tb_Alarm;