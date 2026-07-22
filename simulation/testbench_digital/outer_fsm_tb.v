`timescale 1ns/1ps

module outer_fsm_tb;

    reg clk;
    reg rst_n;

    reg start;
    reg i2c_request;

    reg i2c_state_done;
    reg measurement_state_done;

    wire run_i2c;
    wire run_measurement;

    outer_fsm dut
    (
        .clk(clk),
        .rst_n(rst_n),

        .start(start),
        .i2c_request(i2c_request),

        .i2c_state_done(i2c_state_done),
        .measurement_state_done(measurement_state_done),

        .run_i2c(run_i2c),
        .run_measurement(run_measurement)
    );

    //--------------------------------------------------
    // Clock Generation
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

        $dumpfile("outer_fsm.vcd");
        $dumpvars(0, outer_fsm_tb);

        rst_n = 0;

        start = 0;
        i2c_request = 0;

        i2c_state_done = 0;
        measurement_state_done = 0;

        #20;

        rst_n = 1;

        //--------------------------------------------------
        // TEST 1
        // Measurement Request
        //--------------------------------------------------

        #20;
        start = 1;

        #20;
        start = 0;

        #40;
        measurement_state_done = 1;

        #10;
        measurement_state_done = 0;

        //--------------------------------------------------
        // TEST 2
        // I2C Request
        //--------------------------------------------------

        #40;

        i2c_request = 1;

        #20;
        i2c_request = 0;

        #40;

        i2c_state_done = 1;

        #10;
        i2c_state_done = 0;

        //--------------------------------------------------
        // TEST 3
        // Simultaneous Requests
        // last_served = 0
        // Expect RUN_MEASUREMENT
        //--------------------------------------------------

        #40;

        start = 1;
        i2c_request = 1;

        #40;

        measurement_state_done = 1;

        #10;

        measurement_state_done = 0;

        start = 0;
        i2c_request = 0;


        //--------------------------------------------------
        // TEST 4
        // Simultaneous Requests
        // last_served = 1
        // Expect RUN_I2C
        //--------------------------------------------------

        #40;

        start = 1;
        i2c_request = 1;

        #40;

        i2c_state_done = 1;

        #10;

        i2c_state_done = 0;

        start = 0;
        i2c_request = 0;

        #100;

        $finish;


            end

endmodule