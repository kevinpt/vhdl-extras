--# Copyright © 2014 Kevin Thibedeau

library extras;
use extras.text_buffering.all;
use extras.strings_unbounded.all;

use std.textio.all;

entity test_text_buffering is
end entity;

architecture test of test_text_buffering is
begin

  test: process
    variable tb, tb2 : text_buffer;
    file fh : text;
    constant fname : string := "test/test-output/test_text_buffering.txt";
    variable sa, sa2 : unbounded_string;
    variable at_end : boolean;
  begin

    sa := to_unbounded_string("Line 1");
    append(sa, tb);

    sa := to_unbounded_string("Line 2");
    append(sa, tb);

    --sa := to_unbounded_string("Line 3");
    --append(sa, tb);
    append("Line 3", tb);

    assert tb.lines = 3
      report "Line count mismatch" severity failure;

    file_open(fh, fname, write_mode);
    write(fh, tb);
    file_close(fh);

    load_buffer(fname, tb2);

    assert tb2.lines = tb.lines
      report "Line count mismatch in tb2" severity failure;

    for i in 1 to tb.lines loop
      nextline(tb, sa);
      nextline(tb2, sa2);

      assert sa.all = sa2.all
        report "Content mismatch" severity failure;
    end loop;

    endbuffer(tb, at_end);
    assert at_end report "Not at end of tb" severity failure;

    endbuffer(tb2, at_end);
    assert at_end report "Not at end of tb2" severity failure;

    free(tb);

    -- Append more lines
    append_file(fname, tb2);

    assert tb2.lines = tb.lines * 2
      report "Linecount mismatch in extended tb2" severity failure;

    nextline(tb2, sa);

    assert sa.all = "Line 1"
      report "Bad append" severity failure;

    setline(tb2, 3);
    nextline(tb2, sa);

    assert sa.all = "Line 3"
      report "Bad setline" severity failure;

    free(tb2);

    wait;
  end process;

end architecture;
