class
	TESTER

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			puzzle: PUZZLE
			i: INTEGER
		do
			create puzzle
			from
				i := solution_counts.lower
			until
				i > solution_counts.upper
			loop
				print (i.out + ": ")
				puzzle.solve (i)
				if puzzle.solutions.count = solution_counts [i] then
					print ("correct%N")
				else
					print ("expected " + solution_counts [i].out + " and got " + puzzle.solutions.count.out + "%N")
				end
				io.new_line
				i := i + 1
			end
		end

	solution_counts: ARRAY [INTEGER]
			-- Number of solutions depending on the board size.
		once
			Result := <<1, 0, 0, 2, 10, 4, 40, 92, 352, 724>>
		end

end
