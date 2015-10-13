note
	description: "Creating new objects for Zurich."

class
	OBJECT_CREATION

inherit
	ZURICH_OBJECTS

feature -- Explore Zurich

	explore
			-- Create new objects for Zurich.
		do
			add_buildings
			add_route
		end

	add_buildings
			-- Add new buildings to Zurich.
		local
			north_west, south_east: VECTOR
			eth_main_building: BUILDING
			zurich_opera: BUILDING
		do
			-- ETH Main Building
			create north_west.make (240, 0)
			create south_east.make (320, -100)
			create eth_main_building.make ("Hauptgebäude ETH Zürich", north_west, south_east)
			Zurich.add_building (eth_main_building)

			-- Zurich Opera
			create north_west.make (150, -1350)
			create south_east.make (250, -1480)
			create zurich_opera.make ("Opernhaus", north_west, south_east)
			Zurich.add_building (zurich_opera)
		end

	add_route
			-- Adds a route Polyterrasse -> Paradeplatz -> Opernhaus
		local
			route: ROUTE
		do
			-- Route starting at Polyterrasse
			create route.make_empty (Polyterrasse)

			-- Polyterrasse to Central on line 24
			route.append_segment (Zurich.line (24), Central)

			-- Central to Paradeplatz on line 7
			route.append_segment (Zurich.line (7), Zurich.station ("Paradeplatz"))

			-- Paradeplatz to Opernhaus on line 2
			route.append_segment (Zurich.line (2), Opernhaus)

			-- Add the final route to the map
			Zurich.add_route (route)
		end

end
