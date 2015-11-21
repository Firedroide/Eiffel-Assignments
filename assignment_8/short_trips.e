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

	highlight_reachable (s: STATION; t: REAL_64)
			-- Highight stations reachable from `s' within `t' seconds.
		require
			station_exists: s /= Void
		local
			north, south: STATION
			station_view: STATION_VIEW
			t_dash: REAL_64
		do
			if t >= 0 then
				Zurich_map.station_view (s).highlight

				across
					s.lines as l
				loop
					north := l.item.next_station (s, l.item.north_terminal)
					south := l.item.next_station (s, l.item.south_terminal)

					if north /= Void then
						t_dash := t - l.item.time (s, north)
						highlight_reachable (north, t_dash)
					end

					if south /= Void then
						t_dash := t - l.item.time (s, south)
						highlight_reachable (south, t_dash)
					end
				end
			end
		end
end
