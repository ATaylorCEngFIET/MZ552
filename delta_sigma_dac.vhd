library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.fixed_float_types.all;

entity delta_sigma_dac is port(
    i_clk           : in std_logic;
    i_sample_val    : in std_logic;
    i_sample_data   : in std_logic_vector(15 downto 0);

    o_dac_op        : out std_logic
);
end entity;

architecture rtl of delta_sigma_dac is 
    signal s_accumulator : sfixed(3 downto -16) := (others =>'0'); 
    signal s_feedback    : sfixed(3 downto -16) := (others =>'0');

begin

    dac_1st: process(i_clk)
        variable v_accum_temp : sfixed(3 downto -16);
    begin
        if rising_edge(i_clk) then 
            if i_sample_val ='1' then 
                v_accum_temp := resize (arg => (s_accumulator + to_sfixed( i_sample_data,-1,-16)- s_feedback), 
                                        size_res => s_accumulator,
                                        overflow_style => fixed_wrap);
                o_dac_op <= '0' when v_accum_temp < 0 else '1';
                s_accumulator <= v_accum_temp;
            end if;
        end if;
    end process;

    s_feedback <= to_sfixed(-1,3,-16) when o_dac_op = '1' else to_sfixed( 1,3,-16);      

end architecture;