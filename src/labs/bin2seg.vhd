----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2025 09:06:25 AM
-- Design Name: 
-- Module Name: bin2seg - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bin2seg is
    Port ( clear : in STD_LOGIC;
           bin : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end bin2seg;

architecture Behavioral of bin2seg is

begin



-- This combinational process decodes binary input (`bin`) into 7-segment display output
-- (`seg`) for a Common Anode configuration. When either `bin` or `clear` changes, the
-- process is triggered. Each bit in `seg` represents a segment from A to G. The display
-- is cleared if input `clear` is set to 1.
p_7seg_decoder : process (bin, clear) is
begin

  if (clear = '1') then
    seg <= "1111111";  -- Clear the display
  else

    case bin is
      when x"0" =>     -- x"0" means "0000" in hexadecimal
        seg <= "0000001";
      when x"1" =>
        seg <= "1001111";

      -- WRITE YOUR CODE HERE
      -- 2, 3, 4, 5, 6
      when x"2" =>     -- Display 2
        seg <= "0010010";  -- segments a, b, d, e, g on

      when x"3" =>     -- Display 3
        seg <= "0000110";  -- segments a, b, c, d, g on

      when x"4" =>     -- Display 4
        seg <= "1001100";  -- segments b, c, f, g on

      when x"5" =>     -- Display 5
        seg <= "0100100";  -- segments a, c, d, f, g on

      when x"6" =>     -- Display 6
        seg <= "0100000";  -- segments a, c, d, e, f, g on

      when x"7" =>
        seg <= "0001111";
      when x"8" =>
        seg <= "0000000";

      -- WRITE YOUR CODE HERE
      -- 9, A, b, C, d

      when x"9" =>     -- Display 9
        seg <= "0000100";  -- segments a, b, c, d, f, g on

      when x"A" =>     -- Display A
        seg <= "0001000";  -- segments a, b, c, e, f, g on

      when x"b" =>     -- Display b
        seg <= "1100000";  -- segments c, d, e, f, g on

      when x"C" =>     -- Display C
        seg <= "0110001";  -- segments a, d, e, f on

      when x"d" =>     -- Display d
        seg <= "1000010";  -- segments b, c, d, e, g on

      when x"E" =>
        seg <= "0110000";
      when others =>
        seg <= "0111000";
    end case;

  end if;    
end process p_7seg_decoder;










end Behavioral;
