module dvl_control_top
(
    input clk,
    input rst_n,

    input start_cmd,

    input tdc_done,
    input [15:0] tdc_data,

    output interrupt,
    output tdc_start
);

wire busy;

control_fsm u_fsm
(
    .clk(clk),
    .rst_n(rst_n),

    .start_cmd(start_cmd),
    .tdc_done(tdc_done),

    .tdc_start(tdc_start),
    .interrupt(interrupt),
    .busy(busy)
);

register_bank u_regs
(
    .clk(clk),
    .rst_n(rst_n),

    .start_cmd(start_cmd),

    .tdc_done(tdc_done),
    .tdc_data(tdc_data)

);

endmodule