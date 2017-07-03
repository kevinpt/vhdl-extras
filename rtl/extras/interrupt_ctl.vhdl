--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# interrupt_ctl.vhdl - General purpose priority interrupt controller
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2014 Kevin Thibedeau
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
--#  This package provides a general purpose interrupt controller that handles
--#  the management of multiple interrupt sources. It uses unconstrained arrays
--#  to specify the interrupt vector signals. It can thus be sized as needed to
--#  suit required number of interrupts.
--#
--#  The priority of the interrupts is fixed with the lowest index having the
--#  highest priority. You can use ascending or descending ranges for the
--#  control vectors. Multiple pending interrupts are serviced from highest to
--#  lowest priority. If a higher priority interrupt arrives when a lower
--#  priority interrupt is currently in service, the higher priority interrupt
--#  takes effect after the lower interrupt is acknowledged. If you disable a
--#  pending interrupt with its mask it will not return after reenabling the
--#  mask bit until the next interrupt arrives.
--#
--#  EXAMPLE USAGE:
--#
--#  -- Create an 8-bit interrupt controller
--#  signal int_mask, int_request, pending_int, current_int :
--#         std_ulogic_vector(7 downto 0);
--#  ...
--#  -- Disable interrupts 5, 6, and 7
--#  int_mask <= (7 downto 5 => '0', others => '1');
--#  ic: interrupt_ctl
--#    port map (
--#      Clock => clock,
--#      Reset => reset,
--#
--#      Int_mask    => int_mask,      -- Mask to enable/disable interrupts
--#      Int_request => int_request,   -- Interrupt sources
--#      Pending     => pending_int,   -- Current set of pending interrupts
--#      Current     => current_int,   -- Vector identifying which interrupt is active
--#
--#      Interrupt     => interrupt,     -- Signal when an interrupt is pending
--#      Acknowledge   => interrupt_ack, -- Acknowledge the interrupt has been serviced
--#      Clear_pending => clear_pending  -- Optional control to clear all
--#    );
--#
--#  -- Assemble interrupt sources into a request vector
--#  int_request <= (
--#    0 => source1, -- Highest priority
--#    1 => source2,
--#    2 => source3,
--#    3 => source4, -- Lowest priority
--#    others => '0'); -- The remaining sources are unused
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package interrupt_ctl_pkg is


  --## Priority interrupt controller.
  component interrupt_ctl is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Int_mask    : in std_ulogic_vector;  --# Set bits correspond to active interrupts
      Int_request : in std_ulogic_vector;  --# Controls used to activate new interrupts
      Pending     : out std_ulogic_vector; --# Set bits indicate which interrupts are pending
      Current     : out std_ulogic_vector; --# Single set bit for the active interrupt

      Interrupt     : out std_ulogic; --# Flag indicating when an interrupt is pending
      Acknowledge   : in std_ulogic;  --# Clear the active interupt
      Clear_pending : in std_ulogic   --# Clear all pending interrupts
    );
  end component;
end package;


library ieee;
use ieee.std_logic_1164.all;

entity interrupt_ctl is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic; --# System clock
    Reset : in std_ulogic; --# Asynchronous reset

    --# {{control|}}
    Int_mask    : in std_ulogic_vector;  --# Set bits correspond to active interrupts
    Int_request : in std_ulogic_vector;  --# Controls used to activate new interrupts
    Pending     : out std_ulogic_vector; --# Set bits indicate which interrupts are pending
    Current     : out std_ulogic_vector; --# Single set bit for the active interrupt

    Interrupt     : out std_ulogic; --# Flag indicating when an interrupt is pending
    Acknowledge   : in std_ulogic;  --# Clear the active interupt
    Clear_pending : in std_ulogic   --# Clear all pending interrupts
  );
end entity;

architecture rtl of interrupt_ctl is
  signal pending_loc, current_loc : std_ulogic_vector(Int_request'range);
  signal interrupt_loc : std_ulogic;

  -- Priority decoder
  -- Input is a vector of all pending interrupts. Result is a vector with just the
  -- highest priority interrupt bit set.
  function priority_decode(pending : std_ulogic_vector) return std_ulogic_vector is
    variable result : std_ulogic_vector(pending'range);
    variable or_chain : std_ulogic;
  begin

   -- Lowest bit has highest priority
    result(pending'low) := pending(pending'low);
    or_chain := result(pending'low);

    -- Loop through looking for the highest priority interrupt that is pending
    for i in pending'low + 1 to pending'high loop
      if pending(i) = '1' and or_chain = '0' then
        result(i) := '1';
      else
        result(i) := '0';
      end if;

      or_chain := or_chain or pending(i);
    end loop;

    return result;
  end function;

  -- OR-reduce for compatability with VHDL-93
  function or_reduce(vec: std_ulogic_vector) return std_ulogic is
    variable or_chain : std_ulogic;
  begin
    or_chain := '0';
    for i in vec'range loop
      or_chain := or_chain or vec(i);
    end loop;

    return or_chain;
  end function;

begin

  ic: process(Clock, Reset) is
    variable clear_int_n, pending_v, current_v : std_ulogic_vector(pending'range);
    variable interrupt_v : std_ulogic;
  begin
    assert Int_request'length >= 2
      report "Interrupt priority decoder must have at least two inputs"
      severity failure;

    assert Int_mask'length = Int_request'length
      report "Int_mask length must match Int_request" severity failure;

    assert Pending'length = Int_request'length
      report "Pending length must match Int_request" severity failure;

    assert Current'length = Int_request'length
      report "Current length must match Int_request" severity failure;


    if Reset = RESET_ACTIVE_LEVEL then
      pending_loc <= (others => '0');
      current_loc <= (others => '0');
      interrupt_loc <= '0';
    elsif rising_edge(Clock) then

      if Clear_pending = '1' then -- Clear all
        clear_int_n := (others => '0');
      elsif Acknowledge = '1' then -- Clear the pending interrupt
        clear_int_n := not current_loc;
      else -- Clear nothing
        clear_int_n := (others => '1');
      end if;

      -- Keep track of pending interrupts while disabling inactive interrupts
      -- and clearing acknowledged interrupts.
      pending_v := (Int_request or pending_loc) and Int_mask and clear_int_n;
      pending_loc <= pending_v;

      -- Determine the active interrupt from among those pending
      current_v := priority_decode(pending_v);

      -- Flag when any active interrupt is pending
      interrupt_v := or_reduce(current_v);
      interrupt_loc <= interrupt_v;

      if interrupt_loc = '0' or (interrupt_loc = '1' and Acknowledge = '1') then
        -- Update current interrupt
        current_loc <= current_v;
      end if;

    end if;
  end process;

  Current <= current_loc;
  Pending <= pending_loc;
  Interrupt <= interrupt_loc;
end architecture;

