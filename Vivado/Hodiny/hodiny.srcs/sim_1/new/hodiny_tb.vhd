library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity hodiny_tb is
end entity hodiny_tb;

architecture Behavioral of hodiny_tb is

component hodiny 

port(
        clk100MHz : in  std_logic;
        A         : in  std_logic;
        B         : in  std_logic;
        C         : in  std_logic;
        mode      : in std_logic_vector(1 downto 0):= "00";
        HH        : out std_logic_vector(7 downto 0);
        MM        : out std_logic_vector(7 downto 0);
        SS        : out std_logic_vector(7 downto 0)
    );
end component ;
   
    signal clk100MHz_tb : std_logic := '0';
    signal A_tb         : std_logic := '0';
    signal B_tb         : std_logic := '0';
    signal C_tb         : std_logic := '0';
    signal HH_tb        : std_logic_vector(7 downto 0);
    signal MM_tb        : std_logic_vector(7 downto 0);
    signal SS_tb        : std_logic_vector(7 downto 0);

    
    constant clk_period : time := 10 ns;


begin
    
    uut: hodiny 
        port map ( clk100MHz => clk100MHz_tb,
                   A         => A_tb,
                   B         => B_tb,
                   C         => C_tb,
                   
                   HH        => HH_tb,
                   MM        => MM_tb,
                   SS        => SS_tb 
            );
                   

    
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

        
    	end process;
    end architecture Behavioral;