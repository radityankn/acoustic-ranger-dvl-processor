###############################################################################
# Created by write_sdc
###############################################################################
current_design i2c_controller
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name system_clock -period 100.0000 [get_ports {CLK_I}]
set_clock_uncertainty 0.5000 system_clock
set_propagated_clock [get_clocks {system_clock}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ACK_I}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[0]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[1]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[2]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[3]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[4]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[5]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[6]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[7]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ERR_I}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {RST_I}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {RTY_I}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {i2c_scl_in}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {i2c_sda_in}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_O[0]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_O[1]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_O[2]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_O[3]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_O[4]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_O[5]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_O[6]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_O[7]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {CYC_O}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[0]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[1]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[2]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[3]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[4]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[5]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[6]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[7]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {STB_O}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {WE_O}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {i2c_sda_out_pin_ctrl}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {i2c_sda_out_pin_ctrl_n}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
