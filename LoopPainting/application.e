class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			user_input: STRING
			dimension: NATURAL
		do
			-- Read user input
			print ("Enter the dimension: ")
			Io.read_line
			user_input := Io.last_string
			print ("%N%N")

			-- Make sure input is valid
			-- Eiffel, Y U DO THIS? Why don't you just let me "return"?
			-- Instead you make me create this ugly branching :(
			if user_input = Void or else not user_input.is_natural then
				print ("Input must be a positive natural number.")
			else
				dimension := user_input.to_natural

				if dimension < 2 or dimension > 32 then
					print ("Only dimensions between 2 and 32 are allowed.")
				else
					-- Run actual code
					print_triangle (dimension)
					print_diamond (dimension)
				end
			end
		end

	print_triangle (dimension: NATURAL)
			-- Prints a checker diamond with hypotenuse length of `dimension'
		local
			i: NATURAL
		do
			print ("Checker triangle:%N%N")

			from
				i := 1
			until
				i > dimension
			loop
				print (triangle_line (i))
				print ("%N")
				i := i + 1
			variant
				(dimension + 1 - i).as_integer_32
			end

			print ("%N%N")
		end

	print_diamond (dimension: NATURAL)
			-- Prints a checker diamond with side length of `dimension'
		local
			i: NATURAL
		do
			print ("Checker diamond:%N%N")

			-- Forth
			from
				i := 1
			until
				i > dimension
			loop
				print (diamond_line (i, dimension))
				print ("%N")
				i := i + 1
			variant
				(dimension + 1 - i).as_integer_32
			end

			-- And back
			from
				i := dimension - 1
			until
				i = 0
			loop
				print (diamond_line (i, dimension))
				print ("%N")
				i := i - 1
			variant
				i.as_integer_32
			end

			print ("%N%N")
		end

	diamond_line (i, dimension: NATURAL): STRING
			-- Creates the `i'-th line of a `dimension' side length diamond pattern
			-- by composing `triangle_line's and padding the result
		require
			i <= dimension
		local
			padding, left, right: STRING
		do
			-- Padding to create centered line, padding only where necessary
			if i = dimension then
				padding := ""
			else
				padding := " "
				padding.multiply ((dimension - i).as_integer_32)
			end

			-- Left is mirror of right side minus the middle column
			left := triangle_line (i)
			left.remove_head (1)
			left.mirror

			-- Right side as in checker triangle
			right := triangle_line (i)

			Result := padding + left + right
		end

	triangle_line (dimension: NATURAL): STRING
			-- Creates the last line of a `dimension' hypotenuse length triangle pattern,
			-- which happens to be the `dimension'-th line of any triangle pattern
			-- (with a hypotenuse length greather than `dimension')
		local
			stars, i: NATURAL
			has_leading_space: BOOLEAN
		do
			stars := (dimension + 1) // 2
			has_leading_space := ((dimension \\ 2) = 0)

			create Result.make_empty
			from
				i := 0
			invariant
				Result.count = 2 * i.as_integer_32
			until
				i >= stars
			loop
				Result.append (" *")
				i := i + 1
			variant
				-- Just trying out variants
				-- But Eiffel, why does this need to be an INTEGER
				-- if it only accepts positive variants??
				(stars + 1 - i).as_integer_32
			end

			if not has_leading_space then
				Result.remove_head (1)
			end
		end

end
