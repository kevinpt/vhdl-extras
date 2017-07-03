--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# secded_codec.vhdl - Synthesizable SECDED encoder/decoder component
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2010 Kevin Thibedeau
--# (kevin 'period' thibedeau 'at' gmail 'punto' com)
--#
--# Permission is hereby granted, free of charge, to any person obtaining a
--# copy of this software and associated documentation files (the "Software"),
--# to deal in the Software without restriction, including without limitation
--# the rights to use, copy, modify, merge, publish, distribute, sublicense,
--# and/or sell copies of the Software, and to permit persons to whom the
--# Software is furnished to do so, subject to the following conditions:
--#
--# The above copyright notice and this permission notice shall be included in
--# all copies or substantial portions of the Software.
--#
--# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
--# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
--# DEALINGS IN THE SOFTWARE.
--#
--# DEPENDENCIES: secded_edac pipelining sizing hamming_edac parity_ops
--#
--# DESCRIPTION:
--#  This package provides a component that implements SECDED EDAC as a
--#  single unified codec. The codec can switch between encoding and decoding
--#  on each clock cycle with a minimum latency of two clock cycles through the
--#  input and output registers. The SECDED logic is capable of correcting
--#  single-bit errors and detecting double-bit errors.
--#
--#  Optional pipelining is available to reduce the maximum delay through the
--#  internal logic. To be effective, you must activate the retiming feature of
--#  the synthesis tool being used. See the notes in pipelining.vhdl for more
--#  information on how to accomplish this. The pipelining is controlled with
--#  the PIPELINE_STAGES generic. A value of 0 will disable pipelining.
--#
--#  To facilitate testing, the codec includes an error generator that can
--#  insert single-bit and double-bit errors into the encoded output. When
--#  active, successive bits are flipped on each clock cycle. This feature
--#  provides for the testing of error handling logic in the decoding process.
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library extras;
use extras.hamming_edac.ecc_vector;
use extras.secded_edac.secded_indices;

package secded_codec_pkg is

  -- Coded_mode constants
  --# Select encoding mode
  constant CODEC_ENCODE : std_ulogic := '0';
  --# Select decoding mode
  constant CODEC_DECODE : std_ulogic := '1';

  -- Insert_error constants
  --# No error injection
  constant INSERT_NONE   : std_ulogic_vector := "00";
  --# Single-bit error injection
  constant INSERT_SINGLE : std_ulogic_vector := "01";
  --# Double-bit error injection
  constant INSERT_DOUBLE : std_ulogic_vector := "10";

  component secded_codec is
    generic (
      DATA_SIZE : positive;                  --# Size of the ``Data`` input
      PIPELINE_STAGES : natural := 0;        --# Number of pipeline stages appended to end
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Codec_mode   : in std_ulogic; --# OPerating mode: '0' = encode, '1' = decode
      Insert_error : in std_ulogic_vector(1 downto 0); --# Error injection

      --# {{data|Encoding port}}
      Data         : in std_ulogic_vector(DATA_SIZE-1 downto 0); --# Data to encode
      Encoded_data : out ecc_vector(DATA_SIZE-1 downto secded_indices(DATA_SIZE).right); --# Data message with  SECDED parity

      --# {{Decoding port}}
      Ecc_data     : in ecc_vector(DATA_SIZE-1 downto secded_indices(DATA_SIZE).right); --# Received data
      Decoded_data : out std_ulogic_vector(DATA_SIZE-1 downto 0); --# Received data with errors corrected

      --# {{Error flags}}
      Single_bit_error : out std_ulogic; --# '1' when a single-bit error is detected (automatically corrected)
      Double_bit_error : out std_ulogic  --# '1' when a double-bit error is detected
    );
  end component;

end package;


library ieee;
use ieee.std_logic_1164.all;

library extras;
use extras.hamming_edac.all;
use extras.secded_edac.secded_indices;

