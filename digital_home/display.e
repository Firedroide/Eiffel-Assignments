note
	description: "Digital display for temperatures."

class
	DISPLAY

feature -- Basic operations

	show (a_temperature: REAL_64)
			-- Display `a_temperature'.
		local
			str: STRING
			row, i: INTEGER
			format: FORMAT_DOUBLE
		do
			create format.make (Integer_digits + Fractional_digits + 2, 1)
			format.right_justify
			str := format.formatted (trimmed (a_temperature))

			from
				row := 1
			until
				row > Height
			loop
				from
					i := 1
				until
					i > str.count
				loop
					if str [i] = '.' then
						if row = Height then
							print (".")
						else
							print (" ")
						end
					elseif str [i] = '-' then
						if row = 2 then
							print (" _ ")
						else
							print ("   ")
						end
					elseif str [i] = ' ' then
						print ("   ")
					else
						check str [i].is_digit end
						print (digit_row (digit (str [i]), row))
					end
					i := i + 1
				end

				if row = 1 then
					print (" o  _")
				elseif row = Height then
					print ("   |_")
				else
					print ("   |")
				end

				row := row + 1
				io.new_line
			end
		end

feature {NONE} -- Implementation

	Integer_digits: INTEGER = 3
			-- Number of digits before decimal point.

	Fractional_digits: INTEGER = 1
			-- Number of digits after decimal point.

	trimmed (a_temperature: REAL_64): REAL_64
			-- `a_temperature' trimmed to the range that can be shown by the display.
		local
			max_val: REAL_64
		do
			max_val := (10 ^ Integer_digits - 10 ^ (-Fractional_digits)).truncated_to_real
			Result := a_temperature.min (max_val).max (-max_val)
		end

	Height: INTEGER = 3
			-- Height of each digit on the display.

	Width: INTEGER = 3
			-- Width of each digit on the display.

	digit (c: CHARACTER): INTEGER
			-- Digit represented by `c'.
		require
			is_digit: c.is_digit
		do
			Result := c.difference ('0')
		ensure
			is_digit: digits.has_index (Result)
		end

	digits: V_ARRAY [STRING]
			-- Representation of digits on the display.
		once
			create Result.make (0, 9)
			Result [0] := " _ | ||_|"
			Result [1] := "     |  |"
			Result [2] := " _  _||_ "
			Result [3] := " _  _| _|"
			Result [4] := "   |_|  |"
			Result [5] := " _ |_  _|"
			Result [6] := " _ |_ |_|"
			Result [7] := " _   |  |"
			Result [8] := " _ |_||_|"
			Result [9] := " _ |_| _|"
		ensure
			result_exists: Result /= Void
			correct_bounds: Result.lower = 0 and Result.upper = 9
			correct_length: Result.for_all (agent (s: STRING): BOOLEAN do Result := s.count = Height * Width end)
		end

	digit_row (d, i: INTEGER): STRING
			-- Representation of `i'th row of digit `d'.
		require
			valid_digit: digits.has_index (d)
			valid_row: 1 <= i and i <= Height
		do
			Result := digits [d].substring ((i - 1) * Width + 1, i * Width)
		ensure
			result_exists: Result /= Void
			valid_width: Result.count = Width
		end
end
