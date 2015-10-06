note
	description: "Introduction to Traffic."

class
	PREVIEW

inherit
	ZURICH_OBJECTS

feature -- Explore Zurich

	explore
			-- Turn back now, bad and undocumented code ahead.
		local
			count: INTEGER
			direction: STATION
			connected_directly: BOOLEAN
		do
			wait (1)
			console.output ("How bright is the color of line 13? "
					+ Zurich.line (13).color.brightness.out)
			wait (3)
			console.output ("How many meters to the north of the city center is the third station of line 31 located? "
					+ Zurich.line (31).i_th (3).position.y.out)
			wait (3)
			console.output ("What is the next station of line 31 after Loewenplatz in the direction of its west terminal? "
					+ Zurich.line (31).next_station (Zurich.station ("Loewenplatz"), Zurich.line (31).west_terminal).name)

			wait (3)
			count := 0
			across Zurich.lines as line loop
				if line.item.has_station (Zurich.station ("Paradeplatz")) then
					count := count + 1
				end
			end
			console.output ("How many public transportation lines go through station Paradeplatz? "
					+ count.out)

			wait (3)
			direction := Zurich.line (7).direction (Zurich.station ("Paradeplatz"), Zurich.station ("Rennweg"))
			connected_directly := Zurich.line (7).next_station (Zurich.station ("Paradeplatz"), direction) = Zurich.station ("Rennweg")
			console.output ("Does line 7 connect stations Paradeplatz and Rennweg directly? " + connected_directly.out)
		end

end
