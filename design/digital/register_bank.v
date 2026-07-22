module register_bank
(
    input clk,
    input rst_n,

    input start_cmd,

    input tdc_done,
    input [15:0] tdc_data,

    output reg [7:0] control_reg,
    output reg [7:0] status_reg,

    output reg [15:0] result_reg
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        control_reg <= 8'd0;
        status_reg  <= 8'd0;
        result_reg  <= 16'd0;
    end
    else
    begin
        if(start_cmd)
            status_reg[0] <= 1'b1; // BUSY

        if(tdc_done)
        begin
            result_reg <= tdc_data;

            status_reg[0] <= 1'b0; // BUSY
            status_reg[1] <= 1'b1; // DONE
        end
    end
end

endmodule
``