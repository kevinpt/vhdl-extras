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
--#  This version of the package is implemented with taking advantage of some
--#  VHDL-2008 features, such as generic types and functions, unresolved numeric
--#  types, and definition of the resolved types as subtypes of the unresolved
--#  ones. Due to these features, the package provides components independent
--#  from data ports types, so they can be used for delaying or pipelining
--#  objects of user-defined types (like records and arrays) without verbose
--#  type conversions.
--#  The fixed delay line component in this implementation uses else-generate
--#  clause, so the compiler does not produce false warnings about possible
--#  double assignments to an object of unresolved type like it used to do
--#  in fixed_delay_line_sulv.
--#  Different components for slv and sulv are not necessary in VHDL-2008, thanks
--#  to the new definition of resolved types. However, pipeline_slv was left here
--#  as an alias for pipeline_sulv, so the package's interface stays the same.
--#  
--#  The package uses unresolved_signed and unresolved_unsigned instead of signed
--#  and unsigned.
--#
--#  The package provides an additional definition of dynamic delay line for
--#  std_ulogic (dynamic_delay_line) type for consistancy.
--#
--#  EXAMPLE USAGE:
--#  library work; use work.pipelining.pipeline_universal;
--#  
--#  type my_record is record
--#    field_1 : u_unsigned(3 downto 0);
--#    field_2 : std_ulogic;
--#  end record my_record;
--#  
--#  function reset_my_record( rec : my_record ) return my_record is
--#  begin
--#    return ((others => '0'), '0');
--#  end function reset_my_record;
--#  ...
--#  pipeline_inst : pipeline_universal
--#    generic map (
--#      ELEMENT_TYPE => my_record,
--#      RESET_ELEMENT => reset_my_record,
--#      PIPELINE_STAGES => 3,
--#      ATTR_REG_BALANCING => "backward",
--#      RESET_ACTIVE_LEVEL => '1' )
--#    port map (Clock, Reset, sig_1, sig_2);
--#
--#  RETIMING: Here are notes on how to activate retiming in various synthesis
--#  tools:
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

  --## Pipeline registers for data of any type
  component pipeline_universal is
    generic (
  	  type ELEMENT_TYPE; --## Type of pipeline element
  	  function RESET_ELEMENT ( element : ELEMENT_TYPE ) return ELEMENT_TYPE; --## Defines how to reset pipeline element
      PIPELINE_STAGES : positive; --# Number of pipeline stages to insert
      ATTR_REG_BALANCING : string := "backward"; --# Control propagation direction (Xilinx only)
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock   : in std_ulogic; --# System clock
      Reset   : in std_ulogic; --# Asynchronous reset
      --# {{data|}}
      Sig_in  : in ELEMENT_TYPE; --# Signal from block to be pipelined
      Sig_out : out ELEMENT_TYPE --# Pipelined result
    );
  end component;

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
  alias pipeline_slv is pipeline_sulv;

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
      Sig_in  : in u_unsigned; --# Signal from block to be pipelined
      Sig_out : out u_unsigned --# Pipelined result
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
      Sig_in  : in u_signed; --# Signal from block to be pipelined
      Sig_out : out u_signed --# Pipelined result
    );
  end component;
  
  
  --## Fixed delay line for data of any type
  component fixed_delay_line_universal is
    generic (
	  type ELEMENT_TYPE; --# Type of the element being delayed
      STAGES : natural   --# Number of delay stages (0 for short circuit)
      );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable : in std_ulogic;          --# Synchronous enable

      --# {{data|}}
      Data_in  : in ELEMENT_TYPE;      --# Input data
      Data_out : out ELEMENT_TYPE      --# Delayed output data
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
      Data_in  : in u_signed; --# Input data
      Data_out : out u_signed --# Delayed output data
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
      Data_in  : in u_unsigned; --# Input data
      Data_out : out u_unsigned --# Delayed output data
      );
  end component;
  
  
  --## Dynamic delay line for data of any type
  component dynamic_delay_line_universal is
    generic (
      type ELEMENT_TYPE  --# Type of the element being delayed
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable  : in std_ulogic;         --# Synchronous enable
      Address : in u_unsigned;         --# Selected delay stage

      --# {{data|}}
      Data_in  : in  ELEMENT_TYPE; --# Input data
      Data_out : out ELEMENT_TYPE  --# Delayed output data
      );
  end component;
  
  --## Dynamic delay line for std_ulogic_vector data.
  component dynamic_delay_line_sulv is
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable  : in std_ulogic;         --# Synchronous enable
      Address : in u_unsigned;         --# Selected delay stage

      --# {{data|}}
      Data_in  : in std_ulogic_vector; --# Input data
      Data_out : out std_ulogic_vector --# Delayed output data
      );
  end component;

  --## Dynamic delay line for signed data.
  component dynamic_delay_line_signed is
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable  : in std_ulogic;         --# Synchronous enable
      Address : in u_unsigned;         --# Selected delay stage

      --# {{data|}}
      Data_in  : in u_signed;          --# Input data
      Data_out : out u_signed          --# Delayed output data
      );
  end component;

  --## Dynamic delay line for unsigned data.
  component dynamic_delay_line_unsigned is
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable  : in std_ulogic;         --# Synchronous enable
      Address : in u_unsigned;         --# Selected delay stage

      --# {{data|}}
      Data_in  : in u_unsigned;        --# Input data
      Data_out : out u_unsigned        --# Delayed output data
      );
  end component;
  
  --## Dynamic delay line for std_ulogic data.
  component dynamic_delay_line is
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      -- No reset so this can be inferred as SRL16/32

      --# {{control|}}
      Enable  : in std_ulogic;         --# Synchronous enable
      Address : in u_unsigned;         --# Selected delay stage

      --# {{data|}}
      Data_in  : in std_ulogic;        --# Input data
      Data_out : out std_ulogic        --# Delayed output data
      );
  end component;

