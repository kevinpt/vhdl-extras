                                  VHDL-extras
                      http://code.google.com/p/vhdl-extras
   ---------------------------------------------------------------------------

   This archive contains all of the code for the VHDL-extras library. These
   packages are provided freely as open source code. See the licensing
   section at the end of this document for more information on your permissions
   to use these files.

   This library provides some "extra" bits of code that are not found in the
   standard VHDL libraries. With VHDL-extras you can create designs that will
   resize to varying data widths, compute with time, frequency, and clock
   cycles, include error correction, and many more commonly enountered issues
   in digital logic design. These packages can be used for logic simulations
   and, in most cases, can be synthesized to hardware with an FPGA or ASIC
   target.

Usage

   You will need to be aware of any library mappings required to use the
   VHDL-extras packages. Those packages lacking any dependencies may be used
   directly without any additional steps necessary. The remaining packages
   with dependencies on other portions of the VHDL-extras library need their
   dependencies mapped into a new "extras" library rather than the default
   "work" library. Consult your tool documentation on how to accomplish
   this.

   Each file provides a package of publicly accessible types, constants,
   subprograms, and components. Once the "extras" library has been mapped
   you can access a package with the following code:

     library extras;
     use extras.<package_name>.all;

   Most of the packages employ parameterization through the use of unbounded
   arrays in subprogram parameter lists and entity ports. You control the
   size of the logic with the signals and variables connected to these
   interfaces. In some cases there are implied size relationships between
   various input and output arrays that must be observed to produce correct
   results. These will usually be verified by assertions but may be missed
   if no attempt is made to simulate a design before synthesis.

   All components are designed to use asynchronous resets. The active level
   of the reset is controlled with the RESET_ACTIVE_LEVEL generic on each
   component. It defaults to '1' meaning the reset will be active-high. Set
   it to '0' if you want to use active-low resets in a design. You should
   ensure that the asynchronous resets in your design are released
   synchronously to prevent spurious setup and hold violations when coming
   out of reset.

   Most but not all of these packages are usable for synthesis. All of the
   code in the extras library is written in conformance to the VHDL-93 standard.
   Various synthesis tools may differ in their support for the language
   constructs used within VHDL-extras. For Synopsys Design Compiler you will
   need to activate the newer presto VHDL compiler if it isn't set as the
   default.

   Some of the code is available as enhanced implementations that take
   advantage of features provided by newer versions of VHDL. These packages
   are provided in the extras_2008 library. Files that are VHDL-2000 compliant
   have a "_20xx" suffix while VHDL-2008 specific code has a "_2008" suffix.
   The Modelsim build script compiles all of these files in 2008 mode. You will
   have to manually build anything you want in 2000 (or 2002) mode.

   In this library, the unresolved std_ulogic and std_ulogic_vector types are
   preferentially used in favor of std_logic and std_logic_vector. Driver
   resolution isn't needed in most cases and using the unresolved types adds an
   extra level of assurance to a design by preventing accidental connections of
   multiple signal drivers. Using these types can require a little extra work
   with type conversions and consequently most resources for VHDL avoid
   demonstrating their use. Since std_logic is a subtype and closely related
   to std_ulogic you can freely interchange signals of those types but the same
   is not the case for the arrays std_ulogic_vector and std_logic_vector. For
   these, you will have to employ explicit type conversions with implementations
   of the language before VHDL-2008. The 2008 standard revised the library to
   define std_logic_vector as a resolved subtype of std_ulogic_vector rather than
   an independent type. With tools that support VHDL-2008 you will be able
   to interchange these array types without calling conversion functions. This
   library employs std_ulogic_vector for non-numeric arrays in anticipation
   of wider adoption of the latest standard.

The Code

The VHDL-extras library contains the following packages:

  * Core packages

      pipelining -- Pipeline registers

      sizing -- Generalized integer logarithms and array size computation

      synchronizing -- Clock domain synchronizing components

      timing_ops -- Conversions for time, frequency, and clock cycles

  * Error handling
      crc_ops -- Compute CRCs

      hamming_edac -- Generalized Hamming error correction encoding and decoding

      parity_ops -- Basic parity operations

      secded_edac -- Hamming extension with double-error detection

  * Encoding
      bcd_conversion -- Encode and decode packed Binary Coded Decimal

      gray_code -- Encode and decode Gray code

      muxing -- Decoder and muxing operations

      muxing_2008 -- Enhanced muxing with unconstrained array of arrays

  * Memories
      fifos -- General purpose FIFOs

      memory -- Synthesizable memories

      reg_file -- General purpose register file

      reg_file_2008 -- Register file with unconstrained array of arrays

  * Randomization
      lcar_ops -- Linear Cellular Automata

      lfsr_ops -- Linear Feedback Shift Registers

      random -- Simulation-only random number generation

      random_20xx -- VHDL-2000 version of random using a protected type

  * String and character handling
      characters_handling -- Character class identification and case conversions

      strings_fixed -- Operations on fixed length strings

      strings_maps -- Mapping character sets

      strings_unbounded -- Operations on unbounded strings

  * Miscellaneous

      binaryio -- Binary file I/O

      text_buffering -- Store text files in internal buffers

      ddfs -- Direct Digital Frequency Synthesizer

      glitch_filtering -- Clean up noisy inputs


Licensing

   All of the source files distributed as part of VHDL-extras are made freely
   available under the MIT license. The license permits unrestricted use of
   this code for commercial and non-commercial use. You may freely mix
   VHDL-extras code with proprietary code. You may make any modifications
   necessary without any requirement to redistribute your source code. The only
   requirement is to maintain the copyright and licensing information in the
   file headers.

   It is presumed that portions of the VHDL-extras library will be
   translated into circuitry with synthesis software. The resulting hardware
   implementation will be free of any requirements beyond those that apply
   when the code is used as software. The functions provided in VHDL-extras
   are all commonly known in the art and are free of any patent
   restrictions. It would be a nice gesture if the documentation for any
   hardware containing VHDL-extras code included an acknowledgement of that
   code and a pointer to this web site.

  MIT License

     Permission is hereby granted, free of charge, to any person obtaining a
     copy of this software and associated documentation files (the "Software"),
     to deal in the Software without restriction, including without limitation
     the rights to use, copy, modify, merge, publish, distribute, sublicense,
     and/or sell copies of the Software, and to permit persons to whom the
     Software is furnished to do so, subject to the following conditions:

     The above copyright notice and this permission notice shall be included in
     all copies or substantial portions of the Software.

     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
     DEALINGS IN THE SOFTWARE.

