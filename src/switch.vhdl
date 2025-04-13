library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity switch is

    Port ( hh       : in STD_LOGIC_VECTOR (4 downto 0);
           mm       : in STD_LOGIC_VECTOR (5 downto 0);
           ss       : in STD_LOGIC_VECTOR (5 downto 0);
           D        : in STD_LOGIC_VECTOR (1 downto 0);
           ahh      : in STD_LOGIC_VECTOR (4 downto 0);
           amm      : in STD_LOGIC_VECTOR (5 downto 0);
           smm      : in STD_LOGIC_VECTOR (5 downto 0);
           sss      : in STD_LOGIC_VECTOR (5 downto 0);
           svv      : in STD_LOGIC_VECTOR (6 downto 0);
           
           fhh      : out STD_LOGIC_VECTOR (4 downto 0);
           fmm      : out STD_LOGIC_VECTOR (5 downto 0);
           fss      : out STD_LOGIC_VECTOR (5 downto 0);
           fvv      : out STD_LOGIC_VECTOR (6 downto 0);
           mode     : out STD_LOGIC_VECTOR (1 downto 0)
           );
           
end switch;

architecture Behavioral of switch is
    
signal sig_mode : unsigned(1 downto 0) := "00";



begin
 -- pokud to bude dělat latche tak to uděláme synchronní
   Mode_Sel : process(D)
   begin
            if mode = "10" then
                D_prev <= '0';
            else
                D_prev <= D; -- Edge detection
                    if D = '1' and D_prev = '0' then
                        sig_mode = sig_mode + 1;
                        else
                        sig_mode <= '0'; 
                    end if;
                end if;

   end process Mode_Sel;
    
    mode <= std_logic_vector(sig_mode);

    Switch_proc : process(hh, mm, ss, D, ahh, amm, smm, sss, svv)
    begin
        mode <= "00";
        fhh <= (others => '0');
        fmm <= (others => '0');
        fss <= (others => '0');
        fvv <= (others => '0');
        case std_logic_vector(sig_mode) is
            when "00" =>
                fhh <= hh;
                fmm <= mm;
                fss <= ss;
                fvv <= "0000000";
            when "01" =>
                fhh <= ahh;
                fmm <= amm;
                fss <= "000000";
                fvv <= "0000000";
            when "10" =>
                fhh <= "00000";
                fmm <= smm;
                fss <= sss;
                fvv <= svv;
            when others =>
                mode <= "00";
        end case;
    end process Switch_proc;
end Behavioral;
