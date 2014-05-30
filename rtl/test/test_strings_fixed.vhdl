--# Copyright © 2014 Kevin Thibedeau

library extras;
use extras.strings.all;
use extras.strings_fixed.all;
use extras.strings_maps.all;
use extras.strings_maps_constants.all;


entity test_strings_fixed is
end entity;

architecture test of test_strings_fixed is
begin
  test: process
    variable s, t : string(1 to 10);
    variable i, first, last : natural;
    
  begin

    -- move
    move("X", t, error, left);
    assert t = "X         " report "move 1: unexpected result" severity failure;

    move("XYZ", t, error, right);
    assert t = "       XYZ" report "move 2: unexpected result" severity failure;

    move("XYZ", t, error, right, pad => '_');
    assert t = "_______XYZ" report "move 3: unexpected result" severity failure;


    move("01234567891", t, drop => right);
    assert t = "0123456789" report "move 4: unexpected result" severity failure;

    move("01234567891", t, drop => left);
    assert t = "1234567891" report "move 5: unexpected result" severity failure;

    -- index
    i := index("ABCDAB", "AB", going => forward);
    assert i = 1 report "index 1: unexpected result " & integer'image(i) severity failure;

    i := index("ABCDAB__", "AB", going => backward);
    assert i = 5 report "index 2: unexpected result " & integer'image(i) severity failure;

    i := index("ABCDAB", "XXX");
    assert i = 0 report "index 3: unexpected result" severity failure;

    -- index (character set)
    i := index("ABCDB", to_set('B'));
    assert i = 2 report "index 4: unexpected result" severity failure;

    i := index("ABCDB", to_set('B'), going => backward);
    assert i = 5 report "index 5: unexpected result" severity failure;

    i := index("ABCDB", to_set('B'), test => outside, going => backward);
    assert i = 4 report "index 6: unexpected result" severity failure;

    -- index_non_blank
    i := index_non_blank("ABCD");
    assert i = 1 report "index_non_blank 1: unexpected result" severity failure;

    i := index_non_blank("  ABCD ");
    assert i = 3 report "index_non_blank 2: unexpected result" severity failure;

    i := index_non_blank("  ABCD ", going => backward);
    assert i = 6 report "index_non_blank 3: unexpected result" severity failure;

    i := index_non_blank("       ");
    assert i = 0 report "index_non_blank 4: unexpected result" severity failure;

    -- count
    i := count("ABCDAB", "AB");
    assert i = 2 report "count 1: unexpected result" severity failure;

    i := count("ABCDAB", "C");
    assert i = 1 report "count 2: unexpected result" severity failure;

    i := count("ABCDAB", "XXXXXXXXX");
    assert i = 0 report "count 3: unexpected result" severity failure;

    i := count("ABCDAB", "ABCDABXXX");
    assert i = 0 report "count 4: unexpected result" severity failure;

    -- count (character set)
    i := count("ABCDAB", to_set('A'));
    assert i = 2 report "count 5: unexpected result" severity failure;

    i := count("ABCDAB", to_set('X'));
    assert i = 0 report "count 6: unexpected result" severity failure;

    i := count("ABCDAB", to_set("AB"));
    assert i = 4 report "count 7: unexpected result" severity failure;

    -- find_token
    find_token("ABCDABC", to_set("BC"), inside, first => first, last => last);
    assert first = 2 and last = 3 report "find_token 1: unexpected result" severity failure;

    find_token("ABCDABC", to_set("DAB"), inside, first => first, last => last);
    assert first = 1 and last = 2 report "find_token 2: unexpected result" severity failure;

    find_token("ABCDABC", to_set('D'), inside, first => first, last => last);
    assert first = 4 and last = 4 report "find_token 3: unexpected result" severity failure;

    find_token("ABCDABC", to_set("XYZ"), inside, first => first, last => last);
    assert first = 1 and last = 0 report "find_token 4: unexpected result" severity failure;

    find_token("ABCDAB", to_set("AB"), outside, first => first, last => last);
    assert first = 3 and last = 4 report "find_token 5: unexpected result" severity failure;

    -- translate
    t := translate("ABCD012345", LOWER_CASE_MAP);
    assert t = "abcd012345" report "translate 1: unexpected result" severity failure;

    s := "ABCD01234X";
    translate(s, LOWER_CASE_MAP);
    assert s = "abcd01234x" report "translate 2: unexpected result" severity failure;

    -- replace_slice
    t := replace_slice("0123456789", 2, 3, "AB");
    assert t = "0AB3456789" report "replace_slice 1: unexpected result" severity failure;

    t := replace_slice("0123456789", 2, 2, "A");
    assert t = "0A23456789" report "replace_slice 2: unexpected result" severity failure;

    t := replace_slice("01234567", 3, 0, "AB");
    assert t = "01AB234567" report "replace_slice 3: unexpected result" severity failure;

    s := "0123456789";
    replace_slice(s, 4, 5, "AB");
    assert s = "012AB56789" report "replace_slice 4: unexpected result" severity failure;

    s := "0123456789";
    replace_slice(s, 4, 5, "ABCD", drop => right);
    assert s = "012ABCD567" report "replace_slice 5: unexpected result" severity failure;

    s := "0123456789";
    replace_slice(s, 4, 5, "ABCD", drop => left);
    assert s = "2ABCD56789" report "replace_slice 6: unexpected result" severity failure;

    s := "0123456789";
    replace_slice(s, 4, 5, "A", justify => left, pad => '#');
    assert s = "012A56789#" report "replace_slice 7: unexpected result" severity failure;

    s := "0123456789";
    replace_slice(s, 4, 5, "A", justify => right, pad => '#');
    assert s = "#012A56789" report "replace_slice 8: unexpected result" severity failure;

    -- insert
    t := insert("012345", 1, "ABCD");
    assert t = "ABCD012345" report "insert 1: unsepected result" severity failure;

    t := insert("0123456789", 2, "");
    assert t = "0123456789" report "insert 2: unsepected result" severity failure;

    t := insert("012345", 4, "ABCD");
    assert t = "012ABCD345" report "insert 3: unsepected result" severity failure;

    s := "0123456789";
    insert(s, 4, "ABCD", drop => right);
    assert s = "012ABCD345" report "insert 4: unsepected result" severity failure;

    s := "0123456789";
    insert(s, 4, "ABCD", drop => left);
    assert s = "BCD3456789" report "insert 5: unsepected result" severity failure;

    -- overwrite
    t := overwrite("0123456789", 2, "XYZ");
    assert t = "0XYZ456789" report "overwrite 1: unexpected result" severity failure;

    t := overwrite("0123456789", 4, "");
    assert t = "0123456789" report "overwrite 2: unexpected result" severity failure;

    s := "0123456789";
    overwrite(s, 6, "ABCDEF", drop => right);
    assert s = "01234ABCDE" report "overwrite 3: unexpected result" severity failure;

    s := "0123456789";
    overwrite(s, 6, "ABCDEF", drop => left);
    assert s = "1234ABCDEF" report "overwrite 4: unexpected result" severity failure;

    
    -- delete
    t := delete("XXX0123456789", 1, 3);
    assert t = "0123456789" report "delete 1: unexpected result" severity failure;

    t := delete("0123456789", 4, 3);
    assert t = "0123456789" report "delete 2: unexpected result" severity failure;

    s := "0123456789";
    delete(s, 1, 3);
    assert s = "3456789   " report "delete 3: unexpected result" severity failure;

    s := "0123456789";
    delete(s, 2, 4, justify => right);
    assert s = "   0456789" report "delete 4: unexpected result" severity failure;


    -- trim
    t := trim("  0123456789", side => left);
    assert t = "0123456789" report "trim 1: unexpected result" severity failure;

    t := trim(" 123456789  ", side => right);
    assert t = " 123456789" report "trim 2: unexpected result" severity failure;

    t := trim(" 0123456789 ", side => both);
    assert t = "0123456789" report "trim 3: unexpected result" severity failure;

    s := "   3456789";
    trim(s, side => left, justify => left, pad => '#');
    assert s = "3456789###" report "trim 4: unexpected result" severity failure;

    s := "   3456789";
    trim(s, side => right, justify => left, pad => '#');
    assert s = "   3456789" report "trim 5: unexpected result" severity failure;

    s := "   3456789";
    trim(s, side => left, justify => right, pad => '#');
    assert s = "###3456789" report "trim 6: unexpected result" severity failure;
    

    t := trim("A0123456789Z", to_set("AB"), to_set('Z'));
    assert t = "0123456789" report "trim 7: unexpected result" severity failure;

    t := trim("AB0123456789", to_set("AB"), to_set('Z'));
    assert t = "0123456789" report "trim 8: unexpected result" severity failure;

    s := "AB01234567";
    trim(s, to_set("AB"), to_set("Z"), justify => left);
    assert s = "01234567  " report "trim 9: unexpected result" severity failure;

    s := "AB01234567";
    trim(s, to_set("AB"), to_set(""), justify => right);
    assert s = "  01234567" report "trim 10: unexpected result" severity failure;


    -- head
    t := head("0123456789ABCD", 10);
    assert t = "0123456789" report "head 1: unexpected result" severity failure;

    t := head("012345", 10);
    assert t = "012345    " report "head 2: unexpected result" severity failure;

    s := "0123456789";
    head(s, 4, justify => left);
    assert s = "0123      " report "head 3: unexpected result" severity failure;

    s := "0123456789";
    head(s, 4, justify => right, pad => '#');
    assert s = "######0123" report "head 4: unexpected result" severity failure;


    -- tail
    t := tail("0123456789ABCD", 10);
    assert t = "456789ABCD" report "tail 1: unexpected result" severity failure;

    t := tail("012345", 10);
    assert t = "    012345" report "tail 2: unexpected result" severity failure;

    s := "0123456789";
    tail(s, 4, justify => left);
    assert s = "6789      " report "tail 3: unexpected result" severity failure;

    s := "0123456789";
    tail(s, 4, justify => right, pad => '#');
    assert s = "######6789" report "tail 4: unexpected result" severity failure;

    s := "0123456789";
    tail(s, 10, justify => left);
    assert s = "0123456789" report "tail 5: unexpected result" severity failure;


    -- *
    t := 10 * 'X';
    assert t = "XXXXXXXXXX" report "multiply 1: unexpected result" severity failure;

    t := 5 * "AB";
    assert t = "ABABABABAB" report "multiply 2: unexpected result" severity failure;

    wait;
  end process;
end architecture;
