--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# fifo_pkg.vhdl - FIFOs
--# $Id$
--# Freely available from VHDL-extras (http://vhdl-extras.org)
--#
--# Copyright © 2014 Kevin Thibedeau
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
--# DEPENDENCIES: memory_pkg
--#


library ieee;
use ieee.std_logic_1164.all;

package fifo_pkg is

  component fifo_simple is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1';
      MEM_SIZE           : positive;
      SYNC_READ          : boolean    := true
      );
    port (
      Clock   : in std_ulogic;
      Reset   : in std_ulogic;
      We      : in std_ulogic;
      Wr_data : in std_ulogic_vector;

      Re      : in  std_ulogic;
      Rd_data : out std_ulogic_vector;

      Empty : out std_ulogic;
      Full  : out std_ulogic;

      Almost_empty_thresh : in  natural range 0 to MEM_SIZE-1 := 1;
      Almost_full_thresh  : in  natural range 0 to MEM_SIZE-1 := 1;
      Almost_empty        : out std_ulogic;
      Almost_full         : out std_ulogic
      );
  end component;

  component fifo is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1';
      MEM_SIZE           : positive;
      SYNC_READ          : boolean    := true
      );
    port (
      Wr_clock : in std_ulogic;
      Wr_reset : in std_ulogic;
      We       : in std_ulogic;
      Wr_data  : in std_ulogic_vector;

      Rd_clock : in  std_ulogic;
      Rd_reset : in  std_ulogic;
      Re       : in  std_ulogic;
      Rd_data  : out std_ulogic_vector;

      Empty : out std_ulogic;
      Full  : out std_ulogic;

      Almost_empty_thresh : in  natural range 0 to MEM_SIZE-1 := 1;
      Almost_full_thresh  : in  natural range 0 to MEM_SIZE-1 := 1;
      Almost_empty        : out std_ulogic;
      Almost_full         : out std_ulogic
      );
  end component;


  component packet_fifo is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1';
      MEM_SIZE           : positive;
      SYNC_READ          : boolean    := true
      );
    port (
      Wr_clock : in std_ulogic;
      Wr_reset : in std_ulogic;
      We       : in std_ulogic;
      Wr_data  : in std_ulogic_vector;
      Keep     : in std_ulogic;
      Discard  : in std_ulogic;

      Rd_clock : in  std_ulogic;
      Rd_reset : in  std_ulogic;
      Re       : in  std_ulogic;
      Rd_data  : out std_ulogic_vector;

      Empty : out std_ulogic;
      Full  : out std_ulogic;

      Almost_empty_thresh : in  natural range 0 to MEM_SIZE-1 := 1;
      Almost_full_thresh  : in  natural range 0 to MEM_SIZE-1 := 1;
      Almost_empty        : out std_ulogic;
      Almost_full         : out std_ulogic
      );
  end component;

end package;


library ieee;
use ieee.std_logic_1164.all;

library extras;
use extras.memory_pkg.dual_port_ram;

entity fifo_simple is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1';
    MEM_SIZE           : positive;
    SYNC_READ          : boolean    := true
    );
  port (
    Clock   : in std_ulogic;
    Reset   : in std_ulogic;
    We      : in std_ulogic;
    Wr_data : in std_ulogic_vector;

    Re      : in  std_ulogic;
    Rd_data : out std_ulogic_vector;

    Empty : out std_ulogic;
    Full  : out std_ulogic;

    Almost_empty_thresh : in  natural range 0 to MEM_SIZE-1 := 1;
    Almost_full_thresh  : in  natural range 0 to MEM_SIZE-1 := 1;
    Almost_empty        : out std_ulogic;
    Almost_full         : out std_ulogic
    );
end entity;

architecture rtl of fifo_simple is

  signal head, tail : natural range 0 to MEM_SIZE-1;
  signal dpr_we     : std_ulogic;
  signal wraparound : boolean;

  signal empty_loc, full_loc : std_ulogic;
