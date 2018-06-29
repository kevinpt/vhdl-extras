--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# filtering.vhdl - Digital filters
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2017 Kevin Thibedeau
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
--# DEPENDENCIES: common_2008 pipelining_2008
--#
--# DESCRIPTION:
--#   This package implements general purpose digital filters.
--# 
--# EXAMPLE USAGE:
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras_2008;
use extras_2008.common.all;

package filtering is

  --# Attenuation gain from 0.0 to 1.0.
  subtype attenuation_factor is real range 0.0 to 1.0;

  --## Convert attenuation factor into a signed factor
  --# Args:
  --#  Factor: Factor for gain value
  --#  Size:   Number of bits in the result
  --# Returns:
  --#  Signed value representing the Factor scaled to the range of Size.
  function attenuation_gain(Factor : attenuation_factor; Size : positive) return signed;


--  component fir_filter is
--    generic (
--      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
--      );
--    port (
--      --# {{clocks|}}
--      Clock : in std_ulogic;
--      Reset : in std_ulogic;

--      --# {{control|}}
--      Coefficients : in signed_array;

--      --# {{data|}}
--      New_data : in std_ulogic;
--      Data_in  : in signed;
--      Data_out : out signed
--      );
--  end component;
  
  --# Finite Impulse Response filter.
  component fir_filter is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
      );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Coefficients : in signed_array; --# Filter tap coefficients

      --# {{data|Write port}}
      Data_valid : in std_ulogic; --# Indicate when ``Data`` is valid
      Data : in signed;           --# Data input to the filter
      Busy : out std_ulogic;      --# Indicate when filter is ready to accept new data

      --# {{Read port}}
      Result_valid : out std_ulogic; --# Indicates when a new filter result is valid
      Result : out signed;           --# Filtered output
      In_use : in std_ulogic         --# Request to keep ``Result`` unchanged
      );
  end component;


  --## Compute the alpha value for a lowpass filter
  --# Args:
  --#  Tau:           Time constant
  --#  Sample_period: Sample period of the filtered data
  --# Returns:
  --#  Alpha constant passed to the lowpass_filter component.
  function lowpass_alpha(Tau : real; Sample_period : real) return real;

  --## First order lowpass filter.
  --#  This filter operates in two modes. When REGISTERED_MULTIPLY is false
  --#  the filter processes a new data sample on every clock cycle.
  component lowpass_filter is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1'; --# Asynch. reset control level
      ALPHA : real;  --# Alpha parameter computed with lowpass_alpha()
      REGISTERED_MULTIPLY : boolean := false --# Control registration of internal mutiplier
      );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset
      
      --# {{data|}}
      Data   : in signed;  --# Data input to the filter
      Result : out signed  --# Filtered output
      );
  end component;

  --# Scale samples by an attenuation factor.
  component attenuate is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
      );
    port (
      --# {{clocks|}}
      Clock    : in std_ulogic; --# System clock
      Reset    : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Gain     : in signed;  --# Attenuation factor

      --# {{data|Write port}}
      Data_valid : in std_ulogic; --# Indicate when ``Data`` is valid
      Data       : in signed;     --# Data input to the filter

      --# {{Read port}}
      Result_valid : out std_ulogic; --# Indicates when a new filter result is valid
      Result       : out signed      --# Filtered output
      );
  end component;

  --# Convert binary data into numeric samples.
  component sampler is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
      );
    port (
      --# {{clocks|}}
      Clock    : in std_ulogic; --# System clock
      Reset    : in std_ulogic; --# Asynchronous reset

      --# {{data|Write port}}
      Data_valid : in std_ulogic; --# Indicate when ``Data`` is valid
      Data       : in std_ulogic; --# Data input to the filter

      --# {{Read port}}
      Result_valid : out std_ulogic; --# Indicates when a new filter result is valid
      Result       : out signed      --# Filtered output
      );
  end component;

  --# Capture and hold data samples.
  component sample_and_hold is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
      );
    port (
      --# {{clocks|}}
      Clock    : in std_ulogic; --# System clock
      Reset    : in std_ulogic; --# Asynchronous reset

      --# {{data|Write port}}
      Data_valid : in std_ulogic; --# Indicate when ``Data`` is valid
      Data : in signed;           --# Data input to the filter
      Busy : out std_ulogic;      --# Indicate when filter is ready to accept new data

      --# {{Read port}}
      Result_valid : out std_ulogic; --# Indicates when a new filter result is valid
      Result : out signed;           --# Filtered output
      In_use : in std_ulogic         --# Request to keep ``Result`` unchanged
      );
  end component;

