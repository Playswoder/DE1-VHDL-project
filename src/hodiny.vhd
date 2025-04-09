library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hodiny is
    Port ( clk100MHz : in  std_logic;
           A         : in  std_logic;
           B         : in  std_logic;
           C         : in  std_logic;
           HH        : out std_logic_vector(4 downto 0); 
           MM        : out std_logic_vector(5 downto 0); 
           SS        : out std_logic_vector(5 downto 0)  
         );
end entity hodiny;
architecture Behavioral of hodiny is
    signal s_sekundy : integer range 0 to 59 := 0;
    signal s_minuty  : integer range 0 to 59 := 0;
    signal s_hodiny  : integer range 0 to 23 := 0;

    signal count : integer range 0 to 99999999; 
    signal mode  : integer range 0 to 1 := 0;   

begin
    process (clk100MHz)
    begin
        if rising_edge(clk100MHz) then
            if mode = 0 then 
                count <= count + 1;
                if count = 1000 then 
                    count <= 0;
                    if s_sekundy = 59 then
                        s_sekundy <= 0;
                        if s_minuty = 59 then
                            s_minuty <= 0;
                            if s_hodiny = 23 then
                                s_hodiny <= 0;
                            else
                                s_hodiny <= s_hodiny + 1;
                            end if;
                        else
                            s_minuty <= s_minuty + 1;
                        end if;
                    else
                        s_sekundy <= s_sekundy + 1;
                    end if;
                end if;
            else 
                if rising_edge(A) then
                    if s_hodiny = 23 then
                        s_hodiny <= 0;
                    else
                        s_hodiny <= s_hodiny + 1;
                    end if;
                end if;
                if rising_edge(B) then
                    if s_hodiny = 0 then
                        s_hodiny <= 23;
                    else
                        s_hodiny <= s_hodiny - 1;
                    end if;
                end if;
            end if;

            
            if rising_edge(C) then
                mode <= 1 - mode; 
            end if;
        end if;
    end process;

   
    HH <= std_logic_vector(to_unsigned(s_hodiny, 5));
    MM <= std_logic_vector(to_unsigned(s_minuty, 6));
    SS <= std_logic_vector(to_unsigned(s_sekundy, 6));

end architecture Behavioral;

