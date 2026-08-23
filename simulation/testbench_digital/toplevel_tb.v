`timescale 10ns / 1ps

module top_level_tb; 

    // TDC Registers
    // All registers are in MSB format
    // Contents : 
    // range_count_register (0x0E, 0x0F, and 0x10) --> used to set what address we need the module to respond to.
    //      - 24 bit wide, divided into 8-bit high, mid, and low register. Contains ranging measurement result
    // pulse_timing_register (0x11, 0x12, and 0x13) --> used for WRITE process where we receive data
    //      - 24 bit wide, divided into 8-bit high, mid, and low register. Contains doppler measurement result
    // pulse_count_threshold_register (0x14 and 0x15) --> used for READ process where we send data
    //      - 16 bit wide, divided into high and low register. Contains doppler pulse count threshold. 
    // counter_control_status_register (0x16) --> used to poll or set the operation of the module
    //      - bit 7: measurement start bit. Set this to start measuring, automatically cleared once finished
    //      - bit 6: measurement done bit. Automatically set upon measurement completion. please clear manually
    //      - bit 5: measurement range mode enable. Set this to enable ranging mode, clear to disable it
    //      - bit 4: measurement pulse mode enable. Set this to enable doppler mode, clear to disable it
    //      - bit 3: measurement range mode timeout. this bit will be set if the measurement timed out
    //      - bit 2: measurement pulse mode timeout. this bit will be set if the measurement timed out
    //      - bit 1: Reserved
    //      - bit 0: Reset counter interface (when things go awry, initialization means besides resetting the whole chip)

    // I2C Registers
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
    
    localparam WIDTH = 8;
    localparam SCL_PERIOD = 250;
    localparam SIGNAL_PERIOD = 40;

    localparam I2C_READ_ADDRESS = 8'hAB;
    localparam I2C_WRITE_ADDRESS = 8'hAA;

    localparam [WIDTH-1:0] ADDR_SET_REGISTER_ADDRESS = 10;
    localparam [WIDTH-1:0] RECV_DATA_BUFFER_ADDRESS = 11;
    localparam [WIDTH-1:0] SEND_DATA_BUFFER_ADDRESS = 12;
    localparam [WIDTH-1:0] WHOAMI_REGISTER_ADDRESS = 13;

    localparam [WIDTH-1:0] RANGE_TIMING_REGISTER_HIGH_ADDRESS = 14;
    localparam [WIDTH-1:0] RANGE_TIMING_REGISTER_MID_ADDRESS = 15;
    localparam [WIDTH-1:0] RANGE_TIMING_REGISTER_LOW_ADDRESS = 16;
    localparam [WIDTH-1:0] PULSE_TIMING_REGISTER_HIGH_ADDRESS = 17;
    localparam [WIDTH-1:0] PULSE_TIMING_REGISTER_MID_ADDRESS = 18;
    localparam [WIDTH-1:0] PULSE_TIMING_REGISTER_LOW_ADDRESS = 19;
    localparam [WIDTH-1:0] PULSE_COUNT_THRESHOLD_REGISTER_HIGH_ADDRESS = 20;
    localparam [WIDTH-1:0] PULSE_COUNT_THRESHOLD_REGISTER_LOW_ADDRESS = 21;
    localparam [WIDTH-1:0] COUNTER_CONTROL_STATUS_REGISTER_ADDRESS = 22;
    
    reg i2c_sda_in;
    reg i2c_scl_in;
    reg ext_clk_in;
    reg ext_rst_n_in;
    reg signal_input;

    wire i2c_sda_out_pin_ctrl;
    wire i2c_sda_out_pin_ctrl_n;
    wire trigger_signal_out;
    wire gpio0;

    top_level my_top_level (
        .i2c_sda_in(i2c_sda_in),                   // wire this to A pin on digital tristate pad block 
        .i2c_scl_in(i2c_scl_in),
        .signal_input(signal_input),
        .ext_rst_n_in(ext_rst_n_in),
        .ext_clk_in(ext_clk_in),
        .i2c_sda_out_pin_ctrl(i2c_sda_out_pin_ctrl),        // to OE pin on digital tristate pad block
        .i2c_sda_out_pin_ctrl_n(i2c_sda_out_pin_ctrl_n),      // to IE pin on digital tristate pad block
        .trigger_signal_out(trigger_signal_out),
        .gpio0(gpio0)
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

    // For TDC
    task simulate_return_ping;
		integer i;
		input real multiplier;
		begin
			for (i = 0;i < 1020;i++) begin
				signal_input <= ~signal_input;
				#(SIGNAL_PERIOD*(0.5*multiplier));
                signal_input <= ~signal_input;
				#(SIGNAL_PERIOD*(0.5*multiplier));
			end
		end
    endtask

    reg [7:0] result;
    reg [7:0] result2;
    reg [7:0] result3;

    initial begin
        $dumpfile("Toplevel_result.vcd");
		$dumpvars(0, top_level_tb);
        i2c_sda_in = 1'b1;
        i2c_scl_in = 1'b1;
        signal_input = 1'b0;
        ext_clk_in = 1'b0;
        ext_rst_n_in = 1'b0;
        #30;
        signal_input = 1'b1;
        #5;
        signal_input = 1'b0;
        ext_rst_n_in = 1'b1;
        #10;
    end

    always @(posedge ext_clk_in) begin
        i2c_start();
        i2c_write_byte(I2C_WRITE_ADDRESS, 0);
        i2c_write_byte(COUNTER_CONTROL_STATUS_REGISTER_ADDRESS,0);
        i2c_write_byte(8'b10110000, 1);
        i2c_stop();
        #(SIGNAL_PERIOD*1000);
        simulate_return_ping(1.0005);
        i2c_start();
        i2c_write_byte(I2C_WRITE_ADDRESS, 0);
        i2c_write_byte(RANGE_TIMING_REGISTER_HIGH_ADDRESS,0);
        i2c_start();
        i2c_write_byte(I2C_READ_ADDRESS, 0);
        i2c_read_byte(result, 0);
        i2c_read_byte(result2, 0);
        i2c_read_byte(result3, 1);
        i2c_stop();
        #100;
        $display("the ranging result is %0h %0h %0h", result, result2, result3);
        $finish;
    end

    always #5 ext_clk_in <= ~ext_clk_in;
    always #125 i2c_scl_in <= ~i2c_scl_in;
endmodule