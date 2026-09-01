# Timing Constraint SDC files for TDC Block
# Refer to Librelane Documentation as well as OpenSTA or general SDC file glossary
#
#
# Normally, all we have to do is to define the timing constraint of the signals
# this can be done with 5 command keyword: create_clock, set_clock_uuncertainty, 
# set_clock_group, set_input_delay, and set_output_delay, anything beyond it 
# usually will be supplied by the PDK default value, so don't worry about being 
# way too inaccurate with the analysis.

# Point at the intended module of interest
current_design frequency_counter

# set variables here
set io_delay_percentage 0.2
set clock_uncertainty 0.5
set clock_period 100

# set units for the whole SDC file expressions involving these quantities
set_units -time ns -capacitance pF

# Define the existing clock in the file for analysis. Here we are using 2 clocks
# because there are 2 different clocks for this block's operation
create_clock -name system_clock -period 100 -waveform {0.0 50.0} [get_ports CLK_I]
create_clock -name signal_clock -period 4000 -waveform {0.0 2000.0} [get_ports signal_input]

# group the aforementioned clock, declare them as asynchronous to avoid analysis error
# involving paths between these domains
set_clock_group -name asynchronous_clock -asynchronous \
    -group [get_clocks system_clock] \
    -group [get_clocks signal_clock]

# set clock uncertainty to represent jitter and skew
set_clock_uncertainty $clock_uncertainty [get_clocks system_clock]

# set input and output delay to represent the time needed before it reaches the FF's
# input pin. The input ones needed supposedly for setup time information, while the 
# output ones are used for the desired hold time information of the design. 
set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] [get_ports {CLK_I signal_input}]]
set_input_delay [expr $clock_period * $io_delay_percentage] -clock [get_clocks system_clock] $non_clock_inputs
set_output_delay [expr $clock_period * $io_delay_percentage] -clock [get_clocks system_clock] [all_outputs]