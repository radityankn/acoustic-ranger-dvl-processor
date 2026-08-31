`timescale 10ns / 1ns

module i2c_tb;

    localparam SCL_PERIOD = 250;
    localparam WIDTH = 8;

    // Inputs for the module
    reg i2c_sda_in;
    reg i2c_scl_in;
    reg CLK_I;
    reg RST_I;
    wire [WIDTH-1:0] ADDR_O;
    reg [WIDTH-1:0] DAT_I;
    wire CYC_O;
    wire STB_O;
    wire WE_O;
    wire i2c_sda_out_pin_ctrl;
    wire i2c_sda_out_pin_ctrl_n;

    // Outputs for the module
    wire [WIDTH-1:0] DAT_O;
    reg ACK_I;
    reg ERR_I;
    reg RTY_I;

    i2c_controller #(.WIDTH(WIDTH)) my_controller (
        .i2c_sda_in(i2c_sda_in),
        .i2c_sda_out_pin_ctrl(i2c_sda_out_pin_ctrl),
        .i2c_sda_out_pin_ctrl_n(i2c_sda_out_pin_ctrl_n),
        .i2c_scl_in(i2c_scl_in),
        .CLK_I(CLK_I),
        .RST_I(RST_I),
        .ADDR_O(ADDR_O),
        .DAT_I(DAT_I),
        .CYC_O(CYC_O),
        .STB_O(STB_O),
        .WE_O(WE_O),
        .DAT_O(DAT_O),
        .ACK_I(ACK_I),
        .ERR_I(ERR_I),
        .RTY_I(RTY_I)
    );
    
    // I2C tasks
    task i2c_start;
    begin
        if (i2c_sda_in == 1'b1) begin
            wait (i2c_scl_in == 1'b0);
        end
        else begin
            i2c_sda_in <= 1;
            #(SCL_PERIOD/4);

        end
        wait (i2c_sda_in == 1'b1 && i2c_scl_in == 1'b1);
        // #(SCL_PERIOD/2);
        #(SCL_PERIOD/4);
        i2c_sda_in <= 0;
        #(SCL_PERIOD/2);
        // i2c_scl_in = 0;
    end
    endtask
    
    task i2c_stop;
    begin
        wait (i2c_scl_in == 1'b0);
        i2c_sda_in <= 0;
        wait (i2c_sda_in == 1'b0 && i2c_scl_in == 1'b1);
        // #(SCL_PERIOD/2);
        #(SCL_PERIOD/4);
        i2c_sda_in <= 1;
        #(SCL_PERIOD/2);
    end
    endtask
    
    task i2c_write_byte;
        input [7:0] data;
        input continue_cycle;
        integer i;
        begin
            for (i = 7; i >= 0; i--) begin
                i2c_sda_in <= data[i];
                #(SCL_PERIOD);
                // i2c_scl_in = 1;
                // #(SCL_PERIOD/2);
                // i2c_scl_in = 0;
            end
            // ACK phase (release SDA for slave)
            i2c_sda_in <= 1'b1;
            #(SCL_PERIOD);
            // i2c_scl_in = 1;
            // #(SCL_PERIOD/2);
            // i2c_scl_in = 0;
        end
    endtask

    task i2c_read_byte;
        output [7:0] data;
        input continue_cycle;
        integer i;
        begin
            for (i = 7; i >= 0; i--) begin
                data[i] <= i2c_sda_out_pin_ctrl;
                #(SCL_PERIOD);
                // i2c_scl_in = 1;
                // #(SCL_PERIOD/2);
                // i2c_scl_in = 0;
            end
            // ACK phase (0 for keep slave sending, 1 for terminate)
            i2c_sda_in <= continue_cycle;
            #(SCL_PERIOD);
            // i2c_scl_in = 1;
            // #(SCL_PERIOD/2);
            // i2c_scl_in = 0;
        end
    endtask

    // WB Tasks
    task wb_respond_to_write;
        input [7:0] target_addr;
        output [7:0] result;
        begin
            wait (STB_O == 1);
            if (ADDR_O == target_addr && WE_O == 1'b1) begin
                result <= DAT_O;
                ACK_I <= 1; 
            end
            wait (CLK_I == 0);
            wait (CLK_I == 1);
            ACK_I <= 0;
            $display("write result to %0h is %0h",target_addr, result);
        end
    endtask

    task wb_respond_to_read;
        input [7:0] target_addr;
        input [7:0] target_data;
        begin
            wait (STB_O == 1);
            if (ADDR_O == target_addr && WE_O == 1'b0) begin
                DAT_I <= target_data;
                ACK_I <= 1; 
            end
            wait (CLK_I == 0);
            wait (CLK_I == 1);
            ACK_I <= 0;
            $display("read register %0h which has %0h, please look at the I2C output",target_addr, target_data);
        end
    endtask
    
    reg [7:0] result;

    initial begin
        $dumpfile("i2c_wb_master_result.vcd");
		$dumpvars(0, i2c_tb);
        i2c_sda_in = 1'b1;
        i2c_scl_in = 1'b1;
        CLK_I = 1'b0;
        RST_I = 1'b1;
        DAT_I = 8'b0;
        #10;
        RST_I = 1'b0;
        #10;
    end

    always @(posedge CLK_I) begin
        // begin request to I2C
        i2c_start();
        i2c_write_byte(8'hAA,1); // Address 0x55 + Write bit (0)
        i2c_write_byte(8'd13,1); // Register read
        i2c_start();
        i2c_write_byte(8'hAB,1); // Address 0x55 + Read bit (1)
        i2c_read_byte(result,1);
        i2c_stop();
        $display("Read result is %0h", result);
        #10;
        i2c_start();
        i2c_write_byte(8'hAA,1); // Address 0x55 + Write bit (0)
        i2c_write_byte(8'd15,1); // Register write
        $display("writing %0h to I2C device", 8'hAB);
        i2c_write_byte(8'hAB,1); // data to be written
        i2c_stop();
        #10;
        $finish;
    end

    always @(posedge CLK_I) begin
        wb_respond_to_read(8'd13, 8'hDE);
        wb_respond_to_write(8'd15, result);
    end

    /*
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
    */

    assign i2c_sda_out_pin_ctrl_n = ~i2c_sda_out_pin_ctrl;
    always #5 CLK_I <= ~CLK_I;
    always #125 i2c_scl_in <= ~i2c_scl_in;
endmodule