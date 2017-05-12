--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# characters_latin_1.vhdl - Character constants for Latin-1
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2010 Kevin Thibedeau
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
--# This package is derived from the Ada 95 Reference Manual (ARM):
--# <ARM copyright terms>
--#   Copyright © 1992, 1993, 1994, 1995, Intermetrics, Inc.
--#   This copyright is assigned to the U.S. Government. All rights reserved.
--#
--#   This document may be copied, in whole or in part, in any form or by any
--#   means, as is or with alterations, provided that (1) alterations are
--#   clearly marked as alterations and (2) this copyright notice is included
--#   unmodified in any copy. Compiled copies of standard library units and
--#   examples need not contain this copyright notice so long as the notice is
--#   included in all copies of source code and documentation.
--# <end ARM copyright terms>
--#
--# DEPENDENCIES: none
--#
--# DESCRIPTION:
--#  This package provides Latin-1 character constants. These constants are
--#  adapted from the definitions in the Ada'95 ARM for the package
--#  Ada.Characters.Latin_1.
--#
--#  This package differs from the Ada implementation in that constants are not
--#  defined for the control characters to avoid ambiguity between the elements
--#  of the VHDL character enumeration.

package characters_latin_1 is

-- control characters 0 to 31

  constant  Space                : character := ' ';  -- character'val(32)
  constant  Exclamation          : character := '!';  -- character'val(33)
  constant  Quotation            : character := '"';  -- character'val(34)
  constant  Number_Sign          : character := '#';  -- character'val(35)
  constant  Dollar_Sign          : character := '$';  -- character'val(36)
  constant  Percent_Sign         : character := '%';  -- character'val(37)
  constant  Ampersand            : character := '&';  -- character'val(38)
  constant  Apostrophe           : character := ''';  -- character'val(39)
  constant  Left_Parenthesis     : character := '(';  -- character'val(40)
  constant  Right_Parenthesis    : character := ')';  -- character'val(41)
  constant  Asterisk             : character := '*';  -- character'val(42)
  constant  Plus_Sign            : character := '+';  -- character'val(43)
  constant  Comma                : character := ',';  -- character'val(44)
  constant  Hyphen               : character := '-';  -- character'val(45)
    alias     Minus_Sign         : character is Hyphen;
  constant  Full_Stop            : character := '.';  -- character'val(46)
  constant  Solidus              : character := '/';  -- character'val(47)

-- digits '0' to '9'

  constant  Colon                : character := ':';  -- character'val(58)
  constant  Semicolon            : character := ';';  -- character'val(59)
  constant  Less_Than_Sign       : character := '<';  -- character'val(60)
  constant  Equals_Sign          : character := '=';  -- character'val(61)
  constant  Greater_Than_Sign    : character := '>';  -- character'val(62)
  constant  Question             : character := '?';  -- character'val(63)
  constant  Commercial_At        : character := '@';  -- character'val(64)

-- letters 'A' to 'Z'

  constant  Left_Square_Bracket  : character := '[';  -- character'val(91)
  constant  Reverse_Solidus      : character := '\';  -- character'val(92)
  constant  Right_Square_Bracket : character := ']';  -- character'val(93)
  constant  Circumflex           : character := '^';  -- character'val(94)
  constant  Low_Line             : character := '_';  -- character'val(95)
  constant  Grave                : character := '`';  -- character'val(96)
  constant  LC_A                 : character := 'a';  -- character'val(97)
  constant  LC_B                 : character := 'b';  -- character'val(98)
  constant  LC_C                 : character := 'c';  -- character'val(99)
  constant  LC_D                 : character := 'd';  -- character'val(100)
  constant  LC_E                 : character := 'e';  -- character'val(101)
  constant  LC_F                 : character := 'f';  -- character'val(102)
  constant  LC_G                 : character := 'g';  -- character'val(103)
  constant  LC_H                 : character := 'h';  -- character'val(104)
  constant  LC_I                 : character := 'i';  -- character'val(105)
  constant  LC_J                 : character := 'j';  -- character'val(106)
  constant  LC_K                 : character := 'k';  -- character'val(107)
  constant  LC_L                 : character := 'l';  -- character'val(108)
  constant  LC_M                 : character := 'm';  -- character'val(109)
  constant  LC_N                 : character := 'n';  -- character'val(110)
  constant  LC_O                 : character := 'o';  -- character'val(111)
  constant  LC_P                 : character := 'p';  -- character'val(112)
  constant  LC_Q                 : character := 'q';  -- character'val(113)
  constant  LC_R                 : character := 'r';  -- character'val(114)
  constant  LC_S                 : character := 's';  -- character'val(115)
  constant  LC_T                 : character := 't';  -- character'val(116)
  constant  LC_U                 : character := 'u';  -- character'val(117)
  constant  LC_V                 : character := 'v';  -- character'val(118)
  constant  LC_W                 : character := 'w';  -- character'val(119)
  constant  LC_X                 : character := 'x';  -- character'val(120)
  constant  LC_Y                 : character := 'y';  -- character'val(121)
  constant  LC_Z                 : character := 'z';  -- character'val(122)
  constant  Left_Curly_Bracket   : character := '{';  -- character'val(123)
  constant  Vertical_Line        : character := '|';  -- character'val(124)
  constant  Right_Curly_Bracket  : character := '}';  -- character'val(125)
  constant  Tilde                : character := '~';  -- character'val(126)

-- control characters 127 to 159

  constant  No_Break_Space              : character := character'val(160);
    alias     NBSP                      : character is No_Break_Space;
  constant  Inverted_Exclamation        : character := character'val(161);
  constant  Cent_Sign                   : character := character'val(162);
  constant  Pound_Sign                  : character := character'val(163);
  constant  Currency_Sign               : character := character'val(164);
  constant  Yen_Sign                    : character := character'val(165);
  constant  Broken_Bar                  : character := character'val(166);
  constant  Section_Sign                : character := character'val(167);
  constant  Diaeresis                   : character := character'val(168);
  constant  Copyright_Sign              : character := character'val(169);
  constant  Feminine_Ordinal_Indicator  : character := character'val(170);
  constant  Left_Angle_Quotation        : character := character'val(171);
  constant  Not_Sign                    : character := character'val(172);
  constant  Soft_Hyphen                 : character := character'val(173);
  constant  Registered_Trade_Mark_Sign  : character := character'val(174);
  constant  Macron                      : character := character'val(175);
  constant  Degree_Sign                 : character := character'val(176);
    alias     Ring_Above                : character is Degree_Sign;
  constant  Plus_Minus_Sign             : character := character'val(177);
  constant  Superscript_Two             : character := character'val(178);
  constant  Superscript_Three           : character := character'val(179);
  constant  Acute                       : character := character'val(180);
  constant  Micro_Sign                  : character := character'val(181);
  constant  Pilcrow_Sign                : character := character'val(182);
    alias     Paragraph_Sign            : character is Pilcrow_Sign;
  constant  Middle_Dot                  : character := character'val(183);
  constant  Cedilla                     : character := character'val(184);
  constant  Superscript_One             : character := character'val(185);
  constant  Masculine_Ordinal_Indicator : character := character'val(186);
  constant  Right_Angle_Quotation       : character := character'val(187);
  constant  Fraction_One_Quarter        : character := character'val(188);
  constant  Fraction_One_Half           : character := character'val(189);
  constant  Fraction_Three_Quarters     : character := character'val(190);
  constant  Inverted_Question           : character := character'val(191);
  constant  UC_A_Grave                  : character := character'val(192);
  constant  UC_A_Acute                  : character := character'val(193);
  constant  UC_A_Circumflex             : character := character'val(194);
  constant  UC_A_Tilde                  : character := character'val(195);
  constant  UC_A_Diaeresis              : character := character'val(196);
  constant  UC_A_Ring                   : character := character'val(197);
  constant  UC_AE_Diphthong             : character := character'val(198);
  constant  UC_C_Cedilla                : character := character'val(199);
  constant  UC_E_Grave                  : character := character'val(200);
  constant  UC_E_Acute                  : character := character'val(201);
  constant  UC_E_Circumflex             : character := character'val(202);
  constant  UC_E_Diaeresis              : character := character'val(203);
  constant  UC_I_Grave                  : character := character'val(204);
  constant  UC_I_Acute                  : character := character'val(205);
  constant  UC_I_Circumflex             : character := character'val(206);
  constant  UC_I_Diaeresis              : character := character'val(207);
  constant  UC_Icelandic_Eth            : character := character'val(208);
  constant  UC_N_Tilde                  : character := character'val(209);
  constant  UC_O_Grave                  : character := character'val(210);
  constant  UC_O_Acute                  : character := character'val(211);
  constant  UC_O_Circumflex             : character := character'val(212);
  constant  UC_O_Tilde                  : character := character'val(213);
  constant  UC_O_Diaeresis              : character := character'val(214);
  constant  Multiplication_Sign         : character := character'val(215);
  constant  UC_O_Oblique_Stroke         : character := character'val(216);
  constant  UC_U_Grave                  : character := character'val(217);
  constant  UC_U_Acute                  : character := character'val(218);
  constant  UC_U_Circumflex             : character := character'val(219);
  constant  UC_U_Diaeresis              : character := character'val(220);
  constant  UC_Y_Acute                  : character := character'val(221);
  constant  UC_Icelandic_Thorn          : character := character'val(222);
  constant  LC_German_Sharp_S           : character := character'val(223);
  constant  LC_A_Grave                  : character := character'val(224);
  constant  LC_A_Acute                  : character := character'val(225);
  constant  LC_A_Circumflex             : character := character'val(226);
  constant  LC_A_Tilde                  : character := character'val(227);
  constant  LC_A_Diaeresis              : character := character'val(228);
  constant  LC_A_Ring                   : character := character'val(229);
  constant  LC_AE_Diphthong             : character := character'val(230);
  constant  LC_C_Cedilla                : character := character'val(231);
  constant  LC_E_Grave                  : character := character'val(232);
  constant  LC_E_Acute                  : character := character'val(233);
  constant  LC_E_Circumflex             : character := character'val(234);
  constant  LC_E_Diaeresis              : character := character'val(235);
  constant  LC_I_Grave                  : character := character'val(236);
  constant  LC_I_Acute                  : character := character'val(237);
  constant  LC_I_Circumflex             : character := character'val(238);
  constant  LC_I_Diaeresis              : character := character'val(239);
  constant  LC_Icelandic_Eth            : character := character'val(240);
  constant  LC_N_Tilde                  : character := character'val(241);
  constant  LC_O_Grave                  : character := character'val(242);
  constant  LC_O_Acute                  : character := character'val(243);
  constant  LC_O_Circumflex             : character := character'val(244);
  constant  LC_O_Tilde                  : character := character'val(245);
  constant  LC_O_Diaeresis              : character := character'val(246);
  constant  Division_Sign               : character := character'val(247);
  constant  LC_O_Oblique_Stroke         : character := character'val(248);
  constant  LC_U_Grave                  : character := character'val(249);
  constant  LC_U_Acute                  : character := character'val(250);
  constant  LC_U_Circumflex             : character := character'val(251);
  constant  LC_U_Diaeresis              : character := character'val(252);
  constant  LC_Y_Acute                  : character := character'val(253);
  constant  LC_Icelandic_Thorn          : character := character'val(254);
  constant  LC_Y_Diaeresis              : character := character'val(255);

end package;
