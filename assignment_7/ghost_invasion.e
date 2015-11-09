note
	description: "Adding ghosts to Zurich."

class
	GHOST_INVASION

inherit
	ZURICH_OBJECTS

feature -- Explore Zurich

	invade
			-- Add ghosts to random stations.
		local
			rnd: V_RANDOM
			station_cursor: like Zurich.stations.new_cursor

			i: INTEGER
			a_station: STATION
			a_radius: REAL_64
		do
			create rnd.default_create
			station_cursor := Zurich.stations.new_cursor

			from
				i := 1
			until
				i > 10
			loop
				station_cursor.go_to (1 + rnd.bounded_item (1, Zurich.stations.count))
				rnd.forth
				a_station := station_cursor.item
				a_radius := 10.0 + 90.0 * rnd.double_item -- 10 .. 100
				rnd.forth

				add_ghost (a_station, a_radius)

				i := i + 1
			variant
				11 - i
			end

			Zurich_map.animate
		end

	add_ghost (a_station: STATION; a_radius: REAL_64)
			-- Add a ghost going around `a_station'.
		require
			a_station_exists: a_station /= Void
			a_radius_positive: a_radius > 0.0
		local
			ghost: GHOST -- what else did you expect?
		do
			create ghost.haunt (a_station, a_radius)
			Zurich.add_custom_mobile (ghost)
			Zurich_map.update
			Zurich_map.custom_mobile_view (ghost).set_icon ("../image/ghost.png")
		end

end
