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


module wb_controller_fsm #(parameter WIDTH = 8) (
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
    output reg RTY_O,
    
    // module-specific signaling with regards to I2C 
    // (because its only purpose is to pipe data from I2C to WB and vice versa)
    input write_request_internal_flag,
    input received_data_internal_flag,

    );

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
                defaut : begin
                    wb_master_subroutine_iteration <= 2'd0;
                end
            endcase
        end
    end

    // Wishbone Interface of the I2C block
    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            // Reset everything!
            DAT_O <= 0;
            STB_O <= 1'b0;
            CYC_O <= 1'b0;
            WE_O <= 1'b0;
            wb_master_next_state <= WB_MASTER_STATE_IDLE;
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
                        else wb_master_next_state <= WB_MASTER_STATE_WRITE;
                    end
                    else if (write_request_internal_flag == 1'b1 && received_data_internal_flag == 1'b0) begin 
                        wb_master_next_state <= WB_MASTER_STATE_READ;
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
                            // place here to add ACK, ERR, or RTY behaviour
                        end
                        2'd2 : begin
                            // deassert everything
                            WE_O <= 1'b0;
                            CYC_O <= 1'b0;
                            STB_O <= 1'b0;
                            ADDR_O <= 8'd0;
                            send_data_buffer <= DAT_I;
                            DAT_O <= 8'd0;
                            // And increment the address pointer
                            addr_pointer_register_internal <= addr_pointer_register_internal + 1'b1;
                            // set the WB master next state to IDLE
                            wb_master_next_state <= WB_MASTER_STATE_IDLE;
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
                            // place here to add ACK, ERR, or RTY behaviour
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
                            // set the WB master next state to IDLE
                            wb_master_next_state <= WB_MASTER_STATE_IDLE;
                        end
                    endcase
                end
            endcase          
        end
    end


endmodule
