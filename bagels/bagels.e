note
	description : "Bagels application"

class
	BAGELS

create
	execute, set_answer

feature -- Initialization
	execute
			-- Play bagels.
		local
			d: INTEGER
		do
			from
				print ("Number of digits (> 0): ")
				Io.read_integer
				d := Io.last_integer
			until
				-- Our contracts demand something that can be represented in -32- -> 64 bits
				-- Which is a stupid limitation since we never need to convert to a number
				-- But here we are, stuck with 18 digits
				d > 0 and d < 18
			loop
				print ("Needs to be a valid positive number%N")
				print ("Let's try this again...%N%N")

				print ("Number of digits (> 0): ")
				Io.read_integer
				d := Io.last_integer
			end

			print ("%N")
			play (d)
		end

feature -- Implementation

	play (d: INTEGER)
			-- Generate a number with `d' digits and let the player guess it.
		require
			d_positive: d > 0
		local
			guess_count: INTEGER
			guess: STRING
		do
			from
				guess_count := 1
				generate_answer (d)
				print ("Generated a new random number with " + d.out + " digits!%N")
				print ("Guess away and try to find the correct answer%N%N")
			until
				answer ~ guess
			loop
				print ("%NGuess No. " + guess_count.out + ": ")
				Io.read_line

				guess := Io.last_string
				if guess = Void or else not guess.is_natural_64 then
					print ("Hey! You need to enter a valid number!%N")
					print ("Let's try this again...%N")
				elseif guess.count /= answer.count then
					print ("Hey! We decided on a number of " + d.out + " digits!%N")
					print ("Let's try this again...%N")
				elseif guess.has ('0') then
					print ("Hey! We agreed that there would be no zeroes!%N")
					print ("Let's try this again...%N")
				else
					print (clue (guess))
					print ("%N")
					guess_count := guess_count + 1
				end
			end

			-- We overcounted when the guess is correct
			guess_count := guess_count - 1
			print ("%NYou found the correct number in " + guess_count.out + " guesses!%N")
			print ("Congratulations!%N")
		end

	answer: STRING
			-- Correct answer.		

	set_answer (s: STRING)
			-- Set `answer' to `s'.		
		require
			s_non_empty: s /= Void and then not s.is_empty
			is_natural: s.is_natural_64
			no_zeros: not s.has ('0')
		do
			answer := s
		ensure
			answer_set:answer = s
		end

	generate_answer (d: INTEGER)
			-- Generate a number with `d' non-zero digits and store it in `answer'.
		require
			d_positive: d > 0
		local
			random: V_RANDOM
			i: INTEGER
		do
			create answer.make_filled ('0', d) -- '0's so we'd break the contract were we to miss a digit
			create random.default_create

			from
				i := 1
			until
				i > d
			loop
				answer[i] := '0' + random.bounded_item (1, 9)
				random.forth -- Eiffel, please. :(
				i := i + 1
			variant
				d + 1 - i
			end
		ensure
			answer_exists: answer /= Void
			correct_length: answer.count = d
			is_natural: answer.is_natural_64
			no_zeros: not answer.has ('0')
		end

	clue (guess: STRING): STRING
			-- Clue for `guess' with respect to `answer'.
		require
			answer_exists: answer /= Void
			guess_exists: guess /= Void
			same_length: answer.count = guess.count
		local
			i: INTEGER
			guess_copy, answer_copy: STRING
		do
			create Result.make_empty
			answer_copy := answer.twin
			guess_copy := guess.twin

			-- Fermis
			from
				i := 1
			until
				i > guess.count
			loop
				if guess[i] = answer[i] then
					-- Exclude matches from being considered for "Pico"
					answer_copy.put ('-', i)
					guess_copy.put ('+', i)
					Result.append ("Fermi ")
				end
				i := i + 1
			variant
				guess.count + 1 - i
			end

			-- Picos
			across
				guess_copy.new_cursor as g
			loop
				if answer_copy.has (g.item) then
					answer_copy.prune (g.item)
					Result.append ("Pico ")
				end
			end

			-- Sonst Bagels
			if Result.count = 0 then
				Result := "Bagels"
			else
				Result.remove_tail (1)
			end
		end
end
