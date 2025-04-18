-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Fri, 18 Apr 2025 21:20:54 GMT
-- Request id : cfwk-fed377c2-6802c236c99df

library ieee;
use ieee.std_logic_1164.all;

entity tb_edge_detector is
end tb_edge_detector;

architecture tb of tb_edge_detector is

    component edge_detector
        port (CLK100MHZ : in std_logic;
              input     : in std_logic;
              output    : out std_logic);
    end component;

    signal CLK100MHZ : std_logic;
    signal input     : std_logic;
    signal output    : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : edge_detector
    port map (CLK100MHZ => CLK100MHZ,
              input     => input,
              output    => output);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK100MHZ is really your main clock signal
    CLK100MHZ <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        input <= '0';

        -- ***EDIT*** Add stimuli here
        wait for 30ns;

        input <= '1';

        wait for 50ns;

        input <= '0';

        wait for 100ns;

        input <= '1';

        wait for 50ns;

        input <= '0';

        wait for 100ns;

        input <= '1';

        wait for 50ns;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_edge_detector of tb_edge_detector is
    for tb
    end for;
end cfg_tb_edge_detector;
