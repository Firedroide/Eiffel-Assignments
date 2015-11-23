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
		local
			fastest_times: V_HASH_TABLE [STATION, REAL_64]
					-- Shortest travel times to visited stations
					-- I decided to make this local so we don't add state to an otherwise stateless class
		do
			create fastest_times
			highlight_reachable (fastest_times, s, 120.0)
			Zurich_map.station_view (s).unhighlight
		end

feature {NONE} -- Implementation

	highlight_reachable (fastest_times: V_HASH_TABLE [STATION, REAL_64]; s: STATION; t: REAL_64)
			-- Highight stations reachable from `s' within `t' seconds.
		require
			station_exists: s /= Void
		local
			north, south: STATION
			station_view: STATION_VIEW
			t_dash: REAL_64
		do
			if t >= 0 and (fastest_times.has_key (s) implies t > fastest_times.item (s)) then
				fastest_times.force (t, s) -- force (value, key)? WTF Eiffel -.-
				Zurich_map.station_view (s).highlight

				across
					s.lines as l
				loop
					north := l.item.next_station (s, l.item.north_terminal)
					south := l.item.next_station (s, l.item.south_terminal)

					if north /= Void then
						t_dash := t - l.item.time (s, north)
						highlight_reachable (fastest_times, north, t_dash)
					end

					if south /= Void then
						t_dash := t - l.item.time (s, south)
						highlight_reachable (fastest_times, south, t_dash)
					end
				end
			end
		end
end
