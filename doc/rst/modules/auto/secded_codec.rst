.. Generated from ../rtl/extras/secded_codec.vhdl on 2018-06-28 23:37:28.760142
.. vhdl:package:: extras.secded_codec_pkg


Constants
---------


.. vhdl:constant:: CODEC_ENCODE

  Select encoding mode

.. vhdl:constant:: CODEC_DECODE

  Select decoding mode

.. vhdl:constant:: INSERT_NONE

  No error injection

.. vhdl:constant:: INSERT_SINGLE

  Single-bit error injection

.. vhdl:constant:: INSERT_DOUBLE

  Double-bit error injection

Components
----------


secded_codec
~~~~~~~~~~~~

.. symbolator::
  :name: secded_codec_pkg-secded_codec

  component secded_codec is
  generic (
    DATA_SIZE : positive;
    PIPELINE_STAGES : natural;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Codec_mode : in std_ulogic;
    Insert_error : in std_ulogic_vector(1 downto 0);
    --# {{data|Encoding port}}
    Data : in std_ulogic_vector(DATA_SIZE-1 downto 0);
    Encoded_data : out ecc_vector(DATA_SIZE-1 downto secded_indices(DATA_SIZE).right);
    --# {{Decoding port}}
    Ecc_data : in ecc_vector(DATA_SIZE-1 downto secded_indices(DATA_SIZE).right);
    Decoded_data : out std_ulogic_vector(DATA_SIZE-1 downto 0);
    --# {{Error flags}}
    Single_bit_error : out std_ulogic;
    Double_bit_error : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: secded_codec

  
  :generic DATA_SIZE: Size of the ``Data`` input
  :gtype DATA_SIZE: positive
  :generic PIPELINE_STAGES: Number of pipeline stages appended to end
  :gtype PIPELINE_STAGES: natural
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Codec_mode: OPerating mode: '0' = encode, '1' = decode
  :ptype Codec_mode: in std_ulogic
  :port Insert_error: Error injection
  :ptype Insert_error: in std_ulogic_vector(1 downto 0)
  :port Data: Data to encode
  :ptype Data: in std_ulogic_vector(DATA_SIZE-1 downto 0)
  :port Encoded_data: Data message with  SECDED parity
  :ptype Encoded_data: out ecc_vector(DATA_SIZE-1 downto secded_indices(DATA_SIZE).right)
  :port Ecc_data: Received data
  :ptype Ecc_data: in ecc_vector(DATA_SIZE-1 downto secded_indices(DATA_SIZE).right)
  :port Decoded_data: Received data with errors corrected
  :ptype Decoded_data: out std_ulogic_vector(DATA_SIZE-1 downto 0)
  :port Single_bit_error: '1' when a single-bit error is detected (automatically corrected)
  :ptype Single_bit_error: out std_ulogic
  :port Double_bit_error: '1' when a double-bit error is detected
  :ptype Double_bit_error: out std_ulogic
