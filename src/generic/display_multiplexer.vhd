library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_multiplexer is
    generic (
        NUM_DIGITS : integer := 6
    );
    port (
        clk         : in  std_logic; -- Use clk_mux_out (~1kHz) from divider
        reset       : in  std_logic;
        -- BCD inputs for 6 digits (e.g., HH MM SS or MM SS CC)
        digit5_bcd  : in  std_logic_vector(3 downto 0); -- Most significant (e.g., H_tens)
        digit4_bcd  : in  std_logic_vector(3 downto 0); -- (e.g., H_units)
        digit3_bcd  : in  std_logic_vector(3 downto 0); -- (e.g., M_tens)
        digit2_bcd  : in  std_logic_vector(3 downto 0); -- (e.g., M_units)
        digit1_bcd  : in  std_logic_vector(3 downto 0); -- (e.g., S_tens)
        digit0_bcd  : in  std_logic_vector(3 downto 0); -- Least significant (e.g., S_units)
        -- Outputs to display hardware
        anode_select: out std_logic_vector(NUM_DIGITS-1 downto 0); -- Active LOW for common anode usually
        segment_out : out std_logic_vector(6 downto 0)  -- From seven_seg_decoder
    );
end entity display_multiplexer;

architecture behavioral of display_multiplexer is
    signal current_digit_bcd : std_logic_vector(3 downto 0);
    signal digit_select      : integer range 0 to NUM_DIGITS-1 := 0;

    -- Component Declaration for the decoder
    component seven_seg_decoder is
        port (
            bcd_in    : in  std_logic_vector(3 downto 0);
            segment_out : out std_logic_vector(6 downto 0)
        );
    end component;

    signal segments_internal : std_logic_vector(6 downto 0);
    signal anode_select_int : std_logic_vector(NUM_DIGITS-1 downto 0);

begin
    -- Instantiate the BCD to 7-segment decoder
    decoder_inst : seven_seg_decoder
        port map (
            bcd_in      => current_digit_bcd,
            segment_out => segments_internal
        );

    -- Digit Selection Multiplexer (combinatorial)
    process(digit_select, digit0_bcd, digit1_bcd, digit2_bcd, digit3_bcd, digit4_bcd, digit5_bcd)
    begin
        case digit_select is
            when 0 => current_digit_bcd <= digit0_bcd;
            when 1 => current_digit_bcd <= digit1_bcd;
            when 2 => current_digit_bcd <= digit2_bcd;
            when 3 => current_digit_bcd <= digit3_bcd;
            when 4 => current_digit_bcd <= digit4_bcd;
            when 5 => current_digit_bcd <= digit5_bcd;
            when others => current_digit_bcd <= "----"; -- Should not happen
        end case;
    end process;

    -- Anode/Digit Selection Counter (sequential)
    process(clk, reset)
    begin
        if reset = '1' then
            digit_select <= 0;
        elsif rising_edge(clk) then -- Use MUX clock tick
            if digit_select = NUM_DIGITS - 1 then
                digit_select <= 0;
            else
                digit_select <= digit_select + 1;
            end if;
        end if;
    end process;

    -- Generate Anode Select Signal (Active Low Example)
    process(digit_select)
    variable anode_temp : std_logic_vector(NUM_DIGITS-1 downto 0);
    begin
         anode_temp := (others => '1'); -- All off
         anode_temp(digit_select) := '0'; -- Turn selected one ON
         anode_select_int <= anode_temp;
    end process;

    -- Assign internal signals to outputs
    segment_out <= segments_internal;
    anode_select <= anode_select_int;

end architecture behavioral;