end package;


library ieee;
use ieee.std_logic_1164.all;

entity pipeline_universal is
  generic (
	type ELEMENT_TYPE;
	function RESET_ELEMENT ( element : ELEMENT_TYPE ) return ELEMENT_TYPE;
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string := "backward";
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock   : in std_ulogic;
    Reset   : in std_ulogic;
    Sig_in  : in ELEMENT_TYPE;
    Sig_out : out ELEMENT_TYPE
  );
end entity;

architecture rtl of pipeline_universal is
  attribute register_balancing : string;
  attribute syn_allow_retiming : boolean;
  attribute register_balancing of Sig_out : signal is ATTR_REG_BALANCING;
  attribute syn_allow_retiming of Sig_out : signal is true;
begin
  reg: process(Clock, Reset)
    type sig_word_vector is array ( natural range <> ) of ELEMENT_TYPE;
    variable pl_regs : sig_word_vector(1 to PIPELINE_STAGES);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
	  for i in pl_regs'range loop
		pl_regs(i) := RESET_ELEMENT(pl_regs(i));
	  end loop;
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
  function reset_ul (ul : std_ulogic) return std_ulogic is
  begin
    return '0';
  end function;
begin
  pipeline_inst : entity work.pipeline_universal(rtl)
	generic map (
	  ELEMENT_TYPE => Sig_in'subtype,
	  RESET_ELEMENT => reset_ul,
	  PIPELINE_STAGES => PIPELINE_STAGES,
	  ATTR_REG_BALANCING => ATTR_REG_BALANCING,
	  RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL)
    port map (Clock, Reset, Sig_in, Sig_out);
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
  function reset_sulv (ul : std_ulogic_vector) return std_ulogic_vector is
  begin
    return (ul'range => '0');
  end function;
begin
  pipeline_inst : entity work.pipeline_universal(rtl)
	generic map (
	  ELEMENT_TYPE => Sig_in'subtype,
	  RESET_ELEMENT => reset_sulv,
	  PIPELINE_STAGES => PIPELINE_STAGES,
	  ATTR_REG_BALANCING => ATTR_REG_BALANCING,
	  RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL)
	port map (Clock, Reset, Sig_in, Sig_out);
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
    Sig_in  : in u_unsigned;
    Sig_out : out u_unsigned
  );
end entity;

architecture rtl of pipeline_u is
  signal s1, s2 : std_ulogic_vector(Sig_out'range);
begin
  s1 <= std_ulogic_vector(Sig_in);
  pipeline_inst : entity work.pipeline_sulv(rtl)
	generic map (PIPELINE_STAGES, ATTR_REG_BALANCING, RESET_ACTIVE_LEVEL)
	port map (Clock => Clock, Reset => Reset, Sig_in => s1, Sig_out => s2);
  Sig_out <= u_unsigned(s2);
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
    Sig_in  : in u_signed;
    Sig_out : out u_signed
  );
end entity;

