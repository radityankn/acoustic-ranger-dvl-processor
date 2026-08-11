module outer_fsm
(
    // Wishbone bus wire connections
    input  wire CLK_I,
    input  wire RST_I,
    output wire [7:0] ADDR_O,
    input  wire [7:0] DAT_I,
    output wire [7:0] DAT_O,
    output wire CYC_O,
    output wire STB_O,
    output wire WE_O,
    input  wire ACK_I,
    input  wire ERR_I,
    input  wire RTY_I,

    //input flags from the peripherals 
    input  wire start,
    input  wire i2c_request,

    input  wire i2c_state_done,
    input  wire measurement_state_done,

    output reg  run_i2c,
    output reg  run_measurement
);

localparam IDLE            = 2'b00;
localparam READ_FLAGS      = 2'b01;
localparam RUN_I2C         = 2'b10;
localparam RUN_MEASUREMENT = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

reg last_served;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Last Served Flag updater block, in pure combinational
always @(posedge clk )
begin
    if(!rst_n)
        last_served <= 1'b0;

    else
    begin
        case(current_state)

            RUN_I2C:
                last_served <= 1'b0;

            RUN_MEASUREMENT:
                last_served <= 1'b1;

            default:
                last_served <= last_served;

        endcase
    end
end

// Next State logic in full combinational
always @(*)
begin

    //next_state = current_state;

    case(current_state)

        IDLE:
        begin
            if(start || i2c_request)
                next_state = READ_FLAGS;
            else
                next_state = IDLE;
        end

        READ_FLAGS:
        begin

            if(!start && !i2c_request)
                next_state = IDLE;

            else if(start && !i2c_request)
                next_state = RUN_MEASUREMENT;

            else if(!start && i2c_request)
                next_state = RUN_I2C;

            else
            begin
                if(last_served == 1'b0)
                    next_state = RUN_MEASUREMENT;
                else
                    next_state = RUN_I2C;
            end

        end

        RUN_I2C:
        begin
            if(i2c_state_done)
                next_state = READ_FLAGS;
            else
                next_state = RUN_I2C;
        end

        RUN_MEASUREMENT:
        begin
            if(measurement_state_done)
                next_state = READ_FLAGS;
            else
                next_state = RUN_MEASUREMENT;
        end

        default:
            next_state = IDLE;

    endcase

end

always @(*)
begin

    run_i2c         = 1'b0;
    run_measurement = 1'b0;

    case(current_state)

        RUN_I2C:
            run_i2c = 1'b1;

        RUN_MEASUREMENT:
            run_measurement = 1'b1;

        default:
        begin
            run_i2c         = 1'b0;
            run_measurement = 1'b0;
        end

    endcase

end

measurement_fsm measurement_routine (

);

i2c_fsm i2c_routine (

);

endmodule