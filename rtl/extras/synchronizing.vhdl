--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# synchronizing.vhdl - Clock domain synchronization components
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
--# DEPENDENCIES: none
--#
--# DESCRIPTION:
--#  This package provides a number of synchronizer components for managing
--#  data transmission between clock domains.
--#
--#  If you need to synchronize a vector of bits together you should use the
--#  handshake_synchronizer component. If you generate an array of bit_synchronizer
--#  components instead, there is a risk that some bits will take longer than
--#  others and invalid values will appear at the outputs. This is particularly
--#  problematic if the vector represents a numeric value. bit_synchronizer can
--#  be used safely in an array only if you know the input signal comes from an
--#  isochronous domain (same period, different phase).

--# SYNTHESIS:
--#  Vendor specific synthesis attributes have been included to help prevent
--#  undesirable results. It is important to know that, ideally, synchronizing
--#  flip-flops should be placed as close together as possible. It is also desirable
--#  to have the first stage flip-flop incorporated into the input buffer to minimize
--#  input delay. Because of this these components do not have attributes to guide
--#  relative placement of flip-flops to make them contiguous. Instead you should
--#  apply timing constraints to the components that will force the synthesizer into
--#  using an optimal placement.
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package synchronizing is

  --## A basic synchronizer with a configurable number of stages.
  --#  The ``Sync`` output is synchronized to the ``Clock`` domain.
  component bit_synchronizer is
    generic (
      STAGES : natural := 2; --# Number of flip-flops in the synchronizer
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock  : in std_ulogic; --# System clock
      Reset  : in std_ulogic; --# Asynchronous reset

      --# {{data|}}
      Bit_in : in std_ulogic; --# Unsynchronized signal
      Sync   : out std_ulogic --# Synchronized to Clock's domain
    );
  end component;

  --## Synchronizer for generating a synchronized reset.
  --#  The deactivating edge transition for the ``Sync_reset`` output
  --#  is synchronized to the ``Clock`` domain. Its activating edge remains asynchronous.
  component reset_synchronizer is
    generic (
      STAGES : natural := 2; --# Number of flip-flops in the synchronizer
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{data|}}
      Sync_reset : out std_ulogic --# Synchronized reset
    );
  end component;

--## A handshaking synchronizer for sending an array between clock domains.
--#  This uses the four-phase handshake protocol.
  component handshake_synchronizer is
    generic (
      STAGES : natural := 2; --# Number of flip-flops in the synchronizer
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock_tx : in std_ulogic; --# Transmitting domain clock
      Reset_tx : in std_ulogic; --# Asynchronous reset for Clock_tx

      Clock_rx : in std_ulogic; --# Receiving domain clock
      Reset_rx : in std_ulogic; --# Asynchronous reset for Clock_rx


      --# {{data|Send port}}
      Tx_data   : in std_ulogic_vector; --# Data to send
      Send_data : in std_ulogic;  --# Control signal to send new data
      Sending   : out std_ulogic; --# Active while TX is in process
      Data_sent : out std_ulogic; --# Flag to indicate TX completion

      --# {{Receive port}}
      Rx_data  : out std_ulogic_vector; --# Data received in clock_rx domain
      New_data : out std_ulogic   --# Flag to indicate new data
    );
  end component;

end package;



library ieee;
use ieee.std_logic_1164.all;

--## A basic synchronizer with a configurable number of stages
entity bit_synchronizer is
  generic (
    STAGES : natural := 2; --# Number of flip-flops in the synchronizer
    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
  );
  port (
    Clock  : in std_ulogic; --# System clock
    Reset  : in std_ulogic; --# Asynchronous reset

    Bit_in : in std_ulogic; --# Unsynchronized signal
    Sync   : out std_ulogic --# Synchronized to Clock's domain
  );
end entity;

architecture rtl of bit_synchronizer is
  signal sr : std_ulogic_vector(1 to STAGES);
  
  -- Xilinx synth attributes:
  attribute SHREG_EXTRACT : string;
  attribute ASYNC_REG     : string;
  attribute RLOC          : string;
  
  -- Guard against SRL16 inference in case Reset is not being used
  attribute SHREG_EXTRACT of sr : signal is "no";
  attribute ASYNC_REG of sr     : signal is "TRUE";
  
