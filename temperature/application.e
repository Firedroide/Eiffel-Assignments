note
	description : "Temperature application root class"

class
	APPLICATION

create
	execute

feature {NONE} -- Initialization

	execute
			-- Run application.
		local

			temperature_1, temperature_2, average: TEMPERATURE
		do
			-- Input temperature in Celsius and show the converted value in Kelvin.
			Io.put_string ("Input temperature 1 in Celsius: ")
			Io.read_double

			create temperature_1.make_celsius(Io.last_double)
			Io.put_string ("Value in Kelvin: ")
			Io.put_double (temperature_1.kelvin)
			Io.new_line
			Io.new_line

			-- Input temperature in Kelvin and show the converted value in Celsius.
			Io.put_string ("Input temperature 2 in Kelvin: ")
			Io.read_double

			create temperature_2.make_kelvin(Io.last_double)
			Io.put_string ("Value in Celsius: ")
			Io.put_double (temperature_2.celsius)
			Io.new_line
			Io.new_line

			-- Calculate the average temperature and show it in Kelvin, Celsius and Fahrenheit.
			average := temperature_1.average (temperature_2)
			Io.put_string ("Average temperature")
			Io.new_line
			Io.put_string ("Kelvin: ")
			Io.put_double (average.kelvin)
			Io.new_line
			Io.put_string ("Celsius: ")
			Io.put_double (average.celsius)
			Io.new_line
			Io.put_string ("Fahrenheit: ")
			Io.put_double (average.fahrenheit)
		end

end
