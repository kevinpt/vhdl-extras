-- This program is used to generate the constants needed in strings_maps_constants.vhdl
-- Doing this allows us to eliminate using the GNAT derived LGPL code for
-- ada.strings.maps.constants in that file.

-- This program spits out just the constant portion of strings_maps_constants.vhdl. A
-- fixed header must be appended to the top for it to be a complete package.

with ada.text_io;
use ada.text_io;

with ada.strings.maps;
use ada.strings.maps;
with ada.strings.maps.constants;
use ada.strings.maps.constants;


procedure vhdl_gen is

  subtype fstring is string(1..27);
  type vcnames is array(character) of fstring;

  -- VHDL named character constants
  vhdl_cname : constant vcnames := (
    "NUL                        ",
    "SOH                        ",
    "STX                        ",
    "ETX                        ",
    "EOT                        ",
    "ENQ                        ",
    "ACK                        ",
    "BEL                        ",
    "BS                         ",
    "HT                         ",
    "LF                         ",
    "VT                         ",
    "FF                         ",
    "CR                         ",
    "SO                         ",
    "SI                         ",
    "DLE                        ",
    "DC1                        ",
    "DC2                        ",
    "DC3                        ",
    "DC4                        ",
    "NAK                        ",
    "SYN                        ",
    "ETB                        ",
    "CAN                        ",
    "EM                         ",
    "SUB                        ",
    "ESC                        ",
    "FSP                        ",
    "GSP                        ",
    "RSP                        ",
    "USP                        ",
    "' '                        ",
    "'!'                        ",
    "'""'                        ",
    "'#'                        ",
    "'$'                        ",
    "'%'                        ",
    "'&'                        ",
    "'''                        ",
    "'('                        ",
    "')'                        ",
    "'*'                        ",
    "'+'                        ",
    "','                        ",
    "'-'                        ",
    "'.'                        ",
    "'/'                        ",
    "'0'                        ",
    "'1'                        ",
    "'2'                        ",
    "'3'                        ",
    "'4'                        ",
    "'5'                        ",
    "'6'                        ",
    "'7'                        ",
    "'8'                        ",
    "'9'                        ",
    "':'                        ",
    "';'                        ",
    "'<'                        ",
    "'='                        ",
    "'>'                        ",
    "'?'                        ",
    "'@'                        ",
    "'A'                        ",
    "'B'                        ",
    "'C'                        ",
    "'D'                        ",
    "'E'                        ",
    "'F'                        ",
    "'G'                        ",
    "'H'                        ",
    "'I'                        ",
    "'J'                        ",
    "'K'                        ",
    "'L'                        ",
    "'M'                        ",
    "'N'                        ",
    "'O'                        ",
    "'P'                        ",
    "'Q'                        ",
    "'R'                        ",
    "'S'                        ",
    "'T'                        ",
    "'U'                        ",
    "'V'                        ",
    "'W'                        ",
    "'X'                        ",
    "'Y'                        ",
    "'Z'                        ",
    "'['                        ",
    "'\'                        ",
    "']'                        ",
    "'^'                        ",
    "'_'                        ",
    "'`'                        ",
    "'a'                        ",
    "'b'                        ",
    "'c'                        ",
    "'d'                        ",
    "'e'                        ",
    "'f'                        ",
    "'g'                        ",
    "'h'                        ",
    "'i'                        ",
    "'j'                        ",
    "'k'                        ",
    "'l'                        ",
    "'m'                        ",
    "'n'                        ",
    "'o'                        ",
    "'p'                        ",
    "'q'                        ",
    "'r'                        ",
    "'s'                        ",
    "'t'                        ",
    "'u'                        ",
    "'v'                        ",
    "'w'                        ",
    "'x'                        ",
    "'y'                        ",
    "'z'                        ",
    "'{'                        ",
    "'|'                        ",
    "'}'                        ",
    "'~'                        ",
    "DEL                        ",
    "c128                       ",
    "c129                       ",
    "c130                       ",
    "c131                       ",
    "c132                       ",
    "c133                       ",
    "c134                       ",
    "c135                       ",
    "c136                       ",
    "c137                       ",
    "c138                       ",
    "c139                       ",
    "c140                       ",
    "c141                       ",
    "c142                       ",
    "c143                       ",
    "c144                       ",
    "c145                       ",
    "c146                       ",
    "c147                       ",
    "c148                       ",
    "c149                       ",
    "c150                       ",
    "c151                       ",
    "c152                       ",
    "c153                       ",
    "c154                       ",
    "c155                       ",
    "c156                       ",
    "c157                       ",
    "c158                       ",
    "c159                       ",
    "No_Break_Space             ",
    "Inverted_Exclamation       ",
    "Cent_Sign                  ",
    "Pound_Sign                 ",
    "Currency_Sign              ",
    "Yen_Sign                   ",
    "Broken_Bar                 ",
    "Section_Sign               ",
    "Diaeresis                  ",
    "Copyright_Sign             ",
    "Feminine_Ordinal_Indicator ",
    "Left_Angle_Quotation       ",
    "Not_Sign                   ",
    "Soft_Hyphen                ",
    "Registered_Trade_Mark_Sign ",
    "Macron                     ",
    "Degree_Sign                ",
    "Plus_Minus_Sign            ",
    "Superscript_Two            ",
    "Superscript_Three          ",
    "Acute                      ",
    "Micro_Sign                 ",
    "Pilcrow_Sign               ",
    "Middle_Dot                 ",
    "Cedilla                    ",
    "Superscript_One            ",
    "Masculine_Ordinal_Indicator",
    "Right_Angle_Quotation      ",
    "Fraction_One_Quarter       ",
    "Fraction_One_Half          ",
    "Fraction_Three_Quarters    ",
    "Inverted_Question          ",
    "UC_A_Grave                 ",
    "UC_A_Acute                 ",
    "UC_A_Circumflex            ",
    "UC_A_Tilde                 ",
    "UC_A_Diaeresis             ",
    "UC_A_Ring                  ",
    "UC_AE_Diphthong            ",
    "UC_C_Cedilla               ",
    "UC_E_Grave                 ",
    "UC_E_Acute                 ",
    "UC_E_Circumflex            ",
    "UC_E_Diaeresis             ",
    "UC_I_Grave                 ",
    "UC_I_Acute                 ",
    "UC_I_Circumflex            ",
    "UC_I_Diaeresis             ",
    "UC_Icelandic_Eth           ",
    "UC_N_Tilde                 ",
    "UC_O_Grave                 ",
    "UC_O_Acute                 ",
    "UC_O_Circumflex            ",
    "UC_O_Tilde                 ",
    "UC_O_Diaeresis             ",
    "Multiplication_Sign        ",
    "UC_O_Oblique_Stroke        ",
    "UC_U_Grave                 ",
    "UC_U_Acute                 ",
    "UC_U_Circumflex            ",
    "UC_U_Diaeresis             ",
    "UC_Y_Acute                 ",
    "UC_Icelandic_Thorn         ",
    "LC_German_Sharp_S          ",
    "LC_A_Grave                 ",
    "LC_A_Acute                 ",
    "LC_A_Circumflex            ",
    "LC_A_Tilde                 ",
    "LC_A_Diaeresis             ",
    "LC_A_Ring                  ",
    "LC_AE_Diphthong            ",
    "LC_C_Cedilla               ",
    "LC_E_Grave                 ",
    "LC_E_Acute                 ",
    "LC_E_Circumflex            ",
    "LC_E_Diaeresis             ",
    "LC_I_Grave                 ",
    "LC_I_Acute                 ",
    "LC_I_Circumflex            ",
    "LC_I_Diaeresis             ",
    "LC_Icelandic_Eth           ",
    "LC_N_Tilde                 ",
    "LC_O_Grave                 ",
    "LC_O_Acute                 ",
    "LC_O_Circumflex            ",
    "LC_O_Tilde                 ",
    "LC_O_Diaeresis             ",
    "Division_Sign              ",
    "LC_O_Oblique_Stroke        ",
    "LC_U_Grave                 ",
    "LC_U_Acute                 ",
    "LC_U_Circumflex            ",
    "LC_U_Diaeresis             ",
    "LC_Y_Acute                 ",
    "LC_Icelandic_Thorn         ",
    "LC_Y_Diaeresis             "
  );


  procedure gen_range_set(name : string; rng : character_ranges) is
  begin
    put_line("  constant " & name & " : character_set := (");
    for i in rng'range loop
      put_line("    " & vhdl_cname(rng(i).low) & " to  " & vhdl_cname(rng(i).high) & "=> true," );
    end loop;
    put_line("    others  =>  false");
    put_line("  );");
    new_line;
  end;

  procedure gen_char_map(name : string; cmap : character_mapping) is
    c, amp : character;
  begin
    put_line("  constant " & name & " : character_mapping := (");
    amp := '&';
    for i in 0..255 loop
      c := character'val(i);
      if i = 255 then
        amp := ' ';
      end if;

      put_line("    " & vhdl_cname(value(cmap, c))
        & " " & amp & "  -- " & vhdl_cname(c) & " " & integer'image(i));
    end loop;
    put_line("  );");
    new_line;
  end;
begin

  put_line("  --## Constants generated by vhdl_gen.adb");
  new_line;

  gen_range_set("CONTROL_SET", to_ranges(control_set));
  gen_range_set("GRAPHIC_SET", to_ranges(graphic_set));
  gen_range_set("LETTER_SET", to_ranges(letter_set));
  gen_range_set("LOWER_SET", to_ranges(lower_set));
  gen_range_set("UPPER_SET", to_ranges(upper_set));
  gen_range_set("BASIC_SET", to_ranges(basic_set));
  gen_range_set("DECIMAL_DIGIT_SET", to_ranges(decimal_digit_set));
  gen_range_set("HEXADECIMAL_DIGIT_SET", to_ranges(hexadecimal_digit_set));
  gen_range_set("ALPHANUMERIC_SET", to_ranges(alphanumeric_set));
  gen_range_set("SPECIAL_SET", to_ranges(special_set));
  gen_range_set("ISO_646_SET", to_ranges(iso_646_set));

  gen_char_map("LOWER_CASE_MAP", lower_case_map);
  gen_char_map("UPPER_CASE_MAP", upper_case_map);
  gen_char_map("BASIC_MAP", basic_map);

  put_line("end package body;");
end;

