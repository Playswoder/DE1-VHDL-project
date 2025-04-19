----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 09:18:46 AM
-- Design Name: 
-- Module Name: Alarm - Behavioral
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

entity Alarm is
    Port ( hh : in STD_LOGIC_VECTOR (7 downto 0);
           mm : in STD_LOGIC_VECTOR (7 downto 0);
           mode : in STD_LOGIC_VECTOR (1 downto 0);
           A : in STD_LOGIC;
           B : in STD_LOGIC;
           CLK100MHZ : in STD_LOGIC;
           ahh : out STD_LOGIC_VECTOR (7 downto 0);
           amm : out STD_LOGIC_VECTOR (7 downto 0);
           alarm_out : out STD_LOGIC);
end Alarm;

architecture Behavioral of Alarm is

signal alarm_hh : std_logic_vector(7 downto 0) := "00010111";
signal alarm_mm : std_logic_vector(7 downto 0) := "00111011";

begin


        -- default value for clock
        --alarm_hh <= x"17";
        --alarm_mm <= x"3b";
    
        -- setting alarm time
        process (mode, A, CLK100MHZ)
        begin
            if (mode = "01" and rising_edge (CLK100MHZ)) then
            
                if (A = '1') then
                    if (alarm_hh = x"17") then
                        alarm_hh <= x"00";
                    else
                        alarm_hh <= std_logic_vector(unsigned(alarm_hh) + 1);
                    end if;
                else    
               
                   alarm_hh <= alarm_hh; 
                
                end if;
                
            else
                    
                alarm_hh <= alarm_hh;
                
            end if;
            
                
        end process;
        
        process (mode, B, CLK100MHZ)
        begin
            if (mode = "01" and rising_edge (CLK100MHZ)) then
                
                if (B = '1') then
                    if (alarm_mm = x"3b") then
                        alarm_mm <= x"00";
                    else
                        alarm_mm <= std_logic_vector(unsigned(alarm_mm) + 1);
                    end if;
                    
                else    
            
                alarm_mm <= alarm_mm;
                
                end if;
                
            else    
                alarm_mm <= alarm_mm;
                
            end if;
            
                
        end process;


    -- Output the alarm set values
    ahh <= alarm_hh;
    amm <= alarm_mm;
    

     
    -- launch alarm if time matches
    alarm_out <= '1' when (hh = alarm_hh and mm = alarm_mm) else '0';


end Behavioral;