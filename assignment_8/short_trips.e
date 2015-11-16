note
	description: "Short trips."

class
	SHORT_TRIPS

inherit
	ZURICH_OBJECTS

feature -- Explore Zurich

	highlight_short_distance (s: STATION)
			-- Highlight stations reachable from `s' within 2 minutes.
		require
			station_exists: s /= Void
		do
			highlight_reachable (s, 120.0)
			Zurich_map.station_view (s).unhighlight
		end

feature {NONE} -- Implementation

	-- Problems this code has:
	-- Copy-paste programming for "north", "south"
	-- -> Tradeoff between code repetition and added complexity from adding a new method

	highlight_reachable (s: STATION; t: REAL_64)
			-- Highight stations reachable from `s' within `t' seconds.
		require
			station_exists: s /= Void
		local
			north, south: STATION
			station_view: STATION_VIEW
			t_dash: REAL_64
		do
			across
				s.lines as l
			loop
				north := l.item.next_station (s, l.item.north_terminal)
				south := l.item.next_station (s, l.item.south_terminal)

				if north /= Void then
					t_dash := t - l.item.time (s, north)
					station_view := Zurich_map.station_view (north)

					if t_dash >= 0 and not station_view.is_highlighted then
						station_view.highlight
						highlight_reachable (north, t_dash)
					end
				end

				if south /= Void then
					t_dash := t - l.item.time (s, south)
					station_view := Zurich_map.station_view (south)

					if t_dash >= 0 and not station_view.is_highlighted then
						station_view.highlight
						highlight_reachable (south, t_dash)
					end
				end
			end
		end
end
