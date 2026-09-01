###############################################################################
# Created by write_sdc
###############################################################################
current_design frequency_counter
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name system_clock -period 100.0000 [get_ports {CLK_I}]
set_clock_uncertainty 0.5000 system_clock
set_propagated_clock [get_clocks {system_clock}]
create_clock -name signal_clock -period 4000.0000 [get_ports {signal_input}]
set_propagated_clock [get_clocks {signal_clock}]
set_clock_groups -name asynchronous_clock -asynchronous \
 -group [get_clocks {signal_clock}]\
 -group [get_clocks {system_clock}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_I[0]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_I[1]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_I[2]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_I[3]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_I[4]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_I[5]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_I[6]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ADDR_I[7]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {CYC_I}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[0]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[1]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[2]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[3]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[4]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[5]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[6]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_I[7]}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {RST_I}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {STB_I}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {WE_I}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ext_rst_i}]
set_input_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {signal_input}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ACK_O}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[0]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[1]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[2]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[3]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[4]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[5]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[6]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {DAT_O[7]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {ERR_O}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {RTY_O}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {bypass_pin_control[0]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {bypass_pin_control[1]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {bypass_pin_control[2]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {pga_gain_control[0]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {pga_gain_control[1]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {pga_gain_control[2]}]
set_output_delay 20.0000 -clock [get_clocks {system_clock}] -add_delay [get_ports {trigger_signal_out}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
set_max_transition 3.5000 [current_design]
set_max_capacitance 0.0790 [get_ports {ACK_O}]
set_max_capacitance 0.0790 [get_ports {DAT_O[0]}]
set_max_capacitance 0.0790 [get_ports {DAT_O[1]}]
set_max_capacitance 0.0790 [get_ports {DAT_O[2]}]
set_max_capacitance 0.0790 [get_ports {DAT_O[3]}]
set_max_capacitance 0.0790 [get_ports {DAT_O[4]}]
set_max_capacitance 0.0790 [get_ports {DAT_O[5]}]
set_max_capacitance 0.0790 [get_ports {DAT_O[6]}]
set_max_capacitance 0.0790 [get_ports {DAT_O[7]}]
set_max_capacitance 0.0790 [get_ports {ERR_O}]
set_max_capacitance 0.0790 [get_ports {RTY_O}]
set_max_capacitance 0.0790 [get_ports {bypass_pin_control[0]}]
set_max_capacitance 0.0790 [get_ports {bypass_pin_control[1]}]
set_max_capacitance 0.0790 [get_ports {bypass_pin_control[2]}]
set_max_capacitance 0.0790 [get_ports {pga_gain_control[0]}]
set_max_capacitance 0.0790 [get_ports {pga_gain_control[1]}]
set_max_capacitance 0.0790 [get_ports {pga_gain_control[2]}]
set_max_capacitance 0.0790 [get_ports {trigger_signal_out}]
