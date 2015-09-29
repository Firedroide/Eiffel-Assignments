class
	APPLICATION

create
	execute

feature {NONE} -- Initialization

	execute
			-- Run application.
		local
			me: PERSON
		do
			create me.make ("Roger Baumgartner", 19, "Deutsch", False)
			Io.put_string (me.out)
		end

end
