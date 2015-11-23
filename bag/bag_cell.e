class
	BAG_CELL [G]

create
	make

feature -- Initialization

	make (v: G)
			-- Create a cell with a single copy of `v'.
		do
			value := v
			count := 1
		ensure
			value_set: value = v
			single_copy: count = 1
		end

feature -- Access

	value: G
			-- Value.

	count: INTEGER
			-- Number of copies.

	next: BAG_CELL [G]
			-- Next cell.

feature -- Setting

	set_count (new_count: INTEGER)
			-- Set `count' to `new_count'.
		require
			new_count_positive: new_count > 0
		do
			count := new_count
		ensure
			count_set: count = new_count
		end

	set_next (c: BAG_CELL [G])
			-- Set `next' to `c'.
		do
			next := c
		ensure
			next_set: next = c
		end

invariant
	positive_count: count > 0

end
