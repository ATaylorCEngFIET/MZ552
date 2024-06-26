
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use work.p_wave_Package.all;

entity delta_sigma_dac_tb is
end;

architecture bench of delta_sigma_dac_tb is

  constant c_clk_period : time := 5 ns;
  constant c_sequence_len : integer := 1000;
  constant c_wave_len : integer := 100;

  signal s_clk : std_logic:='0';
  signal s_sample_val : std_logic;
  signal s_sample_data : std_logic_vector(15 downto 0);
  signal s_dac_op : std_logic;



  signal s_count          : integer := 0;
  signal s_sample_count   : integer := 0;

begin

  delta_sigma_dac_inst : entity work.delta_sigma_dac
  port map (
    i_clk => s_clk,
    i_sample_val => s_sample_val,
    i_sample_data => s_sample_data,
    o_dac_op => s_dac_op
  );
  
  s_clk <= not s_clk after ( c_clk_period / 2);

stim: process(s_clk)
    begin
        if rising_edge(s_clk) then
            s_sample_data <= analog_wave(s_sample_count);
            s_sample_val <= '1';
            if s_count = ( c_sequence_len - 1 ) then
                if s_sample_count = ( c_wave_len - 1) then
                   s_sample_count <= 0;
                else
                   s_sample_count <= s_sample_count +1;
                end if;
                s_count <= 0;
            else
                s_count <= s_count + 1;
            end if;
         end if;
    end process;


end architecture;