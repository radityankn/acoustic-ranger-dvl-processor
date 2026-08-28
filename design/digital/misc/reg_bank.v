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
    output reg [GPIO_NUMBER-1:0] PAD_CS;
    output [GPIO_NUMBER-1:0] PAD_OE;
    output [GPIO_NUMBER-1:0] PAD_IE;
    output [GPIO_NUMBER-1:0] PAD_PU;
    output [GPIO_NUMBER-1:0] PAD_PD;
    output [GPIO_NUMBER-1:0] PAD_SL;
    output reg [GPIO_NUMBER-1:0] PAD_PDRV0;
    output reg [GPIO_NUMBER-1:0] PAD_PDRV1;
    );

    reg [GPIO_NUMBER-1:0] PAD_ALT_FUNCTION_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_INPUT_TYPE_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_DIRECTION_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_PULLUP_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_PULLDOWN_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_SLEWRATE_REGISTER;

    reg blinker

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