architecture rtl of pipeline_s is
  signal s1, s2 : std_ulogic_vector(Sig_out'range);
begin
  s1 <= std_ulogic_vector(Sig_in);
  pipeline_inst : entity work.pipeline_sulv(rtl)
	generic map (PIPELINE_STAGES, ATTR_REG_BALANCING, RESET_ACTIVE_LEVEL)
	port map (Clock => Clock, Reset => Reset, Sig_in => s1, Sig_out => s2);
  Sig_out <= u_signed(s2);
end architecture;



library ieee;
use ieee.std_logic_1164.all;

entity fixed_delay_line_universal is
  generic (
    type ELEMENT_TYPE;
    STAGES : natural
    );
  port (
    Clock : in std_ulogic;
    Enable : in std_ulogic;
    Data_in  : in ELEMENT_TYPE;
    Data_out : out ELEMENT_TYPE
    );
end entity;

architecture rtl of fixed_delay_line_universal is
  type elements_vector is array ( natural range <> ) of ELEMENT_TYPE;
  signal dly : elements_vector(0 to STAGES-1);
begin

  g : if STAGES = 0 generate
    Data_out <= Data_in;
  elsif STAGES > 0 generate
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

end architecture;


library ieee;
use ieee.std_logic_1164.all;

entity fixed_delay_line is
  generic (
    STAGES : natural
    );
  port (
    Clock : in std_ulogic;
    Enable : in std_ulogic;
    Data_in  : in std_ulogic;
    Data_out : out std_ulogic
    );
end entity;

architecture rtl of fixed_delay_line is
begin
  dl_inst : entity work.fixed_delay_line_universal(rtl)
    generic map (ELEMENT_TYPE => Data_in'subtype, STAGES => STAGES)
	port map (Clock, Enable, Data_in, Data_out);
end architecture;


library ieee;
use ieee.std_logic_1164.all;

entity fixed_delay_line_sulv is
  generic (
    STAGES : natural
    );
  port (
    Clock : in std_ulogic;
    Enable : in std_ulogic;
    Data_in  : in std_ulogic_vector;
    Data_out : out std_ulogic_vector
    );
end entity;

architecture rtl of fixed_delay_line_sulv is
begin
  dl_inst : entity work.fixed_delay_line_universal(rtl)
    generic map (ELEMENT_TYPE => Data_in'subtype, STAGES => STAGES)
	port map (Clock, Enable, Data_in, Data_out);
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fixed_delay_line_signed is
  generic (
    STAGES : natural
    );
  port (
    Clock : in std_ulogic;
    Enable : in std_ulogic;
    Data_in  : in u_signed;
    Data_out : out u_signed
    );
end entity;

architecture rtl of fixed_delay_line_signed is
begin
  dl_inst : entity work.fixed_delay_line_universal(rtl)
    generic map (ELEMENT_TYPE => Data_in'subtype, STAGES => STAGES)
	port map (Clock, Enable, Data_in, Data_out);
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fixed_delay_line_unsigned is
  generic (
    STAGES : natural
    );
  port (
    Clock : in std_ulogic;
    Enable : in std_ulogic;
    Data_in  : in u_unsigned;
    Data_out : out u_unsigned
    );
end entity;

architecture rtl of fixed_delay_line_unsigned is
begin
  dl_inst : entity work.fixed_delay_line_universal(rtl)
    generic map (ELEMENT_TYPE => Data_in'subtype, STAGES => STAGES)
	port map (Clock, Enable, Data_in, Data_out);
end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dynamic_delay_line_universal is
  generic (
    type ELEMENT_TYPE
  );
  port (
    Clock : in std_ulogic;
    Enable  : in std_ulogic;
    Address : in u_unsigned;
    Data_in  : in ELEMENT_TYPE;
    Data_out : out ELEMENT_TYPE
    );
end entity;

architecture rtl of dynamic_delay_line_universal is
  constant STAGES : positive := 2**Address'length;
  type word_array is array(natural range <>) of ELEMENT_TYPE;

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

entity dynamic_delay_line_sulv is
  port (
    Clock : in std_ulogic;
    Enable  : in std_ulogic;
    Address : in u_unsigned;
    Data_in  : in std_ulogic_vector;
    Data_out : out std_ulogic_vector
    );
end entity;

architecture rtl of dynamic_delay_line_sulv is
begin
  ddl_inst : entity work.dynamic_delay_line_universal(rtl)
    generic map (ELEMENT_TYPE => Data_in'subtype)
    port map (Clock, Enable, Address, Data_in, Data_out);
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dynamic_delay_line_signed is
  port (
    Clock : in std_ulogic;
    Enable  : in std_ulogic;
    Address : in u_unsigned;
    Data_in  : in u_signed;
    Data_out : out u_signed
    );
end entity;

architecture rtl of dynamic_delay_line_signed is
begin
  ddl_inst : entity work.dynamic_delay_line_universal(rtl)
    generic map (ELEMENT_TYPE => Data_in'subtype)
    port map (Clock, Enable, Address, Data_in, Data_out);
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dynamic_delay_line_unsigned is
  port (
    Clock : in std_ulogic;
    Enable  : in std_ulogic;
    Address : in u_unsigned;
    Data_in  : in u_unsigned;
    Data_out : out u_unsigned
    );
end entity;

architecture rtl of dynamic_delay_line_unsigned is
begin
  ddl_inst : entity work.dynamic_delay_line_universal(rtl)
    generic map (ELEMENT_TYPE => Data_in'subtype)
    port map (Clock, Enable, Address, Data_in, Data_out);
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dynamic_delay_line is
  port (
    Clock : in std_ulogic;
    Enable  : in std_ulogic;
    Address : in u_unsigned;
    Data_in  : in std_ulogic;
    Data_out : out std_ulogic
    );
end entity;

architecture rtl of dynamic_delay_line is
begin
  ddl_inst : entity work.dynamic_delay_line_universal(rtl)
    generic map (ELEMENT_TYPE => Data_in'subtype)
    port map (Clock, Enable, Address, Data_in, Data_out);
end architecture;