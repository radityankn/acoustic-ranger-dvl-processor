`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2026 01:09:04 AM
// Design Name: I2C Slave Controller Block
// Module Name: i2c_controller
// Project Name: 
// Target Devices: XC7Z010-CLG225-1 Zynq 7010
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
    output reg [WIDTH-1:0] DAT_O,
    input CYC_I,
    input STB_I,
    input WE_I,
    output reg ACK_O,
    output reg ERR_O,
    output reg RTY_O
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
    //      - bit 7: data received status, 1 means received data. Poll this to see if we receive data
    //      - bit 6: data send status, 1 means send data done, 0 means in progress
    //      - bit 5: I2C read request, 1 means we need to send data, 0 means no action needed
    //      - bit 4: I2C write request, 1 means we need to receive data, 0 means no action needed
    //      - bit 3: I2C mode (MASTER/SLAVE) (coming soon! we won't need this for now)
    //      - bit 2: I2C master speed (coming soon! we won't need this for now)
    //      - bit 1: I2C master start send (coming soon! we won't need this for now)
    //      - bit 0: Reserved

    // Registers of the I2C Blocks
    // The localparam is for defining the address of the I2C block's registers, please change it here in case
    // you need its address to be other than the default
    localparam [WIDTH-1:0] ADDR_SET_REGISTER_ADDRESS = 10;
    localparam [WIDTH-1:0] RECV_DATA_BUFFER_ADDRESS = 11;
    localparam [WIDTH-1:0] SEND_DATA_BUFFER_ADDRESS = 12;
    localparam [WIDTH-1:0] CTRL_STATUS_REGISTER_ADDRESS = 13;

    reg [7:0] addr_set_register;
    reg [7:0] recv_data_buffer;
    reg [7:0] send_data_buffer;
    reg [7:0] ctrl_status_register;

    // Wishbone Interface of the I2C block
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            // Reset everything!
            DAT_O <= 0;
            ERR_O <= 1'b0;
            ACK_O <= 1'b0;
            RTY_O <= 1'b0;
        end
        else if (RST_I == 1'b0 && CYC_I == 1'b1 && STB_I == 1'b1) begin
            if ((ACK_O | ERR_O | RTY_O) == 1'b0) begin
                case (ADDR_I)
                    ADDR_SET_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                        addr_set_register <= DAT_I;
                        ACK_O <= 1'b1;
                        end
                        else begin
                            DAT_O <= addr_set_register;
                            ACK_O <= 1'b1;
                        end
                    end
                    RECV_DATA_BUFFER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                        addr_set_register <= DAT_I;
                        ACK_O <= 1'b1;
                        end
                        else begin
                            DAT_O <= recv_data_buffer;
                            ACK_O <= 1'b1;
                        end
                    end
                    SEND_DATA_BUFFER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                        addr_set_register <= DAT_I;
                        ACK_O <= 1'b1;
                        end
                        else begin
                            DAT_O <= addr_set_register;
                            ACK_O <= 1'b1;
                        end
                    end
                    CTRL_STATUS_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                        addr_set_register <= DAT_I;
                        ACK_O <= 1'b1;
                        end
                        else begin
                            DAT_O <= addr_set_register;
                            ACK_O <= 1'b1;
                        end
                    end
                    default : begin
                        // Error, the register doesn't exist!
                        DAT_O <= 0;
                        ERR_O <= 1'b1;
                        ACK_O <= 1'b0;
                        RTY_O <= 1'b0;
                    end
                endcase
            end  
            else begin
                DAT_O <= 0;
                ERR_O <= 1'b0;
                ACK_O <= 1'b0;
                RTY_O <= 1'b0;
            end
        end
    end

    // Start-Stop condition detector
    reg sda_previous_state;
    wire start_condition;
    wire stop_condition;
    
    assign start_condition = sda_previous_state & ~i2c_sda_in & i2c_scl_in;
    assign stop_condition = ~sda_previous_state & i2c_sda_in & i2c_scl_in;
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) sda_previous_state <= 1'b0;
        else previous_state <= i2c_sda_in;
    end

    // Rising-Falling edge detector
    reg previous_state;
    wire rising_edge_detected;
    wire falling_edge_detected;

    assign rising_edge_detected = ~previous_state & i2c_scl_in;
    assign rising_edge_detected = previous_state & ~i2c_scl_in;
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
    reg [3:0] iteration_addr;
    reg [7:0] address_data_buffer_internal;
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            i2c_next_state_addr_block <= 2'b00;
            iteration_addr <= 4'd0;
        end
        else if (stop_condition == 1'b1) begin
            i2c_next_state_read_block <= STATE_IDLE;
            iteration_addr <= 4'd0;
        end
        else if (start_condition == 1'b1) begin
            i2c_next_state_read_block <= STATE_ADDR;
            iteration_addr <= 4'd0;
        end
        // The block below is used for nulling the state transition after ACK to ensure the OR'ed state remains correct
        else if (i2c_state != STATE_ADDR) begin
            // set next_state_addr_block (next state indicator from ADDR routine) to IDLE (basically 0) to allow others to prevail
            i2c_next_state_addr_block <= STATE_IDLE;
            // keep the routine iteration counter at 0
            iteration_addr <= 4'd0;
        end
        else if (i2c_state == STATE_ADDR && rising_edge_detected == 1'b1) begin
            case (iteration_addr)
                4'd0 : begin
                    address_data_buffer_internal[7] <= i2c_sda_in;
                    iteration_addr <= iteration_addr + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR;          
                end
                4'd1 : begin
                    address_data_buffer_internal[6] <= i2c_sda_in;
                    iteration_addr <= iteration_addr + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd2 : begin
                    address_data_buffer_internal[5] <= i2c_sda_in;
                    iteration_addr <= iteration_addr + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd3 : begin
                    address_data_buffer_internal[4] <= i2c_sda_in;
                    iteration_addr <= iteration_addr + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd4 : begin
                    address_data_buffer_internal[3] <= i2c_sda_in;
                    iteration_addr <= iteration_addr + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd5 : begin
                    address_data_buffer_internal[2] <= i2c_sda_in;
                    iteration_addr <= iteration_addr + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd6 : begin
                    address_data_buffer_internal[1] <= i2c_sda_in;
                    iteration_addr <= iteration_addr + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd7 : begin
                    address_data_buffer_internal[0] <= i2c_sda_in;
                    iteration_addr <= iteration_addr + 1'b1;
                    i2c_next_state_addr_block <= STATE_ADDR; 
                end
                4'd8 : begin
                    // if the address is correct (means we're being called)
                    if (address_data_buffer_internal[7:1] == addr_set_register[6:0]) begin
                        // reset the subroutine FSM
                        iteration_addr <= 4'd0;
                        // give the proper ACK to the line
                        i2c_sda_out_pin_ctrl <= 1'b1;
                        // the check the read/write bit
                        // if it's 1 (means I2C read command is received a.k.a requesting data --> must WRITE)...
                        if (address_data_buffer_internal[0] == 1) begin
                            i2c_next_state_addr_block <= STATE_WRITE;
                        end 
                        // if it's 0 (means I2C write command is received a.k.a receiving data --> must READ)...
                        else if (address_data_buffer_internal[0] == 1) begin
                            i2c_next_state_addr_block <= STATE_READ;
                        end
                    end else begin
                        // reset the subroutine FSM
                        iteration_addr <= 4'd0;
                        // do not give the proper ACK to the line
                        i2c_sda_out_pin_ctrl <= 1'b0;
                        // return to IDLE state
                        i2c_next_state_addr_block <= STATE_IDLE;
                    end
                end
            endcase
        end
        // When there is nothing else to look for (e.g. in-between states when waiting for rising edge)...
        else begin
            // Preserve the current state, all of it 
            iteration_addr <= iteration_addr;
            i2c_next_state_addr_block <= i2c_next_state_addr_block;
        end
    end

    // I2C: Subroutine READ (means READing from the bus, used in WRITE operation)
    reg [1:0] i2c_next_state_read_block;
    reg [3:0] iteration_read;
    
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            i2c_next_state_read_block <= STATE_IDLE;
            iteration_read <= 4'd0;
        end
        else if (stop_condition == 1'b1) begin
            i2c_next_state_read_block <= STATE_IDLE;
            iteration_read <= 4'd0;
        end
        else if (start_condition == 1'b1) begin
            i2c_next_state_read_block <= STATE_ADDR;
            iteration_read <= 4'd0;
        end
        // The block below is used for nulling the state transition after ACK to ensure the OR'ed state remains correct
        else if (i2c_state != STATE_ADDR) begin
            // set next_state_addr_block (next state indicator from ADDR routine) to IDLE (basically 0) to allow others to prevail
            i2c_next_state_addr_block <= STATE_IDLE;
            // keep the routine iteration counter at 0
            iteration_read <= 4'd0;
        end
        else if (i2c_state == STATE_READ && rising_edge_detected == 1'b1) begin
            case (iteration_read)
                4'd0 : begin
                    recv_data_buffer[7] <= i2c_sda_in;
                    iteration_read <= iteration_read + 1'b1;
                    i2c_next_state_read_block <= STATE_READ;          
                end
                4'd1 : begin
                    recv_data_buffer[6] <= i2c_sda_in;
                    iteration_read <= iteration_read + 1'b1;
                    i2c_next_state_read_block <= STATE_READ; 
                end
                4'd2 : begin
                    recv_data_buffer[5] <= i2c_sda_in;
                    iteration_read <= iteration_read + 1'b1;
                    i2c_next_state_read_block <= STATE_READ; 
                end
                4'd3 : begin
                    recv_data_buffer[4] <= i2c_sda_in;
                    iteration_read <= iteration_read + 1'b1;
                    i2c_next_state_read_block <= STATE_READ; 
                end
                4'd4 : begin
                    recv_data_buffer[3] <= i2c_sda_in;
                    iteration_read <= iteration_read + 1'b1;
                    i2c_next_state_read_block <= STATE_READ; 
                end
                4'd5 : begin
                    recv_data_buffer[2] <= i2c_sda_in;
                    iteration_read <= iteration_read + 1'b1;
                    i2c_next_state_read_block <= STATE_READ; 
                end
                4'd6 : begin
                    recv_data_buffer[1] <= i2c_sda_in;
                    iteration_read <= iteration_read + 1'b1;
                    i2c_next_state_read_block <= STATE_READ; 
                end
                4'd7 : begin
                    recv_data_buffer[0] <= i2c_sda_in;
                    iteration_read <= iteration_read + 1'b1;
                    i2c_next_state_read_block <= STATE_READ; 
                end
                4'd8 : begin
                    iteration_read <= 4'd0;
                    // give the proper ACK to the line
                    i2c_sda_out_pin_ctrl <= 1'b1;
                end
            endcase
        end
        else begin
            iteration_read <= iteration_read;
            i2c_next_state_addr_block <= i2c_next_state_addr_block;
        end
    end

    // I2C: Subroutine WRITE (means WRITEing to the bus, used in READ operation)
    // WRITE will be a little complex, because we need to time it properly so it doesn't violate setup/hold
    // time of the I2C bus. Hence why the 4 if/else case because we cannot rely solely on the SCL rising edge to transmit
    // data
    //
    // We still figuring out how to do it properly without the area exploding
    // the falling edge delayer basically delay the signal from the detector above by 3 clock cycle
    // detector reg --> FF0 --> FF1 --> always @() block

    reg [1:0] i2c_next_state_write_block;
    reg [1:0] falling_edge_delayer;
    reg [3:0] iteration_write;
    wire falling_edge_detected_delayed;
    reg write_request_flag_internal;

    assign falling_edge_detected_delayed = falling_edge_delayer[1];
    always @(posedge CLK_I) begin
        falling_edge_delayer[0] <= falling_edge_detected;
        falling_edge_delayer[1] <= falling_edge_delayer[0];
        if (RST_I == 1'b1) begin
            i2c_next_state_addr_block <= 2'b00;
            iteration_write <= 4'd0;
        end
        else if (stop_condition == 1'b1) begin
            i2c_next_state_write_block <= STATE_IDLE;
            iteration_write <= 4'd0;
        end
        else if (start_condition == 1'b1) begin
            i2c_next_state_write_block <= STATE_ADDR;
            iteration_write <= 4'd0;
        end
        // The block below is used for nulling the state transition after ACK to ensure the OR'ed state remains correct
        else if (i2c_state != STATE_ADDR) begin
            // set next_state_addr_block (next state indicator from ADDR routine) to IDLE (basically 0) to allow others to prevail
            i2c_next_state_addr_block <= STATE_IDLE;
            // keep the routine iteration counter at 0
            iteration_write <= 4'd0;
        end
        else if (i2c_state == STATE_WRITE && falling_edge_detected_delayed == 1'b1) begin
            case (iteration_write)
                4'd0 : begin
                    i2c_sda_out_pin_ctrl <= send_data_buffer[7];
                    iteration_write <= iteration_write;
                    i2c_next_state_write_block <= STATE_WRITE;          
                end
                4'd1 : begin
                    i2c_sda_out_pin_ctrl <= send_data_buffer[6];
                    iteration_write <= iteration_write;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd2 : begin
                    i2c_sda_out_pin_ctrl <= send_data_buffer[5];
                    iteration_write <= iteration_write;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd3 : begin
                    i2c_sda_out_pin_ctrl <= send_data_buffer[4];
                    iteration_write <= iteration_write;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd4 : begin
                    i2c_sda_out_pin_ctrl <= send_data_buffer[3];
                    iteration_write <= iteration_write;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd5 : begin
                    i2c_sda_out_pin_ctrl <= send_data_buffer[2];
                    iteration_write <= iteration_write;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd6 : begin
                    i2c_sda_out_pin_ctrl <= send_data_buffer[1];
                    iteration_write <= iteration_write;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd7 : begin
                    i2c_sda_out_pin_ctrl <= send_data_buffer[0];
                    iteration_write <= iteration_write;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd8 : begin
                    // do not do anything, except changing SDA to 0. we will sample the host ACK
                    // when it is in rising edge
                    iteration_write <= iteration_write;
                    i2c_next_state_write_block <= i2c_next_state_write_block;
                    i2c_sda_out_pin_ctrl <= 1'b0;                
                end
            endcase
        end
        // Here is the block to increment the bit pointer in rising edge, but keep the SDA line fixed until SCL falling edge
        // It is said that this is ridiculously long, we might be able to get shorter code with C-style looping
        else if (i2c_state == STATE_WRITE && rising_edge_detected == 1'b1) begin
            case (iteration_write)
                4'd0 : begin
                    i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                    iteration_write <= iteration_write + 1'b1;
                    i2c_next_state_write_block <= STATE_WRITE;          
                end
                4'd1 : begin
                    i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                    iteration_write <= iteration_write + 1'b1;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd2 : begin
                    i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                    iteration_write <= iteration_write + 1'b1;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd3 : begin
                    i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                    iteration_write <= iteration_write + 1'b1;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd4 : begin
                    i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                    iteration_write <= iteration_write + 1'b1;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd5 : begin
                    i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                    iteration_write <= iteration_write + 1'b1;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd6 : begin
                    i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                    iteration_write <= iteration_write + 1'b1;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd7 : begin
                    i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                    iteration_write <= iteration_write + 1'b1;
                    i2c_next_state_write_block <= STATE_WRITE; 
                end
                4'd8 : begin
                    // If host is ACK, keep in WRITE state
                    if (i2c_sda_in == 1'b0) begin
                        i2c_next_state_write_block <= STATE_WRITE;
                        
                        iteration_write <= 4'd0;
                        i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                    end
                    // If host is NAK, go to IDLE state (because usually it will be stopped)
                    else begin
                        i2c_next_state_write_block <= STATE_IDLE;
                        iteration_write <= 4'd0;
                        i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                    end
                end
            endcase
        end
        else begin
            iteration_write <= iteration_write;
            i2c_next_state_addr_block <= i2c_next_state_addr_block;
            i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
        end
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
