--# Copyright © 2014 Kevin Thibedeau

library extras;
use extras.characters_handling.all;
use extras.strings_maps.all;

entity test_characters_handling is
end entity;

architecture test of test_characters_handling is
begin
  classes: process
    variable cset : character_set;
  begin
    -- Is_Alphanumeric
    cset := to_set(character_ranges'(('0', '9'), ('a', 'z'), ('A', 'Z'), ('À','Ö'), ('Ø','ö'), ('ø','ÿ')));
    for c in cset'range loop
      assert Is_Alphanumeric(c) = cset(c) report "alphanum mismatch: " & character'image(c)
        & ", " & integer'image(character'pos(c)) severity failure;
    end loop;

    -- Is_Letter
    cset := to_set(character_ranges'(('a', 'z'), ('A', 'Z'), ('À','Ö'), ('Ø','ö'), ('ø','ÿ')));
    for c in cset'range loop
      assert Is_Letter(c) = cset(c) report "letter mismatch: " & character'image(c)
        & ", " & integer'image(character'pos(c)) severity failure;
    end loop;
    
    -- Is_Control
    cset := to_set(character_ranges'((NUL, USP), (DEL, c159)));
    for c in cset'range loop
      assert Is_Control(c) = cset(c) report "control mismatch: " & character'image(c)
        & ", " & integer'image(character'pos(c)) severity failure;
    end loop;

    -- Is_Digit
    cset := to_set(character_range'('0', '9'));
    for c in cset'range loop
      assert Is_Digit(c) = cset(c) report "digit mismatch: " & character'image(c)
        & ", " & integer'image(character'pos(c)) severity failure;
    end loop;

    -- Is_Hexadecimal_Digit
    cset := to_set(character_ranges'(('0', '9'), ('a', 'f'), ('A', 'F')));
    for c in cset'range loop
      assert Is_Hexadecimal_Digit(c) = cset(c) report "hex mismatch: " & character'image(c)
        & ", " & integer'image(character'pos(c)) severity failure;
    end loop;

    -- Is_Basic
    cset := to_set(character_ranges'(('a', 'z'), ('A', 'Z'), ('Æ','Æ'), ('æ','æ'), ('Ð','Ð'), ('ð','ð'), ('Þ','Þ'), ('þ','þ'), ('ß','ß')));
    for c in cset'range loop
      assert Is_Basic(c) = cset(c) report "basic mismatch: " & character'image(c)
        & ", " & integer'image(character'pos(c)) & ", expect " & boolean'image(cset(c)) severity failure;
    end loop;

    -- Is_Graphic
    cset := to_set(character_ranges'((' ', '~'), (character'val(160), 'ÿ')));
    for c in cset'range loop
      assert Is_Graphic(c) = cset(c) report "graphic mismatch: " & character'image(c)
        & ", " & integer'image(character'pos(c)) severity failure;
    end loop;

    -- Is_Lower
    cset := to_set(character_ranges'(('a', 'z'), ('ß', 'ö'), ('ø','ÿ')));
    for c in cset'range loop
      assert Is_Lower(c) = cset(c) report "lower mismatch: " & character'image(c)
        & ", " & integer'image(character'pos(c)) severity failure;
    end loop;
    
    -- Is_Upper
    cset := to_set(character_ranges'(('A', 'Z'), ('À', 'Ö'), ('Ø','Þ')));
    for c in cset'range loop
      assert Is_Upper(c) = cset(c) report "upper mismatch: " & character'image(c)
        & ", " & integer'image(character'pos(c)) severity failure;
    end loop;
    
    -- Is_Special
    cset := to_set(character_ranges'((' ', '/'), (':', '@'), ('[','`'), ('{', '~'), (character'val(160), '¿'), ('×', '×'), ('÷', '÷')));
    for c in cset'range loop
      assert Is_Special(c) = cset(c) report "special mismatch: " & character'image(c)
        & ", " & integer'image(character'pos(c)) severity failure;
    end loop;
    wait;
  end process;

  convert: process
    variable cset : character_set;
    variable ch : character;
    variable str : string(1 to 8);
  begin
  
    cset := to_set(character_ranges'(('A', 'Z'), ('À', 'Ö'), ('Ø','Þ')));
    for c in cset'range loop
      if cset(c) then
        assert Is_Upper(To_Upper(To_Lower(c))) = true report "upper conv mismatch: " & character'image(c) severity failure;
      end if;
    end loop;

    cset := to_set(character_ranges'(('a', 'z'), ('ß', 'ö'), ('ø','ÿ')));
    for c in cset'range loop
      if cset(c) then
        assert Is_Lower(To_Lower(To_Upper(c))) = true report "lower conv mismatch: " & character'image(c) severity failure;
      end if;
    end loop;

    for i in 0 to 255 loop
      ch := character'val(i);
      if Is_Letter(ch) and not Is_Basic(ch) then
        assert Is_Basic(To_Basic(ch)) = true report "basic conv mismatch: " & character'image(ch) severity failure;
      end if;
    end loop;

    str := "ABCD0123";
    assert To_Upper(To_Lower(str)) = str report "upper str conv mismatch: " & str severity failure;
    assert To_Lower(str) = "abcd0123" report "lower str conv mismatch: " & str severity failure;

    str := "abcd0123";
    assert To_Lower(To_Upper(str)) = str report "lower str conv mismatch: " & str severity failure;
    assert To_Upper(str) = "ABCD0123" report "upper str conv mismatch: " & str severity failure;
    
    wait;
  end process;

end architecture;
