--# Copyright © 2014 Kevin Thibedeau

library extras_2008;
package s10 is new extras_2008.strings_bounded
  generic map (MAX => 10);

use work.s10.all;

library extras;
use extras.strings.all;
use extras.strings_maps.all;
use extras.strings_maps_constants.all;


entity test_strings_bounded is
end entity;

architecture test of test_strings_bounded is
begin
  test: process
    variable s, t : string(1 to 10);
    variable i, first, last : natural;
    
    variable sb, sb2, sb3 : bounded_string;
  begin

    sb := to_bounded_string("123");
    assert to_string(sb) = "123" report "to_bounded_string 1: unexpected result" severity failure;

    assert length(sb) = 3 report "length: unexpected result" severity failure;

    sb := to_bounded_string("0123456789X", drop => left);
    assert to_string(sb) = "123456789X" report "to_bounded_string 2: unexpected result" severity failure;

    sb := to_bounded_string("0123456789X", drop => right);
    assert to_string(sb) = "0123456789" report "to_bounded_string 3: unexpected result" severity failure;

    sb := to_bounded_string("01234");
    sb2 := to_bounded_string("56789");
    sb3 := append(sb, sb2);
    assert to_string(sb3) = "0123456789" report "append 1.0: unexpected result" severity failure;

    sb2 := to_bounded_string("56789XYZ");
    sb3 := append(sb, sb2, drop => left);
    assert to_string(sb3) = "3456789XYZ" report "append 1.1: unexpected result" severity failure;

    sb2 := to_bounded_string("56789XYZ");
    sb3 := append(sb, sb2, drop => right);
    assert to_string(sb3) = "0123456789" report "append 1.2: unexpected result" severity failure;


    sb := to_bounded_string("01234");
    sb3 := append(sb, "56789"); -- len <= MAX
    assert to_string(sb3) = "0123456789" report "append 2.0: unexpected result" severity failure;

    sb3 := append(sb, "56789XYZ", drop => left); -- len > MAX
    assert to_string(sb3) = "3456789XYZ" report "append 2.1: unexpected result" severity failure;

    sb3 := append(sb, "56789XYZ", drop => right); -- len > MAX
    assert to_string(sb3) = "0123456789" report "append 2.2: unexpected result" severity failure;

    sb3 := append(sb, "56789XYZABCDE", drop => left); -- right len > MAX
    assert to_string(sb3) = "89XYZABCDE" report "append 2.3: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    sb3 := append(sb, "56789XYZABCDE", drop => right); -- left len >= MAX
    assert to_string(sb3) = "0123456789" report "append 2.4: unexpected result" severity failure;


    sb := to_bounded_string("56789");
    sb3 := append("01234", sb); -- len <= MAX
    assert to_string(sb3) = "0123456789" report "append 3.0: unexpected result" severity failure;

    sb := to_bounded_string("56789XYZ");
    sb3 := append("01234", sb, drop => left); -- len > MAX
    assert to_string(sb3) = "3456789XYZ" report "append 3.1: unexpected result" severity failure;

    sb3 := append("01234", sb, drop => right); -- len > MAX
    assert to_string(sb3) = "0123456789" report "append 3.2: unexpected result" severity failure;

    sb := to_bounded_string("56789XYZAB");
    sb3 := append("01234", sb, drop => left); -- right len > MAX
    assert to_string(sb3) = "56789XYZAB" report "append 3.3: unexpected result" severity failure;

    sb3 := append("0123456789", sb, drop => right); -- left len >= MAX
    assert to_string(sb3) = "0123456789" report "append 3.4: unexpected result" severity failure;

    sb := to_bounded_string("0123");
    sb3 := append(sb, 'X');
    assert to_string(sb3) = "0123X" report "append 4.0: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    sb3 := append(sb, 'X', drop => left);
    assert to_string(sb3) = "123456789X" report "append 4.1: unexpected result" severity failure;

    sb3 := append(sb, 'X', drop => right);
    assert to_string(sb3) = "0123456789" report "append 4.2: unexpected result" severity failure;


    sb := to_bounded_string("0123");
    sb3 := append('X', sb);
    assert to_string(sb3) = "X0123" report "append 5.0: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    sb3 := append('X', sb, drop => left);
    assert to_string(sb3) = "0123456789" report "append 5.1: unexpected result" severity failure;

    sb3 := append('X', sb, drop => right);
    assert to_string(sb3) = "X012345678" report "append 5.2: unexpected result" severity failure;


    sb := to_bounded_string("01234");
    sb2 := to_bounded_string("56789");
    append(sb, sb2);
    assert to_string(sb) = "0123456789" report "append 6.0: unexpected result" severity failure;

    sb := to_bounded_string("01234");
    sb2 := to_bounded_string("56789X");
    append(sb, sb2, drop => left);
    assert to_string(sb) = "123456789X" report "append 6.1: unexpected result" severity failure;

    sb := to_bounded_string("01234");
    sb2 := to_bounded_string("56789XYZAB");
    append(sb, sb2, drop => left);
    assert to_string(sb) = "56789XYZAB" report "append 6.2: unexpected result" severity failure;

    sb := to_bounded_string("01234");
    sb2 := to_bounded_string("56789X");
    append(sb, sb2, drop => right);
    assert to_string(sb) = "0123456789" report "append 6.3: unexpected result" severity failure;


    sb := to_bounded_string("01234");
    append(sb, "56789");
    assert to_string(sb) = "0123456789" report "append 7.0: unexpected result" severity failure;

    sb := to_bounded_string("01234");
    append(sb, "56789X", drop => left);
    assert to_string(sb) = "123456789X" report "append 7.1: unexpected result" severity failure;

    sb := to_bounded_string("01234");
    append(sb, "56789XYZAB", drop => left);
    assert to_string(sb) = "56789XYZAB" report "append 7.2: unexpected result" severity failure;

    sb := to_bounded_string("01234");
    append(sb, "56789X", drop => right);
    assert to_string(sb) = "0123456789" report "append 7.3: unexpected result" severity failure;


    sb := to_bounded_string("01234");
    append(sb, 'X');
    assert to_string(sb) = "01234X" report "append 8.0: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    append(sb, 'X', drop => left);
    assert to_string(sb) = "123456789X" report "append 8.1: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    append(sb, 'X', drop => right);
    assert to_string(sb) = "0123456789" report "append 8.3: unexpected result" severity failure;


    sb := to_bounded_string("01234");
    sb2 := to_bounded_string("56789");
    sb3 := sb & sb2;
    assert to_string(sb3) = "0123456789" report "concat: unexpected result" severity failure;


    sb := to_bounded_string("0123456789");
    assert element(sb, 1) = '0' report "element 1: unexpected result" severity failure;
    assert element(sb, 2) = '1' report "element 2: unexpected result" severity failure;
    assert element(sb, 10) = '9' report "element 3: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    replace_element(sb, 1, 'X');
    assert to_string(sb) = "X123456789" report "replace_element: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    assert slice(sb, 2, 3) = "12" report "slice 1: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    assert slice(sb, 11, 10) = "" report "slice 2: unexpected result" severity failure;


    sb := to_bounded_string("01234");
    sb2 := to_bounded_string("01234");
    assert sb = sb2 report "equals 1: unexpected result" severity failure;
    assert sb = "01234" report "equals 2: unexpected result" severity failure;
    assert "01234" = sb report "equals 3: unexpected result" severity failure;


    sb := to_bounded_string("bb");
    sb2 := to_bounded_string("bc");
    assert sb < sb2 report "less 1: unexpected result" severity failure;
    assert sb < "bc" report "less 2: unexpected result" severity failure;
    assert "ba" < sb report "less 3: unexpected result" severity failure;
    assert not ("bb" < sb) report "less 4: unexpected result" severity failure;

    assert sb <= sb2 report "less-equal 1: unexpected result" severity failure;
    assert sb <= "bc" report "less-equal 2: unexpected result" severity failure;
    assert "ba" <= sb report "less-equal 3: unexpected result" severity failure;
    assert "bb" <= sb report "less-equal 4: unexpected result" severity failure;

    sb := to_bounded_string("bb");
    sb2 := to_bounded_string("ba");
    assert sb > sb2 report "greater 1: unexpected result" severity failure;
    assert sb > "ba" report "greater 2: unexpected result" severity failure;
    assert "bc" > sb report "greater 3: unexpected result" severity failure;
    assert not ("bb" > sb) report "greater 4: unexpected result" severity failure;

    assert sb >= sb2 report "greater-equal 1: unexpected result" severity failure;
    assert sb >= "ba" report "greater-equal 2: unexpected result" severity failure;
    assert "bc" >= sb report "greater-equal 3: unexpected result" severity failure;
    assert "bb" >= sb report "greater-equal 4: unexpected result" severity failure;


    -- translate
    sb3 := translate(to_bounded_string("ABCD012345"), LOWER_CASE_MAP);
    assert to_string(sb3) = "abcd012345" report "translate 1: unexpected result" severity failure;

    sb := to_bounded_string("ABCD01234X");
    translate(sb, LOWER_CASE_MAP);
    assert to_string(sb) = "abcd01234x" report "translate 2: unexpected result" severity failure;

    -- replace_slice
    sb3 := replace_slice(to_bounded_string("0123456789"), 2, 3, "AB");
    assert sb3 = "0AB3456789" report "replace_slice 1: unexpected result" severity failure;

    sb3 := replace_slice(to_bounded_string("0123456789"), 2, 2, "A");
    assert sb3 = "0A23456789" report "replace_slice 2: unexpected result" severity failure;

    sb3 := replace_slice(to_bounded_string("01234567"), 3, 0, "AB");
    assert sb3 = "01AB234567" report "replace_slice 3: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    replace_slice(sb, 4, 5, "AB");
    assert sb = "012AB56789" report "replace_slice 4: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    replace_slice(sb, 4, 5, "ABCD", drop => right);
    assert sb = "012ABCD567" report "replace_slice 5: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    replace_slice(sb, 4, 5, "ABCD", drop => left);
    assert sb = "2ABCD56789" report "replace_slice 6: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    sb3 := replace_slice(sb, 1, 2, "ABCD", drop => left);
    assert sb3 = "CD23456789" report "replace_slice 7: unexpected result" severity failure;

    sb3 := replace_slice(sb, 9, 10, "ABCD", drop => right);
    assert sb3 = "01234567AB" report "replace_slice 8: unexpected result" severity failure;

    -- insert
    sb := insert(to_bounded_string("012345"), 1, "ABCD");
    assert sb = "ABCD012345" report "insert 1: unsepected result" severity failure;

    sb := insert(to_bounded_string("0123456789"), 2, "");
    assert sb = "0123456789" report "insert 2: unsepected result" severity failure;

    sb := insert(to_bounded_string("012345"), 4, "ABCD");
    assert sb = "012ABCD345" report "insert 3: unsepected result" severity failure;

    sb := to_bounded_string("0123456789");
    insert(sb, 4, "ABCD", drop => right);
    assert sb = "012ABCD345" report "insert 4: unsepected result" severity failure;

    sb := to_bounded_string("0123456789");
    insert(sb, 4, "ABCD", drop => left);
    assert sb = "BCD3456789" report "insert 5: unsepected result" severity failure;

    sb := to_bounded_string("0123456789");
    sb3 := insert(sb, 3, "ABCD", drop => left);
    assert sb3 = "CD23456789" report "insert 6: unsepected result" severity failure;

    sb3 := insert(sb, 9, "ABCD", drop => right);
    assert sb3 = "01234567AB" report "insert 7: unsepected result" severity failure;

    -- overwrite
    sb := overwrite(to_bounded_string("0123456789"), 2, "XYZ");
    assert sb = "0XYZ456789" report "overwrite 1: unexpected result" severity failure;

    sb := overwrite(to_bounded_string("0123456789"), 4, "");
    assert sb = "0123456789" report "overwrite 2: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    overwrite(sb, 6, "ABCDEF", drop => right);
    assert sb = "01234ABCDE" report "overwrite 3: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    overwrite(sb, 6, "ABCDEF", drop => left);
    assert sb = "1234ABCDEF" report "overwrite 4: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    overwrite(sb, 6, "ABCDEFGHIJKL", drop => left);
    assert sb = "CDEFGHIJKL" report "overwrite 5: unexpected result" severity failure;

    
    -- delete
    sb := delete(to_bounded_string("XXX0123456"), 1, 3);
    assert sb = "0123456" report "delete 1: unexpected result" severity failure;

    sb := delete(to_bounded_string("0123456789"), 4, 3);
    assert sb = "0123456789" report "delete 2: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    delete(sb, 1, 3);
    assert sb = "3456789" report "delete 3: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    delete(sb, 2, 4);
    assert sb = "0456789" report "delete 4: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    delete(sb, 4, 2);
    assert sb = "0123456789" report "delete 5: unexpected result" severity failure;

    sb := to_bounded_string("0123456789");
    delete(sb, 4, 20);
    assert sb = "012" report "delete 6: unexpected result" severity failure;


    -- trim
    sb := trim(to_bounded_string("  01234567"), side => left);
    assert sb = "01234567" report "trim 1: unexpected result" severity failure;

    sb := trim(to_bounded_string(" 1234567  "), side => right);
    assert sb = " 1234567" report "trim 2: unexpected result" severity failure;

    sb := trim(to_bounded_string(" 01234567 "), side => both);
    assert sb = "01234567" report "trim 3: unexpected result" severity failure;


    sb := trim(to_bounded_string("A01234567Z"), to_set("AB"), to_set('Z'));
    assert sb = "01234567" report "trim 4: unexpected result" severity failure;

    sb := trim(to_bounded_string("AB01234567"), to_set("AB"), to_set('Z'));
    assert sb = "01234567" report "trim 5: unexpected result" severity failure;

    sb := to_bounded_string("AB01234567");
    trim(sb, to_set("AB"), to_set("Z"));
    assert sb = "01234567" report "trim 6: unexpected result" severity failure;


    -- head
    sb := head(to_bounded_string("0123456789"), 8);
    assert sb = "01234567" report "head 1: unexpected result" severity failure;

    sb := head(to_bounded_string("012345"), 10);
    assert sb = "012345    " report "head 2: unexpected result" severity failure;


    -- tail
    sb := tail(to_bounded_string("0123456789"), 8);
    assert sb = "23456789" report "tail 1: unexpected result" severity failure;

    sb := tail(to_bounded_string("012345"), 10);
    assert sb = "    012345" report "tail 2: unexpected result" severity failure;

    -- *
    sb := 10 * 'X';
    assert sb = "XXXXXXXXXX" report "multiply 1: unexpected result" severity failure;

    sb := 5 * "AB";
    assert sb = "ABABABABAB" report "multiply 2: unexpected result" severity failure;

    sb := 5 * to_bounded_string("AB");
    assert sb = "ABABABABAB" report "multiply 3: unexpected result" severity failure;


    -- replicate
    sb := replicate(8, 'X');
    assert sb = "XXXXXXXX" report "replicate 1.0: unexpected result" severity failure;

    sb := replicate(80, 'X', drop => left);
    assert sb = "XXXXXXXXXX" report "replicate 1.1: unexpected result" severity failure;

    sb := replicate(4, "AB");
    assert sb = "ABABABAB" report "replicate 2.0: unexpected result" severity failure;

    sb := replicate(6, "ABC", drop => left);
    assert sb = "CABCABCABC" report "replicate 2.1: unexpected result" severity failure;

    sb := replicate(6, "ABC", drop => right);
    assert sb = "ABCABCABCA" report "replicate 2.2: unexpected result" severity failure;

    sb := replicate(4, to_bounded_string("AB"));
    assert sb = "ABABABAB" report "replicate 3.0: unexpected result" severity failure;


    wait;
  end process;
end architecture;
