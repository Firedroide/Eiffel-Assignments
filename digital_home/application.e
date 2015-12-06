class
	APPLICATION

create
	make

feature {NONE} -- Initialization
	make
			-- Run application.
		local
			sensor: TEMPERATURE_SENSOR
			display: DISPLAY
			heater: HEATING_CONTROLLER
		do
			-- Create a temperature sensor, a display and a heating controller
			create sensor.make
			create display
			create heater.set_goal (18.0)

			-- Subscribe the display and the heating controller to the temperature change events
			-- produced by the temperature sensor
			sensor.add_observer (agent display.show (?))
			sensor.add_observer (agent heater.adjust (?))

			-- Change the temperature a couple of times
			sensor.set_temperature (10.0)
			sensor.set_temperature (18.0)
			sensor.set_temperature (20.0)
			sensor.set_temperature (42.0)
			sensor.set_temperature (5500.0) -- ERROR: Earth = Sun
		end
end
