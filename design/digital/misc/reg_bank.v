`timescale 10ns / 1ns


module register_bank_gpio #(
    parameter WIDTH = 8
    parameter GPIO_NUMBER = 2
    )(
    input RST_I,
    input CLK_I,
    input [WIDTH-1:0] ADDR_I,
    input [WIDTH-1:0] DAT_I,
    input WE_I,
    input CYC_I,
    input STB_I,
    output reg [WIDTH-1:0] DAT_O,
    output reg ERR_O,
    output reg RTY_O,
    output reg ACK_O

    // input/output to GPIOs
    input [GPIO_NUMBER-1:0] PAD_A;
    output reg [GPIO_NUMBER-1:0] PAD_Y;

    //configuration for bidirectional pads
    output [GPIO_NUMBER-1:0] PAD_CS;
    output [GPIO_NUMBER-1:0] PAD_OE;
    output [GPIO_NUMBER-1:0] PAD_IE;
    output [GPIO_NUMBER-1:0] PAD_PU;
    output [GPIO_NUMBER-1:0] PAD_PD;
    output [GPIO_NUMBER-1:0] PAD_SL;
    output [GPIO_NUMBER-1:0] PAD_PDRV0;
    output [GPIO_NUMBER-1:0] PAD_PDRV1;

    // ports for other pin configs
    // here are compatibility pins for every pins attached
    // I2C SCL: Schmitt Trigger Digital Input, Weak PU
    output i2c_scl_in_pu_control,
    output i2c_scl_in_pd_control,

    // I2C SDA: Digital Bidirectional, 16 mA, Tristate, Fast Slew, Weak PU, Schmitt
    output i2c_sda_out_sl_control,
    output i2c_sda_out_pd_control,
    output i2c_sda_out_pu_control,
    output i2c_sda_out_cs_control,
    output [1:0] i2c_sda_out_pdrv_control,

    // Trigger Out: Digital Bidirectional, 16 mA, Push-Pull, Fast Slew, Weak PD
    output trig_out_pd_control,
    output trig_out_pu_control,
    output trig_out_sl_control,
    output trig_out_cs_control,
    output trig_out_ie_control,
    output trig_out_oe_control,
    output [1:0] trig_out_pdrv_control,

    // External Clock Input: CMOS Digital Input, No PU/PD
    output ext_clk_in_pu_control,
    output ext_clk_in_pd_control,

    // External Reset Input: Schmitt Trigger Digital Input, Weak PU
    output nrst_in_pu_control,
    output nrst_in_pd_control
    );

    reg [GPIO_NUMBER-1:0] PAD_ALT_FUNCTION_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_INPUT_TYPE_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_DIRECTION_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_PULLUP_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_PULLDOWN_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_SLEWRATE_REGISTER;

    reg [31:0] blinker;

    assign PAD_OE[GPIO_NUMBER-1:0] = PAD_DIRECTION_REGISTER[GPIO_NUMBER-1:0];
    assign PAD_IE[GPIO_NUMBER-1:0] = ~PAD_DIRECTION_REGISTER[GPIO_NUMBER-1:0];
    assign 

    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            PAD_PDRV0[GPIO_NUMBER-1:0] <= 1'b1;
            PAD_PDRV1[GPIO_NUMBER-1:0] <= 1'b1;
            PAD_ALT_FUNCTION_REGISTER
        end
    end

endmodule