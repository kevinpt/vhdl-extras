.. Generated from ../rtl/extras/interrupt_ctl.vhdl on 2018-06-28 23:37:29.166059
.. vhdl:package:: extras.interrupt_ctl_pkg


Components
----------


interrupt_ctl
~~~~~~~~~~~~~

.. symbolator::
  :name: interrupt_ctl_pkg-interrupt_ctl

  component interrupt_ctl is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Int_mask : in std_ulogic_vector;
    Int_request : in std_ulogic_vector;
    Pending : out std_ulogic_vector;
    Current : out std_ulogic_vector;
    Interrupt : out std_ulogic;
    Acknowledge : in std_ulogic;
    Clear_pending : in std_ulogic
  );
  end component;

|


.. vhdl:entity:: interrupt_ctl

  Priority interrupt controller.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Int_mask: Set bits correspond to active interrupts
  :ptype Int_mask: in std_ulogic_vector
  :port Int_request: Controls used to activate new interrupts
  :ptype Int_request: in std_ulogic_vector
  :port Pending: Set bits indicate which interrupts are pending
  :ptype Pending: out std_ulogic_vector
  :port Current: Single set bit for the active interrupt
  :ptype Current: out std_ulogic_vector
  :port Interrupt: Flag indicating when an interrupt is pending
  :ptype Interrupt: out std_ulogic
  :port Acknowledge: Clear the active interupt
  :ptype Acknowledge: in std_ulogic
  :port Clear_pending: Clear all pending interrupts
  :ptype Clear_pending: in std_ulogic
