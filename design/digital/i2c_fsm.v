module i2c_fsm
(
    input  wire clk,
    input  wire rst_n,

    input  wire run_i2c,

    input  wire ACK_O,
    input  wire ERR_O,
    input  wire RTY_O,

    input  wire [7:0] DAT_O,

    input  wire data_received_flag,
    input  wire data_send_done_flag,
    input  wire read_request_flag,

    output reg [7:0] ADDR_I,
    output reg [7:0] DAT_I,

    output reg WE_I,
    output reg STB_I,
    output reg CYC_I,

    output reg i2c_state_done
);

localparam IDLE            = 3'b000;
localparam CHECK_STATUS    = 3'b001;
localparam READ_BUFFER     = 3'b010;
localparam DECODE_COMMAND  = 3'b011;
localparam WRITE_BUFFER    = 3'b100;
localparam DONE            = 3'b101;

reg [2:0] current_state;
reg [2:0] next_state;

reg [7:0] received_command;
reg [7:0] transmit_data;
reg [7:0] ctrl_status_shadow;


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
// Internal Registers
//--------------------------------------------------

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        received_command   <= 8'h00;
        transmit_data      <= 8'h00;
        ctrl_status_shadow <= 8'h00;
    end
    else
    begin
        if(current_state == READ_BUFFER && ACK_O)
            received_command <= DAT_O;
    end
end


//--------------------------------------------------
// Next State Logic
//--------------------------------------------------

always @(*)
begin

    if(ERR_O)
    begin
        next_state = DONE;
    end
    else
    begin

        case(current_state)

            IDLE:
            begin
                if(run_i2c)
                    next_state = CHECK_STATUS;
                else
                    next_state = IDLE;
            end

            CHECK_STATUS:
            begin
                if(data_received_flag)
                    next_state = READ_BUFFER;

                else if(read_request_flag)
                    next_state = WRITE_BUFFER;

                else
                    next_state = DONE;
            end

            READ_BUFFER:
            begin
                if(ACK_O)
                    next_state = DECODE_COMMAND;
                else
                    next_state = READ_BUFFER;
            end

            DECODE_COMMAND:
            begin
                next_state = DONE;
            end

            WRITE_BUFFER:
            begin
                if(ACK_O)
                    next_state = DONE;
                else
                    next_state = WRITE_BUFFER;
            end

            DONE:
            begin
                next_state = IDLE;
            end

            default:
            begin
                next_state = IDLE;
            end

        endcase

    end

end


//--------------------------------------------------
// Output Logic
//--------------------------------------------------

always @(*)
begin

    ADDR_I = 8'h00;
    DAT_I  = 8'h00;

    WE_I  = 1'b0;
    STB_I = 1'b0;
    CYC_I = 1'b0;

    i2c_state_done = 1'b0;

    case(current_state)

        CHECK_STATUS:
        begin
            CYC_I = 1'b1;
            STB_I = 1'b1;
        end

        READ_BUFFER:
        begin
            CYC_I = 1'b1;
            STB_I = 1'b1;
        end

        WRITE_BUFFER:
        begin
            CYC_I = 1'b1;
            STB_I = 1'b1;
            WE_I  = 1'b1;
            DAT_I = transmit_data;
        end

        DONE:
        begin
            i2c_state_done = 1'b1;
        end

    endcase

end

endmodule