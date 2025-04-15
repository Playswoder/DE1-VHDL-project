library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hodiny is
    Port ( clk100MHz : in  std_logic;
           A         : in  std_logic; -- co to dělá ten čudlík
           B         : in  std_logic;
           C         : in  std_logic; -- confirm třeba
           mode      : in std_logic_vector(1 downto 0);
           HH        : out std_logic_vector(4 downto 0); 
           MM        : out std_logic_vector(5 downto 0); 
           SS        : out std_logic_vector(5 downto 0)  
         );
end entity hodiny;
architecture Behavioral of hodiny is
    signal s_sekundy : integer range 0 to 59 := 0;
    signal s_minuty  : integer range 0 to 59 := 0;
    signal s_hodiny  : integer range 0 to 23 := 0;


    constant SECOND_TC : natural := 1e8; -- počet period CLK100MHz na jednu sekundu

    signal count : natural range 0 to SECOND_TC - 1; 
    signal second_tick : std_logic := '0';

    signal mode_enable  : std_logic := '0';   

begin


    -- Tick generation process
    tick_gen_proc : process(clk100MHz)
    begin
        if rising_edge(clk100MHz) then      
            if count = SECOND_TC - 1 then
                        count <= 0;
                        second_tick <= '1'; -- Generate tick
                    else
                        count <= count + 1;
                        second_tick <= '0'; -- Ensure tick remains low
                    end if;
                end if;
    end process tick_gen_proc;


    Clock : process (clk100MHz)
    begin

        mode_enable <= '1' when mode = "00" else '0'; -- jen když mode je ve stavu "00" bude reagovat na čudlíky

        if rising_edge(clk100MHz) then 
            if second_tick = '1' and mode_enable = 0 then
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
        else -- if rising_edge(clk100MHz) nemusí mít else

                if rising_edge(A) then -- změnit
                    if s_hodiny = 23 then
                        s_hodiny <= 0;
                    else
                        s_hodiny <= s_hodiny + 1;
                    end if;
                end if;

                if rising_edge(B) then -- zmnit rising edge
                    if s_hodiny = 0 then
                        s_hodiny <= 23;
                    else
                        s_hodiny <= s_hodiny - 1;
                    end if;
                end if;
            end if;

            
            if rising_edge(C) then -- mode je input
                mode <= 1 - mode; 
            end if;
    end process Clock;

   
    HH <= std_logic_vector(to_unsigned(s_hodiny, 5));
    MM <= std_logic_vector(to_unsigned(s_minuty, 6));
    SS <= std_logic_vector(to_unsigned(s_sekundy, 6));

end architecture Behavioral;

