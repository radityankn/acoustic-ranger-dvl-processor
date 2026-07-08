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


module i2c_controller(
    input ext_clk,
    input i2c_data_in,
    input [7:0] addr_bus,
    input [31:0] data_in,
    output [31:0] data_in,
    input rw_signal,
    output i2c_data_out,
    output i2c_pin_ctrl,
    output i2c_pin_ctrl_n,
    input system_clk,
    input rst
    );
endmodule
