`timescale 10ns/1ns


module top_level #(parameter GPIO_NUMBER = 2) (
    `ifdef USE_POWER_PINS
    inout VDD,
    inout VSS,
    `endif    
    // Analog and Internal Pins
    input BPF_OUT,
    input OTA_IN_M,
    input JUNCTION,
    input RX_IN_P,
    input RX_IN_N,
    input IN_BPF,
    input IN_SCHMITT,
    input signal_input,
    output [2:0] pga_gain_control,
    output [2:0] bypass_pin_control,

    // input/output to GPIOs
    output [GPIO_NUMBER-1:0] PAD_A,
    input [GPIO_NUMBER-1:0] PAD_Y,

    //configuration for bidirectional pads
    output [GPIO_NUMBER-1:0] PAD_CS,
    output [GPIO_NUMBER-1:0] PAD_OE,
    output [GPIO_NUMBER-1:0] PAD_IE,
    output [GPIO_NUMBER-1:0] PAD_PU,
    output [GPIO_NUMBER-1:0] PAD_PD,
    output [GPIO_NUMBER-1:0] PAD_SL,
    output [GPIO_NUMBER-1:0] PAD_PDRV0,
    output [GPIO_NUMBER-1:0] PAD_PDRV1,

    // ports for other pin configs
    // here are compatibility pins for every pins attached
    // I2C SCL: Schmitt Trigger Digital Input, Weak PU
    input i2c_scl_in,
    output i2c_scl_in_pu_control,
    output i2c_scl_in_pd_control,

    // I2C SDA: Digital Bidirectional, 16 mA, Tristate, Fast Slew, Weak PU, Schmitt
    input i2c_sda_in,                   // wire this to A pin on digital tristate pad block 
    output i2c_sda_out_pin_ctrl,        // to OE pin on digital tristate pad block
    output i2c_sda_out_pin_ctrl_n,      // to IE pin on digital tristate pad block
    output i2c_sda_out_sl_control,
    output i2c_sda_out_pd_control,
    output i2c_sda_out_pu_control,
    output i2c_sda_out_cs_control,
    output [1:0] i2c_sda_out_pdrv_control,

    // Trigger Out: Digital Bidirectional, 16 mA, Push-Pull, Fast Slew, Weak PD
    output trigger_signal_out,
    output trig_out_pd_control,
    output trig_out_pu_control,
    output trig_out_sl_control,
    output trig_out_cs_control,
    output trig_out_ie_control,
    output trig_out_oe_control,
    output [1:0] trig_out_pdrv_control,

    // External Clock Input: CMOS Digital Input, No PU/PD
    input ext_clk_in,
    output ext_clk_in_pu_control,
    output ext_clk_in_pd_control,

    // External Reset Input: Schmitt Trigger Digital Input, Weak PU
    input ext_rst_n_in,
    output nrst_in_pu_control,
    output nrst_in_pd_control
);
    
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


    // GPIO Registers
    // All registers are in MSB format
    // Contents : 
    // pin_input_read_register (0x18) --> store digital read value of the pin.
    //      - bit 7-2: reserved
    //      - bit 1: input state of pin GPIO1
    //      - bit 0: input state of pin GPIO0
    // pin_output_write_register (0x19) --> store output data of the pin
    //      - bit 7-2: reserved
    //      - bit 1: output state of pin GPIO1
    //      - bit 0: output state of pin GPIO0
    // pin_settings_1_register (0x1A) --> used for READ process where we send data
    //      - bit 7: Alternate Function 
    //      - bit 6: Pin Direction
    //      - bit 5: Pull-Up Enable
    //      - bit 4: Pull-Down Enable
    //      - bit 3: Input Type (Schmitt/CMOS)
    //      - bit 2: Slew Rate Setting
    //      - bit 1: Reserved
    //      - bit 0: Reserved
    // pin_settings_2_register (0x1B) --> used to poll or set the operation of the module
    //      - bit 7: Alternate Function 
    //      - bit 6: Pin Direction
    //      - bit 5: Pull-Up Enable
    //      - bit 4: Pull-Down Enable
    //      - bit 3: Input Type (Schmitt/CMOS)
    //      - bit 2: Slew Rate Setting
    //      - bit 1: Reserved
    //      - bit 0: Reserved 
    // blinker_constant_register (0x1C, 0x1D, 0x1E, 0x1F) --> used to control the blinker blinking frequency
    //      - 0x1C -> bit 31:24 [MSB->LSB]
    //      - 0x1D -> bit 23:16 [MSB->LSB]
    //      - 0x1E -> bit 15:8 [MSB->LSB]
    //      - 0x1F -> bit 7:0 [MSB->LSB]
    // blinker_compare_register (0x20, 0x21, 0x22, 0x23) --> used to control the blinker blinking frequency
    //      - 0x20 -> bit 31:24 [MSB->LSB]
    //      - 0x21 -> bit 23:16 [MSB->LSB]
    //      - 0x22 -> bit 15:8 [MSB->LSB]
    //      - 0x23 -> bit 7:0 [MSB->LSB]
    // blinker_reset_register (0x24, 0x25, 0x26, 0x27) --> used to control the blinker blinking frequency
    //      - 0x20 -> bit 31:24 [MSB->LSB]
    //      - 0x21 -> bit 23:16 [MSB->LSB]
    //      - 0x22 -> bit 15:8 [MSB->LSB]
    //      - 0x23 -> bit 7:0 [MSB->LSB]
    
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

    wire [WIDTH-1:0] DATA_BUS_TO_MASTER_CLIENT [1:0];
    wire ACK_BUS_CLIENT [1:0];
    wire RTY_BUS_CLIENT [1:0];
    wire ERR_BUS_CLIENT [1:0];

    reg [1:0] rst_buffer;

    assign rst_input_internal = ~ext_rst_n_in;
    assign ACK_BUS = (ACK_BUS_CLIENT[0] | ACK_BUS_CLIENT[1]);
    assign RTY_BUS = (RTY_BUS_CLIENT[0] | RTY_BUS_CLIENT[1]);
    assign ERR_BUS = (ERR_BUS_CLIENT[0] | ERR_BUS_CLIENT[1]);
    assign DATA_BUS_TO_MASTER = (DATA_BUS_TO_MASTER_CLIENT[0] | DATA_BUS_TO_MASTER_CLIENT[1]);

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
		.DAT_O(DATA_BUS_TO_MASTER_CLIENT[0]),
		.ERR_O(ERR_BUS_CLIENT[0]),
		.RTY_O(RTY_BUS_CLIENT[0]),
		.ACK_O(ACK_BUS_CLIENT[0]),
        .pga_gain_control(pga_gain_control),
        .bypass_pin_control(bypass_pin_control)
    );

    register_bank_gpio #(.WIDTH(WIDTH), .GPIO_NUMBER(2)) reg_bank (
        .RST_I(rst_buffer[1]),
        .CLK_I(ext_clk_in),
        .ADDR_I(ADDR_BUS),
        .DAT_I(DATA_BUS_FROM_MASTER),
        .WE_I(WE_BUS),
        .CYC_I(CYC_BUS),
        .STB_I(STB_BUS),
        .DAT_O(DATA_BUS_TO_MASTER_CLIENT[1]),
        .ERR_O(ERR_BUS_CLIENT[1]),
        .RTY_O(RTY_BUS_CLIENT[1]),
        .ACK_O(ACK_BUS_CLIENT[1]),
        .PAD_A(PAD_A),
        .PAD_Y(PAD_Y),
        .PAD_CS(PAD_CS),
        .PAD_OE(PAD_OE),
        .PAD_IE(PAD_IE),
        .PAD_PU(PAD_PU),
        .PAD_PD(PAD_PD),
        .PAD_SL(PAD_SL),
        .PAD_PDRV0(PAD_PDRV0),
        .PAD_PDRV1(PAD_PDRV1),
        .i2c_scl_in_pu_control(i2c_scl_in_pu_control),
        .i2c_scl_in_pd_control(i2c_scl_in_pd_control),
        .i2c_sda_out_sl_control(i2c_sda_out_sl_control),
        .i2c_sda_out_pd_control(i2c_sda_out_pd_control),
        .i2c_sda_out_pu_control(i2c_sda_out_pu_control),
        .i2c_sda_out_cs_control(i2c_sda_out_cs_control),
        .i2c_sda_out_pdrv_control(i2c_sda_out_pdrv_control),
        .trig_out_pd_control(trig_out_pd_control),
        .trig_out_pu_control(trig_out_pu_control),
        .trig_out_sl_control(trig_out_sl_control),
        .trig_out_cs_control(trig_out_cs_control),
        .trig_out_ie_control(trig_out_ie_control),
        .trig_out_oe_control(trig_out_oe_control),
        .trig_out_pdrv_control(trig_out_pdrv_control),
        .ext_clk_in_pu_control(ext_clk_in_pu_control),
        .ext_clk_in_pd_control(ext_clk_in_pd_control),
        .nrst_in_pu_control(nrst_in_pu_control),
        .nrst_in_pd_control(nrst_in_pd_control)
    );

endmodule