--# Copyright © 2014 Kevin Thibedeau

library extras;
use extras.strings.all;
use extras.strings_unbounded.all;
use extras.strings_maps.all;
use extras.strings_maps_constants.all;
use extras.random.all;


entity test_strings_unbounded is
end entity;

architecture test of test_strings_unbounded is
begin
  test: process
    variable s : string(1 to 10);
    variable sa, sa2 : unbounded_string;
    variable n, first, last : natural;
    variable c : character;
    variable b : boolean;
  begin

    s := "0123456789";
    sa := to_unbounded_string(s);

    assert sa.all = s report "to_unbounded_string[string] mismatch" severity failure;

    sa := to_unbounded_string(20);
    assert sa.all'length = 20 report "to_unbounded_string[natural] bad alloc" severity failure;

    sa := to_unbounded_string("abcdefghij");
    to_string(sa, s);
    assert s = "abcdefghij" report "to_string mismatch" severity failure;

    initialize(sa);
    assert sa.all'length = 0 report "initialize error" severity failure;

    free(sa);

    sa := to_unbounded_string("01234");
    length(sa, n);
    assert n = 5 report "length error" severity failure;

    copy(sa, sa2);
    assert sa.all = sa2.all report "copy mismatch" severity failure;

    copy(sa, sa2, 1);
    assert sa2.all'length = 1 and sa2(1) = '0' report "copy 2 mismatch" severity failure;

    copy(sa, sa2, 10);
    assert sa2.all'length = 5 and sa2.all = sa.all report "copy 3 mismatch" severity failure;

    sa := to_unbounded_string("XXX");
    sa2 := to_unbounded_string("yyy");
    append(sa, sa2);
    assert sa.all = "XXXyyy" report "append mismatch" severity failure;

    sa := to_unbounded_string("XXX");
    append(sa, "zzz");
    assert sa.all = "XXXzzz" report "append 2 mismatch" severity failure;

    sa := to_unbounded_string("XXX");
    append(sa, 'a');
    assert sa.all = "XXXa" report "append 3 mismatch" severity failure;

    free(sa);
    append(sa, 'a');
    assert sa.all = "a" report "append 4 mismatch" severity failure;
    

    s := "0123456789";
    sa := to_unbounded_string(s);
    for i in s'left to s'right loop
      element(sa, i, c);
      assert c = s(i) report "element mismatch" severity failure;
    end loop;


    replace_element(sa, 1, 'X');
    replace_element(sa, 3, 'Y');
    replace_element(sa, 10, 'Z');

    assert sa.all = "X1Y345678Z" report "replace_element mismatch" severity failure;


    slice(sa, 1, 4, sa2);
    assert sa2.all = "X1Y3" report "slice mismatch" severity failure;

    slice(sa, 5, 4, sa2);
    assert sa2.all = "" report "slice 2 mismatch" severity failure;

    eq(sa, sa2, b);
    assert b = false report "eq mismatch" severity failure;
    copy(sa, sa2);
    eq(sa, sa2, b);
    assert b = true report "eq 2 mismatch" severity failure;

    sa := to_unbounded_string("hello");
    eq(sa, "hello", b);
    assert b = true report "eq 3 mismatch" severity failure;



    -- Adapted from test_strings_fixed

    sa := to_unbounded_string("ABCDAB");
    count(sa, "AB", n);
    assert n = 2 report "count 1: unexpected result" severity failure;

    count(sa, "C", n);
    assert n = 1 report "count 2: unexpected result" severity failure;

    count(sa, "XXXXXXXXX", n);
    assert n = 0 report "count 3: unexpected result" severity failure;

    count(sa, "ABCDABXXX", n);
    assert n = 0 report "count 4: unexpected result" severity failure;

    -- delete
    sa := to_unbounded_string("XXX0123456789");
    delete(sa, 1, 3);
    assert sa.all = "0123456789" report "delete 1: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    delete(sa, 4, 3);
    assert sa.all = "0123456789" report "delete 2: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    delete(sa, 1, 3);
    assert sa.all = "3456789" report "delete 3: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    delete(sa, 2, 4);
    assert sa.all = "0456789" report "delete 4: unexpected result" severity failure;

    -- find_token
    sa := to_unbounded_string("ABCDABC");
    find_token(sa, to_set("BC"), inside, first => first, last => last);
    assert first = 2 and last = 3 report "find_token 1: unexpected result" severity failure;

    sa := to_unbounded_string("ABCDABC");
    find_token(sa, to_set("DAB"), inside, first => first, last => last);
    assert first = 1 and last = 2 report "find_token 2: unexpected result" severity failure;

    sa := to_unbounded_string("ABCDABC");
    find_token(sa, to_set('D'), inside, first => first, last => last);
    assert first = 4 and last = 4 report "find_token 3: unexpected result" severity failure;

    sa := to_unbounded_string("ABCDABC");
    find_token(sa, to_set("XYZ"), inside, first => first, last => last);
    assert first = 1 and last = 0 report "find_token 4: unexpected result" severity failure;

    sa := to_unbounded_string("ABCDAB");
    find_token(sa, to_set("AB"), outside, first => first, last => last);
    assert first = 3 and last = 4 report "find_token 5: unexpected result" severity failure;

    -- head
    sa := to_unbounded_string("0123456789ABCD");
    head(sa, 10);
    assert sa.all = "0123456789" report "head 1: unexpected result" severity failure;

    sa := to_unbounded_string("012345");
    head(sa, 10);
    assert sa.all = "012345    " report "head 2: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    head(sa, 4);
    assert sa.all = "0123" report "head 3: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    head(sa, 14, pad => '#');
    assert sa.all = "0123456789####" report "head 4: unexpected result" severity failure;


    -- insert
    sa := to_unbounded_string("012345");
    insert(sa, 1, "ABCD");
    assert sa.all = "ABCD012345" report "insert 1: unsepected result" severity failure;

    sa := to_unbounded_string("0123456789");
    insert(sa, 2, "");
    assert sa.all = "0123456789" report "insert 2: unsepected result" severity failure;

    sa := to_unbounded_string("012345");
    insert(sa, 4, "ABCD");
    assert sa.all = "012ABCD345" report "insert 3: unsepected result" severity failure;

    sa := to_unbounded_string("0123456789");
    insert(sa, 4, "ABCD");
    assert sa.all = "012ABCD3456789" report "insert 4: unsepected result" severity failure;

    sa := to_unbounded_string("0123456789");
    insert(sa, 4, "ABCD");
    assert sa.all = "012ABCD3456789" report "insert 5: unsepected result" severity failure;


    -- overwrite
    sa := to_unbounded_string("0123456789");
    overwrite(sa, 2, "XYZ");
    assert sa.all = "0XYZ456789" report "overwrite 1: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    overwrite(sa, 4, "");
    assert sa.all = "0123456789" report "overwrite 2: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    overwrite(sa, 6, "ABCDEF");
    assert sa.all = "01234ABCDEF" report "overwrite 3: unexpected result" severity failure;


    -- replace_slice
    sa := to_unbounded_string("0123456789");
    replace_slice(sa, 2, 3, "AB");
    assert sa.all = "0AB3456789" report "replace_slice 1: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    replace_slice(sa, 2, 2, "A");
    assert sa.all = "0A23456789" report "replace_slice 2: unexpected result" severity failure;

    sa := to_unbounded_string("01234567");
    replace_slice(sa, 3, 0, "AB");
    assert sa.all = "01AB234567" report "replace_slice 3: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    replace_slice(sa, 4, 5, "AB");
    assert sa.all = "012AB56789" report "replace_slice 4: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    replace_slice(sa, 4, 5, "ABCD");
    assert sa.all = "012ABCD56789" report "replace_slice 5: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    replace_slice(sa, 4, 5, "ABCD");
    assert sa.all = "012ABCD56789" report "replace_slice 6: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    replace_slice(sa, 4, 5, "A");
    assert sa.all = "012A56789" report "replace_slice 7: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    replace_slice(sa, 4, 5, "A");
    assert sa.all = "012A56789" report "replace_slice 8: unexpected result" severity failure;


    -- tail
    sa := to_unbounded_string("0123456789ABCD");
    tail(sa, 10);
    assert sa.all = "456789ABCD" report "tail 1: unexpected result" severity failure;

    sa := to_unbounded_string("012345");
    tail(sa, 10);
    assert sa.all = "    012345" report "tail 2: unexpected result" severity failure;

    sa := to_unbounded_string("0123456789");
    tail(sa, 4);
    assert sa.all = "6789" report "tail 3: unexpected result" severity failure;


    -- translate
    sa := to_unbounded_string("ABCD012345");
    translate(sa, LOWER_CASE_MAP);
    assert sa.all = "abcd012345" report "translate 1: unexpected result" severity failure;

    sa := to_unbounded_string("ABCD01234X");
    translate(sa, LOWER_CASE_MAP);
    assert sa.all = "abcd01234x" report "translate 2: unexpected result" severity failure;


    -- trim
    sa := to_unbounded_string("  0123456789");
    trim(sa, side => left);
    assert sa.all = "0123456789" report "trim 1: unexpected result" severity failure;

    sa := to_unbounded_string(" 123456789  ");
    trim(sa, side => right);
    assert sa.all = " 123456789" report "trim 2: unexpected result" severity failure;

    sa := to_unbounded_string(" 0123456789 ");
    trim(sa, side => both);
    assert sa.all = "0123456789" report "trim 3: unexpected result" severity failure;

    sa := to_unbounded_string("   3456789");
    trim(sa, side => left);
    assert sa.all = "3456789" report "trim 4: unexpected result" severity failure;

    sa := to_unbounded_string("   3456789");
    trim(sa, side => right);
    assert sa.all = "   3456789" report "trim 5: unexpected result" severity failure;

    sa := to_unbounded_string("   3456789");
    trim(sa, side => left);
    assert sa.all = "3456789" report "trim 6: unexpected result" severity failure;
    

    sa := to_unbounded_string("A0123456789Z");
    trim(sa, to_set("AB"), to_set('Z'));
    assert sa.all = "0123456789" report "trim 7: unexpected result" severity failure;

    sa := to_unbounded_string("AB0123456789");
    trim(sa, to_set("AB"), to_set('Z'));
    assert sa.all = "0123456789" report "trim 8: unexpected result" severity failure;

    sa := to_unbounded_string("AB01234567");
    trim(sa, to_set("AB"), to_set("Z"));
    assert sa.all = "01234567" report "trim 9: unexpected result" severity failure;

    sa := to_unbounded_string("AB01234567");
    trim(sa, to_set("AB"), to_set(""));
    assert sa.all = "01234567" report "trim 10: unexpected result" severity failure;

    wait;
  end process;
end architecture;
