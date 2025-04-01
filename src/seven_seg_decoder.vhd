library ieee;
use ieee.std_logic_1164.all;

entity seven_seg_decoder is
    port (
        bcd_in    : in  std_logic_vector(3 downto 0);
        segment_out : out std_logic_vector(6 downto 0) -- (gfedcba) - common cathode assumed (active high)
    );
end entity seven_seg_decoder;

architecture behavioral of seven_seg_decoder is
begin
    process(bcd_in)
    begin
        case bcd_in is
            when "0000" => segment_out <= "0111111"; -- 0
            when "0001" => segment_out <= "0000110"; -- 1
            when "0010" => segment_out <= "1011011"; -- 2
            when "0011" => segment_out <= "1001111"; -- 3
            when "0100" => segment_out <= "1100110"; -- 4
            when "0101" => segment_out <= "1101101"; -- 5
            when "0110" => segment_out <= "1111101"; -- 6
            when "0111" => segment_out <= "0000111"; -- 7
            when "1000" => segment_out <= "1111111"; -- 8
            when "1001" => segment_out <= "1101111"; -- 9
            when others => segment_out <= "1000000"; -- Dash or blank for invalid BCD
        end case;
    end process;
end architecture behavioral;
-- Note: Adjust segment mapping based on your specific display's common anode/cathode and pinout.