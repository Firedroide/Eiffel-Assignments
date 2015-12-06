note
	description: "Controller that tries to bring room temperature to a preset value."

class
	HEATING_CONTROLLER

create
	set_goal

feature -- Access

	goal: REAL_64
			-- Goal temperature.

	tolerance: REAL_64 = 1.0
			-- How much current temperature can differ from `goal'?

feature -- Setting

	set_goal (a_goal: REAL_64)
			-- Set `goal' to `g'.
		do
			goal := a_goal
		ensure
			goal_set: goal = a_goal
		end

feature -- State

	heating_on: BOOLEAN
			-- Is the heating on?

	cooling_on: BOOLEAN
			-- Is cooling on?

feature -- Basic operations

	adjust (a_temperature: REAL_64)
			-- Turn heating and cooling on or off depending on `a_temperature'.
		do
			io.new_line
			if a_temperature - goal > tolerance then
				cooling_on := True
				print ("COOLING")
			else
				cooling_on := False
			end
			if goal - a_temperature > tolerance then
				heating_on := True
				print ("HEATING")
			else
				heating_on := False
			end
			io.new_line
		end

invariant
	not_both: not (heating_on and cooling_on)
	positive_tolerance: tolerance > 0.0
end
