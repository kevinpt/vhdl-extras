--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

library extras;
use extras.binaryio.all;

entity test_binaryio is
    generic (
        TEST_OUT_DIR : string
    );
end entity;

architecture tb of test_binaryio is
begin
	
	io: process
		file fh : octet_file;
		variable fstatus : file_open_status;
		
		variable byte, r_byte : unsigned(7 downto 0);
		variable word, beword, r_word, r_beword : unsigned(15 downto 0);
		variable sbyte, r_sbyte : signed(7 downto 0);

        function hex(n : unsigned) return string is
            -- Convert vector to hex string
            variable n4 : unsigned(0 to ((n'length + 3) / 4) * 4 - 1);
            variable s : string(1 to (n'length + 3) / 4);
            variable i : natural;
        begin
            n4 := resize(n, n4'length);
            for c in s'range loop
                i := to_integer(n4((c-1)*4 to (c-1)*4+3));
                if i < 10 then
                    s(c) := character'val(i + character'pos('0'));
                else
                    s(c) := character'val(i - 10 + character'pos('A'));
                end if;
            end loop;
            return s;
        end function;
	begin
        word   := X"DEAD";
        beword := X"BEEF";
        byte   := X"05";
        sbyte  := X"85";

		file_open(fstatus, fh, TEST_OUT_DIR & "/binary_output.dat", write_mode);
		write(fh, little_endian, word);
		write(fh, big_endian, beword);
		write(fh, little_endian, byte);
		write(fh, little_endian, sbyte);
        file_close(fh);
	
		file_open(fstatus, fh, TEST_OUT_DIR & "/binary_output.dat", read_mode);
		read(fh, little_endian, r_word);
        read(fh, big_endian, r_beword);
		read(fh, little_endian, r_byte);
		read(fh, little_endian, r_sbyte);
		file_close(fh);
		--file_open(fstatus, fh, test_out & "binary_file.dat", read_mode);
		--read(fh, big_endian, beword);
		
		--report "word: " & integer'image(to_integer(word));
		--report "beword: " & integer'image(to_integer(beword));
		--report "byte: " & integer'image(to_integer(byte));
		--report "sbyte: " & integer'image(to_integer(sbyte));
        assert word = r_word report "word mismatch: " & hex(word) & ", " & hex(r_word) severity failure;
        assert beword = r_beword report "beword mismatch" severity failure;
        assert byte = r_byte report "byte mismatch" severity failure;
        assert sbyte = r_sbyte report "sbyte mismatch" severity failure;
		
		
--		file_close(fh);

		--file_open(fstatus, fh, test_out & "binary_output.dat", write_mode);
		
--		write(fh, little_endian, word);
--		write(fh, big_endian, beword);
--		write(fh, little_endian, byte);
--		write(fh, little_endian, -sbyte);
		
		wait;
	end process;
end architecture;
