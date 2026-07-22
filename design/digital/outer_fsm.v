module outer_fsm
(
    input  wire clk,
    input  wire rst_n,

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

always @(posedge clk or negedge rst_n)
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

always @(*)
begin

    next_state = current_state;

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

endmodule