begin
  reg: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      sr <= (others => '0');
    elsif rising_edge(Clock) then
      sr <= to_X01(Bit_in) & sr(1 to sr'right-1);
    end if;
  end process;

  Sync <= sr(sr'right);
end architecture;


library ieee;
use ieee.std_logic_1164.all;

--## Synchronizer for generating a synchronized reset
entity reset_synchronizer is
  generic (
    STAGES : natural := 2; --# Number of flip-flops in the synchronizer
    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
  );
  port (
    Clock : in std_ulogic; --# System clock
    Reset : in std_ulogic; --# Asynchronous reset

    Sync_reset : out std_ulogic --# Synchronized reset
  );
end entity;

architecture rtl of reset_synchronizer is
  signal sr : std_ulogic_vector(1 to STAGES);
begin

  reg: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      sr <= (others => RESET_ACTIVE_LEVEL);
    elsif rising_edge(Clock) then
      sr <= (not RESET_ACTIVE_LEVEL) & sr(1 to sr'right-1);
    end if;
  end process;

  Sync_reset <= sr(sr'right);
end architecture;


library ieee;
use ieee.std_logic_1164.all;

library extras;
use extras.synchronizing.bit_synchronizer;

--## A handshaking synchronizer for sending an array between clock domains
--#  This uses the four-phase handshake protocol.
entity handshake_synchronizer is
  generic (
    STAGES : natural := 2; --# Number of flip-flops in the synchronizer
    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
  );
  port (
    -- {{clocks|}}
    Clock_tx : in std_ulogic; --# Transmitting domain clock
    Reset_tx : in std_ulogic; --# Asynchronous reset for Clock_tx

    Clock_rx : in std_ulogic; --# Receiving domain clock
    Reset_rx : in std_ulogic; --# Asynchronous reset for Clock_rx


    -- {{data|Send port}}
    Tx_data   : in std_ulogic_vector; --# Data to send
    Send_data : in std_ulogic;  --# Control signal to send new data
    Sending   : out std_ulogic; --# Active while TX is in process
    Data_sent : out std_ulogic; --# Flag to indicate TX completion

    -- {{Receive port}}
    Rx_data  : out std_ulogic_vector; --# Data received in clock_rx domain
    New_data : out std_ulogic   --# Flag to indicate new data
  );
end entity;

architecture rtl of handshake_synchronizer is

  signal ack_rx, ack_tx : std_ulogic;
  signal prev_ack : std_ulogic;

  signal tx_reg_en : std_ulogic;
  signal tx_data_reg : std_ulogic_vector(Tx_data'range);

  signal req_tx, req_rx : std_ulogic;
  signal prev_req : std_ulogic;
begin
  -----------
  -- TX logic
  -----------

  as: bit_synchronizer
    generic map (
      STAGES => STAGES,
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    )
    port map (
      Clock   => Clock_tx,
      Reset => Reset_tx,

      Bit_in => ack_rx,
      Sync   => ack_tx
    );

  ack_change: process(Clock_tx, Reset_tx) is
  begin
    if Reset_tx = RESET_ACTIVE_LEVEL then
      prev_ack <= '0';
    elsif rising_edge(Clock_tx) then
      prev_ack <= ack_tx;
    end if;
  end process;

  Data_sent <= '1' when ack_tx = '0' and prev_ack = '1' else '0';

  fsm: block
    type states is (IDLE, SEND, FINISH);

    signal cur_state : states;
  begin

    process(Clock_tx, Reset_tx) is
      variable next_state : states;
    begin
      if Reset_tx = RESET_ACTIVE_LEVEL then
        cur_state <= IDLE;
        tx_reg_en <= '0';
        req_tx <= '0';
        Sending <= '0';
      elsif rising_edge(Clock_tx) then

        next_state := cur_state;
        tx_reg_en <= '0';
        case cur_state is
          when IDLE =>
            if Send_data = '1' then
              next_state := SEND;
              tx_reg_en <= '1';
            end if;

          when SEND => -- Wait for Rx side to assert ack
            if ack_tx = '1' then
              next_state := FINISH;
            end if;

          when FINISH => -- Wait for Rx side to deassert ack
            if ack_tx = '0' then
              next_state := IDLE;
            end if;

          when others =>
            next_state := IDLE;
        end case;

        cur_state <= next_state;

        req_tx <= '0';
        Sending <= '0';

        case next_state is
          when IDLE =>
            null;

          when SEND =>
            req_tx <= '1';
            Sending <= '1';

          when FINISH =>
            Sending <= '1';

          when others =>
            null;
        end case;

      end if;

    end process;

  end block;

  tx_reg: process(Clock_tx, Reset_tx) is
  begin
    if Reset_tx = RESET_ACTIVE_LEVEL then
      tx_data_reg <= (others => '0');
    elsif rising_edge(Clock_tx) then
      if tx_reg_en = '1' then
        tx_data_reg <= Tx_data;
      end if;
    end if;
  end process;


  -----------
  -- RX logic
  -----------

  rs: bit_synchronizer
    generic map (
      STAGES => STAGES,
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    )
    port map (
      Clock   => Clock_rx,
      Reset => Reset_rx,

      Bit_in => req_tx,
      Sync   => req_rx
    );

  ack_rx <= req_rx;

  req_change: process(Clock_rx, Reset_rx) is
  begin
    if Reset_rx = RESET_ACTIVE_LEVEL then
      prev_req <= '0';
      Rx_data  <= (Rx_data'range => '0');
      New_data <= '0';
    elsif rising_edge(Clock_rx) then
      prev_req <= req_rx;
      New_data <= '0';

      if req_rx = '1' and prev_req = '0' then -- Capture data
        Rx_data  <= tx_data_reg;
        New_data <= '1';
      end if;
    end if;
  end process;

end architecture;
