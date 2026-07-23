`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:53:19 02/20/2025 
// Design Name: 
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
    output reg [WIDTH-1:0] DAT_O,
    output reg ERR_O,
    output reg RTY_O,
    output reg ACK_O,
    );

    // General Register that can be accessed through the bus
    // All registers are in MSB format
    // Contents : 
    // range_count_register (0x0E, 0x0F, and 0x10) --> used to set what address we need the module to respond to.
    //      - 24 bit wide, divided into 8-bit high, mid, and low register. Contains ranging measurement result
    // pulse_count_register (0x11 and 0x12) --> used for WRITE process where we receive data
    //      - 16 bit wide, divided into 8-bit high and low register. Contains doppler measurement result
    // pulse_count_threshold_register (0x13 and 0x14) --> used for READ process where we send data
    //      - 16 bit wide, divided into high and low register. Contains doppler pulse count threshold. 
    // counter_control_status_register (0x15) --> used to poll or set the operation of the module
    //      - bit 7: measurement start bit. Set this to start measuring, automatically cleared once finished
    //      - bit 6: measurement done bit. Automatically set upon measurement completion. please clear manually
    //      - bit 5: measurement range mode enable. Set this to enable ranging mode, clear to disable it
    //      - bit 4: measurement pulse mode enable. Set this to enable doppler mode, clear to disable it
    //      - bit 3: measurement range mode timeout. this bit will be set if the measurement timed out
    //      - bit 2: measurement pulse mode timeout. this bit will be set if the measurement timed out
    //      - bit 1: Reserved
    //      - bit 0: Reset counter interface (when things go awry, initialization means besides resetting the whole chip)

    // Registers of the I2C Blocks
    // The localparam is for defining the address of the I2C block's registers, please change it here in case
    // you need its address to be other than the default
    localparam [WIDTH-1:0] RANGE_COUNT_REGISTER_HIGH_ADDRESS = 14;
    localparam [WIDTH-1:0] RANGE_COUNT_REGISTER_MID_ADDRESS = 15;
    localparam [WIDTH-1:0] RANGE_COUNT_REGISTER_LOW_ADDRESS = 16;
    localparam [WIDTH-1:0] PULSE_COUNT_REGISTER_HIGH_ADDRESS = 17;
    localparam [WIDTH-1:0] PULSE_COUNT_REGISTER_LOW_ADDRESS = 18;
    localparam [WIDTH-1:0] PULSE_COUNT_THRESHOLD_REGISTER_HIGH_ADDRESS = 19;
    localparam [WIDTH-1:0] PULSE_COUNT_THRESHOLD_REGISTER_LOW_ADDRESS = 20;
    localparam [WIDTH-1:0] COUNTER_CONTROL_STATUS_REGISTER_ADDRESS = 21;

    localparam MEASUREMENT_START_BIT = 7;
    localparam MEASUREMENT_DONE_BIT = 6;
    localparam MEASUREMENT_RANGE_MODE_ENABLE = 5;
    localparam MEASUREMENT_PULSE_MODE_ENABLE = 4;
    localparam RESET_COUNTER_BIT = 0;

    reg [23:0] range_count_register;
    reg [15:0] pulse_count_register;
    reg [15:0] pulse_count_threshold_register;
    reg [7:0] counter_control_status_register;

    // Wishbone Interface of the Counter block
    reg just_written_internal_flag;

    always @(posedge CLK_I) begin
        // if we receive a reset signal from the bus...
        if (RST_I == 1'b1) begin
            // Reset everything!
            DAT_O <= 0;
            ERR_O <= 1'b0;
            ACK_O <= 1'b0;
            RTY_O <= 1'b0;
        end
        // if there is any operation
        else if (RST_I == 1'b0 && CYC_I == 1'b1 && STB_I == 1'b1) begin
            if ((ACK_O | ERR_O | RTY_O) == 1'b0) begin
                case (ADDR_I)
                    RANGE_COUNT_REGISTER_HIGH_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= range_count_register[23:16];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    RANGE_COUNT_REGISTER_MID_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= range_count_register[15:8];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    RANGE_COUNT_REGISTER_LOW_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= range_count_register[7:0];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    PULSE_COUNT_REGISTER_HIGH_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= pulse_count_register[15:8];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    PULSE_COUNT_REGISTER_LOW_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= pulse_count_register[7:0];
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
            // if no activity is in progress, update the flag registers and the front facing register 
            else begin

            end
        end
    end
    
    //buffer block goes here
    //for synchronization between clock domains
    reg measurement_end_buffer_1;
    reg measurement_end_buffer_2;
    reg counter_ready_buffer_1;
    reg counter_ready_buffer_2;

    always @(posedge clk_i) begin
        measurement_end_buffer_1 <= measurement_end;
        measurement_end_buffer_2 <= measurement_end_buffer_1;
        counter_ready_buffer_1 <= counter_ready;
        counter_ready_buffer_2 <= counter_ready_buffer_1;
    end

    /*
    Counter front-end begins here
    used to interact with the input signal and reference clock
    */

    reg [15:0] pulse_count_internal;            //front-end measurement counter register, where counting happens and data stored before being pushed to the bus-facing register
    reg [23:0] range_count_internal;            //front-end measurement counter register, where counting happens and data stored before being pushed to the bus-facing register
    reg [1:0] measurement_state;       //state machine to indicate whether input signal rising edge is present or not
    reg [1:0] measurement_next_state;
    reg measurement_start_internal;                      //state of the measurement state machine from the last clock cycle
    reg measurement_done_internal;
    reg counter_ready;

    localparam STATE_READY = 0;
    localparam STATE_RANGE = 1;
    localparam STATE_PULSE = 2;
    localparam STATE_FINISH = 3;

    /*
    reg measurement_begin_buffer_1;
    reg measurement_begin_buffer_2;

    // buffer blocks here, it simply uses the incoming clock signal to propagates the input
    always @(posedge signal_input) begin
        measurement_begin_buffer_1 <= counter_control_reg[7];
        measurement_begin_buffer_2 <= measurement_begin_buffer_1;
    end
    */

    // Rising-Falling Edge Detector Block
    reg input_previous_state;
    wire rising_edge_detected = ~input_previous_state & signal_input;
    wire falling_edge_detected = input_previous_state & ~signal_input;

    always @(posedge CLK_I) begin
        input_previous_state <= signal_input; 
    end

    // Counter Outer FSM begins here
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1 or counter_control_status_register[RESET_COUNTER_BIT] == 1'b1) begin
            measurement_state <= STATE_READY;
        end
        else begin
            measurement_state <= measurement_next_state;
        end
    end

    // Ranging Mode FSM subroutine begins here
    reg trigger_signal_out;
    reg range_timeout_internal_flag;
    reg range_finished_internal_flag;
    reg pulse_timeout_internal_flag;
    reg [1:0] measurement_next_state_range;

    always @(posedge CLK_I) begin
        if (RST_I == 1'b1 or counter_control_status_register[RESET_COUNTER_BIT] == 1'b1) begin
            range_count_internal <= 24'd0;
            counter_ready <= 1'b0;
            measurement_start_internal <= 1'b0;
            measurement_range_done_internal <= 1'b0;
            range_finished_internal_flag <= 1'b0;
            range_timeout_internal_flag <= 1'b0;
        end
        else if (measurement_start_internal <= 1'b1) begin
            if (counter_control_status_register[MEASUREMENT_RANGE_MODE_ENABLE] == 1'b1) begin
                if (measurement_state == STATE_RANGE) begin
                    if (range_count_internal < 24'd11) begin
                        measurement_next_state_range <= STATE_RANGE;
                        range_count_internal <= range_count_internal + 1'b1;
                        trigger_signal_out <= 1'b1;
                    end
                    else if (range_count_internal >= 24'd714286) begin
                        measurement_next_state_range <= STATE_IDLE;
                        range_timeout_internal_flag <= 1'b1;
                    end
                    else if (rising_edge_detected == 1'b1) begin
                        measurement_next_state_range <= STATE_PULSE;
                        range_finished_internal_flag <= 1'b1;
                    end
                    else begin
                        range_count_internal <= range_count_internal + 1'b1;
                        trigger_signal_out <= 1'b0;
                        measurement_next_state_range <= STATE_RANGE;
                    end
                end
                else if (measurement_state == STATE_READY) begin
                    measurement_next_state_range <= STATE_RANGE;
                end
                else begin
                    measurement_next_state_range <= STATE_READY;
                end
            end
            else if (counter_control_status_register[MEASUREMENT_RANGE_MODE_ENABLE] == 1'b0) begin
                if (measurement_state == STATE_READY) begin
                    measurement_next_state_range <= STATE_PULSE
                end
            end
        end
    end

    // Pulse Mode FSM subroutine begins here
    always @(posedge signal_input) begin
        case (measurement_state_machine)
            16'd0 : begin
                if (rst_i == 1 || counter_reset_internal == 1) begin 
                    measurement_state_machine <= 16'd0;
                    counter_ready <= 1'b0;
                    measurement_began <= 1'b0;
                    measurement_end <= 1'b0;
                end else if (measurement_begin_buffer_2 == 1) begin
                    measurement_began <= 1'b1;
                    counter_ready <= 1'b0;
                    measurement_state_machine <= measurement_state_machine + 1'b1;
                end else begin
                    counter_ready <= 1'b1;
                    measurement_began <= 1'b0;
                    measurement_end <= 1'b0;
                    measurement_state_machine <= measurement_state_machine;
                end
            end
            16'd10000 : begin
                if (rst_i == 1 || ext_rst_i == 0 || counter_reset_internal == 1) begin 
                    measurement_state_machine <= 16'd0;
                end else if (measurement_begin_buffer_2 == 1'b0) begin
                    measurement_state_machine <= 16'd0;
                end else begin 
                    measurement_state_machine <= measurement_state_machine;
                    measurement_end <= 1'b1;
                end
            end
            default : begin 
                if (rst_i == 1 || ext_rst_i == 0 || counter_reset_internal == 1) begin 
                    measurement_state_machine <= 16'd0;
                end else measurement_state_machine <= measurement_state_machine + 1'b1;
            end
        endcase
    end

    //main clock measurement block here
    always @(posedge reference_clk_main) begin
        //push to bus-facing register if measurement is done
        if (rst_i == 1'b1 || counter_reset_internal == 1'b1) measurement_count_internal <= 32'd0;
        else if (measurement_began == 1'b1) begin 
            status[1] <= 1'b1;
		    if (measurement_end == 1'b1) begin
				measurement_count_internal <= measurement_count_internal;
            end else measurement_count_internal <= measurement_count_internal + 1'b1;
        end else begin 
            measurement_count_internal <= 32'd0;
            status[1] <= 1'b0;
        end
    end

    assign counter_reset_internal = counter_control_reg[0]; 
    //assign register_window = phase_count_intermediate;
endmodule  


//PR: 
// - working on the analysis of the FSM, whether it is capable of entering the unintended state or not
// - testing the behaviour of the module via simulation, for various condition
// - deciding whether the counter module is better to be separated futher as submodules or not