library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_divider is
    generic (
        CLK_IN_HZ  : integer := 50_000_000; -- Input clock frequency (e.g., 50 MHz)
        CLK_1HZ_DIV : integer := 50_000_000; -- Divisor for 1 Hz
        CLK_100HZ_DIV: integer := 500_000;   -- Divisor for 100 Hz (stopwatch)
        CLK_MUX_DIV : integer := 50_000      -- Divisor for ~1kHz (display mux)
    );
    port (
        clk_in      : in  std_logic;
        reset       : in  std_logic;
        clk_1Hz_out : out std_logic := '0';
        clk_100Hz_out: out std_logic := '0';
        clk_mux_out : out std_logic := '0'
    );
end entity clk_divider;

architecture behavioral of clk_divider is
    signal count_1Hz   : integer range 0 to CLK_1HZ_DIV - 1 := 0;
    signal count_100Hz : integer range 0 to CLK_100HZ_DIV - 1 := 0;
    signal count_mux   : integer range 0 to CLK_MUX_DIV - 1 := 0;
    signal clk_1Hz_tick, clk_100Hz_tick, clk_mux_tick : std_logic := '0';
begin

    process(clk_in, reset)
    begin
        if reset = '1' then
            count_1Hz <= 0;
            count_100Hz <= 0;
            count_mux <= 0;
            clk_1Hz_tick <= '0';
            clk_100Hz_tick <= '0';
            clk_mux_tick <= '0';
        elsif rising_edge(clk_in) then
            -- 1Hz Clock Generation
            clk_1Hz_tick <= '0';
            if count_1Hz = CLK_1HZ_DIV - 1 then
                count_1Hz <= 0;
                clk_1Hz_tick <= '1'; -- Generate a single cycle pulse
            else
                count_1Hz <= count_1Hz + 1;
            end if;

            -- 100Hz Clock Generation
            clk_100Hz_tick <= '0';
            if count_100Hz = CLK_100HZ_DIV - 1 then
                count_100Hz <= 0;
                clk_100Hz_tick <= '1';
            else
                count_100Hz <= count_100Hz + 1;
            end if;

            -- Display Mux Clock Generation
            clk_mux_tick <= '0';
            if count_mux = CLK_MUX_DIV - 1 then
                count_mux <= 0;
                clk_mux_tick <= '1';
            else
                count_mux <= count_mux + 1;
            end if;
        end if;
    end process;

    -- Generate continuous clocks (optional, ticks might be more useful)
    process(clk_in, reset)
    begin
        if reset = '1' then
            clk_1Hz_out <= '0';
            clk_100Hz_out <= '0';
            clk_mux_out <= '0';
        elsif rising_edge(clk_in) then
             if clk_1Hz_tick = '1' then
                 clk_1Hz_out <= not clk_1Hz_out;
             end if;
             if clk_100Hz_tick = '1' then
                 clk_100Hz_out <= not clk_100Hz_out;
             end if;
             if clk_mux_tick = '1' then
                 clk_mux_out <= not clk_mux_out;
             end if;
        end if;
    end process;

end architecture behavioral;