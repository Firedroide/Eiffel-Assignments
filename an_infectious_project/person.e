class
	PERSON

create
	make

feature -- Initialization

	make (a_name: STRING)
			-- Create a person named a name.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
			create {LINKED_LIST[PERSON]} coworkers.make
		ensure
			name_set: name = a_name
			coworkers_exists: coworkers /= Void
		end

feature -- Access

	name: STRING

	coworkers: LIST[PERSON]

	has_flu: BOOLEAN

feature -- Element change

	set_coworker (p: PERSON)
			-- Set coworker to p.
		require
			p_exists: p /= Void
			p_different: p /= Current
		do
			coworkers.extend (p)
		ensure
			coworker_set: coworkers.has (p)
		end

	set_flu
			-- Set has flu to True.
		do
			has_flu := True
		ensure
			has_flu: has_flu
		end

invariant
	name_valid: name /= Void and then not name.is_empty

end