entity secded_codec is
  generic (
    DATA_SIZE : positive;
    PIPELINE_STAGES : natural := 0;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic; -- Asynchronous reset

    Codec_mode   : in std_ulogic; -- '0' = encode, '1' = decode
    Insert_error : in std_ulogic_vector(1 downto 0);

    -- encoding port
    Data         : in std_ulogic_vector(DATA_SIZE-1 downto 0);
    Encoded_data : out ecc_vector(DATA_SIZE-1 downto secded_indices(DATA_SIZE).right);

    -- decoding port
    Ecc_data     : in ecc_vector(DATA_SIZE-1 downto secded_indices(DATA_SIZE).right);
    Decoded_data : out std_ulogic_vector(DATA_SIZE-1 downto 0);

    -- error flags
    Single_bit_error : out std_ulogic;
    Double_bit_error : out std_ulogic
  );
end entity;

library ieee;
use ieee.numeric_std.all;

library extras;
use extras.hamming_edac.all;
use extras.secded_edac.all;
use extras.secded_codec_pkg.all;
use extras.pipelining.all;

architecture rtl of secded_codec is

  constant MSG_SIZE : positive := secded_message_size(Data'length);

  subtype ecc_word is
    ecc_vector(Data'length-1 downto -secded_parity_size(MSG_SIZE));


  -- Input registers
  signal codec_mode_reg : std_ulogic;
  signal insert_error_reg : std_ulogic_vector(Insert_error'range);
  signal data_reg : std_ulogic_vector(Data'range);
  signal ecc_data_reg : ecc_vector(Ecc_data'range);


  signal enc_data, enc_data_reg : ecc_word;
  signal enc_data_pl : std_logic_vector(enc_data'length-1 downto 0);

  signal dec_data, dec_data_reg : std_ulogic_vector(Data'length-1 downto 0);
  signal dec_data_pl : std_logic_vector(dec_data'range);

  signal error_mask_1bit, error_mask_2bit, error_mask : ecc_word;


  signal insert_error_pl : std_logic_vector(Insert_error'range);
  signal insert_error_pl_sulv : std_ulogic_vector(Insert_error'range);
  signal codec_mode_pl : std_logic;
  signal errors_slv : std_logic_vector(1 downto 0);
  signal errors_pl : std_logic_vector(errors_slv'range);

begin

  -- input registers
  in_regs: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      codec_mode_reg <= CODEC_ENCODE;
      insert_error_reg <= INSERT_NONE;
      data_reg <= (others => '0');
      ecc_data_reg <= (others => '0');

    elsif rising_edge(Clock) then
      codec_mode_reg <= Codec_mode;
      insert_error_reg <= Insert_error;
      data_reg <= Data;
      ecc_data_reg <= Ecc_data;
    end if;
  end process;

  -- combinational logic implementing the SECDED codec
  codec_comb: process(codec_mode_reg, data_reg, ecc_data_reg) is
    variable txrx_data : std_ulogic_vector(data_reg'length-1 downto 0);
    variable txrx_parity : unsigned(-enc_data'low-1 downto 1);

    variable message : std_ulogic_vector(enc_data'length-1 downto 1);
    variable parity_bits : unsigned(txrx_parity'range);

    variable errors : secded_errors;

    function to_stdulogic( a : boolean ) return std_ulogic is
    begin
      if a then
        return '1';
      else
        return '0';
      end if;
    end function;

  begin
      if codec_mode_reg = CODEC_ENCODE then -- encoding
        txrx_data   := data_reg;
        txrx_parity := (others => '0');
      else -- decoding
        txrx_data   := get_data(ecc_data_reg);

        -- Hamming parity without the SECDED overall parity bit
        txrx_parity := get_parity(ecc_data_reg(-1 downto Ecc_data'low+1));
      end if;

      message     := hamming_interleave(txrx_data, txrx_parity);
      parity_bits := hamming_parity(message); -- also acts as the syndrome

      enc_data <= secded_encode(data_reg, parity_bits);
      dec_data <= hamming_decode(message, parity_bits);
      errors := secded_has_errors(ecc_data_reg, parity_bits);
      errors_slv <= to_stdulogic(errors(double_bit)) & to_stdulogic(errors(single_bit));
  end process;


  -- feedthrough for the case where no pipelining is selected
  no_pl: if PIPELINE_STAGES = 0 generate
  begin
    insert_error_pl <= to_stdlogicvector(Insert_error);
    codec_mode_pl <= Codec_mode;

    enc_data_pl <= to_stdlogicvector(to_sulv(enc_data));
    dec_data_pl <= to_stdlogicvector(dec_data);
    errors_pl <= errors_slv;
  end generate;

  -- pipeline register instances
  pl: if PIPELINE_STAGES > 0 generate

    signal insert_error_slv : std_logic_vector(Insert_error'range);

    signal enc_data_slv, enc_data_pl_tag : std_logic_vector(enc_data'length-1 downto 0);
    signal dec_data_slv, dec_data_pl_tag : std_logic_vector(dec_data'range);
    signal errors_pl_tag : std_logic_vector(errors_slv'range);

  begin
    insert_error_slv <= to_stdlogicvector(Insert_error);
    pl_ie: pipeline_slv generic map(PIPELINE_STAGES, RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL)
      port map(Clock, Reset, insert_error_slv, insert_error_pl);

    pl_m: pipeline_ul generic map(PIPELINE_STAGES, RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL)
      port map(Clock, Reset, Sig_in => Codec_mode, Sig_out => codec_mode_pl);

    enc_data_slv <= to_stdlogicvector(to_sulv(enc_data));
    pl_ed: pipeline_slv generic map(PIPELINE_STAGES, RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL)
      port map(Clock, Reset, enc_data_slv, enc_data_pl_tag);
    enc_data_pl <= enc_data_pl_tag;

    dec_data_slv <= to_stdlogicvector(dec_data);
    pl_dd: pipeline_slv generic map(PIPELINE_STAGES, RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL)
      port map(Clock, Reset, dec_data_slv, dec_data_pl_tag);
    dec_data_pl <= dec_data_pl_tag;

    pl_e: pipeline_slv generic map(PIPELINE_STAGES, RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL)
      port map(Clock, Reset, errors_slv, errors_pl_tag);
    errors_pl <= errors_pl_tag;

  end generate;

  -- output registers
  out_regs: process(Clock, Reset)

    function "xor"( left, right : ecc_vector ) return ecc_vector is
      variable result : ecc_vector(left'range);
    begin
      result := to_ecc_vec(to_sulv(left) xor to_sulv(right));
      return result;
    end function;

  begin

    if Reset = RESET_ACTIVE_LEVEL then
      enc_data_reg <= (others => '0');
      dec_data_reg <= (others => '0');

      Single_bit_error <= '0';
      Double_bit_error <= '0';

    elsif rising_edge(Clock) then

      enc_data_reg <= to_ecc_vec(to_stdulogicvector(enc_data_pl)) xor error_mask;
      dec_data_reg <= to_stdulogicvector(dec_data_pl);

      if codec_mode_pl = CODEC_ENCODE then -- encoding, no errors
        Single_bit_error <= '0';
        Double_bit_error <= '0';
      else -- decoding
        Single_bit_error <= errors_pl(0);
        Double_bit_error <= errors_pl(1);

      end if;
    end if;

  end process;

  -- These can't be registered directly because of unconstrained array limtations
  -- on initialization with an (others => '0') aggregate;
  Encoded_data <= enc_data_reg;
  Decoded_data <= dec_data_reg;

  -- error generator
  error_gen: process(Clock, Reset)

    function "rol"(left : ecc_vector; right : natural) return ecc_vector is
      variable result : ecc_vector(left'range);
    begin
      result := to_ecc_vec(
        to_stdulogicvector(std_logic_vector(
          unsigned(to_stdlogicvector(to_sulv(left))) rol right
        ))
       );
      return result;
    end function;

  begin
    if Reset = RESET_ACTIVE_LEVEL then
      error_mask_1bit <= (others => '0');
      error_mask_1bit(0) <= '1';

      error_mask_2bit <= (others => '0');
      error_mask_2bit(0) <= '1';
      error_mask_2bit(2) <= '1';

    elsif rising_edge(Clock) then
      error_mask_1bit <= error_mask_1bit rol 1;
      error_mask_2bit <= error_mask_2bit rol 1;
    end if;
  end process;

  insert_error_pl_sulv <= to_stdulogicvector(insert_error_pl);
  with insert_error_pl_sulv select
    error_mask <= error_mask_1bit when INSERT_SINGLE,
                  error_mask_2bit when INSERT_DOUBLE,
                  (others => '0') when others;

end architecture;
