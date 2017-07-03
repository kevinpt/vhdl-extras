--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# pipelining.vhdl - Resizeable pipeline registers
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2010, 2017 Kevin Thibedeau
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
--#  This package provides configurable shift register components intended to
--#  be used as placeholders for register retiming during synthesis. These
--#  components can be placed after a section of combinational logic. With 
--#  retiming activated in the synesis tool, the flip-flops will be distributed
--#  through the combinational logic to balance delays. The number of pipeline
--#  stages is controlled with the PIPELINE_STAGES generic.
--#
--#  RETIMING: Here are notes on how to activate retiming in various synthesis
--#  tools:
--#   Xilinx ISE: register_balancing attributes are implemented in the design.
--#               In Project|Design Goals & Strategies set the Design Goal to
--#               "Timing Performance". The generic ATTR_REG_BALANCING is
--#               avaiable on each entity to control the direction of register
--#               balancing. Valid values are "yes", "no", "forward", and
--#               "backward". If the pipeline stages connect directly to I/O
--#               then set the strategy to "Performance without IOB packing".
--#
--#   Xilinx Vivado: phys_opt_design -retime
--#
--#   Synplify Pro: syn_allow_retiming attributes are implemented in the design
--#
--#   Altera Quartus II: Enable "Perform register retiming" in
--#                      Assignments|Settings|Physical Synthesis Optimizations
--#
--#   Synopsys Design Compiler: Use the optimize_registers command
--#
--#   Synopsys DC Ultra : Same as DC or use set_optimize_registers in conjunction
--#                       with compile_ultra -retime

