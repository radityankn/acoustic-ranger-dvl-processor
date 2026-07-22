`timescale 1ns / 1ps

module measurement_fsm_tb;

    reg clk;
    reg rst_n;

    reg start;
    reg soft_reset;
    reg clear_done;

    reg tdc_ready;
    reg tdc_done;

    wire tdc_start;

    wire ready;
    wire busy;
    wire done;

    wire measurement_state_done;

    measurement_fsm dut
    (
        .clk(clk),
        .rst_n(rst_n),

        .start(start),
        .soft_reset(soft_reset),
        .clear_done(clear_done),

        .tdc_ready(tdc_ready),
        .tdc_done(tdc_done),

        .tdc_start(tdc_start),

        .ready(ready),
        .busy(busy),
        .done(done),

        .measurement_state_done(measurement_state_done)
    );

    //--------------------------------------------------
    // Clock
    //--------------------------------------------------

    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //--------------------------------------------------
    // Stimulus
    //--------------------------------------------------

    initial
    begin

        $dumpfile("measurement_fsm.vcd");
        $dumpvars(0, measurement_fsm_tb);

        rst_n = 0;

        start = 0;
        soft_reset = 0;
        clear_done = 0;

        tdc_ready = 0;
        tdc_done = 0;

        #20;
        rst_n = 1;

        //--------------------------------------------------
        // TEST 1
        // Normal Measurement Flow
        //--------------------------------------------------

        #20;

        start = 1;

        #10;
        start = 0;

        #20;

        tdc_ready = 1;

        #10;
        tdc_ready = 0;

        #40;

        tdc_done = 1;

        #10;
        tdc_done = 0;

        #40;

        clear_done = 1;

        #10;
        clear_done = 0;

        //--------------------------------------------------
        // TEST 2
        // Soft Reset
        //--------------------------------------------------

        #50;

        start = 1;

        #10;
        start = 0;

        #20;

        soft_reset = 1;

        #10;

        soft_reset = 0;

        #50;

        $finish;

    end

endmodule