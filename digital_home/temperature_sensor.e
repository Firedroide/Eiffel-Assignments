class
	TEMPERATURE_SENSOR

create
	make

feature -- Access

	temperature: REAL_64
			-- The current temperature measured by this sensor

	add_observer (observer: PROCEDURE [ANY, TUPLE [REAL_64]])
			-- Add an observer to be notified when the temperature changes.
		do
			observers.extend (observer)
		end

	remove_observer (observer: PROCEDURE [ANY, TUPLE [REAL_64]])
			-- Remove a previously registered observer.
			-- Does nothing if observer wasn't registered.
		do
			observers.prune (observer)
		end

feature {APPLICATION} -- Reserved to "hardware"

	set_temperature (new_temperature: REAL_64)
			-- Change the observed temperature to `new_temperature'
		do
			temperature := new_temperature
			across
				observers as o
			loop
				o.item.call (temperature)
			end
		end

feature {NONE} -- Implementation

	observers: LINKED_LIST [PROCEDURE [ANY, TUPLE [REAL_64]]]

feature {NONE} -- Initialization

	make
			-- Create this sensor.
		do
			create observers.make
		end

invariant
	observer_list_exists: observers /= Void
end
