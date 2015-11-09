class
	GHOST

inherit
	MOBILE

create
	haunt

feature {NONE} -- Initialization

	haunt (s: STATION; r: REAL_64)
			-- Initialization for `Current'.
		do
			station := s
			radius := r
			speed := 15.0 + 15.0 * random.double_item -- 15.0 .. 30.0
			random.forth
			circumference := 2 * {MATH_CONST}.pi * radius
			angle := random.double_item * 2 * {MATH_CONST}.pi -- 0 .. 2 * pi
			random.forth
			update_position
		end

feature -- Access

	station: STATION
			-- Station to be haunted

	position: VECTOR
			-- Current position in the city.

	speed: REAL_64
			-- Constant motion speed of 10 meters/second.

	radius: REAL_64
			-- Radius, at which the ghost circles the station

	circumference: REAL_64
			-- Circumference of the circle around the station

	angle: REAL_64
			-- Angle between 0 and 2 * pi

feature {NONE} -- Movement

	move_distance (d: REAL_64)
			-- Move by `d' meters.
		local
			d_angle: REAL_64
		do
			d_angle := d / circumference
			angle := angle + d_angle
			if angle > (2 * {MATH_CONST}.pi) then -- Because modulo, i.e. \\, gives me compile errors ...
				angle := angle - 2 * {MATH_CONST}.pi
			end
			update_position
		end

	update_position
		local
			v: VECTOR
		do
			create v.make_polar (radius, angle)
			position := station.position.sum (v)
		end

feature {NONE} -- Random

	random: V_RANDOM
			-- Just a Random instance
			-- There are some occasions where Math.random() would be SO neat. :(
		once
			create Result.default_create
		end

invariant
	position_not_void: position /= Void
	station_not_void: station /= Void
	angle_in_bounds: 0 <= angle and angle <= 2 * {MATH_CONST}.pi
end
