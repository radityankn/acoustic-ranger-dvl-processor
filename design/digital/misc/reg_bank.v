`timescale 10ns / 1ns


module register_bank_gpio #(
    parameter WIDTH = 8,
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
    output reg ACK_O,

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

    // The localparam is for defining the address of the GPIO block's registers, please change it here in case
    // you need its address to be other than the default
    localparam [WIDTH-1:0] PIN_INPUT_READ_REGISTER_ADDRESS = 24;
    localparam [WIDTH-1:0] PIN_OUTPUT_WRITE_REGISTER_ADDRESS = 25;
    localparam [WIDTH-1:0] PIN_SETTINGS_1_REGISTER_ADDRESS = 26;
    localparam [WIDTH-1:0] PIN_SETTINGS_2_REGISTER_ADDRESS = 27;
    localparam [WIDTH-1:0] BLINKER_CONSTANT_HI_REGISTER_ADDRESS = 28;
    localparam [WIDTH-1:0] BLINKER_CONSTANT_MIDH_REGISTER_ADDRESS = 29;
    localparam [WIDTH-1:0] BLINKER_CONSTANT_MIDL_REGISTER_ADDRESS = 30;
    localparam [WIDTH-1:0] BLINKER_CONSTANT_LO_REGISTER_ADDRESS = 31;
    localparam [WIDTH-1:0] BLINKER_COMPARE_HI_REGISTER_ADDRESS = 32;
    localparam [WIDTH-1:0] BLINKER_COMPARE_MIDH_REGISTER_ADDRESS = 33;
    localparam [WIDTH-1:0] BLINKER_COMPARE_MIDL_REGISTER_ADDRESS = 34;
    localparam [WIDTH-1:0] BLINKER_COMPARE_LO_REGISTER_ADDRESS = 35;
    localparam [WIDTH-1:0] BLINKER_RESET_HI_REGISTER_ADDRESS = 36;
    localparam [WIDTH-1:0] BLINKER_RESET_MIDH_REGISTER_ADDRESS = 37;
    localparam [WIDTH-1:0] BLINKER_RESET_MIDL_REGISTER_ADDRESS = 38;
    localparam [WIDTH-1:0] BLINKER_RESET_LO_REGISTER_ADDRESS = 39;

    reg [GPIO_NUMBER-1:0] PAD_ALT_FUNCTION_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_INPUT_TYPE_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_DIRECTION_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_PULLUP_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_PULLDOWN_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_SLEWRATE_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_INPUT_READ_REGISTER;
    reg [GPIO_NUMBER-1:0] PAD_OUTPUT_WRITE_REGISTER;

    reg [32:0] blinker;
    reg [31:0] blinker_constant_register;
    reg [31:0] blinker_compare_register;
    reg [31:0] blinker_reset_register;
    reg blinker_output;
    reg blinker_has_toggled;

    // Assign GPIO Pad settings here
    // This is reserved for the GPIO feature of our chip
    assign PAD_OE[GPIO_NUMBER-1:0] = PAD_DIRECTION_REGISTER[GPIO_NUMBER-1:0];
    assign PAD_IE[GPIO_NUMBER-1:0] = ~PAD_DIRECTION_REGISTER[GPIO_NUMBER-1:0];
    assign PAD_PD[GPIO_NUMBER-1:0] = PAD_PULLDOWN_REGISTER[GPIO_NUMBER-1:0];
    assign PAD_PU[GPIO_NUMBER-1:0] = PAD_PULLUP_REGISTER[GPIO_NUMBER-1:0];
    assign PAD_CS[GPIO_NUMBER-1:0] = PAD_INPUT_TYPE_REGISTER[GPIO_NUMBER-1:0];
    assign PAD_SL[GPIO_NUMBER-1:0] = PAD_SLEWRATE_REGISTER[GPIO_NUMBER-1:0];

    assign PAD_A = PAD_ALT_FUNCTION_REGISTER ? {2{blinker[31]}} : PAD_OUTPUT_WRITE_REGISTER;

    // Assign Pad Settings here, especially the one that is permanent
    // I2C SCL: Digital Input Schmitt Trigger, Weak PU
    assign i2c_scl_in_pu_control = 1'b1;
    assign i2c_scl_in_pd_control = 1'b0;

    // I2C SDA: Digital Bidirectional, 16 mA, Tristate, Fast Slew, Weak PU, Schmitt
    assign i2c_sda_out_sl_control = 1'b0;
    assign i2c_sda_out_pd_control = 1'b0;
    assign i2c_sda_out_pu_control = 1'b1;
    assign i2c_sda_out_cs_control = 1'b1;
    assign i2c_sda_out_pdrv_control[1:0] = 2'b11;

    // Trigger Out: Digital Bidirectional, 16 mA, Push-Pull, Fast Slew, Weak PD
    assign trig_out_pd_control = 1'b1;
    assign trig_out_pu_control = 1'b0;
    assign trig_out_sl_control = 1'b0;
    assign trig_out_cs_control = 1'b0;
    assign trig_out_ie_control = 1'b0;
    assign trig_out_oe_control = 1'b1;
    assign trig_out_pdrv_control[1:0] = 2'b11;

    // External Clock Input: CMOS Digital Input, No PU/PD
    assign ext_clk_in_pu_control = 1'b0;
    assign ext_clk_in_pd_control = 1'b0;

    // External Reset Input: Schmitt Trigger Digital Input, Weak PU
    assign nrst_in_pu_control = 1'b1;
    assign nrst_in_pd_control = 1'b0;

    assign PAD_PDRV1[1:0] = 2'b11;
    assign PAD_PDRV0[1:0] = 2'b11;

    // General Register that can be accessed through the bus
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

    reg [1:0] PAD_Y_synchronizer [1:0];

    // buffering of the input pin
    always @(posedge CLK_I) begin
        PAD_Y_synchronizer[1] <= PAD_Y;
        PAD_Y_synchronizer[0] <= PAD_Y_synchronizer[1];
    end

    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            // Reset everything!
            DAT_O <= 0;
            ERR_O <= 1'b0;
            ACK_O <= 1'b0;
            RTY_O <= 1'b0;
            // Reset the registers!
            PAD_ALT_FUNCTION_REGISTER[GPIO_NUMBER-1:0] <= 2'b00;
            PAD_INPUT_TYPE_REGISTER[GPIO_NUMBER-1:0] <= 2'b00;
            PAD_DIRECTION_REGISTER[GPIO_NUMBER-1:0] <= 2'b00;
            PAD_PULLUP_REGISTER[GPIO_NUMBER-1:0] <= 2'b00;
            PAD_PULLDOWN_REGISTER[GPIO_NUMBER-1:0] <= 2'b00;
            PAD_SLEWRATE_REGISTER[GPIO_NUMBER-1:0] <= 2'b00;
            PAD_INPUT_READ_REGISTER[GPIO_NUMBER-1:0] <= 2'b00;
            PAD_OUTPUT_WRITE_REGISTER[GPIO_NUMBER-1:0] <= 2'b00;
            blinker_constant_register <= 32'd0;
            blinker_compare_register <= 32'd0;
            blinker_reset_register <= 32'd0;
        end
        // if there is any operation
        else if (RST_I == 1'b0 && CYC_I == 1'b1 && STB_I == 1'b1) begin
            if ((ACK_O | ERR_O | RTY_O) == 1'b0) begin
                case (ADDR_I)
                    PIN_INPUT_READ_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            // Throw ERR signal (receive buffer is read only!)
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b0;
                            ERR_O <= 1'b1;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O[GPIO_NUMBER-1:0] <= {6'd0,PAD_INPUT_READ_REGISTER[GPIO_NUMBER-1:0]};
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    PIN_OUTPUT_WRITE_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            PAD_OUTPUT_WRITE_REGISTER[GPIO_NUMBER-1:0] <= DAT_I[GPIO_NUMBER-1:0];
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O[GPIO_NUMBER-1:0] <= {6'd0,PAD_OUTPUT_WRITE_REGISTER[1:0]};
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    PIN_SETTINGS_1_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            {PAD_ALT_FUNCTION_REGISTER[0],PAD_DIRECTION_REGISTER[0],PAD_PULLUP_REGISTER[0],PAD_PULLDOWN_REGISTER[0],PAD_INPUT_TYPE_REGISTER[0],PAD_SLEWRATE_REGISTER[0]} <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= {PAD_ALT_FUNCTION_REGISTER[0],PAD_DIRECTION_REGISTER[0],PAD_PULLUP_REGISTER[0],PAD_PULLDOWN_REGISTER[0],PAD_INPUT_TYPE_REGISTER[0],PAD_SLEWRATE_REGISTER[0]};
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    PIN_SETTINGS_2_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            {PAD_ALT_FUNCTION_REGISTER[1],PAD_DIRECTION_REGISTER[1],PAD_PULLUP_REGISTER[1],PAD_PULLDOWN_REGISTER[1],PAD_INPUT_TYPE_REGISTER[1],PAD_SLEWRATE_REGISTER[1]} <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= {PAD_ALT_FUNCTION_REGISTER[1],PAD_DIRECTION_REGISTER[1],PAD_PULLUP_REGISTER[1],PAD_PULLDOWN_REGISTER[1],PAD_INPUT_TYPE_REGISTER[1],PAD_SLEWRATE_REGISTER[1]};
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_CONSTANT_HI_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_constant_register[31:24] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_constant_register[31:24];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_CONSTANT_MIDH_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_constant_register[23:16] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_constant_register[23:16];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_CONSTANT_MIDL_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_constant_register[15:8] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_constant_register[15:8];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_CONSTANT_LO_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_constant_register[7:0] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_constant_register[7:0];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_COMPARE_HI_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_compare_register[31:24] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_compare_register[31:24];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_COMPARE_MIDH_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_compare_register[23:16] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_compare_register[23:16];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_COMPARE_MIDL_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_compare_register[15:8] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_compare_register[15:8];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_COMPARE_LO_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_compare_register[7:0] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_compare_register[7:0];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_RESET_HI_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_reset_register[31:24] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_reset_register[31:24];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_RESET_MIDH_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_reset_register[23:16] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_reset_register[23:16];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_RESET_MIDL_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_reset_register[15:8] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_reset_register[15:8];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    BLINKER_RESET_LO_REGISTER_ADDRESS : begin
                        if (WE_I == 1'b1) begin
                            blinker_reset_register[7:0] <= DAT_I;
                            DAT_O <= 8'd0;
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                        else begin
                            DAT_O <= blinker_reset_register[7:0];
                            ACK_O <= 1'b1;
                            ERR_O <= 1'b0;
                            RTY_O <= 1'b0;
                        end
                    end
                    default : begin
                        // Register does not exist, but do not throw any error
                        DAT_O <= 0;
                        ERR_O <= 1'b0;
                        ACK_O <= 1'b0;
                        RTY_O <= 1'b0;
                    end
                endcase
            end  
            // if any of the signaling has been asserted (ACK, RTY, or ERR)...
            else if ((ACK_O | ERR_O | RTY_O) == 1'b1) begin
                // de-assert first before moving on to the next transaction
                DAT_O <= 0;
                ERR_O <= 1'b0;
                ACK_O <= 1'b0;
                RTY_O <= 1'b0;
            end
        end

        // housekeeping task
        if (PAD_DIRECTION_REGISTER[0] == 1) begin
            PAD_INPUT_READ_REGISTER[0] <= PAD_OUTPUT_WRITE_REGISTER[0];
        end
        else begin
            PAD_INPUT_READ_REGISTER[0] <= PAD_Y_synchronizer[0][0];
        end
        if (PAD_DIRECTION_REGISTER[1] == 1) begin
            PAD_INPUT_READ_REGISTER[1] <= PAD_OUTPUT_WRITE_REGISTER[1];
        end
        else begin
            PAD_INPUT_READ_REGISTER[1] <= PAD_Y_synchronizer[0][1];
        end    
    end

    always @(posedge CLK_I) begin
        if (RST_I == 1'b1) begin
            blinker <= 33'd0;
            blinker_output <= 1'b0;
            blinker_has_toggled <= 1'b0;
        end
        else begin
            blinker <= blinker + blinker_constant_register;
            if (blinker >= blinker_compare_register && blinker_has_toggled == 1'b0) begin
               blinker_output <= ~blinker_output; 
               blinker_has_toggled <= 1'b1;
            end
            else if (blinker >= blinker_reset_register) begin
                blinker <= 33'd0;
                blinker_output <= blinker_output;
                blinker_has_toggled <= 1'b0;
            end
        end
    end

endmodule