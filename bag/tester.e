class
	TESTER

create
	make

feature {NONE} -- Initialization

	make
			-- Test LINKED_BAG.
		local
			b1, b2: LINKED_BAG [INTEGER]
		do
			create b1
			b1.add (1, 1)
			b1.add (2, 1)
			b1.add (2, 1)
			b1.add (3, 3)
			check b1.occurrences (1) = 1 end
			check b1.occurrences (2) = 2 end
			check b1.occurrences (3) = 3 end

			create b2
			b2.add (2, 1)
			b2.add (3, 3)

			b1.subtract (b2)
			check b1.occurrences (1) = 1 end
			check b1.occurrences (2) = 1 end
			check b1.occurrences (3) = 0 end
		end

end
