library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity switch is

    Port ( hh       : in STD_LOGIC_VECTOR (7 downto 0);
           mm       : in STD_LOGIC_VECTOR (7 downto 0);
           ss       : in STD_LOGIC_VECTOR (7 downto 0);
           D        : in std_logic_vector (1 downto 0); 
           ahh      : in STD_LOGIC_VECTOR (7 downto 0);
           amm      : in STD_LOGIC_VECTOR (7 downto 0);
           smm      : in STD_LOGIC_VECTOR (7 downto 0);
           sss      : in STD_LOGIC_VECTOR (7 downto 0);
           svv      : in STD_LOGIC_VECTOR (7 downto 0);
           
           fhh      : out STD_LOGIC_VECTOR (7 downto 0);
           fmm      : out STD_LOGIC_VECTOR (7 downto 0);
           fss      : out STD_LOGIC_VECTOR (7 downto 0)
           );
           
end switch;

architecture Behavioral of switch is
    
signal sig_mode : unsigned(1 downto 0) := "00";
signal D_prev : std_logic := '0';


begin

    Switch_proc : process(hh, mm, ss, D, ahh, amm, smm, sss, svv, sig_mode)
    begin
        case D is
            when "00" =>
                fhh <= hh;
                fmm <= mm;
                fss <= ss;
            when "01" =>
                fhh <= ahh;
                fmm <= amm;
                fss <= "00000000";
            when "10" =>
                fhh <= smm;
                fmm <= sss;
                fss <= svv;
            when others =>
                fhh <= (others => '0');
                fmm <= (others => '0');
                fss <= (others => '0');
        end case;
    end process Switch_proc;
end Behavioral;