--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pipelining is

  --## Pipeline registers for std_ulogic and std_logic.
  component pipeline_ul is
    generic (
      PIPELINE_STAGES : positive; --# Number of pipeline stages to insert
      ATTR_REG_BALANCING : string := "backward"; --# Control propagation direction (Xilinx only)
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock   : in std_ulogic; --# System clock
      Reset   : in std_ulogic; --# Asynchronous reset
      --# {{data|}}
      Sig_in  : in std_ulogic; --# Signal from block to be pipelined
      Sig_out : out std_ulogic --# Pipelined result
    );
  end component;

  --## Pipeline registers for std_ulogic_vector.
  component pipeline_sulv is
    generic (
      PIPELINE_STAGES : positive; --# Number of pipeline stages to insert
      ATTR_REG_BALANCING : string := "backward"; --# Control propagation direction (Xilinx only)
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock   : in std_ulogic; --# System clock
      Reset   : in std_ulogic; --# Asynchronous reset
      --# {{data|}}
      Sig_in  : in std_ulogic_vector; --# Signal from block to be pipelined
      Sig_out : out std_ulogic_vector --# Pipelined result
    );
  end component;

  --## Pipeline registers for std_logic_vector.
  component pipeline_slv is
    generic (
      PIPELINE_STAGES : positive; --# Number of pipeline stages to insert
      ATTR_REG_BALANCING : string := "backward"; --# Control propagation direction (Xilinx only)
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock   : in std_ulogic; --# System clock
      Reset   : in std_ulogic; --# Asynchronous reset
      --# {{data|}}
      Sig_in  : in std_logic_vector; --# Signal from block to be pipelined
      Sig_out : out std_logic_vector --# Pipelined result
    );
  end component;

  --## Pipeline registers for unsigned.
  component pipeline_u is
    generic (
      PIPELINE_STAGES : positive; --# Number of pipeline stages to insert
      ATTR_REG_BALANCING : string := "backward"; --# Control propagation direction (Xilinx only)
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock   : in std_ulogic; --# System clock
      Reset   : in std_ulogic;
      --# {{data|}}
      Sig_in  : in unsigned; --# Signal from block to be pipelined
      Sig_out : out unsigned --# Pipelined result
    );
  end component;

  --## Pipeline registers for signed.
  component pipeline_s is
    generic (
      PIPELINE_STAGES : positive; --# Number of pipeline stages to insert
      ATTR_REG_BALANCING : string := "backward"; --# Control propagation direction (Xilinx only)
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock   : in std_ulogic; --# System clock
      Reset   : in std_ulogic; --# Asynchronous reset
      --# {{data|}}
      Sig_in  : in signed; --# Signal from block to be pipelined
      Sig_out : out signed --# Pipelined result
    );
  end component;


  --## Fixed delay line for std_ulogic data.
  component fixed_delay_line is
    generic (
      STAGES : natural  --# Number of delay stages (0 for short circuit)
      );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable : in std_ulogic;          --# Synchronous enable

      --# {{data|}}
      Data_in  : in std_ulogic;        --# Input data
      Data_out : out std_ulogic        --# Delayed output data
      );
  end component;


  --## Fixed delay line for std_ulogic_vector data.
  component fixed_delay_line_sulv is
    generic (
      STAGES : natural  --# Number of delay stages (0 for short circuit)
      );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable : in std_ulogic;          --# Synchronous enable

      --# {{data|}}
      Data_in  : in std_ulogic_vector; --# Input data
      Data_out : out std_ulogic_vector --# Delayed output data
      );
  end component;

  --## Fixed delay line for signed data.
  component fixed_delay_line_signed is
    generic (
      STAGES : natural  --# Number of delay stages (0 for short circuit)
      );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable : in std_ulogic;          --# Synchronous enable

      --# {{data|}}
      Data_in  : in signed; --# Input data
      Data_out : out signed --# Delayed output data
      );
  end component;

  --## Fixed delay line for unsigned data.
  component fixed_delay_line_unsigned is
    generic (
      STAGES : natural  --# Number of delay stages (0 for short circuit)
      );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable : in std_ulogic;          --# Synchronous enable

      --# {{data|}}
      Data_in  : in unsigned; --# Input data
      Data_out : out unsigned --# Delayed output data
      );
  end component;



  --## Fixed delay line for std_ulogic_vector data.
  component dynamic_delay_line_sulv is
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable  : in std_ulogic;         --# Synchronous enable
      Address : in unsigned;           --# Selected delay stage

      --# {{data|}}
      Data_in  : in std_ulogic_vector; --# Input data
      Data_out : out std_ulogic_vector --# Delayed output data
      );
  end component;

  --## Fixed delay line for signed data.
  component dynamic_delay_line_signed is
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable  : in std_ulogic;         --# Synchronous enable
      Address : in unsigned;           --# Selected delay stage

      --# {{data|}}
      Data_in  : in signed;            --# Input data
      Data_out : out signed            --# Delayed output data
      );
  end component;

  --## Fixed delay line for unsigned data.
  component dynamic_delay_line_unsigned is
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable  : in std_ulogic;         --# Synchronous enable
      Address : in unsigned;           --# Selected delay stage

      --# {{data|}}
      Data_in  : in unsigned;          --# Input data
      Data_out : out unsigned          --# Delayed output data
      );
  end component;


end package;


library ieee;
use ieee.std_logic_1164.all;

entity pipeline_ul is
  generic (
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string := "backward";
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock   : in std_ulogic;
    Reset   : in std_ulogic;
    Sig_in  : in std_ulogic;
    Sig_out : out std_ulogic
  );
end entity;

architecture rtl of pipeline_ul is
  attribute register_balancing : string;
  attribute syn_allow_retiming : boolean;
  attribute register_balancing of Sig_out : signal is ATTR_REG_BALANCING;
  attribute syn_allow_retiming of Sig_out : signal is true;
