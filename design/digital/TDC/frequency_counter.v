`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:53:19 02/20/2025 
// Design Name:    Frequency Counter 
// Module Name:    frequency_counter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module frequency_counter #(parameter WIDTH = 8) (
    input ext_rst_i,
    input RST_I,
    input CLK_I,
    input [WIDTH-1:0] ADDR_I,
    input [WIDTH-1:0] DAT_I,
    input WE_I,
    // input [3:0] sel_i,
    input CYC_I,
    input STB_I,
    // input LOCK_I,
    // input TAGN_I,
    input signal_input,
    output reg trigger_signal_out,
    output reg [WIDTH-1:0] DAT_O,
    output reg ERR_O,
    output reg RTY_O,
    output reg ACK_O,
    output [2:0] pga_gain_control,
    output [2:0] bypass_pin_control
    );

    // General Register that can be accessed through the bus
    // All registers are in MSB format
    // Contents : 
    // range_count_register (0x0E, 0x0F, and 0x10) --> used to set what address we need the module to respond to.
    //      - 24 bit wide, divided into 8-bit high, mid, and low register. Contains ranging measurement result
    // pulse_timing_register (0x11, 0x12, and 0x13) --> used for WRITE process where we receive data
    //      - 24 bit wide, divided into 8-bit high, mid, and low register. Contains doppler measurement result
    // pulse_count_threshold_register (0x14 and 0x15) --> used for READ process where we send data
    //      - 16 bit wide, divided into high and low register. Contains doppler pulse count threshold. 
    // counter_control_status_register (0x16) --> used to poll or set the operation of the module
    //      - bit 7: measurement start bit. Set this to start measuring, automatically cleared once finished
    //      - bit 6: measurement done bit. Automatically set upon measurement completion. please clear manually
    //      - bit 5: measurement range mode enable. Set this to enable ranging mode, clear to disable it
    //      - bit 4: measurement pulse mode enable. Set this to enable doppler mode, clear to disable it
    //      - bit 3: measurement range mode timeout. this bit will be set if the measurement timed out
    //      - bit 2: measurement pulse mode timeout. this bit will be set if the measurement timed out
    //      - bit 1: Reserved
    //      - bit 0: Reset counter interface (when things go awry, initialization means besides resetting the whole chip)
    // afe_config_bypass_control_register (0x17) --> used to control the PGA gain, as well as bypass pins for analog debugging
    //      - bit 7-5: PGA gain config. Uses one-hot data format
    //          - bit 7: enables gain x2
    //          - bit 6: enables gain x10
    //          - bit 5: enables gain x50
    //      - bit 4: LNA bypass, activates the IN_BPF pin. can be used to test the LNA
    //      - bit 3: BPF bypass, activates the IN_SCHMITT pin. can be used to test the BPF
    //      - bit 2: optional bypass just in case
    //      - bit 1: Reserved
    //      - bit 0: Reserved

    // Registers of the TDC Blocks
    // The localparam is for defining the address of the TDC block's registers, please change it here in case
    // you need its address to be other than the default
    localparam [WIDTH-1:0] RANGE_TIMING_REGISTER_HIGH_ADDRESS = 14;
    localparam [WIDTH-1:0] RANGE_TIMING_REGISTER_MID_ADDRESS = 15;
    localparam [WIDTH-1:0] RANGE_TIMING_REGISTER_LOW_ADDRESS = 16;
    localparam [WIDTH-1:0] PULSE_TIMING_REGISTER_HIGH_ADDRESS = 17;
    localparam [WIDTH-1:0] PULSE_TIMING_REGISTER_MID_ADDRESS = 18;
    localparam [WIDTH-1:0] PULSE_TIMING_REGISTER_LOW_ADDRESS = 19;
    localparam [WIDTH-1:0] PULSE_COUNT_THRESHOLD_REGISTER_HIGH_ADDRESS = 20;
    localparam [WIDTH-1:0] PULSE_COUNT_THRESHOLD_REGISTER_LOW_ADDRESS = 21;
    localparam [WIDTH-1:0] COUNTER_CONTROL_STATUS_REGISTER_ADDRESS = 22;
    localparam [WIDTH-1:0] AFE_CONFIG_BYPASS_CONTROL_REGISTER_ADDRESS = 23;

    localparam MEASUREMENT_START_BIT = 7;
    localparam MEASUREMENT_DONE_BIT = 6;
    localparam MEASUREMENT_RANGE_MODE_ENABLE = 5;
    localparam MEASUREMENT_PULSE_MODE_ENABLE = 4;
    localparam MASUREMENT_RANGE_TIMEOUT = 3;
    localparam MASUREMENT_PULSE_TIMEOUT = 2;
    localparam RESET_COUNTER_BIT = 0;

    reg [23:0] range_timing_register;
    reg [23:0] pulse_timing_register;
    reg [15:0] pulse_count_threshold_register;
    reg [7:0] counter_control_status_register;
    reg [7:0] afe_config_bypass_control_register;

    reg [23:0] pulse_timing_internal;            //front-end measurement counter register, where counting happens and data stored before being pushed to the bus-facing register
    reg [23:0] range_timing_internal;            //front-end measurement counter register, where counting happens and data stored before being pushed to the bus-facing register
    reg counter_ready;

    reg range_timeout_internal_flag;
    reg range_finished_internal_flag;
    reg pulse_timeout_internal_flag;
    reg measurement_pulse_start_internal_flag;
    reg measurement_pulse_done_internal_flag;

    // Wishbone Interface of the Counter block
    reg just_written_internal_flag;
    
    wire measurement_done_internal;

    assign pga_gain_control[2:0] = afe_config_bypass_control_register[7:5];
    assign bypass_pin_control[2:0] = afe_config_bypass_control_register[4:2];

    always @(posedge CLK_I) begin
        // if we receive a reset signal from the bus...
        if (RST_I == 1'b1) begin
            // Reset everything!
            DAT_O <= 0;
            ERR_O <= 1'b0;
            ACK_O <= 1'b0;
            RTY_O <= 1'b0;
            range_timing_register <= 24'd0;
            pulse_timing_register <= 24'd0;
            pulse_count_threshold_register <= 16'd1000;
            counter_control_status_register <= 8'd0;
        end
        // if there is any operation
        else if (RST_I == 1'b0 && CYC_I == 1'b1 && STB_I == 1'b1) begin
            if ((ACK_O | ERR_O | RTY_O) == 1'b0) begin
                case (ADDR_I)
                    RANGE_TIMING_REGISTER_HIGH_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= range_timing_register[23:16];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    RANGE_TIMING_REGISTER_MID_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= range_timing_register[15:8];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    RANGE_TIMING_REGISTER_LOW_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= range_timing_register[7:0];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    PULSE_TIMING_REGISTER_HIGH_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= pulse_timing_register[23:16];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    PULSE_TIMING_REGISTER_MID_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= pulse_timing_register[15:8];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    PULSE_TIMING_REGISTER_LOW_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= pulse_timing_register[7:0];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    PULSE_COUNT_THRESHOLD_REGISTER_HIGH_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            pulse_count_threshold_register[15:8] <= DAT_I;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= pulse_count_threshold_register[15:8];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    PULSE_COUNT_THRESHOLD_REGISTER_LOW_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            pulse_count_threshold_register[7:0] <= DAT_I;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= pulse_count_threshold_register[7:0];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    COUNTER_CONTROL_STATUS_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            counter_control_status_register <= DAT_I;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= counter_control_status_register;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    AFE_CONFIG_BYPASS_CONTROL_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            afe_config_bypass_control_register <= DAT_I;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= afe_config_bypass_control_register;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    default : begin
                        // Register does not exist, but do not throw any error
                        DAT_O <= 0;
                        ERR_O <= 1'b0;
                        ACK_O <= 1'b0;
                        RTY_O <= 1'b0;
                    end
                endcase
            end  
            // if any of the signaling has been asserted (ACK, RTY, or ERR)...
            else if ((ACK_O | ERR_O | RTY_O) == 1'b1) begin
                // de-assert first before moving on to the next transaction
                DAT_O <= 0;
                ERR_O <= 1'b0;
                ACK_O <= 1'b0;
                RTY_O <= 1'b0;
            end
        end
        // if no activity is in progress, update the flag registers and the front facing register 
        else begin
            if (counter_control_status_register[MEASUREMENT_RANGE_MODE_ENABLE] == 1'b1 && counter_control_status_register[MEASUREMENT_PULSE_MODE_ENABLE] == 1'b1) begin
                if (range_finished_internal_flag == 1'b1 && measurement_pulse_done_internal_flag == 1'b1) begin
                    range_timing_register <= range_timing_internal;
                    pulse_timing_register <= pulse_timing_internal;
                    counter_control_status_register[MEASUREMENT_DONE_BIT] <= 1'b1;
                    counter_control_status_register[MEASUREMENT_START_BIT] <= 1'b0;
                end
                else begin
                    range_timing_register <= range_timing_register;
                    pulse_timing_register <= pulse_timing_register;
                    counter_control_status_register[MEASUREMENT_DONE_BIT] <= counter_control_status_register[MEASUREMENT_DONE_BIT];
                    counter_control_status_register[MEASUREMENT_START_BIT] <= counter_control_status_register[MEASUREMENT_START_BIT];
                end
            end
            else if (counter_control_status_register[MEASUREMENT_RANGE_MODE_ENABLE] == 1'b0 && counter_control_status_register[MEASUREMENT_PULSE_MODE_ENABLE] == 1'b1) begin
                if (measurement_pulse_done_internal_flag == 1'b1) begin
                    range_timing_register <= range_timing_internal;
                    pulse_timing_register <= pulse_timing_internal;
                    counter_control_status_register[MEASUREMENT_DONE_BIT] <= 1'b1;
                    counter_control_status_register[MEASUREMENT_START_BIT] <= 1'b0;
                end
                else begin
                    range_timing_register <= range_timing_register;
                    pulse_timing_register <= pulse_timing_register;
                    counter_control_status_register[MEASUREMENT_DONE_BIT] <= counter_control_status_register[MEASUREMENT_DONE_BIT];
                    counter_control_status_register[MEASUREMENT_START_BIT] <= counter_control_status_register[MEASUREMENT_START_BIT];
                end
            end
            else if (counter_control_status_register[MEASUREMENT_RANGE_MODE_ENABLE] == 1'b1 && counter_control_status_register[MEASUREMENT_PULSE_MODE_ENABLE] == 1'b0) begin
                if (range_finished_internal_flag == 1'b1) begin
                    range_timing_register <= range_timing_internal;
                    pulse_timing_register <= pulse_timing_internal;
                    counter_control_status_register[MEASUREMENT_DONE_BIT] <= 1'b1;
                    counter_control_status_register[MEASUREMENT_START_BIT] <= 1'b0;
                end
                else begin
                    range_timing_register <= range_timing_register;
                    pulse_timing_register <= pulse_timing_register;
                    counter_control_status_register[MEASUREMENT_DONE_BIT] <= counter_control_status_register[MEASUREMENT_DONE_BIT];
                    counter_control_status_register[MEASUREMENT_START_BIT] <= counter_control_status_register[MEASUREMENT_START_BIT];
                end
            end
            else begin
                if (counter_control_status_register[RESET_COUNTER_BIT] == 1'b1) begin
                    counter_control_status_register[RESET_COUNTER_BIT] <= 1'b0;                    
                end
                else if (range_finished_internal_flag == 1'b1) begin
                    range_timing_register <= range_timing_internal;
                    pulse_timing_register <= pulse_timing_internal;
                    counter_control_status_register[MEASUREMENT_DONE_BIT] <= 1'b1;
                    counter_control_status_register[MEASUREMENT_START_BIT] <= 1'b0;
                end
                else begin
                    range_timing_register <= range_timing_register;
                    pulse_timing_register <= pulse_timing_register;
                    counter_control_status_register[MEASUREMENT_DONE_BIT] <= counter_control_status_register[MEASUREMENT_DONE_BIT];
                    counter_control_status_register[MEASUREMENT_START_BIT] <= counter_control_status_register[MEASUREMENT_START_BIT];
                end
            end
        end
    end

    /*
    Counter front-end begins here
    used to interact with the input signal and reference clock
    */

    localparam STATE_READY = 0;
    localparam STATE_RANGE = 1;
    localparam STATE_PULSE = 2;
    localparam STATE_FINISH = 3;

    // buffer blocks here, it simply uses the incoming clock signal to propagates the input
    // TBD...

    // Rising-Falling Edge Detector Block
    reg input_previous_state;
    wire rising_edge_detected = ~input_previous_state & signal_input;
    wire falling_edge_detected = input_previous_state & ~signal_input;

    always @(posedge CLK_I) begin
        input_previous_state <= signal_input; 
    end

    // Trigger Output Signal Generator Block
    reg [6:0] trigger_timer_internal;
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1 || counter_control_status_register[RESET_COUNTER_BIT] == 1'b1) begin
            trigger_signal_out <= 1'b0;
            trigger_timer_internal <= 1'b0; 
        end
        else if (counter_control_status_register[MEASUREMENT_START_BIT] == 1'b1 && counter_control_status_register[MEASUREMENT_DONE_BIT] == 1'b0) begin
            if (trigger_timer_internal == 7'd100) begin
                trigger_signal_out <= 1'b0;
                trigger_timer_internal <= trigger_timer_internal;    
            end
            else begin
                trigger_signal_out <= 1'b1;
                trigger_timer_internal <= trigger_timer_internal + 1'b1;
            end
        end
        else if (counter_control_status_register[MEASUREMENT_START_BIT] == 1'b1 && counter_control_status_register[MEASUREMENT_DONE_BIT] == 1'b1) begin
            trigger_signal_out <= 1'b0;
            trigger_timer_internal <= trigger_timer_internal;
        end
        else begin
            trigger_signal_out <= 1'b0;
            trigger_timer_internal <= 7'd0;
        end
    end


    // Ranging Mode FSM subroutine begins here
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1 || counter_control_status_register[RESET_COUNTER_BIT] == 1'b1) begin
            range_timing_internal <= 24'd0;
            counter_ready <= 1'b1;
            range_finished_internal_flag <= 1'b0;
            range_timeout_internal_flag <= 1'b0;
            measurement_pulse_start_internal_flag <= 1'b0;
        end
        else if (counter_control_status_register[MEASUREMENT_RANGE_MODE_ENABLE] == 1'b1) begin
            if (counter_control_status_register[MEASUREMENT_START_BIT] == 1'b1 && range_finished_internal_flag == 1'b0) begin
                counter_ready <= 1'b0;
                // When it's timeout, go to idle, do not continue because there won't be any pulse
                if (range_timing_internal >= 24'd714285) begin
                    range_timeout_internal_flag <= 1'b1;
                    range_finished_internal_flag <= 1'b1;
                    range_timing_internal <= 24'd0;
                end
                // When the ranging is finished (pulse detected)...
                else if (rising_edge_detected == 1'b1) begin
                    if (counter_control_status_register[MEASUREMENT_PULSE_MODE_ENABLE] == 1'b1) begin
                        range_finished_internal_flag <= 1'b1;
                        range_timing_internal <= range_timing_internal;
                        measurement_pulse_start_internal_flag <= 1'b1;
                    end
                    else begin
                        range_finished_internal_flag <= 1'b1;
                        range_timing_internal <= range_timing_internal;
                        measurement_pulse_start_internal_flag <= 1'b0;
                    end
                end
                else begin
                    range_timing_internal <= range_timing_internal + 1'b1;
                end
            end
            else if (counter_control_status_register[MEASUREMENT_START_BIT] == 1'b1 && range_finished_internal_flag == 1'b1) begin
                range_timing_internal <= range_timing_internal;
                counter_ready <= 1'b0;
                range_finished_internal_flag <= range_finished_internal_flag;
                measurement_pulse_start_internal_flag <= measurement_pulse_start_internal_flag;
                range_timeout_internal_flag <= range_timeout_internal_flag;
            end 
            else if (counter_control_status_register[MEASUREMENT_START_BIT] == 1'b0 && range_finished_internal_flag == 1'b1) begin
                range_timing_internal <= 24'b0;
                counter_ready <= 1'b1;
                range_finished_internal_flag <= 1'b0;
                range_timeout_internal_flag <= 1'b0;
                measurement_pulse_start_internal_flag <= 1'b0;
            end
            else begin
                range_timing_internal <= range_timing_internal;
                counter_ready <= counter_ready;
                measurement_pulse_start_internal_flag <= measurement_pulse_start_internal_flag;
                range_finished_internal_flag <= range_finished_internal_flag;
                range_timeout_internal_flag <= range_timeout_internal_flag;
            end
        end
        else if (counter_control_status_register[MEASUREMENT_RANGE_MODE_ENABLE] == 1'b0) begin
            if (counter_control_status_register[MEASUREMENT_PULSE_MODE_ENABLE] == 1'b1) begin
                if (counter_control_status_register[MEASUREMENT_START_BIT] == 1'b1 && range_finished_internal_flag == 1'b0) begin
                    counter_ready <= 1'b0;
                    range_finished_internal_flag <= 1'b1;
                    measurement_pulse_start_internal_flag <= 1'b1;
                end
                else if (counter_control_status_register[MEASUREMENT_START_BIT] == 1'b0 && range_finished_internal_flag == 1'b1) begin
                    counter_ready <= 1'b1;
                    range_finished_internal_flag <= 1'b0;
                    measurement_pulse_start_internal_flag <= 1'b0;
                end
            end
            else begin
                // do nothing...
            end
        end
    end

    // Pulse Mode FSM subroutine begins here
    reg [15:0] measurement_state_machine;

    always @(posedge signal_input) begin
        if (RST_I == 1 || counter_control_status_register[RESET_COUNTER_BIT] == 1) begin 
                measurement_state_machine <= 16'd0;
                measurement_pulse_done_internal_flag <= 1'b0;
        end
        else if (measurement_pulse_start_internal_flag == 1'b1 && measurement_pulse_done_internal_flag == 1'b0) begin
            case (measurement_state_machine)
                16'd0 : begin
                    measurement_state_machine <= measurement_state_machine + 1'b1;
                end
                pulse_count_threshold_register : begin                   
                    measurement_state_machine <= 16'd0;
                    measurement_pulse_done_internal_flag <= 1'b1;
                end
                default : begin 
                    measurement_state_machine <= measurement_state_machine + 1'b1;
                end
            endcase
        end
        else if (measurement_pulse_start_internal_flag == 1'b0 && measurement_pulse_done_internal_flag == 1'b1) begin
            measurement_pulse_done_internal_flag <= 1'b0;
        end
        else begin
            // do nothing...
        end 
    end

    // Pulse clock duration measurement block here
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1 || counter_control_status_register[RESET_COUNTER_BIT] == 1'b1) begin 
            pulse_timing_internal <= 24'd0;
        end
        else if (measurement_pulse_start_internal_flag == 1'b1) begin 
		    if (measurement_pulse_done_internal_flag == 1'b1) begin
				pulse_timing_internal <= pulse_timing_internal;
            end 
            else begin
                pulse_timing_internal <= pulse_timing_internal + 1'b1;
            end
        end else begin 
            pulse_timing_internal <= 24'd0;
        end
    end 
endmodule  
