library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity BinTo7seg is
port (
    clk : in std_logic;
    HH : in std_logic_vector(7 downto 0); -- all will have united length
    MM : in std_logic_vector(7 downto 0);
    SS : in std_logic_vector(7 downto 0);
    --SVV : in std_logic_vector(7 downto 0); -- just port it to the SS terminal
    --MODE : in std_logic_vector(1 downto 0); -- will ignore
    SEG_OUT : out std_logic_vector(7 downto 0); -- used to forward singular numbers out
    POS_OUT : out std_logic_vector(5 downto 0); -- position of each 7seg disp (should cycle between them)
    -- common anode so diplay turned on should have value 0 at its anode
);
end entity BinTo7seg;

    architecture behavioral of BinTo7seg is


    signal digit0 : integer range 0 to 9;
    signal digit1 : integer range 0 to 9;
    signal POS_reg : unsigned(2 downto 0) := (others => '0');
    constant n7SegDisp : integer := 6;

    begin

    
    -- Separate the two digits from the input number
    digit1 <= number_in / 10;  -- Get the tens digit
    digit0 <= number_in mod 10; -- Get the units digit




-- tick generating process if necessary, skip otherwise 



process (Position_counter)
begin
    if rising_edge(clk) then -- could be done at slower rate tho (not necessary hopefully, manual suggest 1ms per each)
        if POS_reg = 6 then
            POS_reg <= (others => '0');
        else
            POS_reg <= POS_reg + 1; 
        end if;
    end if;
end process;

process (Pos_converter)
begin
if rising_edge(clk)
case POS_reg is
    when 6 => POS_OUT <= '011111'; -- display lights on '0'
    when 5 => POS_OUT <= '101111';
    -- and so on --
    
    when others => POS_OUT <= '111111';
end case;
end if;
end process;

process (BCD)
begin
-- code that lights individual segments (labs)
-- make it synchronous
end process;
end architecture behavioral;