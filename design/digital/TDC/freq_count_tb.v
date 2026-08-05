`timescale 10ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:43:37 02/20/2025
// Design Name:   frequency_counter
// Module Name:   /home/raditya/Documents/Projects/Coding/Verilog/frequency_counter/freq_count_tb.v
// Project Name:  frequency_counter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: frequency_counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module freq_count_tb;

    localparam SIGNAL_PERIOD = 40;
    localparam WIDTH = 8;

    // Inputs for the module
    reg signal_input;
    reg CLK_I;
    reg RST_I;
    reg [WIDTH-1:0] ADDR_I;
    reg [WIDTH-1:0] DAT_I;
    reg CYC_I;
    reg STB_I;
    reg WE_I;

    // Outputs for the module
	wire trigger_signal_out;
    wire [WIDTH-1:0] DAT_O;
    wire ACK_O;
    wire ERR_O;
    wire RTY_O;

    frequency_counter #(.WIDTH(WIDTH)) my_counter (
		.RST_I(RST_I),
		.CLK_I(CLK_I),
		.ADDR_I(ADDR_I),
		.DAT_I(DAT_I),
		.WE_I(WE_I),
		.CYC_I(CYC_I),
		.STB_I(STB_I),
		.signal_input(signal_input),
		.trigger_signal_out(trigger_signal_out),
		.DAT_O(DAT_O),
		.ERR_O(ERR_O),
		.RTY_O(RTY_O),
		.ACK_O(ACK_O)
    );
    
    // I2C tasks
    task simulate_return_ping;
		integer i;
		input integer multiplier;
		begin
			for (i = 0;i < 1020;i++) begin
				signal_input <= ~signal_input;
				#(SIGNAL_PERIOD*(0.5*multiplier));
			end
		end
    endtask

    // WB Tasks
    task wb_write_register;
        input [7:0] target_addr;
        input [7:0] target_data;
        input continue_cycle;
        begin
            wait (CLK_I == 0);
            wait (CLK_I == 1);
            ADDR_I <= target_addr;
            DAT_I <= target_data;
            WE_I <= 1;
            STB_I <= 1;
            CYC_I <= 1;
            wait (CLK_I == 0);
            wait (CLK_I == 1);
            wait (CLK_I == 0);
            wait (CLK_I == 1);
            if (ACK_O == 1'b1) begin
                STB_I <= 0;
                CYC_I <= continue_cycle;
                WE_I <= 0;
                DAT_I <= 8'd0;
                ADDR_I <= 8'd0;
            end 
            else begin 
                target_data = 0;
                STB_I <= 0;
                CYC_I <= continue_cycle;
                WE_I <= 0;
                DAT_I <= 8'd0;
                ADDR_I <= 8'd0;
                $display("ERROR at writing to the register!!");
            end
        end
    endtask

    task wb_read_register;
        input [7:0] target_addr;
        output [7:0] target_data;
        input continue_cycle;
        begin
            wait (CLK_I == 0);
            wait (CLK_I == 1);
            ADDR_I <= target_addr;
            DAT_I <= 0;
            WE_I <= 0;
            STB_I <= 1;
            CYC_I <= 1;
            wait (CLK_I == 0);
            wait (CLK_I == 1);
            wait (CLK_I == 0);
            wait (CLK_I == 1);
            if (ACK_O == 1'b1) begin
                target_data = DAT_O;
                STB_I <= 0;
                CYC_I <= continue_cycle;
                WE_I <= 0;
                DAT_I <= 8'd0;
                ADDR_I <= 8'd0;
            end
            else begin 
                target_data <= 0;
                STB_I <= 0;
                CYC_I <= continue_cycle;
                WE_I <= 0;
                DAT_I <= 8'd0;
                ADDR_I <= 8'd0;
                $display("ERROR at reading the register!!");
            end
        end
    endtask
    
    reg [7:0] result;

    initial begin
        $dumpfile("i2c_result.vcd");
		$dumpvars(0, i2c_tb);
        i2c_sda_in = 1'b1;
        i2c_scl_in = 1'b1;
        CLK_I = 1'b0;
        RST_I = 1'b1;
        ADDR_I = 8'b0;
        DAT_I = 8'b0;
        CYC_I = 1'b0;
        STB_I = 1'b0;
        WE_I = 1'b0;
        #10;
        RST_I = 1'b0;
        #10;
    end

    always @(posedge CLK_I) begin
        wb_write_register(8'hA, 8'hAA, 1);
        wb_write_register(8'hC, 8'hAA, 0);
        // Write test
        $display("Reading from slave...");
        i2c_start();
        // I2C reading from device sequence
        i2c_write_byte(8'hAB,1);  // Address 0x55 + Read bit (1)
        i2c_read_byte(result,0);  // Data
        $display("Read result is %0h", result);
        
        $display("Writing to slave...");
        ///I2C writing to device sequence
        i2c_start();
        i2c_write_byte(8'hAA,1);  // Address 0x55 + Write bit (0)
        i2c_write_byte(8'hBE,1);  // Data
        wb_read_register(8'hB, result, 0);
        $display("Write result is %0h", result);
        i2c_stop();
        #1500;
        $finish;
    end
	
	// Clock signal always on
    always #5 CLK_I <= ~CLK_I;

endmodule

