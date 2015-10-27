note
	description: "Testing the bagles application."

class
	TESTER

create
	test

feature -- Testing

	test
			-- Test Bagels application.
		local
			game: BAGELS
			i, passed: INTEGER
			clue: STRING
		do
			from
				i := 1
			until
				i > Test_count
			loop
				create game.set_answer (data [i].answer)
				clue := game.clue (data [i].guess)
				if clue /= Void then
					clue.left_adjust
					clue.right_adjust
				else
					clue := "Void"
				end
				if clue ~ data [i].clue then
					passed := passed + 1
				else
					print ("Test " + i.out + " failed: for answer " + data [i].answer + " and guess " + data [i].guess +
					"%Nexpected: %"" + data[i].clue + "%" got: %"" + clue + "%"%N")
				end
				i := i + 1
			end
			print ("%N ")
			from
				i := 1
			until
				i > Test_count
			loop
				if i <= passed then
					print ('%/178/')
				else
					print ('%/176/')
				end
				i := i + 1
			end
			print ("%N%N")
			print ("Passed " + passed.out + " tests out of " + Test_count.out)
		end


feature -- Implementation

	Test_count: INTEGER = 10
			-- Total number of tests.

	data: V_ARRAY [TUPLE [answer: STRING; guess: STRING; clue: STRING]]
			-- Test data.
		once
			create Result.make (1, Test_count)
			Result [1] := ["123", "123", "Fermi Fermi Fermi"]
			Result [2] := ["123", "312", "Pico Pico Pico"]
			Result [3] := ["123", "456", "Bagels"]
			Result [4] := ["123", "329", "Fermi Pico"]
			Result [5] := ["999", "912", "Fermi"]
			Result [6] := ["912", "999", "Fermi"]
			Result [7] := ["322", "244", "Pico"]
			Result [8] := ["262", "661", "Fermi"]
			Result [9] := ["2626", "6611", "Fermi Pico"]
			Result [10] := ["112211", "191191", "Fermi Fermi Pico Pico"]
		end
end