end package;

package body filtering is

  function saturate(N : unsigned) return unsigned is
    variable result : unsigned(N'length-2 downto 0);
  begin
    if N(N'high) = '1' then -- Saturate
      result := (others => '1');
    else -- Trim bit
      result := resize(N, result'length);
    end if;
    
    return result;
  end function;


  function saturate(N : signed) return signed is
    variable result : signed(N'length-2 downto 0);
  begin
    if N(N'high) /= N(N'high-1) then -- Saturate
      -- Preserve sign and replicate guard bit
      result := N(N'high) & resize(N(N'high-1 downto N'high-1), result'length-1);
    else --  Trim bit
      result := resize(N, result'length);
    end if;
    
    return result;
  end function;


  function attenuation_gain(Factor : attenuation_factor; Size : positive) return signed is
  begin
    return to_signed(integer(factor * 2.0**Size) / 2 - 1, Size);
  end function;

  function lowpass_alpha(Tau : real; Sample_period : real) return real is
  begin
    return 1.0 / ((Tau / Sample_Period) + 1.0);
  end function;

end package body;



--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

--library extras;
--use extras.sizing.ceil_log2;

--library extras_2008;
--use extras_2008.common.all;
--use extras_2008.filtering.all;
--use extras_2008.pipelining.tapped_delay_line;

--entity fir_filter is
--  generic (
--    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
--    );
--  port (
--    Clock : in std_ulogic;
--    Reset : in std_ulogic;
--    
--    Coefficients : in signed_array;

--    New_data : in std_ulogic;
--    Data_in  : in signed;
--    Data_out : out signed
--    );
--end entity;

--architecture rtl of fir_filter is
--  constant ACCUM_LEN : positive := Data_out'length +
--                                   ceil_log2(Coefficients'length) +
--                                   Coefficients'element'length;
--  signal accum : signed(ACCUM_LEN-1 downto 0);

--  signal din : std_ulogic_vector(Data_in'length-1 downto 0);
--  signal taps_sulv : sulv_array(0 to Coefficients'length-1)(Data_in'range);
--  signal taps : signed_array(0 to Coefficients'length-1)(Data_in'range);

--  subtype filter_taps is integer range 0 to Coefficients'length-1;
--  signal ix : filter_taps;
--  signal shift_en : std_ulogic;
--begin

--  din <= to_stdulogicvector(std_logic_vector(Data_in));

--  dl: tapped_delay_line
--    generic map (
--      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL,
--      REGISTER_FIRST_STAGE => true
--    )
--    port map (
--      Clock => Clock,
--      Reset => Reset,
--      Enable => shift_en,
--      Data  => din,
--      Taps  => taps_sulv
--    );
--    
--  taps <= to_signed_array(taps_sulv);

--  filt: process(Clock, Reset) is
--    variable prod : signed(Data_in'length + Coefficients'element'length - 1 downto 0);
--  begin
--    if Reset = RESET_ACTIVE_LEVEL then
--      ix <= filter_taps'high;
--      accum <= (others => '0');
--      Data_out <= (Data_out'range => '0');
--      shift_en <= '0';
--    elsif rising_edge(Clock) then
--      -- Multiply current tap with its coefficient
--      prod := taps(ix) * Coefficients(ix);
--      accum <= accum + resize(prod, accum'length);

--      shift_en <= '0';

--      if ix /= 0 then -- Cycle through taps
--        ix <= ix - 1;
--      elsif New_data = '1' then -- Done with each tap
--        ix <= filter_taps'high;
--        shift_en <= '1';
--        Data_out <= accum(Coefficients'element'length + Data_out'length - 1 downto Coefficients'element'length);
--        accum <= (others => '0'); -- Reset accumulator
--      end if;
--    end if;
--  end process;

--end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.sizing.ceil_log2;

library extras_2008;
use extras_2008.common.all;
use extras_2008.filtering.all;
use extras_2008.pipelining.tapped_delay_line;


entity fir_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    Coefficients : in signed_array;

    Data_valid : in std_ulogic;
    Data : in signed;
    Busy : out std_ulogic;

    Result_valid : out std_ulogic;      
    Result : out signed;
    In_use : in std_ulogic
    );
end entity;


architecture rtl of fir_filter is
  constant ACCUM_LEN : positive := Result'length +
                                   ceil_log2(Coefficients'length) +
                                   Coefficients'element'length;
  signal accum : signed(ACCUM_LEN-1 downto 0);

  signal din : std_ulogic_vector(Data'length-1 downto 0);
  signal taps_sulv : sulv_array(0 to Coefficients'length-1)(Data'range);
  signal taps : signed_array(0 to Coefficients'length-1)(Data'range);

  subtype filter_taps is integer range 0 to Coefficients'length-1;
  signal ix : filter_taps;
  signal shift_en, data_valid_dly : std_ulogic;
begin

  din <= to_stdulogicvector(std_logic_vector(Data));

  dl: tapped_delay_line
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL,
      REGISTER_FIRST_STAGE => true
    )
    port map (
      Clock => Clock,
      Reset => Reset,
      Enable => shift_en,
      Data  => din,
      Taps  => taps_sulv
    );
    
  taps <= to_signed_array(taps_sulv);

  filt: process(Clock, Reset) is
    variable prod : signed(Data'length + Coefficients'element'length - 1 downto 0);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      ix <= filter_taps'high;
      accum <= (others => '0');
      Result <= (Result'range => '0');
      Result_valid <= '0';
      Busy <= '0';
      --shift_en <= '0';
      data_valid_dly <= '1';
    elsif rising_edge(Clock) then
      -- Multiply current tap with its coefficient
      prod := taps(ix) * Coefficients(ix);
      accum <= accum + resize(prod, accum'length);

      Result_valid <= '0';
      Busy <= '0';
      --shift_en <= '0';
      data_valid_dly <= Data_valid;

      if ix /= 0 then -- Cycle through taps
        ix <= ix - 1;
        Busy <= '1';
      elsif Data_valid = '1' and In_use = '0' then -- Done with each tap
        ix <= filter_taps'high;
        --shift_en <= '1';
        Result <= accum(Coefficients'element'length + Result'length - 1 downto Coefficients'element'length);
        Result_valid <= '1';
        accum <= (others => '0'); -- Reset accumulator
      end if;
    end if;
  end process;
  
  shift_en <= Data_valid and not data_valid_dly;

end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras_2008;
use extras_2008.common.all;

entity lowpass_filter_one_cycle is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'; --# Asynch. reset control level
    ALPHA : real
    );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    
    Data   : in signed;
    Result : out signed
    );
end entity;

architecture rtl of lowpass_filter_one_cycle is

  -- Convert a real to signed fixed point
  function to_sfixed(N : real; Size : positive) return signed is
  begin
    return to_signed(integer(N * 2.0**(Size-1)), Size);
  end function;


  constant PROD_LEN : positive := Data'length * 2;
  
  -- Alpha value in fixed point form
  constant C0 : signed(Data'length-1 downto 0) := to_sfixed(ALPHA, Data'length);
  --constant C1 : signed(Data'length-1 downto 0) := to_sfixed(1.0 - ALPHA, Data'length);
  
  signal delay : signed(Data'length-1 downto 0);
begin
  filt: process(Clock, Reset) is
    variable delta : signed(Data'length downto 0);
    variable p0 : signed(delta'length + C0'length - 1 downto 0);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      delay <= (others => '0');
    elsif rising_edge(Clock) then
      -- result' <= result + Alpha * (Data - delay)
      delta := resize(Data, delta'length) - resize(delay, delta'length);
      p0 := C0 * delta;
      delay <= delay + resize(p0(p0'high downto C0'length-1), delay'length);
    end if;
  end process;

  Result <= resize(delay, Result'length);

end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras_2008;
use extras_2008.common.all;
use extras_2008.filtering.lowpass_alpha;

entity lowpass_filter_reg_mult is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'; --# Asynch. reset control level
    ALPHA : real
    );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    
    Data   : in signed;
    Result : out signed
    );
end entity;

architecture rtl of lowpass_filter_reg_mult is

  function to_sfixed(N : real; Size : positive) return signed is
  begin
    return to_signed(integer(N * 2.0**(Size-1)), Size);
  end function;
  
  constant Q : real := (1.0 - ALPHA) / ALPHA; -- Tau / Period
  constant ALPHA_ADJ : real := lowpass_alpha(0.5 * Q, 1.0); -- Correct Alpha to account for extra cycle delay

  constant PROD_LEN : positive := Data'length * 2;
  constant C0 : signed(Data'length-1 downto 0) := to_sfixed(ALPHA_ADJ, Data'length);
  
  signal p0 : signed(Data'length + C0'length downto 0);
  signal delay : signed(Data'length-1 downto 0);
  signal new_product : std_ulogic;
begin
  filt: process(Clock, Reset) is
    variable delta : signed(Data'length downto 0);
    
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      delay <= (others => '0');
      new_product <= '0';
    elsif rising_edge(Clock) then
      delta := resize(Data, delta'length) - resize(delay, delta'length);
      p0 <= C0 * delta;
      new_product <= not new_product;
      
      if new_product = '1' then
        delay <= delay + resize(p0(p0'high downto C0'length-1), delay'length);
      end if;
    end if;
  end process;

  Result <= resize(delay, Result'length);

end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras_2008;
use extras_2008.common.all;

entity lowpass_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'; --# Asynch. reset control level
    ALPHA : real;
    REGISTERED_MULTIPLY : boolean := false
    );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    
    Data   : in signed;
    Result : out signed
    );
end entity;

architecture rtl of lowpass_filter is

  component lowpass_filter_one_cycle is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1'; --# Asynch. reset control level
      ALPHA : real
      );
    port (
      Clock : in std_ulogic;
      Reset : in std_ulogic;
      
      Data   : in signed;
      Result : out signed
      );
  end component;

  component lowpass_filter_reg_mult is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1'; --# Asynch. reset control level
      ALPHA : real
      );
    port (
      Clock : in std_ulogic;
      Reset : in std_ulogic;
      
      Data   : in signed;
      Result : out signed
      );
  end component;

begin
  g: if REGISTERED_MULTIPLY = true generate
    lp: lowpass_filter_reg_mult
      generic map (
        RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL,
        ALPHA => ALPHA
      )
      port map (
        Clock => Clock,
        Reset => Reset,
        Data  => Data,
        Result => Result
      );
  else generate
    lp: lowpass_filter_one_cycle
      generic map (
        RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL,
        ALPHA => ALPHA
      )
      port map (
        Clock => Clock,
        Reset => Reset,
        Data  => Data,
        Result => Result
      );
  end generate;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity attenuate is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
  port (
    Clock    : in std_ulogic;
    Reset    : in std_ulogic;
    
    Gain     : in signed;
    
    Data_valid : in std_ulogic;
    Data       : in signed;
    
    Result_valid : out std_ulogic;
    Result       : out signed
    );
end entity;

architecture rtl of attenuate is
  signal prod : signed(Data'length + Gain'length - 1 downto 0);
begin
  atten: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      Result <= (Result'range => '0');
      Result_valid <= '0';
    elsif rising_edge(Clock) then
      prod <= Gain * Data;
      -- Skipping extra sign bit
      Result <= prod(prod'high-1 downto prod'high - Result'length);
      Result_valid <= Data_valid;
    end if;
  end process;
end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sampler is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
  port (
    Clock    : in std_ulogic;
    Reset    : in std_ulogic;

    Data_valid   : in std_ulogic;
    Data         : in std_ulogic;

    Result_valid : out std_ulogic;
    Result       : out signed
    );
end entity;


architecture rtl of sampler is
  signal sample : signed(Result'length-1 downto 0);
begin
  s: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      sample <= (others => '0');
      Result_valid <= '0';
    elsif rising_edge(Clock) then
      if Data = '1' then
        sample <= to_signed(2**(sample'length-1) - 1, sample'length);
      else
        sample <= to_signed(-2**(sample'length-1), sample'length);
      end if;
      Result_valid <= Data_valid;
    end if;
  end process;
  
  Result <= sample;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sample_and_hold is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
  port (
    Clock    : in std_ulogic;
    Reset    : in std_ulogic;

    Data_valid   : in std_ulogic;
    Data         : in signed;
    Busy         : out std_ulogic;

    Result_valid : out std_ulogic;
    Result       : out signed;
    In_use       : in std_ulogic
    );
end entity;

architecture rtl of sample_and_hold is
begin
  s: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      Result_valid <= '0';
      Result <= (Result'range => '0');
      Busy <= '0';
    elsif rising_edge(Clock) then
      Result_valid <= '0';

      if Data_valid = '1' and In_use = '0' then
        Result <= Data;
        Result_valid <= '1';
      end if;
      Busy <= In_use;
    end if;
  end process;
  
end architecture;

