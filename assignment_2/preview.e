note
	description: "Introduction to Traffic."

class
	PREVIEW

inherit
	ZURICH_OBJECTS

feature
	-- Explore Zurich

	Zoo: STATION
	Zoo_view: STATION_VIEW

	explore
			-- Modify the map.
		local
			highlight_counter: INTEGER
		do
			-- Add station "Zoo" and connect it to line 6
			Zurich.add_station ("Zoo", 1250, 300)
			Zurich.connect_station (6, "Zoo")

			-- Update visual representation
			Zurich_map.update
			Zurich_map.fit_to_window

			-- Get newly created station and its view
			Zoo := Zurich.station ("Zoo")
			Zoo_view := Zurich_map.station_view (Zoo)

			from
				highlight_counter := 0
			until
				highlight_counter = 3
			loop
				-- Highlight
				Zoo_view.highlight
				wait (1)

				-- Unhighlight
				Zoo_view.unhighlight
				wait (1)

				highlight_counter := highlight_counter + 1
			end
		end

end
