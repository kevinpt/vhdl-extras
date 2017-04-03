==========
pipelining
==========

`extras/pipelining.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/pipelining.vhdl>`_

Dependencies
------------

None

Description
-----------

This package provides configurable shift register components intended to
be used as placeholders for register retiming during synthesis. These
components can be placed after a section of combinational logic. With 
retiming activated in the synesis tool, the flip-flops will be distributed
through the combinational logic to balance delays. The number of pipeline
stages is controlled with the ``PIPELINE_STAGES`` generic.

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

    
Components
----------

pipeline_ul
~~~~~~~~~~~

.. image:: ../../image/sym/pipelining-pipeline_ul.svg


pipeline_sulv
~~~~~~~~~~~~~

.. image:: ../../image/sym/pipelining-pipeline_sulv.svg


pipeline_slv
~~~~~~~~~~~~

.. image:: ../../image/sym/pipelining-pipeline_slv.svg


pipeline_u
~~~~~~~~~~

.. image:: ../../image/sym/pipelining-pipeline_u.svg


pipeline_s
~~~~~~~~~~

.. image:: ../../image/sym/pipelining-pipeline_s.svg

    
.. include:: auto/pipelining.rst