begin

  dpr : dual_port_ram
    generic map (
      MEM_SIZE  => MEM_SIZE,
      SYNC_READ => SYNC_READ
      )
    port map (
      Wr_clock => Clock,
      We       => dpr_we,
      Wr_addr  => head,
      Wr_data  => Wr_data,

      Rd_clock => Clock,
      Re       => Re,
      Rd_addr  => tail,
      Rd_data  => Rd_data
      );

  dpr_we <= '1' when we = '1' and full_loc = '0' else '0';

  wr_rd : process(Clock, Reset) is
    variable head_v, tail_v : natural range 0 to MEM_SIZE-1;
    variable wraparound_v   : boolean;
  begin

    if Reset = RESET_ACTIVE_LEVEL then
      head         <= 0;
      tail         <= 0;
      full_loc     <= '0';
      empty_loc    <= '1';
      Almost_full  <= '0';
      Almost_empty <= '0';

      wraparound <= false;

    elsif rising_edge(Clock) then
      head_v       := head;
      tail_v       := tail;
      wraparound_v := wraparound;

      if We = '1' and (wraparound = false or head /= tail) then
        
        if head_v = MEM_SIZE-1 then
          head_v       := 0;
          wraparound_v := true;
        else
          head_v := head_v + 1;
        end if;
      end if;

      if Re = '1' and (wraparound = true or head /= tail) then
        if tail_v = MEM_SIZE-1 then
          tail_v       := 0;
          wraparound_v := false;
        else
          tail_v := tail_v + 1;
        end if;
      end if;


      if head_v /= tail_v then
        empty_loc <= '0';
        full_loc  <= '0';
      else
        if wraparound_v then
          full_loc <= '1';
        else
          empty_loc <= '1';
        end if;
      end if;

      Almost_full  <= '0';
      Almost_empty <= '0';
      if head /= tail then
        if head > tail then
          if Almost_full_thresh >= MEM_SIZE - (head - tail) then
            Almost_full <= '1';
          end if;
          if Almost_empty_thresh >= head - tail then
            Almost_empty <= '1';
          end if;
        else
          if Almost_full_thresh >= tail - head then
            Almost_full <= '1';
          end if;
          if Almost_empty_thresh >= MEM_SIZE - (tail - head) then
            Almost_empty <= '1';
          end if;
        end if;
      end if;


      head       <= head_v;
      tail       <= tail_v;
      wraparound <= wraparound_v;
    end if;
  end process;

  Empty <= empty_loc;
  Full  <= full_loc;

end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.sizing.bit_size;
use extras.synchronizing.all;
use extras.memory_pkg.dual_port_ram;

entity fifo is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1';
    MEM_SIZE           : positive;
    SYNC_READ          : boolean    := true
    );
  port (
    Wr_clock : in std_ulogic;
    Wr_reset : in std_ulogic;
    We       : in std_ulogic;
    Wr_data  : in std_ulogic_vector;

    Rd_clock : in  std_ulogic;
    Rd_reset : in  std_ulogic;
    Re       : in  std_ulogic;
    Rd_data  : out std_ulogic_vector;

    Empty : out std_ulogic;
    Full  : out std_ulogic;

    Almost_empty_thresh : in  natural range 0 to MEM_SIZE-1 := 1;
    Almost_full_thresh  : in  natural range 0 to MEM_SIZE-1 := 1;
    Almost_empty        : out std_ulogic;
    Almost_full         : out std_ulogic
    );
end entity;

architecture rtl of fifo is

  signal head, tail, head_rd, tail_wr                 : natural range 0 to MEM_SIZE-1;
  signal dpr_we                                       : std_ulogic;
  signal wraparound_wr, wraparound_rd                 : boolean;
  signal wrap_set, wrap_clr, wrap_set_rd, wrap_clr_wr : std_ulogic;

  signal empty_loc, full_loc : std_ulogic;

  constant ADDR_SIZE               : natural := bit_size(MEM_SIZE-1);
  signal   head_sulv, head_rd_sulv : std_ulogic_vector(ADDR_SIZE-1 downto 0);
  signal   tail_sulv, tail_wr_sulv : std_ulogic_vector(ADDR_SIZE-1 downto 0);
