note
	description: "Route information displays."

class
	DISPLAY

inherit
	ZURICH_OBJECTS

feature -- Explore Zurich

	add_public_transport
			-- Add a public transportation unit per line.
		do
			across
				Zurich.lines as i
			loop
				i.item.add_transport
			end
		end

	update_transport_display (t: PUBLIC_TRANSPORT)
			-- Update route information display inside transportation unit `t'.
		require
			t_exists: t /= Void
		local
			station: STATION
			station_counter: INTEGER
		do
			-- First, clear the console
			console.clear

			-- Then, print the line number and the times until the next stations
			console.append_line ("[" + t.line.number.out + "]  Willkommen / Welcome")

			from
				station_counter := 0
				station := t.arriving
			until
				station = t.destination or (station_counter = 3 and not (t.line.next_station (station, t.destination) = t.destination))
				-- The "and not" part lets us print 5 stations on 5 lines instead of having 3 + "..." + 1
			loop
				console.append_line (stop_info (t, station))

				station := t.line.next_station (station, t.destination)
				station_counter := station_counter + 1
			end

			if station /= t.destination then
				console.append_line (" ...")
			end
			console.append_line (stop_info (t, t.destination))
		end

	Maximum_station_name_length: INTEGER_32 = 30
	stop_info (t: PUBLIC_TRANSPORT; s: STATION): STRING
			-- Formats the info for a station on a line so it can be shown in the console
		require
			t_exists: t /= Void
			s_exists: s /= Void
		local
			valid_connections: LINKED_LIST [INTEGER_32]
			padding: STRING
		do
			Result := seconds_to_string (t.time_to_station (s))
			Result.append ("%T")
			Result.append (s.name)

			create valid_connections.make

			-- Gather all actual connections at that station
			across
				s.lines as l
			loop
				if is_connection (s, t.line, l.item) then
					valid_connections.extend (l.item.number)
				end
			end

			-- Output connections only if is at least one
			if valid_connections.count > 0 then
				padding := " "
				padding.multiply (Maximum_station_name_length - s.name.count)
				Result.append (padding + " [")

				across
					valid_connections as i
				loop
					Result.append (i.item.out + ",")
				end

				Result.remove_tail (1)
				Result.append ("]")
			end
		end

	is_connection (s: STATION; l1, l2: LINE): BOOLEAN
		require
			s_exists: s /= Void
			both_lines_exists: l1 /= Void and l2 /= Void
			s_on_both_lines: l1.has_station (s) and l2.has_station (s)
		local
			l2_prev, l2_next: STATION
			prev_matching, next_matching: BOOLEAN
		do
			l2_prev := l2.next_station (s, l2.north_terminal)
			l2_next := l2.next_station (s, l2.south_terminal)

			prev_matching := l2_prev = Void or else l1.has_station (l2_prev)
			next_matching := l2_next = Void or else l1.has_station (l2_next)

			Result := not (prev_matching and next_matching)
		end

	seconds_to_string (m: INTEGER): STRING
			-- Converts an integer denoting a timespan in seconds to a string
		require
			m_not_negative: m >= 0
		do
			if m < 60 then
				Result := "<1 Min."
			elseif m < 120 then
				Result := " 1 Min."
			else
				Result := (m // 60).out
				if Result.count = 1 then
					Result.prepend (" ")
				end
				Result.append (" Min.")
			end
		end

end
