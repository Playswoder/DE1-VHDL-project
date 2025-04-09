library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity hodiny_tb is
end entity hodiny_tb;

architecture Behavioral of hodiny_tb is
   
    signal clk100MHz_tb : std_logic := '0';
    signal A_tb         : std_logic := '0';
    signal B_tb         : std_logic := '0';
    signal C_tb         : std_logic := '0';
    signal HH_tb        : std_logic_vector(4 downto 0);
    signal MM_tb        : std_logic_vector(5 downto 0);
    signal SS_tb        : std_logic_vector(5 downto 0);

    
    constant clk_period : time := 10 ns;

begin
    
    uut: entity work.hodiny
        port map ( clk100MHz => clk100MHz_tb,
                   A         => A_tb,
                   B         => B_tb,
                   C         => C_tb,
                   HH        => HH_tb,
                   MM        => MM_tb,
                   SS        => SS_tb );

    
    clk_process: process
    begin
        loop
            clk100MHz_tb <= '0';
            wait for clk_period / 2;
            clk100MHz_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    
    stimulus_process: process
    begin

        A_tb <= '0';
        B_tb <= '0';
        C_tb <= '0';
        wait for 20 ns;

        wait for 5000 ms; 

        C_tb <= '1';
        wait for clk_period;
        C_tb <= '0';
        wait for 20 ns;

        for i in 1 to 5 loop
            A_tb <= '1';
            wait for clk_period;
            A_tb <= '0';
            wait for 2 * clk_period;
        end loop;
        wait for 1000 ms;
        
        A_tb <= '1';
		wait for 5 * clk_period;
		A_tb <= '0';

        B_tb <= '1';
        wait for clk_period;
        B_tb <= '0';
        wait for 2 * clk_period;
        wait for 1000 ms; 

        C_tb <= '1';
        wait for clk_period;
        C_tb <= '0';
        wait for 5000 ms;
        
        wait;

        report "Konec simulace";
        
    	end process;
    end architecture Behavioral;
