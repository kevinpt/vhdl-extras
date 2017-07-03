=============
interrupt_ctl
=============

`extras/interrupt_ctl.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/interrupt_ctl.vhdl>`_

Dependencies
------------

None

Description
-----------

This package provides a general purpose interrupt controller that handles
the management of multiple interrupt sources. It uses unconstrained arrays
to specify the interrupt vector signals. It can thus be sized as needed to
suit required number of interrupts.

The priority of the interrupts is fixed with the lowest index having the
highest priority. You can use ascending or descending ranges for the
control vectors. Multiple pending interrupts are serviced from highest to
lowest priority. If a higher priority interrupt arrives when a lower
priority interrupt is currently in service, the higher priority interrupt
takes effect after the lower interrupt is acknowledged. If you disable a
pending interrupt with its mask it will not return after reenabling the mask
bit until the next interrupt arrives.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  -- Create an 8-bit interrupt controller
  signal int_mask, int_request, pending_int, current_int :
        std_ulogic_vector(7 downto 0);
  ...
  -- Disable interrupts 5, 6, and 7
  int_mask <= (7 downto 5 => '0', others => '1');
  ic: interrupt_ctl
   port map (
     Clock => clock,
     Reset => reset,

     Int_mask    => int_mask,     -- Mask to enable/disable interrupts
     Int_request => int_request,  -- Interrupt sources
     Pending     => pending_int,  -- Current set of pending interrupts
     Current     => current_int,  -- Vector identifying which interrupt is active

     Interrupt     => interrupt,     -- Signal when an interrupt is ping
     Acknowledge   => interrupt_ack, -- Acknowledge the interrupt has been serviced
     Clear_pending => clear_pending  -- Optional control to clear all
   );

  -- Assemble interrupt sources into a request vector
  int_request <= (
   0 => source1, -- Highest priority
   1 => source2,
   2 => source3,
   3 => source4, -- Lowest priority
   others => '0'); -- The remaining sources are unused

    
.. include:: auto/interrupt_ctl.rst

