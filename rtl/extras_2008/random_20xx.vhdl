--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# random_20xx.vhdl - Random number generation (VHDL-20xx version)
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
--# DEPENDENCIES: timing_ops
--#
--# DESCRIPTION:
--#  This package provides a general set of pseudo-random number functions.
--#  It is implemented as a wrapper around the ieee.math_real.uniform
--#  procedure and is only suitable for simulation not synthesis. See the
--#  LCAR and LFSR packages for synthesizable random generators.
--#
--#  This package makes use of shared variables to keep track of the PRNG
--#  state more conveniently than calling uniform directly. Because
--#  VHDL-2002 broke forward compatability of shared variables there are
--#  two versions of this package. One (random.vhdl) is for VHDL-93 using
--#  the classic shared variable mechanism. The other (random_20xx.vhdl)
--#  is for VHDL-2002 and later using a protected type to manage the
--#  PRNG state. Both files define a package named "random" and only one
--#  can be in use at any time. The user visible subprograms are the same
--#  in both implementations.
--#
--#  The package provides a number of overloaded subprograms for generating
--#  random numbers of various types.
--#
--# EXAMPLE USAGE:
--#   seed(12345);    -- Initialize PRNG with a seed value
--#   seed(123, 456); -- Alternate seed procedure
--#
--#   variable : r : real    := random; -- Generate a random real
--#   variable : n : natural := random; -- Generate a random natural
--#   variable : b : boolean := random; -- Generate a random boolean
--#   -- Generate a random bit_vector of any size
--#   variable : bv : bit_vector(99 downto 0) := random(100);
--#
--#   -- Generate a random integer within specified range
--#   -- Number between 2 and 10 inclusive
--#   variable : i : natural := randint(2, 10);
--------------------------------------------------------------------

package random is
  --## Seed the PRNG with a number.
  --# Args:
  --#  S:  Seed value
  procedure seed(S : in positive);

  --## Seed the PRNG with s1 and s2. This offers more
  --#  random initialization than the one argument version
  --#  of seed.
  --# Args:
  --#  S1:  Seed value 1
  --#  S2:  Seed value 2
  procedure seed(S1, S2 : in positive);

  --## Generate a random real.
  --# Returns:
  --#  Random value.
  impure function random return real;

  --## Generate a random natural.
  --# Returns:
  --#  Random value.
  impure function random return natural;

  --## Generate a random boolean.
  --# Returns:
  --#  Random value.
  impure function random return boolean;

  --## Generate a random character.
  --# Returns:
  --#  Random value.
  impure function random return character;

  --## Generate a random bit_vector of size bits.
  --# Args:
  --#  Size: Length of the random result
  --# Returns:
  --#  Random value.
  impure function random(Size : positive) return bit_vector;

  --## Generate a random integer between Min and Max inclusive.
  --#  Note that the span Max - Min must be less than integer'high.
  --# Args:
  --#  Min: Minimum value
  --#  Max: Maximum value
  --# Returns:
  --#  Random value between Min and Max.
  impure function randint(Min, Max : integer) return integer;

  --## Generate a random time between Min and Max inclusive.
  --#  Note that the span Max - Min must be less than time'high.
  --# Args:
  --#  Min: Minimum value
  --#  Max: Maximum value
  --# Returns:
  --#  Random value between Min and Max.
  impure function randtime(Min, Max : time) return time;

end package;


library ieee;
use ieee.math_real.all;
use ieee.numeric_bit.all;

library extras;
use extras.timing_ops.all;

package body random is

  -- VHDL-20xx requires shared variables to be a protected type
  type rand_state is protected
    procedure seed(s1, s2 : in positive);
    impure function random return real;
  end protected;

  type rand_state is protected body
    variable seed1 : positive;
    variable seed2 : positive;

    procedure seed(s1, s2 : in positive) is
    begin
      seed1 := s1;
      seed2 := s2;
    end procedure;

    impure function random return real is
      variable result : real;
    begin
      uniform(seed1, seed2, result);
      return result;
    end function;

  end protected body;

  shared variable prng : rand_state;



  procedure seed(s : in positive) is
    variable s2 : positive;
  begin
    if s > 1 then
      s2 := s - 1;
    else
      s2 := s + 42;
    end if;

    prng.seed(s, s2);
  end procedure;

  procedure seed(s1, s2 : in positive) is
  begin
    prng.seed(s1, s2);
  end procedure;


  impure function random return real is
  begin
    return prng.random;
  end function;

  impure function randint(min, max : integer) return integer is
  begin
    return integer(trunc(real(max - min + 1) * random)) + min;
  end function;

  impure function randtime(min, max : time) return time is
  begin
    return to_time(to_real(max - min + resolution_limit) * random) + min;
  end function;

  impure function random return natural is
  begin
    return natural(trunc(real(natural'high) * prng.random));
  end function;

  impure function random return boolean is
  begin
    return randint(0, 1) = 1;
  end function;

  impure function random return character is
  begin
    return character'val(randint(0, 255));
  end function;

  impure function random(size : positive) return bit_vector is
    -- Populate vector in 30-bit chunks to avoid exceeding the
    -- range of integer
    constant seg_size  : natural := 30;
    constant segments  : natural := size / seg_size;
    constant remainder : natural := size - segments * seg_size;

    variable result : bit_vector(size-1 downto 0);
  begin
    if segments > 0 then
      for s in 0 to segments-1 loop
        result((s+1) * seg_size - 1 downto s * seg_size) := bit_vector(to_unsigned(randint(0, 2**seg_size-1), seg_size));
      end loop;
    end if;

    if remainder > 0 then
      result(size-1 downto size-remainder) := bit_vector(to_unsigned(randint(0, 2**remainder-1), remainder));
    end if;

    return result;
  end function;
end package body;
