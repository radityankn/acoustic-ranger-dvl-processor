`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2026 01:09:04 AM
// Design Name: 
// Module Name: i2c_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module i2c_controller #(parameter WIDTH = 8) (
    input i2c_sda_in,
    output reg i2c_sda_out_pin_ctrl,
    output i2c_sda_out_pin_ctrl_n,
    input i2c_scl_in,
    input CLK_I,
    input RST_I,
    input [WIDTH-1:0] ADDR_I,
    input [WIDTH-1:0] DAT_I,
    output [WIDTH-1:0] DAT_O,
    input CYC_I,
    input STB_I,
    input WE_I,
    input ACK_I,
    input ERR_I,
    input RTY_I
    );

    // General Register that can be accessed through the bus
    // All registers are in MSB format
    // Contents : 
    // addr_set_register (0x01) --> used to set what address we need the module to respond to.
    //      - 8 bit wide, but only bit 6 to 0 that is used.
    // recv_data_buffer (0x02) --> used for WRITE process where we receive data
    //      - 8 bit wide, stored the received byte
    // send_data_buffer (0x03) --> used for READ process where we send data
    //      - 8 bit wide, stored the outgoing byte
    // ctrl_status_register (0x04) --> used to poll or set the operation of the module
    //      - bit 7: data received status, 1 means received data. poll this to see if we receive data
    //      - bit 6: data send status, 1 means send data done, 0 means in progress
    //      - bit 5: I2C read request, 1 means we need to send data, 0 means no action needed
    //      - bit 4: I2C write request, 1 means we need to receive data, 0 means no action needed
    //      - bit 3: I2C mode (MASTER/SLAVE) (coming soon! we won't need this for now)
    //      - bit 2: I2C master speed (coming soon! we won't need this for now)
    //      - bit 1: I2C master start send (coming soon! we won't need this for now)
    //      - bit 0: Reserved

    reg [7:0] addr_set_register;
    reg [7:0] recv_data_buffer;
    reg [7:0] send_data_buffer;
    reg [7:0] ctrl_status_register;

    // Start condition detector
    wire start_condition;
    assign start_condition = ~i2c_sda_in & i2c_scl_in;

    // Rising edge detector
    reg previous_state;
    wire rising_edge_detected;

    assign rising_edge_detected = ~previous_state & i2c_scl_in;
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) previous_state <= 1'b0;
        else previous_state <= i2c_scl_in;
    end

    // I2C State Machine
    localparam STATE_IDLE = 2'b00;
    localparam STATE_ADDR = 2'b01;
    localparam STATE_READ = 2'b10;
    localparam STATE_WRITE = 2'b11;

    reg [1:0] i2c_state;
    wire [1:0] i2c_next_state;
    always @(CLK_IN) begin
        if (RST_I == 1'b1) i2c_state <= STATE_IDLE;
        else i2c_state <= i2c_next_state;
    end 

    // I2C: Subroutine IDLE 
    reg [1:0] i2c_next_state_idle_block;
    always @(*) begin
        if (start_condition == 1'b1 && i2c_state == STATE_IDLE) i2c_next_state_idle_block = STATE_ADDR;
        else i2c_next_state_idle_block = 2'b00; 
    end

    // I2C: Subroutine ADDR
    reg [1:0] i2c_next_state_addr_block;
    reg [3:0] iteration;
    reg [7:0] address_data_buffer_internal;
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            i2c_next_state_addr_block <= 2'b00;
            iteration <= 4'd0;
        end
        else if (i2c_state == STATE_ADDR && rising_edge_detected == 1'b1) begin
            case (iteration)
                4'd0 : begin
                    address_data_buffer_internal[7] <= i2c_sda_in;
                    iteration <= iteration + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR;          
                end
                4'd1 : begin
                    address_data_buffer_internal[6] <= i2c_sda_in;
                    iteration <= iteration + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd2 : begin
                    address_data_buffer_internal[5] <= i2c_sda_in;
                    iteration <= iteration + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd3 : begin
                    address_data_buffer_internal[4] <= i2c_sda_in;
                    iteration <= iteration + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd4 : begin
                    address_data_buffer_internal[3] <= i2c_sda_in;
                    iteration <= iteration + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd5 : begin
                    address_data_buffer_internal[2] <= i2c_sda_in;
                    iteration <= iteration + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd6 : begin
                    address_data_buffer_internal[1] <= i2c_sda_in;
                    iteration <= iteration + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd7 : begin
                    address_data_buffer_internal[0] <= i2c_sda_in;
                    iteration <= iteration + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd8 : begin
                    // if the address is correct (means we're being called)
                    if (address_data_buffer_internal[7:1] == addr_set_register[6:0]) begin
                        // reset the subroutine FSM
                        iteration <= 4'd0;
                        // give the proper ACK to the line
                        i2c_sda_out_pin_ctrl <= 1'b1;
                        // the check the read/write bit
                        // if it's 1 (means I2C READ command is received a.k.a requesting data)...
                        if (address_data_buffer_internal[0] == 1) begin
                            i2c_next_state_addr_block <= STATE_READ;
                        end 
                        // if it's 0 (means I2C WRITE command is received a.k.a receiving data)...
                        else if (address_data_buffer_internal[0] == 1) begin
                            i2c_next_state_addr_block <= STATE_WRITE;
                        end
                    end else begin
                        // reset the subroutine FSM
                        iteration <= 4'd0;
                        // do not give the proper ACK to the line
                        i2c_sda_out_pin_ctrl <= 1'b0;
                    end
                end
            endcase
        end
        else begin
            iteration <= iteration;
            i2c_next_state_addr_block <= i2c_next_state_addr_block;
        end
    end

    // I2C: Subroutine READ
    reg [1:0] i2c_next_state_read_block;
    always @(posedge CLK_I) begin
        
    end

    // I2C: Subroutine WRITE
    reg [1:0] i2c_next_state_write_block;
    always @(posedge CLK_I) begin
        
    end

    //the grand next state block, OR'ed from all the subroutine
    assign i2c_next_state = i2c_next_state_idle_block | i2c_next_state_addr_block | i2c_next_state_read_block | i2c_next_state_write_block;

    // Assigning SDA out control port complement to its true counterpart
    assign i2c_sda_out_pin_ctrl_n = ~i2c_sda_out_pin_ctrl;

endmodule

// MASTER
// CLK_I
// RST_I
// ADDR_O[]
// DAT_I[]
// DAT_O[]
// CYC_O
// STB_O
// WE_O
// ACK_O
// ERR_O
// RTY_O