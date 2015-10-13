note
	description : "ZVV information system."

class
	APPLICATION

create
	execute

feature {NONE} -- Initialization

	execute
			-- Run application.
		do
			read_data
			if not read_error then
				Io.new_line
				print ("Eligible for discount: ")
				print (gets_discount)
			end
		end

feature -- Access

	birth_date: DATE
			-- Birth date.

	home: STRING
			-- Home postal code.

	work: STRING
			-- Work postal code.

	age: INTEGER
			-- Age (difference in years between today's date and `birth_date').
		require
			birth_date_exists: birth_date /= Void
		local
			now: DATE
			duration: DATE_DURATION
		do
			create now.make_now
			duration := birth_date.relative_duration (now)
			Result := duration.year
		end

feature -- Status report

	is_valid_postal_code (pc: STRING): BOOLEAN
			-- Is `pc' a valid postal code in Switzerland?
		do
			Result := pc /= Void and then (pc.count = 4 and pc.is_natural)
		end

	is_in_zurich_canton (pc: STRING): BOOLEAN
			-- Is postal code `pc' inside the canton of Zurich?
		require
			valid_code: is_valid_postal_code (pc)
		do
			Result := pc [1] = '8'
		end

	is_in_zurich_city (pc: STRING): BOOLEAN
			-- Is postal code `pc' inside the city of Zurich?
		require
			valid_code: is_valid_postal_code (pc)
		do
			Result := pc [1] = '8' and pc [2] = '0'
		end

	gets_discount: BOOLEAN
			-- Is a customer with the current `birth_date', `home' and `work' eligible for a discounted seasonal ticket?
		require
			birth_date_exists: birth_date /= Void
			valid_home_code: is_valid_postal_code (home)
			valid_work_code: is_valid_postal_code (work)
		local
			younger_than_25, home_in_Zurich_work_outside, work_in_city_home_in_canton: BOOLEAN
		do
			younger_than_25 := age < 25
			home_in_zurich_work_outside := is_in_zurich_city (home) and not is_in_zurich_city (work)
			work_in_city_home_in_canton := is_in_zurich_city (work) and is_in_zurich_canton (home) and not is_in_zurich_city (home)
			Result := younger_than_25 or home_in_Zurich_work_outside or work_in_city_home_in_canton
		end

feature {NONE} -- Implementation

	read_error: BOOLEAN
			-- Did an error occur while reading user data?

	read_data
			-- Read user input.
		local
			date_format: STRING
		do
			date_format := "[0]dd/[0]mm/yyyy"
			print ("Enter birth date as dd/mm/yyyy: ")
			Io.read_line
			if not (create {DATE_VALIDITY_CHECKER}).date_valid (Io.last_string, date_format) then
				print ("Invalid date")
				read_error := True
			else
				create birth_date.make_from_string (Io.last_string, date_format)
			end

			if not read_error then
				print ("Enter home postal code: ")
				Io.read_line
				home := Io.last_string.twin
				if not is_valid_postal_code (home)  then
					print ("Invalid postal code")
					read_error := True
				end
			end

			if not read_error then
				print ("Enter work postal code: ")
				Io.read_line
				work := Io.last_string.twin
				if not is_valid_postal_code (work)  then
					print ("Invalid postal code")
					read_error := True
				end
			end
		end
end
