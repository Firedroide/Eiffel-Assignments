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
			Name := a_name
			Age := a_age
			Mother_tongue := a_mother_tongue
			Has_cat := a_has_cat
		end

feature
	-- Properties

	Name: STRING_8
			-- First and last name

	Age: NATURAL_8
			-- This person's age

	Mother_tongue: STRING_8
			-- The name of the mother tongue

	Has_cat: BOOLEAN
			-- Whether this person has a cat

feature
	-- Out

	out: STRING_8
		do
			Result := "Name:           " + Name + "%N"
			        + "Age:            " + Age.out + "%N"
			        + "Mother tongue:  " + Mother_tongue + "%N"
			        + "Has a cat:      " + Has_cat.out + "%N"
		end

invariant
	valid_name: Name /= Void and then not Name.is_empty
	valid_mother_tongue: Mother_tongue /= Void and then not Mother_tongue.is_empty
end
