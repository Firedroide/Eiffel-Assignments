class
	APPLICATION

create
	make

feature -- Initialization

	make
			-- Simulate flu epidemic.
		local
			joe, mary, tim, sarah, bill, cara, adam: PERSON
		do
			create joe.make ("Joe")
			create mary.make ("Mary")
			create tim.make ("Tim")
			create sarah.make ("Sarah")
			create bill.make ("Bill")
			create cara.make ("Cara")
			create adam.make ("Adam")

			joe.set_coworker (sarah)
			adam.set_coworker (joe)
			tim.set_coworker (sarah)
			sarah.set_coworker (cara)
			bill.set_coworker (tim)
			bill.set_coworker (adam)
			cara.set_coworker (mary)
			mary.set_coworker (bill)

			infect (bill)
		end

	infect (p: PERSON)
			-- Infect `p' and coworkers
	require
		p_exists: p /= Void
	do
		p.set_flu
		print ("Infected " + p.name + "%N")

		across
			p.coworkers as c
		loop
			if not c.item.has_flu then
				infect(c.item)
			end
		end
	end
end
