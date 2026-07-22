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
    input rst_i,
    input clk_i,
    input [WIDTH-1:0] addr_i,
    input [WIDTH-1:0] dat_i,
    input we_i,
    // input [3:0] sel_i,
    input cyc_i,
    input stb_i,
    input lock_i,
    // input tagn_i,
    input signal_input,
    output reg [WIDTH-1:0] dat_o,
    output reg err_o,
    output reg rty_o,
    output reg ack_o,
    );

    // General Register that can be accessed through the bus
    // All registers are in MSB format
    // Contents : 
    // range_count_register (0x0E and 0x0F) --> used to set what address we need the module to respond to.
    //      - 8 bit wide, but only bit 6 to 0 that is used.
    // pulse_count_register (0x10 and 0x11) --> used for WRITE process where we receive data
    //      - 8 bit wide, stored the received byte
    // pulse_count_threshold_register (0x12 and 0x13) --> used for READ process where we send data
    //      - 8 bit wide, stored the outgoing byte
    // counter_control_status_register (0x14) --> used to poll or set the operation of the module
    //      - bit 7: measurement start bit. Set this to start measuring, automatically cleared once finished
    //      - bit 6: measurement done bit. Automatically set upon measurement completion. please clear manually
    //      - bit 5: measurement range mode enable. Set this to enable ranging mode, clear to disable it
    //      - bit 4: measurement pulse mode enable. Set this to enable doppler mode, clear to disable it
    //      - bit 3: I2C master speed (coming soon! we won't need this for now)
    //      - bit 2: Reserved
    //      - bit 1: Reserved
    //      - bit 0: Reserved

    // Registers of the I2C Blocks
    // The localparam is for defining the address of the I2C block's registers, please change it here in case
    // you need its address to be other than the default
    localparam [WIDTH-1:0] RANGE_COUNT_REGISTER_HIGH_ADDRESS = 14;
    localparam [WIDTH-1:0] RANGE_COUNT_REGISTER_LOW_ADDRESS = 15;
    localparam [WIDTH-1:0] PULSE_COUNT_REGISTER_HIGH_ADDRESS = 16;
    localparam [WIDTH-1:0] PULSE_COUNT_REGISTER_LOW_ADDRESS = 17;
    localparam [WIDTH-1:0] PULSE_COUNT_THRESHOLD_REGISTER_HIGH_ADDRESS = 18;
    localparam [WIDTH-1:0] PULSE_COUNT_THRESHOLD_REGISTER_LOW_ADDRESS = 19;
    localparam [WIDTH-1:0] COUNTER_CONTROL_STATUS_REGISTER_ADDRESS = 20;

    reg [15:0] range_count_register;
    reg [15:0] pulse_count_register;
    reg [15:0] pulse_count_threshold_register;
    reg [7:0] counter_control_status_register;

    // Wishbone Interface of the Counter block
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
    reg [15:0] range_count_internal;            //front-end measurement counter register, where counting happens and data stored before being pushed to the bus-facing register
    reg [15:0] measurement_state_machine;       //state machine to indicate whether input signal rising edge is present or not
    reg measurement_began;                      //state of the measurement state machine from the last clock cycle
    reg measurement_end;                        //register of whether a measurement has been done or not, useful when waiting for rising edge
    reg counter_ready;

    reg measurement_begin_buffer_1;
    reg measurement_begin_buffer_2;

    // buffer blocks here, it simply uses the incoming clock signal to propagates the input
    always @(posedge signal_input) begin
        measurement_begin_buffer_1 <= counter_control_reg[7];
        measurement_begin_buffer_2 <= measurement_begin_buffer_1;
    end

    // Ranging Mode FSM begins here
    always @(posedge CLK_I) begin
        // TBD
    end

    // Pulse Counter State Machine begin here
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