----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 09:18:46 AM
-- Design Name: 
-- Module Name: debouncer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
    Port ( CLK100MHZ : in STD_LOGIC;
           input : in STD_LOGIC;
           output : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

constant SECOND01 : natural := 10_000_000;
signal count : natural range 0 to SECOND01 - 1;
signal second_tick01 : STD_LOGIC := '0';
  
begin
        process (CLK100MHZ)
        begin
            if (rising_edge (CLK100MHZ)) then
            
                if (count = SECOND01 - 1) then
                    second_tick01 <= '1';
                    count <= 0;
                else    
                    second_tick01 <= '0';
                    count <= count + 1;
                
                end if;
                
            end if;
            
                
        end process;

        process (CLK100MHZ)
        begin
              if (rising_edge (CLK100MHZ) and second_tick01 = '1') then
                output <= input;
              end if;
        end process;

end Behavioral;
