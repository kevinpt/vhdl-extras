                                  VHDL-extras
                             http://vhdl-extras.org
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
   it to '0' if you want to use active-low resets in a design.

   Most but not all of these packages are usable for synthesis. All of the
   code is written in conformance to the VHDL-93 standard. Various synthesis
   tools may differ in their support for the language constructs used within
   VHDL-extras. For Synopsys Design Compiler you will need to activate the
   newer presto VHDL compiler.

   In this library, the std_ulogic and std_ulogic_vector types are
   preferentially used in favor of std_logic and std_logic_vector. Using the
   unresolved types adds an extra level of assurance to a design by
   preventing accidental connections of multiple signal drivers. Using these
   types can require a little extra work with type conversions and
   consequently most resources for VHDL avoid using them. Since std_logic is
   a subtype and closely related to std_ulogic you can freely interchange
   signals of those types but the same is not the case for the arrays
   std_ulogic_vector and std_logic_vector. For these, you will have to
   employ explicit type conversions with implementations of the language
   before VHDL-2008. The 2008 standard revised the library to define
   std_logic_vector as a resolved subtype of std_ulogic_vector rather than
   an independent type. With tools that support VHDL-2008 you will be able
   to interchange the array types without calling conversion functions. This
   library employs std_ulogic_vector for non-numeric arrays in anticipation
   of wider adoption of the latest standard.

The Code

  Core Packages

   These packages provide core functionality that is of general use in a
   wide array of applications.

                           Procedures for general binary file                    
                           IO. Support is provided for reading 
    *  binaryio.vhdl       and writing vectors of any size      
                           with big and little-endian byte     
                           order.                              

    *  muxing.vhdl         Parameterized multiplexers,                           
                           decoders, and demultiplexers.       

                           Configurable pipeline registers for 
    *  pipeline_pkg.vhdl   use with automated retiming during  
                           synthesis.                          

                           A set of functions for computing                      
    *  sizing.vhdl         integer logarithms in any base and   
                           for determing the size of binary    
                           numbers and encodings.              

                           Synchronizer entities for           
    *  synchronizing.vhdl  transferring signals between clock  
                           domains.                            

                           Procedures for storing text files  
    *  text_buffering.vhdl in an internal buffer and for      
                           accumulating text log information  
                           before writing to a file.          

                           Functions for conversions between  
                           time, frequency, and clock cycles. 
    *  timing_ops.vhdl     Also includes a flexible,          
                           simulation-only clock generation   
                           procedure.                         

    *  timing_ops_xilinx.vhdl  A variant of timing_ops to use with
                               Xilinx XST.

  EDAC

   Packages for performing error detection and correction.

                         A flexible implementation of the  
    *  hamming_edac.vhdl Hamming code for any data size of 
                         4-bits or greater.                

    *  parity_ops.vhdl   Basic parity operations.          

                         Single Error Correction, Double   
    *  secded_edac.vhdl  Error Detection implemented with  
                         extended Hamming code.            

                         An entity providing a combined    
                         SECDED encoder and decoder with   
    *  secded_codec.vhdl added error injection for system  
                         verification. Optional pipelining 
                         is provided.                      

  Encoding

   Packages for encoding data into alternate forms.


    *  bcd_conversion.vhdl Conversion to and from packed Binary          
                           Coded Decimal. Supports any data size.   

    *  gray_code.vhdl      Conversion between binary and Gray code.      


  LFSRs

   These packages provide linear feedback shift registers and related
   structures.

                     An implementation of the Wolfram Linear                     
                     Cellular Automata. This is useful for          
    *  lcar_pkg.vhdl generating pseudo-random numbers with low       
                     correlation between bits. Adaptable to any     
                     number of cells. Constants are provided for    
                     maximal length sequences of up to 100 bits.    

                     Various implementations of Galois and          
                     Fibonacci Linear Feedback Shift Registers.     
    *  lfsr_pkg.vhdl These adapt to any size register. Coefficients 
                     are provided for maximal length sequences up   
                     to 100 bits.                                   

  String and Character Library

   A set of packages that provide string and character operations adapted
   from the Ada standard library.

                                   Functions for                                 
    *  characters_handling.vhdl    identifying character 
                                   classification.       

                                   Constants for the     
    *  characters_latin_1.vhdl     Latin-1 character     
                                   names.                

    *  strings.vhdl                Shared types for the  
                                   string packages.      

                                   Operations for fixed  
    *  strings_fixed.vhdl          length strings using  
                                   the built in string   
                                   type.                 

    *  strings_maps.vhdl           Functions for mapping 
                                   character sets.       

    *  strings_maps_constants.vhdl Constants for basic   
                                   character sets.       

                                   Operations for        
    *  strings_unbounded.vhdl      dynamically allocated 
                                   strings.              

  Miscellaneous

   Additional packages of useful functions.

    *  glitch_filter.vhdl A configurable filter for removing                     
                          spurious transitions from noisy inputs.   

Licensing

   All of the source files distributed as part of VHDL-extras, with one
   exception, are made freely available under the MIT license. The license
   permits unrestricted use of this code for commercial and non-commercial
   use. You may freely mix VHDL-extras code with proprietary code. You may
   make any modifications necessary without any requirement to redistribute
   your source code. The only requirement is to maintain the copyright and
   licensing information in the file headers.

   The exception is strings_maps_constants.vhdl which contains code adapted
   from the GPLv2 licensed Ada library distributed with GNAT 3.15p. The
   license for this version of GNAT includes an exception clause that
   prevents the normal extension of the GPL terms to code that "links" or
   instantiates code from the package. This exception permits proprietary
   code to be combined with this file without imposing the requirement to
   redistribute the proprietary portions of the code.

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

  GNAT License

     GNAT licensing terms from a-stmaco.ads v1.11
     GNAT is free software;  you can  redistribute it  and/or modify it under
     terms of the  GNU General Public License as published  by the Free Soft-
     ware  Foundation;  either version 2,  or (at your option) any later ver-
     sion.  GNAT is distributed in the hope that it will be useful, but WITH-
     OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY
     or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
     for  more details.  You should have  received  a copy of the GNU General
     Public License  distributed with GNAT;  see file COPYING.  If not, write
     to  the Free Software Foundation,  59 Temple Place - Suite 330,  Boston,
     MA 02111-1307, USA.

     As a special exception,  if other files  instantiate  generics from this
     unit, or you link  this unit with other files  to produce an executable,
     this  unit  does not  by itself cause  the resulting  executable  to  be
     covered  by the  GNU  General  Public  License.  This exception does not
     however invalidate  any other reasons why  the executable file  might be
     covered by the  GNU Public License.
