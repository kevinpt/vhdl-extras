.. Generated from ../rtl/extras/interrupt_ctl.vhdl on 2017-04-30 17:19:09.639576
.. vhdl:package:: interrupt_ctl_pkg


Components
----------


interrupt_ctl
~~~~~~~~~~~~~

.. symbolator::

  component interrupt_ctl is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Int_mask : in std_ulogic_vector;
    Int_request : in std_ulogic_vector;
    Pending : out std_ulogic_vector;
    Current : out std_ulogic_vector;
    Interrupt : out std_ulogic;
    Acknowledge : in std_ulogic
  );
  end component;

|


.. vhdl:entity:: interrupt_ctl



  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Int_mask: 
  :ptype Int_mask: in std_ulogic_vector
  :port Int_request: 
  :ptype Int_request: in std_ulogic_vector
  :port Pending: 
  :ptype Pending: out std_ulogic_vector
  :port Current: 
  :ptype Current: out std_ulogic_vector
  :port Interrupt: 
  :ptype Interrupt: out std_ulogic
  :port Acknowledge: 
  :ptype Acknowledge: in std_ulogic
