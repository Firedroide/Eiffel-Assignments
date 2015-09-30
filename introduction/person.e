note
	description: "Represents a person."
	date: "$Date$"
	revision: "$Revision$"

class
	PERSON

inherit

	ANY
		redefine
			out
		end

create
	make

feature
	-- Creation

	make (a_name: STRING_8; a_age: NATURAL_8; a_mother_tongue: STRING_8; a_has_cat: BOOLEAN)
		do
			name := a_name
			age := a_age
			mother_tongue := a_mother_tongue
			has_cat := a_has_cat
		end

feature
	-- Properties

	name: STRING_8
			-- First and last name

	age: NATURAL_8
			-- This person's age

	mother_tongue: STRING_8
			-- The name of the mother tongue

	has_cat: BOOLEAN
			-- Whether this person has a cat

feature
	-- Out

	out: STRING_8
		do
			Result := "Name:           " + name + "%N"
			        + "Age:            " + age.out + "%N"
			        + "Mother tongue:  " + mother_tongue + "%N"
			        + "Has a cat:      " + has_cat.out + "%N"
		end

invariant
	valid_name: name /= Void and then not name.is_empty
	valid_mother_tongue: mother_tongue /= Void and then not mother_tongue.is_empty
end
