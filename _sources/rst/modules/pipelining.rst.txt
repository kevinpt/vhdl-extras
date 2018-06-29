==========
pipelining
==========

`extras/pipelining.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/pipelining.vhdl>`_

`extras_2008/pipelining_2008.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras_2008/pipelining_2008.vhdl>`_


Dependencies
------------

:doc:`common_2008` (for pipelining_2008)

Description
-----------

This package provides configurable shift register components intended to
be used as placeholders for register retiming during synthesis. These
components can be placed after a section of combinational logic. With 
retiming activated in the synesis tool, the flip-flops will be distributed
through the combinational logic to balance delays. The number of pipeline
stages is controlled with the ``PIPELINE_STAGES`` generic.

There are also components for general purpose delay lines with a fixed or variable number of stages. The VHDL-2008 package has a special :vhdl:entity:`~extras_2008.pipelining.tapped_delay_line` component that presents all stage outputs at once.

Retiming
~~~~~~~~
Here are notes on how to activate retiming in various synthesis tools:

Xilinx ISE
  register_balancing attributes are implemented in the design.
  In Project|Design Goals & Strategies set the Design Goal to
  "Timing Performance". The generic ``ATTR_REG_BALANCING`` is
  avaiable on each entity to control the direction of register
  balancing. Valid values are "yes", "no", "forward", and
  "backward". If the pipeline stages connect directly to I/O
  then set the strategy to "Performance without IOB packing".

Xilinx Vivado
  phys_opt_design -retime

Synplify Pro
  syn_allow_retiming attributes are implemented in the design

Altera Quartus II
  Enable "Perform register retiming" in Assignments|Settings|Physical Synthesis Optimizations

Synopsys Design Compiler
  Use the optimize_registers command

Synopsys DC Ultra
  Same as DC or use set_optimize_registers in conjunction with compile_ultra -retime

    
.. include:: auto/pipelining.rst

VHDL-2008 variant
-----------------

.. include:: auto/pipelining_2008.rst