begin

  dpr : dual_port_ram
    generic map (
      MEM_SIZE  => MEM_SIZE,
      SYNC_READ => SYNC_READ
      )
    port map (
      Wr_clock => Wr_clock,
      We       => dpr_we,
      Wr_addr  => head,
      Wr_data  => Wr_data,

      Rd_clock => Rd_clock,
      Re       => Re,
      Rd_addr  => tail,
      Rd_data  => Rd_data
      );

  dpr_we <= '1' when we = '1' and full_loc = '0' else '0';

  wr : process(Wr_clock, Wr_reset) is
    variable head_v       : natural range 0 to MEM_SIZE-1;
    variable wraparound_v : boolean;
  begin

    if Wr_reset = RESET_ACTIVE_LEVEL then
      head        <= 0;
      full_loc    <= '0';
      Almost_full <= '0';

      wraparound_wr <= false;
      wrap_set      <= '0';

    elsif rising_edge(Wr_clock) then
      wrap_set     <= '0';
      head_v       := head;
      wraparound_v := wraparound_wr;

      if We = '1' and (wraparound_v = false or head_v /= tail_wr) then
        if head_v = MEM_SIZE-1 then
          head_v       := 0;
          wraparound_v := true;
          wrap_set     <= '1';
        else
          head_v := head_v + 1;
        end if;
      end if;

      -- Update full flag
      if head_v /= tail_wr then
        full_loc <= '0';
      else
        if wraparound_v then
          full_loc <= '1';
        end if;
      end if;

      -- Update almost full flag
      Almost_full <= '0';
      if head_v /= tail_wr then
        if head_v > tail_wr then
          if Almost_full_thresh >= MEM_SIZE - (head_v - tail_wr) then
            Almost_full <= '1';
          end if;
        else
          if Almost_full_thresh >= tail_wr - head_v then
            Almost_full <= '1';
          end if;
        end if;
      end if;

      head <= head_v;

      if wrap_clr_wr = '0' then
        wraparound_wr <= wraparound_v;
      else
        wraparound_wr <= false;
      end if;

    end if;
  end process;


  rd : process(Rd_clock, Rd_reset) is
    variable tail_v       : natural range 0 to MEM_SIZE-1;
    variable wraparound_v : boolean;
  begin

    if Rd_reset = RESET_ACTIVE_LEVEL then
      tail         <= 0;
      empty_loc    <= '1';
      Almost_empty <= '0';

      wraparound_rd <= false;
      wrap_clr      <= '0';

    elsif rising_edge(Rd_clock) then
      wrap_clr     <= '0';
      tail_v       := tail;
      wraparound_v := wraparound_rd;

      if Re = '1' and (wraparound_v = true or head_rd /= tail_v) then
        if tail_v = MEM_SIZE-1 then
          tail_v       := 0;
          wraparound_v := false;
          wrap_clr     <= '1';
        else
          tail_v := tail_v + 1;
        end if;
      end if;

      -- Update empty flag
      if head_rd /= tail_v then
        empty_loc <= '0';
      else
        if not wraparound_v then
          empty_loc <= '1';
        end if;
      end if;

      -- Update almost empty flag
      Almost_empty <= '0';
      if head_rd /= tail_v then
        if head_rd > tail_v then
          if Almost_empty_thresh >= head_rd - tail_v then
            Almost_empty <= '1';
          end if;
        else
          if Almost_empty_thresh >= MEM_SIZE - (tail_v - head_rd) then
            Almost_empty <= '1';
          end if;
        end if;
      end if;

      tail <= tail_v;

      if wrap_set_rd = '0' then
        wraparound_rd <= wraparound_v;
      else
        wraparound_rd <= true;
      end if;

    end if;
  end process;

  Empty <= empty_loc;
  Full  <= full_loc;

  -- Synchronize head and tail pointers across domains
  hs_head : handshake_synchronizer
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
      )
    port map (
      Clock_tx => Wr_clock,
      Reset_tx => Wr_reset,

      Clock_rx => Rd_clock,
      Reset_rx => Rd_reset,


      Tx_data   => head_sulv,
      Send_data => '1',
      Sending   => open,
      Data_sent => open,

      Rx_data  => head_rd_sulv,
      New_data => open
      );

  head_sulv <= to_stdulogicvector(std_logic_vector(to_unsigned(head, head_sulv'length)));
  head_rd   <= to_integer(unsigned(to_stdlogicvector(head_rd_sulv)));

  hs_tail : handshake_synchronizer
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
      )
    port map (
      Clock_tx => Rd_clock,
      Reset_tx => Rd_reset,

      Clock_rx => Wr_clock,
      Reset_rx => Wr_reset,


      Tx_data   => tail_sulv,
      Send_data => '1',
      Sending   => open,
      Data_sent => open,

      Rx_data  => tail_wr_sulv,
      New_data => open
      );

  tail_sulv <= to_stdulogicvector(std_logic_vector(to_unsigned(tail, tail_sulv'length)));
  tail_wr   <= to_integer(unsigned(to_stdlogicvector(tail_wr_sulv)));


  -- Synchronize wraparound control flags
  wc_wr : bit_synchronizer
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
      )
    port map (
      Clock => Wr_clock,
      Reset => Wr_reset,

      Bit_in => wrap_clr,
      Sync   => wrap_clr_wr
      );

  ws_rd : bit_synchronizer
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
      )
    port map (
      Clock => Rd_clock,
      Reset => Rd_reset,

      Bit_in => wrap_set,
      Sync   => wrap_set_rd
      );

end architecture;




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.sizing.bit_size;
use extras.synchronizing.all;
use extras.memory_pkg.dual_port_ram;

entity packet_fifo is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1';
    MEM_SIZE           : positive;
    SYNC_READ          : boolean    := true
    );
  port (
    Wr_clock : in std_ulogic;
    Wr_reset : in std_ulogic;
    We       : in std_ulogic;
    Wr_data  : in std_ulogic_vector;
    Keep     : in std_ulogic;
    Discard  : in std_ulogic;

    Rd_clock : in  std_ulogic;
    Rd_reset : in  std_ulogic;
    Re       : in  std_ulogic;
    Rd_data  : out std_ulogic_vector;

    Empty : out std_ulogic;
    Full  : out std_ulogic;

    Almost_empty_thresh : in  natural range 0 to MEM_SIZE-1 := 1;
    Almost_full_thresh  : in  natural range 0 to MEM_SIZE-1 := 1;
    Almost_empty        : out std_ulogic;
    Almost_full         : out std_ulogic
    );
end entity;

architecture rtl of packet_fifo is

  signal head, tail, head_rd, tail_wr                 : natural range 0 to MEM_SIZE-1;
  signal dpr_we                                       : std_ulogic;
  signal wraparound_wr, wraparound_rd                 : boolean;
  signal wrap_set, wrap_clr, wrap_set_rd, wrap_clr_wr : std_ulogic;

  signal pkt_head       : natural range 0 to MEM_SIZE-1;
  signal pkt_wraparound : boolean;

  signal empty_loc, full_loc : std_ulogic;

  constant ADDR_SIZE               : natural := bit_size(MEM_SIZE-1);
  signal   head_sulv, head_rd_sulv : std_ulogic_vector(ADDR_SIZE-1 downto 0);
  signal   tail_sulv, tail_wr_sulv : std_ulogic_vector(ADDR_SIZE-1 downto 0);
begin

  dpr : dual_port_ram
    generic map (
      MEM_SIZE  => MEM_SIZE,
      SYNC_READ => SYNC_READ
      )
    port map (
      Wr_clock => Wr_clock,
      We       => dpr_we,
      Wr_addr  => pkt_head,
      Wr_data  => Wr_data,

      Rd_clock => Rd_clock,
      Re       => Re,
      Rd_addr  => tail,
      Rd_data  => Rd_data
      );

  dpr_we <= '1' when we = '1' and full_loc = '0' else '0';

  wr : process(Wr_clock, Wr_reset) is
    variable head_v       : natural range 0 to MEM_SIZE-1;
    variable wraparound_v : boolean;
  begin

    if Wr_reset = RESET_ACTIVE_LEVEL then
      head        <= 0;
      full_loc    <= '0';
      Almost_full <= '0';

      wraparound_wr <= false;
      wrap_set      <= '0';

      pkt_head       <= 0;
      pkt_wraparound <= false;

    elsif rising_edge(Wr_clock) then
      wrap_set     <= '0';
      head_v       := pkt_head;
      wraparound_v := pkt_wraparound;

      if We = '1' and (wraparound_v = false or head_v /= tail_wr) then
        if head_v = MEM_SIZE-1 then
          head_v       := 0;
          wraparound_v := true;
          wrap_set     <= '1';
        else
          head_v := head_v + 1;
        end if;
      end if;

      -- Update full flag
      if head_v /= tail_wr then
        full_loc <= '0';
      else
        if wraparound_v then
          full_loc <= '1';
        end if;
      end if;

      -- Update almost full flag
      Almost_full <= '0';
      if head_v /= tail_wr then
        if head_v > tail_wr then
          if Almost_full_thresh >= MEM_SIZE - (head_v - tail_wr) then
            Almost_full <= '1';
          end if;
        else
          if Almost_full_thresh >= tail_wr - head_v then
            Almost_full <= '1';
          end if;
        end if;
      end if;

      pkt_head <= head_v;

      if wrap_clr_wr = '0' then
        pkt_wraparound <= wraparound_v;
      else
        pkt_wraparound <= false;
      end if;

      if Discard = '1' then
        pkt_head       <= head;
        pkt_wraparound <= wraparound_wr;
      elsif Keep = '1' then
        head          <= pkt_head;
        wraparound_wr <= pkt_wraparound;
      end if;

    end if;
  end process;


  rd : process(Rd_clock, Rd_reset) is
    variable tail_v       : natural range 0 to MEM_SIZE-1;
    variable wraparound_v : boolean;
  begin

    if Rd_reset = RESET_ACTIVE_LEVEL then
      tail         <= 0;
      empty_loc    <= '1';
      Almost_empty <= '0';

      wraparound_rd <= false;
      wrap_clr      <= '0';

    elsif rising_edge(Rd_clock) then
      wrap_clr     <= '0';
      tail_v       := tail;
      wraparound_v := wraparound_rd;

      if Re = '1' and (wraparound_v = true or head_rd /= tail_v) then
        if tail_v = MEM_SIZE-1 then
          tail_v       := 0;
          wraparound_v := false;
          wrap_clr     <= '1';
        else
          tail_v := tail_v + 1;
        end if;
      end if;

      -- Update empty flag
      if head_rd /= tail_v then
        empty_loc <= '0';
      else
        if not wraparound_v then
          empty_loc <= '1';
        end if;
      end if;

      -- Update almost empty flag
      Almost_empty <= '0';
      if head_rd /= tail_v then
        if head_rd > tail_v then
          if Almost_empty_thresh >= head_rd - tail_v then
            Almost_empty <= '1';
          end if;
        else
          if Almost_empty_thresh >= MEM_SIZE - (tail_v - head_rd) then
            Almost_empty <= '1';
          end if;
        end if;
      end if;

      tail <= tail_v;

      if wrap_set_rd = '0' then
        wraparound_rd <= wraparound_v;
      else
        wraparound_rd <= true;
      end if;

    end if;
  end process;

  Empty <= empty_loc;
  Full  <= full_loc;

  -- Synchronize head and tail pointers across domains
  hs_head : handshake_synchronizer
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
      )
    port map (
      Clock_tx => Wr_clock,
      Reset_tx => Wr_reset,

      Clock_rx => Rd_clock,
      Reset_rx => Rd_reset,


      Tx_data   => head_sulv,
      Send_data => '1',
      Sending   => open,
      Data_sent => open,

      Rx_data  => head_rd_sulv,
      New_data => open
      );

  head_sulv <= to_stdulogicvector(std_logic_vector(to_unsigned(head, head_sulv'length)));
  head_rd   <= to_integer(unsigned(to_stdlogicvector(head_rd_sulv)));

  hs_tail : handshake_synchronizer
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
      )
    port map (
      Clock_tx => Rd_clock,
      Reset_tx => Rd_reset,

      Clock_rx => Wr_clock,
      Reset_rx => Wr_reset,


      Tx_data   => tail_sulv,
      Send_data => '1',
      Sending   => open,
      Data_sent => open,

      Rx_data  => tail_wr_sulv,
      New_data => open
      );

  tail_sulv <= to_stdulogicvector(std_logic_vector(to_unsigned(tail, tail_sulv'length)));
  tail_wr   <= to_integer(unsigned(to_stdlogicvector(tail_wr_sulv)));


  -- Synchronize wraparound control flags
  wc_wr : bit_synchronizer
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
      )
    port map (
      Clock => Wr_clock,
      Reset => Wr_reset,

      Bit_in => wrap_clr,
      Sync   => wrap_clr_wr
      );

  ws_rd : bit_synchronizer
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
      )
    port map (
      Clock => Rd_clock,
      Reset => Rd_reset,

      Bit_in => wrap_set,
      Sync   => wrap_set_rd
      );

end architecture;
