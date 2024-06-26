import math

samples = 100
max_int = 65535  # Maximum value for 16-bit unsigned integer

# Compute scaled sine values
sine_values = [int((math.sin(2 * math.pi * i / samples) * 0.5 + 0.5) * max_int) for i in range(samples)]

# Generate VHDL formatted sine values for std_logic_vector type
slv_values = ',\n        '.join(f'"{value:016b}"' for value in sine_values)

# Print the values in VHDL array initialization format
vhdl_output = (
    "constant analog_wave : sine_array := (\n"
    "        " + slv_values + "\n"
    ");"
)

print(vhdl_output)