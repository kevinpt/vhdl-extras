--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.muxing.all;

entity test_muxing is
  generic (
    SEL_WIDTH : natural := 4
  );
end entity;

architecture test of test_muxing is
begin

  test: process
    variable sel : unsigned(SEL_WIDTH-1 downto 0);
    variable full, fmatch : std_ulogic_vector(0 to 2**SEL_WIDTH-1);
    variable partial, pmatch : std_ulogic_vector(0 to full'high - 2);

    variable mux_in : std_ulogic_vector(0 to 2**SEL_WIDTH-1);
    variable expect : std_ulogic;
  begin

    -- Test decode functions
    for i in 0 to 2**SEL_WIDTH-1 loop
      sel := to_unsigned(i, sel'length);

      full := decode(sel);
      fmatch := (others => '0');
      fmatch(i) := '1';

      assert full = fmatch
        report "Mismatch in decode[unsigned]: " & integer'image(i)
        severity failure;

      partial := decode(sel, partial'length);
      pmatch := (others => '0');
      if i <= partial'high then
        pmatch(i) := '1';
      end if;

      assert partial = pmatch
        report "Mismatch in decode[unsigned, positive]: " & integer'image(i)
        severity failure;

    end loop;


    -- Test mux functions
    for i in 0 to 2**SEL_WIDTH-1 loop
      sel := to_unsigned(i, sel'length);

      for j in mux_in'range loop
        mux_in := (others => '0');
        mux_in(j) := '1';

        if j = i then
          expect := '1';
        else
          expect := '0';
        end if;

        assert mux(mux_in, sel) = expect
          report "Mismatch in mux[sulv, unsigned]: sel = " & integer'image(i) & "  j = " & integer'image(j)
          severity failure;

        assert mux(mux_in, decode(sel)) = expect
          report "Mismatch in mux[sulv, sulv]: sel = " & integer'image(i) & "  j = " & integer'image(j)
          severity failure;
        
      end loop;
    end loop;


    -- Test demux
    for i in 0 to 2**SEL_WIDTH-1 loop
      sel := to_unsigned(i, sel'length);
      fmatch := (others => '0');
      fmatch(i) := '1';

      assert demux('1', sel, 2**SEL_WIDTH) = fmatch
        report "Mismatch in demux: sel = " & integer'image(i)
        severity failure;
    end loop;

    wait;
  end process;

end architecture;
