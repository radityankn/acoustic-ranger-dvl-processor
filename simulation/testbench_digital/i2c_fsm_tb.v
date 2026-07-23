`timescale 1ns / 1ps

module i2c_fsm_tb;

    reg clk;
    reg rst_n;

    reg run_i2c;

    reg ACK_O;
    reg ERR_O;
    reg RTY_O;

    reg [7:0] DAT_O;

    reg data_received_flag;
    reg data_send_done_flag;
    reg read_request_flag;

    wire [7:0] ADDR_I;
    wire [7:0] DAT_I;

    wire WE_I;
    wire STB_I;
    wire CYC_I;

    wire i2c_state_done;

    i2c_fsm dut
    (
        .clk(clk),
        .rst_n(rst_n),

        .run_i2c(run_i2c),

        .ACK_O(ACK_O),
        .ERR_O(ERR_O),
        .RTY_O(RTY_O),

        .DAT_O(DAT_O),

        .data_received_flag(data_received_flag),
        .data_send_done_flag(data_send_done_flag),
        .read_request_flag(read_request_flag),

        .ADDR_I(ADDR_I),
        .DAT_I(DAT_I),

        .WE_I(WE_I),
        .STB_I(STB_I),
        .CYC_I(CYC_I),

        .i2c_state_done(i2c_state_done)
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

        $dumpfile("i2c_fsm.vcd");
        $dumpvars(0, i2c_fsm_tb);

        rst_n = 0;

        run_i2c = 0;

        ACK_O = 0;
        ERR_O = 0;
        RTY_O = 0;

        DAT_O = 8'h55;

        data_received_flag = 0;
        data_send_done_flag = 0;
        read_request_flag = 0;

        #20;
        rst_n = 1;

        //--------------------------------------------------
        // TEST 1
        // Receive Path
        //--------------------------------------------------

        #20;

        run_i2c = 1;

        #10;

        data_received_flag = 1;

        #20;

        ACK_O = 1;

        #10;

        ACK_O = 0;
        data_received_flag = 0;
        run_i2c = 0;

        //--------------------------------------------------
        // TEST 2
        // Transmit Path
        //--------------------------------------------------

        #50;

        run_i2c = 1;

        #10;

        read_request_flag = 1;

        #20;

        ACK_O = 1;

        #10;

        ACK_O = 0;
        read_request_flag = 0;
        run_i2c = 0;

        //--------------------------------------------------
        // TEST 3
        // Error Handling
        //--------------------------------------------------

        #50;

        run_i2c = 1;

        #10;

        ERR_O = 1;

        #10;

        ERR_O = 0;
        run_i2c = 0;

        #50;

        $finish;

    end

endmodule