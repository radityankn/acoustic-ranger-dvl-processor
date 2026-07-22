module measurement_fsm
(
    input  wire clk,
    input  wire rst_n,

    input  wire start,
    input  wire soft_reset,
    input  wire clear_done,

    input  wire tdc_ready,
    input  wire tdc_done,

    output reg  tdc_start,

    output reg  ready,
    output reg  busy,
    output reg  done,

    output reg  measurement_state_done
);

localparam IDLE            = 3'b000;
localparam CHECK_READY     = 3'b001;
localparam START_TDC       = 3'b010;
localparam WAIT_TDC_DONE   = 3'b011;
localparam READ_RESULT     = 3'b100;
localparam WRITE_REGS      = 3'b101;
localparam WAIT_ACK        = 3'b110;

reg [2:0] current_state;
reg [2:0] next_state;


//--------------------------------------------------
// State Register
//--------------------------------------------------

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end


//--------------------------------------------------
// Next State Logic
//--------------------------------------------------

always @(*)
begin

    if(soft_reset)
    begin
        next_state = IDLE;
    end
    else
    begin

        case(current_state)

            IDLE:
            begin
                if(start)
                    next_state = CHECK_READY;
                else
                    next_state = IDLE;
            end

            CHECK_READY:
            begin
                if(tdc_ready)
                    next_state = START_TDC;
                else
                    next_state = CHECK_READY;
            end

            START_TDC:
            begin
                next_state = WAIT_TDC_DONE;
            end

            WAIT_TDC_DONE:
            begin
                if(tdc_done)
                    next_state = READ_RESULT;
                else
                    next_state = WAIT_TDC_DONE;
            end

            READ_RESULT:
            begin
                next_state = WRITE_REGS;
            end

            WRITE_REGS:
            begin
                next_state = WAIT_ACK;
            end

            WAIT_ACK:
            begin
                if(clear_done)
                    next_state = IDLE;
                else
                    next_state = WAIT_ACK;
            end

            default:
                next_state = IDLE;

        endcase

    end

end


//--------------------------------------------------
// Output Logic
//--------------------------------------------------

always @(*)
begin

    ready = 1'b0;
    busy  = 1'b0;
    done  = 1'b0;

    tdc_start = 1'b0;

    measurement_state_done = 1'b0;

    case(current_state)

        IDLE:
        begin
            ready = 1'b1;
        end

        CHECK_READY:
        begin
            busy = 1'b1;
        end

        START_TDC:
        begin
            busy      = 1'b1;
            tdc_start = 1'b1;
        end

        WAIT_TDC_DONE:
        begin
            busy = 1'b1;
        end

        READ_RESULT:
        begin
            busy = 1'b1;
        end

        WRITE_REGS:
        begin
            busy = 1'b1;
        end

        WAIT_ACK:
        begin
            done = 1'b1;
            measurement_state_done = 1'b1;
        end

    endcase

end

endmodule