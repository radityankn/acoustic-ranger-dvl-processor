`timescale 10ns / 1ns

module i2c_tb;

    localparam SCL_PERIOD = 250;
    localparam WIDTH = 8;

    // Inputs for the module
    reg i2c_sda_in;
    reg i2c_scl_in;
    reg CLK_I;
    reg RST_I;
    reg [WIDTH-1:0] ADDR_I;
    reg [WIDTH-1:0] DAT_I;
    reg CYC_I;
    reg STB_I;
    reg WE_I;
    wire i2c_sda_out_pin_ctrl;
    wire i2c_sda_out_pin_ctrl_n;

    // Outputs for the module
    wire [WIDTH-1:0] DAT_O;
    wire ACK_O;
    wire ERR_O;
    wire RTY_O;

    i2c_controller #(.WIDTH(WIDTH)) my_controller (
        .i2c_sda_in(i2c_sda_in),
        .i2c_sda_out_pin_ctrl(i2c_sda_out_pin_ctrl),
        .i2c_sda_out_pin_ctrl_n(i2c_sda_out_pin_ctrl_n),
        .i2c_scl_in(i2c_scl_in),
        .CLK_I(CLK_I),
        .RST_I(RST_I),
        .ADDR_I(ADDR_I),
        .DAT_I(DAT_I),
        .CYC_I(CYC_I),
        .STB_I(STB_I),
        .WE_I(WE_I),
        .DAT_O(DAT_O),
        .ACK_O(ACK_O),
        .ERR_O(ERR_O),
        .RTY_O(RTY_O)
    );
    
    // I2C tasks
    task i2c_start;
    begin
        i2c_sda_in = 1;
        i2c_scl_in = 1;
        #(SCL_PERIOD/2);
        i2c_sda_in = 0;
        #(SCL_PERIOD/2);
        i2c_scl_in = 0;
    end
    endtask
    
    task i2c_stop;
    begin
        i2c_sda_in = 0;
        i2c_scl_in = 1;
        #(SCL_PERIOD/2);
        i2c_sda_in = 1;
        #(SCL_PERIOD/2);
    end
    endtask
    
    task i2c_write_byte;
        input [7:0] data;
        integer i;
    begin
        for (i = 7; i >= 0; i--) begin
            i2c_sda_in = data[i];
            #(SCL_PERIOD/2);
            i2c_scl_in = 1;
            #(SCL_PERIOD/2);
            i2c_scl_in = 0;
        end
        // ACK phase (release SDA for slave)
        // sda = 1'bz;
        #(SCL_PERIOD/2);
        i2c_scl_in = 1;
        #(SCL_PERIOD/2);
        i2c_scl_in = 0;
    end
    endtask
    
    initial begin
        $dumpfile("i2c_result.vcd");
		$dumpvars(0, i2c_tb);
        i2c_sda_in = 1'b0;
        i2c_scl_in = 1'b0;
        CLK_I = 1'b0;
        RST_I = 1'b1;
        ADDR_I = 8'b0;
        DAT_I = 8'b1;
        CYC_I = 1'b0;
        STB_I = 1'b0;
        WE_I = 1'b0;

        #10;
        RST_I = 1'b0;

        // Write test
        $display("Writing to slave...");
        i2c_start();
        i2c_write_byte(8'hAA);  // Address 0x55 + Write bit (0)
        i2c_write_byte(8'hA5);  // Data
        i2c_stop();
        
        #1000;
        $finish;
    end

    assign i2c_sda_out_pin_ctrl_n = ~i2c_sda_out_pin_ctrl;
    always #5 CLK_I = !CLK_I;
    always #125 i2c_scl_in = !i2c_scl_in;
endmodule