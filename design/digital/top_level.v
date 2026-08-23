`timescale 10ns/1ns


module top_level (
    input i2c_sda_in,                   // wire this to A pin on digital tristate pad block 
    input i2c_scl_in,
    input signal_input,
    input ext_rst_n_in,
    input ext_clk_in,
    output i2c_sda_out_pin_ctrl,        // to OE pin on digital tristate pad block
    output i2c_sda_out_pin_ctrl_n,      // to IE pin on digital tristate pad block
    output trigger_signal_out,
    output gpio0
);
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

    wire rst_input_internal;
    wire [WIDTH-1:0] ADDR_BUS;
    wire [WIDTH-1:0] DATA_BUS_FROM_MASTER;
    wire [WIDTH-1:0] DATA_BUS_TO_MASTER;
    wire CYC_BUS;
    wire STB_BUS;
    wire WE_BUS;
    wire ACK_BUS;
    wire RTY_BUS;
    wire ERR_BUS;

    reg [1:0] rst_buffer;

    assign rst_input_internal = ~ext_rst_n_in;

    always @(posedge ext_clk_in) begin
        rst_buffer[0] <= rst_input_internal;
        rst_buffer[1] <= rst_buffer[0];
    end

    i2c_controller #(.WIDTH(WIDTH)) i2c_module (
        .i2c_sda_in(i2c_sda_in),
        .i2c_sda_out_pin_ctrl(i2c_sda_out_pin_ctrl),
        .i2c_sda_out_pin_ctrl_n(i2c_sda_out_pin_ctrl_n),
        .i2c_scl_in(i2c_scl_in),
        .CLK_I(ext_clk_in),
        .RST_I(rst_buffer[1]),
        .ADDR_O(ADDR_BUS),
        .DAT_I(DATA_BUS_TO_MASTER),
        .CYC_O(CYC_BUS),
        .STB_O(STB_BUS),
        .WE_O(WE_BUS),
        .DAT_O(DATA_BUS_FROM_MASTER),
        .ACK_I(ACK_BUS),
        .ERR_I(ERR_BUS),
        .RTY_I(RTY_BUS)
    );

    frequency_counter #(.WIDTH(WIDTH)) tdc_module (
		.RST_I(rst_buffer[1]),
		.CLK_I(ext_clk_in),
		.ADDR_I(ADDR_BUS),
		.DAT_I(DATA_BUS_FROM_MASTER),
		.WE_I(WE_BUS),
		.CYC_I(CYC_BUS),
		.STB_I(STB_BUS),
		.signal_input(signal_input),
		.trigger_signal_out(trigger_signal_out),
		.DAT_O(DATA_BUS_TO_MASTER),
		.ERR_O(ERR_BUS),
		.RTY_O(RTY_BUS),
		.ACK_O(ACK_BUS)
    );



endmodule