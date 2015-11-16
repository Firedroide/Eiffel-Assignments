note
	description: "Possibly partial solution to the n-queens problem."

class
	SOLUTION

create
	make_empty

create {SOLUTION}
	make_from_array

feature {NONE} -- Initialization

	make_empty
			-- Create an empty partial solution
			-- (no rows filled)
		do
			create positions.make_empty
		end

	make_from_array (pos: ARRAY [INTEGER])
			-- Create a solution using `pos' as the list of positions.
		do
			positions := pos
		end

feature -- Access

	row_count: INTEGER
			-- Number of rows filled.
		do
			Result := positions.count
		end

	column_at (r: INTEGER): INTEGER
			-- Column in which a queen is placed in row `r'.
		require
			valid_row: 1 <= r and r <= row_count
		do
			Result := positions [r]
		end

feature -- Extension

	extended_with (c: INTEGER): SOLUTION
            -- Returns a new solution that is the Current solution with
            -- one more row, in which the queen is in column `c'.
            -- Current is left unchanged.
		require
			column_positive: c > 0
		local
			pos: ARRAY [INTEGER]
		do
			create pos.make (1, positions.count + 1)
			pos.subcopy (positions, 1, positions.count, 1)
			pos [pos.count] := c
			create Result.make_from_array (pos)
		end

feature {NONE} -- Implementation

	positions: ARRAY [INTEGER]
			-- List of queen positions.
end
