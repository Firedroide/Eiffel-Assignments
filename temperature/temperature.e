note
	description: "Temperature."

class
	TEMPERATURE

create
	make_kelvin, make_celsius, make_fahrenheit

feature {NONE} -- Initialization

	make_kelvin (v: REAL_64)
			-- Create with Kelvin value `v'.
		require
			positive_kelvin: v >= 0
		do
			kelvin := v
		ensure
			kelvin_equals: (kelvin - v).abs < 0.001
		end

	make_celsius (v: REAL_64)
			-- Create with Celsius value `v'.
		require
			positive_kelvin: v >= Celsius_offset
		do
			kelvin := v - Celsius_offset
		ensure
			celsius_equals: (celsius - v).abs < 0.001
		end

	make_fahrenheit (v: REAL_64)
			-- Create with Fahrenheit value `v'.
		require
			positive_kelvin: v >= Fahrenheit_offset
		do
			kelvin := (v - Fahrenheit_offset) / Fahrenheit_scale
		ensure
			fahrenheit_equals: (fahrenheit - v).abs < 0.001
		end

feature -- Access

	kelvin: REAL_64
			-- Value in Kelvin scale.
			-- We're scientists, we save the SI base unit!

	celsius: REAL_64
			-- Value in Celsius scale.
		do
			Result := kelvin + Celsius_offset
		end

	fahrenheit: REAL_64
			-- Value in Fahrenheit scale.
		do
			Result := (kelvin * Fahrenheit_scale) + Fahrenheit_offset
		end

feature -- Measurement

	average (other: TEMPERATURE): TEMPERATURE
			-- Average temperature between `Current' and `other'.
		require
			other_not_void: other /= Void
		local
			average_kelvin: REAL_64
		do
			average_kelvin := (kelvin + other.kelvin) / 2.0
			create Result.make_kelvin (average_kelvin)
		ensure
			is_average: ((Result.kelvin - kelvin) + (Result.kelvin - other.kelvin)).abs < 0.001
		end

feature {NONE} -- Constants
	Fahrenheit_offset: REAL_64 = -459.67
	Fahrenheit_scale: REAL_64 = 1.8
	Celsius_offset: REAL_64 = -273.15

invariant
	kelvin_not_negative: kelvin >= 0
end
