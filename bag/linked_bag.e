class
	LINKED_BAG [G]

feature -- Access

	occurrences (v: G): INTEGER
			-- Number of occurrences of `v'.
		local
			c: BAG_CELL [G]
		do
			from
				c := first
			until
				c = Void or else c.value = v
			loop
				c := c.next
			end
			if c /= Void then
				Result := c.count
			end
		ensure
			non_negative_result: Result >= 0
		end

feature -- Element change

	add (v: G; n: INTEGER)
			-- Add `n' copies of `v'.
		require
			n_positive: n > 0
		local
			c: BAG_CELL [G]
		do
			from
				c := first
			until
				c = Void or else c.value = v
			loop
				c := c.next
			end

			if c = Void then
				create c.make (v)
				c.set_count (n)
				c.set_next (first)
				first := c
			else
				c.set_count (c.count + n)
			end
		ensure
			n_more: occurrences (v) = old occurrences (v) + n
		end

	remove (v: G; n: INTEGER)
			-- Remove as many copies of `v' as possible, up to `n'.
		require
			n_positive: n > 0
		local
			p, c: BAG_CELL [G]
		do
			from
				p := Void
				c := first
			until
				c = Void or else c.value = v
			loop
				p := c
				c := c.next
			end

			if c /= Void then
				if n < c.count then
					c.set_count (c.count - n)
				elseif p /= Void then -- not first element
					p.set_next (c.next)
				else
					first := c.next
				end
			end -- do nothing if `v' not in Bag
		ensure
			n_less: occurrences (v) = (old occurrences (v) - n).max (0)
		end

	subtract (other: LINKED_BAG [G])
			-- Remove all elements of `other'.
		require
			other_exists: other /= Void
		local
			c: BAG_CELL [G]
		do
			-- This could probably be done more efficiently.
			from
				c := other.first
			until
				c = Void
			loop
				remove (c.value, c.count)
				c := c.next
			end
		end

feature {LINKED_BAG} -- Implementation

	first: BAG_CELL [G]
			-- First cell.	

end