begin
  reg: process(Clock, Reset)
    variable pl_regs : std_ulogic_vector(1 to PIPELINE_STAGES);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      pl_regs := (others => '0');
    elsif rising_edge(Clock) then
      if PIPELINE_STAGES = 1 then
        pl_regs(1) := Sig_in;
      else
        pl_regs := Sig_in & pl_regs(1 to pl_regs'high-1);
      end if;
    end if;

    Sig_out <= pl_regs(pl_regs'high);

  end process;
end architecture;


library ieee;
use ieee.std_logic_1164.all;

entity pipeline_sulv is
  generic (
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string := "backward";
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock   : in std_ulogic;
    Reset   : in std_ulogic;
    Sig_in  : in std_ulogic_vector;
    Sig_out : out std_ulogic_vector
  );
end entity;

architecture rtl of pipeline_sulv is
  attribute register_balancing : string;
  attribute syn_allow_retiming : boolean;
  attribute register_balancing of Sig_out : signal is ATTR_REG_BALANCING;
  attribute syn_allow_retiming of Sig_out : signal is true;
begin
  reg: process(Clock, Reset)
    subtype sig_word is std_ulogic_vector(Sig_in'range);
    type sig_word_vector is array ( natural range <> ) of sig_word;

    variable pl_regs : sig_word_vector(1 to PIPELINE_STAGES);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      pl_regs := (pl_regs'range => (sig_word'range => '0'));
    elsif rising_edge(Clock) then
      if PIPELINE_STAGES = 1 then
        pl_regs(1) := Sig_in;
      else
        pl_regs := Sig_in & pl_regs(1 to pl_regs'high-1);
      end if;
    end if;

    Sig_out <= pl_regs(pl_regs'high);
  end process;
end architecture;


library ieee;
use ieee.std_logic_1164.all;

entity pipeline_slv is
  generic (
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string := "backward";
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock   : in std_ulogic;
    Reset  : in std_ulogic;
    Sig_in  : in std_logic_vector;
    Sig_out : out std_logic_vector
  );
end entity;

architecture rtl of pipeline_slv is
  attribute register_balancing : string;
  attribute syn_allow_retiming : boolean;
  attribute register_balancing of Sig_out : signal is ATTR_REG_BALANCING;
  attribute syn_allow_retiming of Sig_out : signal is true;
begin
  reg: process(Clock, Reset)
    subtype sig_word is std_logic_vector(Sig_in'range);
    type sig_word_vector is array ( natural range <> ) of sig_word;

    variable pl_regs : sig_word_vector(1 to PIPELINE_STAGES);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      pl_regs := (pl_regs'range => (sig_word'range => '0'));
    elsif rising_edge(Clock) then
      if PIPELINE_STAGES = 1 then
        pl_regs(1) := Sig_in;
      else
        pl_regs := Sig_in & pl_regs(1 to pl_regs'high-1);
      end if;
    end if;

    Sig_out <= pl_regs(pl_regs'high);
  end process;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline_u is
  generic (
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string := "backward";
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock   : in std_ulogic;
    Reset   : in std_ulogic;
    Sig_in  : in unsigned;
    Sig_out : out unsigned
  );
end entity;

architecture rtl of pipeline_u is
  attribute register_balancing : string;
  attribute syn_allow_retiming : boolean;
  attribute register_balancing of Sig_out : signal is ATTR_REG_BALANCING;
  attribute syn_allow_retiming of Sig_out : signal is true;
begin
  reg: process(Clock, Reset)
    subtype sig_word is unsigned(Sig_in'range);
    type sig_word_vector is array ( natural range <> ) of sig_word;

    variable pl_regs : sig_word_vector(1 to PIPELINE_STAGES);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      pl_regs := (pl_regs'range => (sig_word'range => '0'));
    elsif rising_edge(Clock) then
      if PIPELINE_STAGES = 1 then
        pl_regs(1) := Sig_in;
      else
        pl_regs := Sig_in & pl_regs(1 to pl_regs'high-1);
      end if;
    end if;

    Sig_out <= pl_regs(pl_regs'high);
  end process;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline_s is
  generic (
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string := "backward";
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock   : in std_ulogic;
    Reset   : in std_ulogic;
    Sig_in  : in signed;
    Sig_out : out signed
  );
end entity;

architecture rtl of pipeline_s is
  attribute register_balancing : string;
  attribute syn_allow_retiming : boolean;
  attribute register_balancing of Sig_out : signal is ATTR_REG_BALANCING;
  attribute syn_allow_retiming of Sig_out : signal is true;
begin
  reg: process(Clock, Reset)
    subtype sig_word is signed(Sig_in'range);
    type sig_word_vector is array ( natural range <> ) of sig_word;

    variable pl_regs : sig_word_vector(1 to PIPELINE_STAGES);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      pl_regs := (pl_regs'range => (sig_word'range => '0'));
    elsif rising_edge(Clock) then
      if PIPELINE_STAGES = 1 then
        pl_regs(1) := Sig_in;
      else
        pl_regs := Sig_in & pl_regs(1 to pl_regs'high-1);
      end if;
    end if;

    Sig_out <= pl_regs(pl_regs'high);
  end process;
end architecture;



library ieee;
use ieee.std_logic_1164.all;

--## Fixed delay line for std_ulogic_vector data.
entity fixed_delay_line is
  generic (
    STAGES : natural  --# Number of delay stages (0 for short circuit)
    );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;           --# System clock
    -- No reset so this can be inferred as SRL16/32

    --# {{control|}}
    Enable : in std_ulogic;          --# Synchronous enable

    --# {{data|}}
    Data_in  : in std_ulogic;        --# Input data
    Data_out : out std_ulogic        --# Delayed output data
    );
end entity;

architecture rtl of fixed_delay_line is
  signal dly : std_ulogic_vector(0 to STAGES-1);
begin

  gt: if STAGES > 0 generate
    delay: process(Clock) is
    begin
      if rising_edge(Clock) then
        if Enable = '1' then
          dly <= Data_in & dly(0 to dly'high-1);
        end if;
      end if;
    end process;

    Data_out <= dly(dly'high);
  end generate;

  gf: if STAGES = 0 generate
    Data_out <= Data_in;
  end generate;
end architecture;


library ieee;
use ieee.std_logic_1164.all;

--## Fixed delay line for std_ulogic_vector data.
entity fixed_delay_line_sulv is
  generic (
    STAGES : natural  --# Number of delay stages (0 for short circuit)
    );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;           --# System clock
    -- No reset so this can be inferred as SRL16/32

    --# {{control|}}
    Enable : in std_ulogic;          --# Synchronous enable

    --# {{data|}}
    Data_in  : in std_ulogic_vector; --# Input data
    Data_out : out std_ulogic_vector --# Delayed output data
    );
end entity;

architecture rtl of fixed_delay_line_sulv is
  subtype word is std_ulogic_vector(Data_in'length-1 downto 0);
  type word_array is array(natural range <>) of word;

  signal dly : word_array(0 to STAGES-1);
begin

  gt: if STAGES > 0 generate
    delay: process(Clock) is
    begin
      if rising_edge(Clock) then
        if Enable = '1' then
          dly <= Data_in & dly(0 to dly'high-1);
        end if;
      end if;
    end process;

    Data_out <= dly(dly'high);
  end generate;

  gf: if STAGES = 0 generate
    Data_out <= Data_in;
  end generate;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--## Fixed delay line for signed data.
entity fixed_delay_line_signed is
  generic (
    STAGES : natural  --# Number of delay stages (0 for short circuit)
    );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;           --# System clock
    -- No reset so this can be inferred as SRL16/32

    --# {{control|}}
    Enable : in std_ulogic;          --# Synchronous enable

    --# {{data|}}
    Data_in  : in signed;            --# Input data
    Data_out : out signed            --# Delayed output data
    );
end entity;

architecture rtl of fixed_delay_line_signed is
  subtype word is signed(Data_in'length-1 downto 0);
  type word_array is array(natural range <>) of word;

  signal dly : word_array(0 to STAGES-1);
begin

  gt: if STAGES > 0 generate
    delay: process(Clock) is
    begin
      if rising_edge(Clock) then
        if Enable = '1' then
          dly <= Data_in & dly(0 to dly'high-1);
        end if;
      end if;
    end process;

    Data_out <= dly(dly'high);
  end generate;

  gf: if STAGES = 0 generate
    Data_out <= Data_in;
  end generate;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--## Fixed delay line for unsigned data.
entity fixed_delay_line_unsigned is
  generic (
    STAGES : natural  --# Number of delay stages (0 for short circuit)
    );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;           --# System clock
    -- No reset so this can be inferred as SRL16/32

    --# {{control|}}
    Enable : in std_ulogic;          --# Synchronous enable

    --# {{data|}}
    Data_in  : in unsigned;          --# Input data
    Data_out : out unsigned          --# Delayed output data
    );
end entity;

architecture rtl of fixed_delay_line_unsigned is
  subtype word is unsigned(Data_in'length-1 downto 0);
  type word_array is array(natural range <>) of word;

  signal dly : word_array(0 to STAGES-1);
begin

  gt: if STAGES > 0 generate
    delay: process(Clock) is
    begin
      if rising_edge(Clock) then
        if Enable = '1' then
          dly <= Data_in & dly(0 to dly'high-1);
        end if;
      end if;
    end process;

    Data_out <= dly(dly'high);
  end generate;

  gf: if STAGES = 0 generate
    Data_out <= Data_in;
  end generate;
end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--## Fixed delay line for std_ulogic_vector data.
entity dynamic_delay_line_sulv is
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;           --# System clock
    -- No reset so this can be inferred as SRL16/32

    --# {{control|}}
    Enable  : in std_ulogic;         --# Synchronous enable
    Address : in unsigned;           --# Selected delay stage

    --# {{data|}}
    Data_in  : in std_ulogic_vector; --# Input data
    Data_out : out std_ulogic_vector --# Delayed output data
    );
end entity;

architecture rtl of dynamic_delay_line_sulv is
  constant STAGES : positive := 2**Address'length;
  subtype word is std_ulogic_vector(Data_in'length-1 downto 0);
  type word_array is array(natural range <>) of word;

  signal dly : word_array(0 to STAGES-1);
begin

  delay: process(Clock) is
  begin
    if rising_edge(Clock) then
      if Enable= '1' then
        dly <= Data_in & dly(0 to dly'high-1);
      end if;
    end if;
  end process;

  Data_out <= dly(to_integer(Address));
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--## Fixed delay line for signed data.
entity dynamic_delay_line_signed is
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;           --# System clock
    -- No reset so this can be inferred as SRL16/32

    --# {{control|}}
    Enable  : in std_ulogic;         --# Synchronous enable
    Address : in unsigned;           --# Selected delay stage

    --# {{data|}}
    Data_in  : in signed;            --# Input data
    Data_out : out signed            --# Delayed output data
    );
end entity;

architecture rtl of dynamic_delay_line_signed is
  constant STAGES : positive := 2**Address'length;
  subtype word is signed(Data_in'length-1 downto 0);
  type word_array is array(natural range <>) of word;

  signal dly : word_array(0 to STAGES-1);
begin

  delay: process(Clock) is
  begin
    if rising_edge(Clock) then
      if Enable= '1' then
        dly <= Data_in & dly(0 to dly'high-1);
      end if;
    end if;
  end process;

  Data_out <= dly(to_integer(Address));
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--## Fixed delay line for unsigned data.
entity dynamic_delay_line_unsigned is
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;           --# System clock
    -- No reset so this can be inferred as SRL16/32

    --# {{control|}}
    Enable  : in std_ulogic;         --# Synchronous enable
    Address : in unsigned;           --# Selected delay stage

    --# {{data|}}
    Data_in  : in unsigned;          --# Input data
    Data_out : out unsigned          --# Delayed output data
    );
end entity;

architecture rtl of dynamic_delay_line_unsigned is
  constant STAGES : positive := 2**Address'length;
  subtype word is unsigned(Data_in'length-1 downto 0);
  type word_array is array(natural range <>) of word;

  signal dly : word_array(0 to STAGES-1);
begin

  delay: process(Clock) is
  begin
    if rising_edge(Clock) then
      if Enable= '1' then
        dly <= Data_in & dly(0 to dly'high-1);
      end if;
    end if;
  end process;

  Data_out <= dly(to_integer(Address));
end architecture;

