note
	description: "Finding routes in Zurich."

class
	NAVIGATOR

inherit
	ZURICH_OBJECTS
		redefine
			default_create
		end

feature -- Explore Zurich

	add_event_handlers
			-- Add handlers to mouse-click events on stations
			-- to allow the user to select start and end points of his route.
		local
			s: STATION
			v: STATION_VIEW
		do
			across
				Zurich.stations as i
			loop
				s := i.item
				v := Zurich_map.station_view (s)
				v.on_left_click_no_args.extend_back (agent set_origin (s, v))
				v.on_left_click_no_args.extend_back (agent show_route)
				v.on_right_click_no_args.extend_back (agent set_destination (s, v))
				v.on_right_click_no_args.extend_back (agent show_route)
			end
		end

feature -- Access

	origin: STATION
			-- Currently selected start point.
			-- (Void if no start point selected).

	destination: STATION
			-- Currently selected end point.
			-- (Void if no end point selected).

feature {NONE} -- Implementation

	route_finder: ROUTE_FINDER
	origin_view: STATION_VIEW
	last_route: ROUTE
	destination_view: STATION_VIEW

	default_create
		do
			Precursor
			create route_finder.make (Zurich)
		end

	set_origin (s: STATION; v: STATION_VIEW)
			-- Sets `origin' to `s' and highlights `v'
		do
			if origin_view /= Void then
				origin_view.unhighlight
			end

			origin := s
			if destination = Void then
				v.highlight
				origin_view := v
			end
		end

	set_destination (s: STATION; v: STATION_VIEW)
			-- Sets `destination' to `s' and highlights `v'
		do
			if destination_view /= Void then
				destination_view.unhighlight
			end

			destination := s
			if origin = Void then
				v.highlight
				destination_view := v
			end
		end

	show_route
			-- If both `origin' and `destination' are set, show the route from `origin' to `destination' on the map
			-- and output directions to the console.
			-- Otherwise do nothing.
		local
			i: INTEGER
			station: STATION
			line: LINE
		do
			if origin /= Void and destination /= Void then
				-- Remove highlighting
				if origin_view /= Void then
					origin_view.unhighlight
				end
				if destination_view /= Void then
					destination_view.unhighlight
				end

				-- Change shown route
				if last_route /= Void then
					Zurich.remove_route (last_route)
				end
				last_route := route_finder.shortest_route (origin, destination)
				Zurich.add_route (last_route)
				Zurich_map.update

				-- Output information to console
				console.clear
				console.append_line ("From " + origin.name + " to " + destination.name + ":")
				from
					i := 1
				until
					not last_route.lines.has_index (i)
				loop
					station := last_route.stations[i]
					line := last_route.lines[i]
					console.append_line ("Take " + line.kind.name + " " + line.number.out + " until " + station.name)
					i := i + 1
				end
			end
		end
end
