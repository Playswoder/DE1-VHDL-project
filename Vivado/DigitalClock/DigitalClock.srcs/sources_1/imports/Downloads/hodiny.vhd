library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hodiny is
    Port (
        clk100MHz : in  std_logic;
        A         : in  std_logic;
        B         : in  std_logic;
        C         : in  std_logic;
        mode      : in std_logic_vector(1 downto 0);
        HH        : out std_logic_vector(7 downto 0);
        MM        : out std_logic_vector(7 downto 0);
        SS        : out std_logic_vector(7 downto 0)
    );
end entity hodiny;

architecture Behavioral of hodiny is
    signal s_sekundy : integer range 0 to 59 := 0;
    signal s_minuty  : integer range 0 to 59 := 0;
    signal s_hodiny  : integer range 0 to 23 := 0;

    constant SECOND_TC : natural := 100_000_000;
    signal count : natural range 0 to SECOND_TC - 1;
    signal second_tick : std_logic := '0';

    
    signal A_prev, B_prev, C_prev : std_logic := '0';
  

  
    signal temp_hodiny : integer range 0 to 23 := 0;
    signal temp_minuty : integer range 0 to 59 := 0;

begin

       
   
    tick_gen_proc : process(clk100MHz)
    begin
        if rising_edge(clk100MHz) then
            if count = SECOND_TC - 1 then
                count <= 0;
                second_tick <= '1';
            else
                count <= count + 1;
                second_tick <= '0';
            end if;
        end if;
    end process;

    
    Clock : process(clk100MHz)
    begin
        if rising_edge(clk100MHz) then
            
            A_prev <= A;
            B_prev <= B;
            C_prev <= C;

            

               
                
                    if second_tick = '1' then
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

                    
                    if C = '1' and C_prev = '0' then
                        
                        temp_hodiny <= s_hodiny;
                        temp_minuty <= s_minuty;
                    end if;
case mode is
                
                when "00" =>
                   
                    if A = '1' and A_prev = '0' then
                        if temp_hodiny = 23 then
                            temp_hodiny <= 0;
                        else
                            temp_hodiny <= temp_hodiny + 1;
                        end if;
                    end if;

                    if B = '1' and B_prev = '0' then
                        if temp_minuty = 59 then
                            temp_minuty <= 0;
                        else
                            temp_minuty <= temp_minuty + 1;
                        end if;
                    end if;

                    
                    if C = '1' and C_prev = '0' then
                        s_hodiny <= temp_hodiny;
                        s_minuty <= temp_minuty;
                        s_sekundy <= 0;
                         
                    end if;

                  when others => null;

                end case;
            end if;
        end process;
    SS <= std_logic_vector(TO_UNSIGNED(s_sekundy, 8));
    MM <= std_logic_vector(TO_UNSIGNED(s_minuty,8));
    HH <= std_logic_vector(TO_UNSIGNED(s_hodiny,8));
       
    end Behavioral;
