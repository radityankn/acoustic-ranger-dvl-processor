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
    output reg [WIDTH-1:0] ADDR_O,
    input [WIDTH-1:0] DAT_I,
    output reg [WIDTH-1:0] DAT_O,
    output reg CYC_O,
    output reg STB_O,
    output reg WE_O,
    input ACK_I,
    input ERR_I,
    input RTY_I
    );

    // General Register that can be accessed through the bus
    // All registers are in MSB format
    // Contents : 
    // addr_set_register (0x0A) --> used to set what address we need the module to respond to.
    //      - 8 bit wide, but only bit 7 to 1 that is used. default to 0xAA (W) / 0xAB (R) when reset
    // recv_data_buffer (0x0B) --> used for WRITE process where we receive data
    //      - 8 bit wide, stored the received byte
    // send_data_buffer (0x0C) --> used for READ process where we send data
    //      - 8 bit wide, stored the outgoing byte
    // whoami register (0x0D) --> used for sanity checks and checking I2C functionality
    //      - 8 bit wide, read-only, always return 0xDE when read 

    // Registers of the I2C Blocks
    // The localparam is for defining the address of the I2C block's registers, please change it here in case
    // you need its address to be other than the default
    localparam [WIDTH-1:0] ADDR_SET_REGISTER_ADDRESS = 10;
    localparam [WIDTH-1:0] RECV_DATA_BUFFER_ADDRESS = 11;
    localparam [WIDTH-1:0] SEND_DATA_BUFFER_ADDRESS = 12;
    localparam [WIDTH-1:0] WHOAMI_REGISTER_ADDRESS = 13;

    reg [7:0] addr_set_register;
    reg [7:0] recv_data_buffer;
    reg [7:0] send_data_buffer;
    reg [7:0] addr_pointer_register_internal;

    reg [1:0] wb_master_state;
    reg [1:0] wb_master_next_state;
    reg [1:0] wb_master_subroutine_iteration;
    reg last_operation_internal_flag;

    localparam [1:0] WB_MASTER_STATE_IDLE = 0;
    localparam [1:0] WB_MASTER_STATE_READ = 1;
    localparam [1:0] WB_MASTER_STATE_WRITE = 2;

    reg write_request_internal_flag;
    reg received_data_internal_flag;
    reg read_request_internal_flag;
    reg register_addr_data_flag;
    reg register_content_data_flag;

    //Wishbone interface master FSM, for easier state management
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            wb_master_state <= WB_MASTER_STATE_IDLE;
        end
        else begin
            wb_master_state <= wb_master_next_state;
        end
    end

    //Wishbone interface subroutine iteration FSM
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            wb_master_subroutine_iteration <= 2'd0;
        end
        else begin
            case (wb_master_state)
                WB_MASTER_STATE_IDLE : begin
                    wb_master_subroutine_iteration <= 2'd0;
                end
                WB_MASTER_STATE_READ : begin
                    wb_master_subroutine_iteration <= wb_master_subroutine_iteration + 1'b1;
                    if (wb_master_subroutine_iteration == 2'd2) wb_master_subroutine_iteration <= 2'd0;
                end
                WB_MASTER_STATE_WRITE : begin
                    wb_master_subroutine_iteration <= wb_master_subroutine_iteration + 1'b1;
                    if (wb_master_subroutine_iteration == 2'd2) wb_master_subroutine_iteration <= 2'd0;
                end
                // defaut : begin
                //     wb_master_subroutine_iteration <= 2'd0;
                // end
            endcase
        end
    end

    // Wishbone Interface of the I2C block
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            // Reset everything!
            ADDR_O <= 0;
            DAT_O <= 0;
            STB_O <= 1'b0;
            CYC_O <= 1'b0;
            WE_O <= 1'b0;
            wb_master_next_state <= WB_MASTER_STATE_IDLE;
            addr_set_register <= 8'hAA;
        end
        // here is the management part of the wishbone interface. It will issue register read/write based on 
        // what it receives through the I2C
        else begin
            case (wb_master_state)  
                WB_MASTER_STATE_IDLE : begin
                    if (received_data_internal_flag == 1'b1 && write_request_internal_flag == 1'b0) begin 
                        if (register_addr_data_flag == 1'b1 && register_content_data_flag == 1'b0) begin
                            addr_pointer_register_internal <= recv_data_buffer;
                            wb_master_next_state <= WB_MASTER_STATE_IDLE;
                        end 
                        else begin
                            case (addr_pointer_register_internal)
                                ADDR_SET_REGISTER_ADDRESS : begin
                                    addr_set_register <= recv_data_buffer;
                                    wb_master_next_state <= WB_MASTER_STATE_IDLE;
                                    addr_pointer_register_internal <= addr_pointer_register_internal + 1'b1;
                                end
                                RECV_DATA_BUFFER_ADDRESS : begin
                                    // don't do anything, it's pointless to write a receive buffer from WB
                                    wb_master_next_state <= WB_MASTER_STATE_IDLE;
                                    addr_pointer_register_internal <= addr_pointer_register_internal + 1'b1;
                                end
                                SEND_DATA_BUFFER_ADDRESS : begin
                                    send_data_buffer <= recv_data_buffer;
                                    wb_master_next_state <= WB_MASTER_STATE_IDLE;
                                    addr_pointer_register_internal <= addr_pointer_register_internal + 1'b1;
                                end
                                WHOAMI_REGISTER_ADDRESS : begin
                                    // don't do anything, it's pointless to write a receive buffer from WB
                                    wb_master_next_state <= WB_MASTER_STATE_IDLE;
                                    addr_pointer_register_internal <= addr_pointer_register_internal + 1'b1;
                                end
                                default : begin
                                    wb_master_next_state <= WB_MASTER_STATE_WRITE;
                                end
                            endcase
                        end 
                    end
                    else if (received_data_internal_flag == 1'b0 && write_request_internal_flag == 1'b1) begin 
                        case (addr_pointer_register_internal)
                            ADDR_SET_REGISTER_ADDRESS : begin
                                send_data_buffer <= addr_set_register;
                                wb_master_next_state <= WB_MASTER_STATE_IDLE;
                                addr_pointer_register_internal <= addr_pointer_register_internal + 1'b1;
                            end
                            RECV_DATA_BUFFER_ADDRESS : begin
                                send_data_buffer <= recv_data_buffer;
                                wb_master_next_state <= WB_MASTER_STATE_IDLE;
                                addr_pointer_register_internal <= addr_pointer_register_internal + 1'b1;
                            end
                            SEND_DATA_BUFFER_ADDRESS : begin
                                // don't do anything
                                wb_master_next_state <= WB_MASTER_STATE_IDLE;
                                addr_pointer_register_internal <= addr_pointer_register_internal + 1'b1;
                            end
                            WHOAMI_REGISTER_ADDRESS : begin
                                send_data_buffer <= 8'hDE; // Chip identification and sanity check
                                wb_master_next_state <= WB_MASTER_STATE_IDLE;
                                addr_pointer_register_internal <= addr_pointer_register_internal + 1'b1;
                            end
                            default : begin
                                wb_master_next_state <= WB_MASTER_STATE_READ;
                            end
                        endcase
                    end
                end
                WB_MASTER_STATE_READ : begin
                    case (wb_master_subroutine_iteration)
                        2'd0 : begin
                            // handshake begin with CYC_O and STB_O, as well as target in ADDR_O and R/W operation in WE_O
                            WE_O <= 1'b0;
                            CYC_O <= 1'b1;
                            STB_O <= 1'b1;
                            ADDR_O <= addr_pointer_register_internal;
                            DAT_O <= 8'd0;
                        end
                        2'd1 : begin
                            // Wait for slave acknowledgement
                            WE_O <= 1'b0;
                            CYC_O <= 1'b1;
                            STB_O <= 1'b1;
                            ADDR_O <= addr_pointer_register_internal;
                            DAT_O <= 8'd0;
                            // set the WB master next state to IDLE
                            wb_master_next_state <= WB_MASTER_STATE_IDLE;
                        end
                        2'd2 : begin
                            // deassert everything
                            WE_O <= 1'b0;
                            CYC_O <= 1'b0;
                            STB_O <= 1'b0;
                            ADDR_O <= 8'd0;
                            // place here to add ACK, ERR, or RTY behaviour
                            if (ACK_I == 1'b1) send_data_buffer <= DAT_I;
                            else send_data_buffer <= 8'b0;
                            DAT_O <= 8'd0;
                            // And increment the address pointer
                            addr_pointer_register_internal <= addr_pointer_register_internal + 1'b1;
                        end
                    endcase
                end
                WB_MASTER_STATE_WRITE : begin
                    case (wb_master_subroutine_iteration)
                        2'd0 : begin
                            // handshake begin with CYC_O and STB_O, as well as target in ADDR_O and R/W operation in WE_O
                            WE_O <= 1'b1;
                            CYC_O <= 1'b1;
                            STB_O <= 1'b1;
                            ADDR_O <= addr_pointer_register_internal;
                            DAT_O <= recv_data_buffer;
                        end
                        2'd1 : begin
                            // Wait for slave acknowledgement
                            WE_O <= 1'b1;
                            CYC_O <= 1'b1;
                            STB_O <= 1'b1;
                            ADDR_O <= addr_pointer_register_internal;
                            DAT_O <= recv_data_buffer;
                            // set the WB master next state to IDLE
                            wb_master_next_state <= WB_MASTER_STATE_IDLE;
                        end
                        2'd2 : begin
                            // deassert everything
                            WE_O <= 1'b0;
                            CYC_O <= 1'b0;
                            STB_O <= 1'b0;
                            ADDR_O <= 8'd0;
                            DAT_O <= 8'd0;
                            // And increment the address pointer
                            addr_pointer_register_internal <= addr_pointer_register_internal + 1'b1;
                            // place here to add ACK, ERR, or RTY behaviour
                        end
                    endcase
                end
            endcase          
        end
    end

    //SDA and SCL synchroniser
    reg [1:0] scl_synchroniser_internal;
    reg [1:0] sda_synchroniser_internal;

    wire i2c_sda_in_synchronised_internal;
    wire i2c_scl_in_synchronised_internal;

    assign i2c_sda_in_synchronised_internal = sda_synchroniser_internal[1];
    assign i2c_scl_in_synchronised_internal = scl_synchroniser_internal[1];

    always @(posedge CLK_I) begin
        scl_synchroniser_internal <= {scl_synchroniser_internal[0],i2c_scl_in};
        sda_synchroniser_internal <= {sda_synchroniser_internal[0],i2c_sda_in};
    end

    // Start-Stop condition detector
    reg sda_previous_state;
    wire start_condition;
    wire stop_condition;
    
    assign start_condition = sda_previous_state & ~i2c_sda_in_synchronised_internal & i2c_scl_in_synchronised_internal;
    assign stop_condition = ~sda_previous_state & i2c_sda_in_synchronised_internal & i2c_scl_in_synchronised_internal;

    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) sda_previous_state <= 1'b0;
        else sda_previous_state <= i2c_sda_in_synchronised_internal;
    end

    // Rising-Falling edge detector
    reg previous_state;
    reg rising_edge_detected;
    reg falling_edge_detected;

    
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) previous_state <= 1'b0;
        else previous_state <= i2c_scl_in_synchronised_internal;

        rising_edge_detected <= ~previous_state & i2c_scl_in_synchronised_internal;
        falling_edge_detected <= previous_state & ~i2c_scl_in_synchronised_internal;
    end

    // I2C State Machine
    localparam STATE_IDLE = 2'b00;
    localparam STATE_ADDR = 2'b01;
    localparam STATE_READ = 2'b10;
    localparam STATE_WRITE = 2'b11;

    reg [1:0] i2c_state;
    wire [1:0] i2c_next_state;
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) i2c_state <= STATE_IDLE;
        else i2c_state <= i2c_next_state;
    end 

    // I2C: Subroutine ADDR, READ, WRITE in one iteration
    reg [1:0] i2c_next_state_routine_block;
    reg [3:0] iteration;
    reg [7:0] address_data_buffer_internal;
    // reg [1:0] falling_edge_delayer;
    // reg [3:0] iteration_write;
    
    // always @(posedge CLK_I) begin
    //     falling_edge_delayer[0] <= falling_edge_detected;
    //     falling_edge_delayer[1] <= falling_edge_delayer[0];
    // end

    // wire falling_edge_detected_delayed;
    // assign falling_edge_detected_delayed = falling_edge_delayer[1];

    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            i2c_next_state_routine_block <= STATE_IDLE;
            iteration <= 4'd0;
            register_addr_data_flag <= 1'b0;
            register_content_data_flag <= 1'b0;
        end
        else if (stop_condition == 1'b1) begin
            i2c_next_state_routine_block <= STATE_IDLE;
            iteration <= 4'd0;
            register_addr_data_flag <= 1'b0;
            register_content_data_flag <= 1'b0;
            i2c_sda_out_pin_ctrl <= 1'b1;
        end
        else if (start_condition == 1'b1) begin
            i2c_next_state_routine_block <= STATE_ADDR;
            iteration <= 4'd0;
            register_addr_data_flag <= 1'b0;
            register_content_data_flag <= 1'b0;
            i2c_sda_out_pin_ctrl <= 1'b1;
        end
        else begin
            case(i2c_state)
                STATE_ADDR : begin
                    // Let's sample all the bits
                    if (rising_edge_detected == 1'b1 && iteration < 8) begin
                        // sample the data from sda input line
                        address_data_buffer_internal <= {address_data_buffer_internal[6:0], i2c_sda_in_synchronised_internal};
                        // increment the iteration counter to iterate through all bits
                        iteration <= iteration + 1'b1;
                        // keep the current state until the last bit
                        i2c_next_state_routine_block <= STATE_ADDR;
                    end
                    // When every bit has been sampled...
                    else if (falling_edge_detected == 1'b1 && iteration == 8) begin
                        // if the address is correct... (only 7-bit address is supported)
                        if (address_data_buffer_internal[7:1] == addr_set_register[7:1]) begin
                            // reset the subroutine FSM
                            iteration <= iteration + 1'b1;
                            // give the proper ACK to the line
                            i2c_sda_out_pin_ctrl <= 1'b0;
                            // hold the state until the 9th bit ends
                            i2c_next_state_routine_block <= STATE_ADDR;
                        end else begin
                            // reset the subroutine FSM
                            iteration <= 4'd0;
                            // do not give the proper ACK to the line
                            i2c_sda_out_pin_ctrl <= 1'b1;
                            // return to IDLE state
                            i2c_next_state_routine_block <= STATE_IDLE;
                        end
                    end
                    // then check the read/write bit on the next iteration
                    // if it is falling edge and R/W bit is 0 (means I2C write command is received a.k.a receiving data --> must READ)...
                    else if (falling_edge_detected == 1'b1 && iteration == 9) begin
                        if (address_data_buffer_internal[0] == 0) begin
                            // return the line to default condition before proceeding to the next state
                            i2c_sda_out_pin_ctrl <= 1'b1;
                            // return the iteration FSM to zero (reset)
                            iteration <= 4'd0;
                            // Go to the next state
                            i2c_next_state_routine_block <= STATE_READ;
                            // give proper signal for the correct flag line
                            read_request_internal_flag <= 1'b1;
                        end
                    end
                    // if it is falling edge and R/W bit is 1 (means I2C read command is received a.k.a requesting data --> must WRITE)...
                    else if (rising_edge_detected == 1'b1 && iteration == 9) begin
                        if (address_data_buffer_internal[0] == 1) begin
                            // keep I2C line ACK as-is
                            i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                            // reset the iteration FSM
                            iteration <= 4'd0;
                            // Go to the next state
                            i2c_next_state_routine_block <= STATE_WRITE;
                            // give proper signal for the correct flag line
                            write_request_internal_flag <= 1'b1;
                        end 
                    end
                    else begin
                        // preserve current state
                        iteration <= iteration;
                        i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                        i2c_next_state_routine_block <= i2c_next_state_routine_block;
                        // de-assert flags
                        read_request_internal_flag <= 1'b0;
                        write_request_internal_flag <= 1'b0;
                    end
                end
                STATE_READ : begin
                    // Let's sample all the bits
                    if (rising_edge_detected == 1'b1 && iteration < 4'd8) begin
                        // sample the data from sda input line
                        recv_data_buffer <= {recv_data_buffer[6:0], i2c_sda_in_synchronised_internal};
                        // increment the iteration counter to iterate through all bits
                        iteration <= iteration + 1'b1;
                        // keep the current state until the last bit
                        i2c_next_state_routine_block <= STATE_READ;
                    end
                    // When every bit has been sampled...
                    else if (falling_edge_detected == 1'b1 && iteration == 8) begin
                        if (register_addr_data_flag == 1'b0) begin
                            // reset the subroutine FSM
                            iteration <= iteration + 1;
                            // give the proper ACK to the line
                            i2c_sda_out_pin_ctrl <= 1'b0;
                            i2c_next_state_routine_block <= STATE_READ;
                            received_data_internal_flag <= 1'b1;
                            register_addr_data_flag <= 1'b1;
                        end
                        else begin
                            // reset the subroutine FSM
                            iteration <= iteration + 1;
                            // give the proper ACK to the line
                            i2c_sda_out_pin_ctrl <= 1'b0;
                            i2c_next_state_routine_block <= STATE_READ;
                            received_data_internal_flag <= 1'b1;
                            register_content_data_flag <= 1'b1;
                        end
                    end 
                    else if (falling_edge_detected == 1'b1 && iteration == 9) begin
                        i2c_sda_out_pin_ctrl <= 1'b1;
                        iteration <= 4'd0;
                    end
                    else begin
                        // keep current state of all IO
                        iteration <= iteration;
                        i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                        i2c_next_state_routine_block <= i2c_next_state_routine_block;
                        // de-assert flag
                        received_data_internal_flag <= 1'b0;
                        register_addr_data_flag <= register_addr_data_flag;
                        register_content_data_flag <= register_content_data_flag;
                    end
                end
                STATE_WRITE : begin
                    if (rising_edge_detected == 1'b1 && iteration < 8) begin
                        i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                        // increment the iteration counter to iterate through all bits
                        iteration <= iteration + 1'b1;
                        // keep the current state until the last bit
                        i2c_next_state_routine_block <= STATE_WRITE;
                    end
                    else if (falling_edge_detected == 1'b1 && iteration < 8) begin
                        // only change SDA line when SCL is low
                        i2c_sda_out_pin_ctrl <= send_data_buffer[7-iteration];
                        iteration <= iteration;
                        i2c_next_state_routine_block <= i2c_next_state_routine_block;
                    end
                    else if (falling_edge_detected == 1'b1 && iteration == 8) begin
                        // release SDA line for ACK sampling
                        i2c_sda_out_pin_ctrl <= 1'b1;
                        iteration <= iteration;
                        i2c_next_state_routine_block <= i2c_next_state_routine_block;
                    end
                    // When every bit has been sampled...
                    else if (rising_edge_detected == 1'b1 && iteration == 8) begin
                        // if host is ACK (means still in write or keep sending data)
                        if (i2c_sda_in_synchronised_internal == 1'b0) begin
                            // reset the subroutine FSM
                            iteration <= 4'd0;
                            // set the flag
                            write_request_internal_flag <= 1'b1;
                            // Keep on WRITE
                            i2c_next_state_routine_block <= STATE_WRITE;
                        end
                        // if host NACK (usually this means terminating sequence) 
                        else begin
                            // reset the subroutine FSM
                            iteration <= 4'd0;
                            // de-assert flag
                            write_request_internal_flag <= 1'b0;
                            // return to IDLE state
                            i2c_next_state_routine_block <= STATE_IDLE;
                        end
                    end
                    else begin
                        // Keep current state of all IO, as well as de-assert flag
                        iteration <= iteration;
                        i2c_sda_out_pin_ctrl <= i2c_sda_out_pin_ctrl;
                        i2c_next_state_routine_block <= i2c_next_state_routine_block;
                        // de-assert flag
                        write_request_internal_flag <= 1'b0;
                    end
                end 
            endcase
        end
    end
            
    // The grand next state block, OR'ed from all the subroutine
    // assign i2c_next_state = i2c_next_state_idle_block | i2c_next_state_routine_block;
    assign i2c_next_state = i2c_next_state_routine_block;

    // Assigning SDA out control port complement to its true counterpart
    assign i2c_sda_out_pin_ctrl_n = ~i2c_sda_out_pin_ctrl;

    // Assign flags to ensure it is OR'ed, both read and write requests 
    // assign 

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
