class
	BUSINESS_CARD

create
	fill_in

feature {NONE} -- Initialization

	fill_in
			-- Fill in the card and print it.
		do
			-- Tell the user what to do
			Io.put_string ("Please enter the following data and confirm")
			Io.new_line
			Io.put_string ("by pressing the ENTER key.")
			Io.new_line

			-- Read in data from the console.
			Io.put_string ("Your name: ")
			Io.read_line
			set_name (Io.last_string)

			Io.put_string ("Your job:  ")
			Io.read_line
			set_job (Io.last_string)

			Io.put_string ("Your age:  ")
			Io.read_integer
			set_age (Io.last_integer)

			-- Print the business card
			Io.new_line
			Io.put_string (print_card)
		end

feature -- Access

	name: STRING
			-- Owner's name.

	job: STRING
			-- Owner's job.

	age: INTEGER
			-- Owner's age.

feature -- Setting

	set_name (a_name: STRING)
			-- Set `name' to `a_name'.
		require
			name_exists: a_name /= Void
		do
			name := a_name.twin
		end

	set_job (a_job: STRING)
			-- Set `job' to `a_job'.
		require
			job_exists: a_job /= Void
		do
			job := a_job.twin
		end

	set_age (a_age: INTEGER)
			-- Set `age' to `a_age'.
		require
			age_non_negative: a_age >= 0
		do
			age := a_age
		end

feature -- Output
	age_info: STRING
			-- Text representation of age on the card.
		do
			Result := age.out + " years old"
		end

	Left_column_width: INTEGER = 15
			-- Width of the left column ("name of the data")

	Total_width: INTEGER = 50
			-- Width of the card (in characters), excluding borders.

	line (n: INTEGER): STRING
			-- Horizontal line on length `n'.
		do
			Result := "-"
			Result.multiply (n - 2)
			Result.prepend ("+")
			Result.append ("+")
		end

	spaces (n: INTEGER): STRING
			-- `n' "Space" characters. Yaay copy pasta
		do
			Result := " "
			Result.multiply (n)
		end

	pad_string (s: STRING; n: INTEGER)
			-- Pads `s' with spaces so the length of the result is `n'
		require
			s_exists: s /= Void
			n_at_least_s_count: n >= s.count
		do
			if s.count < n then
				s.append (spaces (n - s.count))
			end
		ensure
			lenght_matching: s.count = n
		end

	content_line (c, v: STRING): STRING
			-- Formats a line in the style of "| `c': <pad> `v' <pad> |"
		require
			c_exists: c /= Void
			v_exists: v /= Void
		do
			-- Left column
			Result := "| "
			Result.append(c + ": ")
			pad_string (Result, Left_column_width)

			-- Right column
			Result.append (v)
			pad_string (Result, total_width - 2)
			Result.append (" |")
		ensure
			length_matching: Result.count = Total_width
		end

	print_card: STRING
			-- Prints the information on this card with some pretty borders
		local
			content_width: INTEGER
		do
			content_width := Total_width - 4
			Result := line (Total_width) + "%N"
					+ content_line ("Name", name) + "%N"
					+ content_line ("Job", job) + "%N"
					+ content_line ("Age", age_info) + "%N"
					+ line (total_width)
		end

end
