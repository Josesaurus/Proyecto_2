`timescale 1ns/1ps

module tb_bin_to_bcd;

    logic [10:0] binary_in;
    logic [3:0]  thousands;
    logic [3:0]  hundreds;
    logic [3:0]  tens;
    logic [3:0]  ones;

    bin_to_bcd dut (
        .binary_in(binary_in),
        .thousands(thousands),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );

    initial begin
        $dumpfile("tb_bin_to_bcd.vcd");
        $dumpvars(0, tb_bin_to_bcd);

        binary_in = 11'd0;
        #10;

        binary_in = 11'd5;
        #10;

        binary_in = 11'd42;
        #10;

        binary_in = 11'd123;
        #10;

        binary_in = 11'd579;
        #10;

        binary_in = 11'd1000;
        #10;

        binary_in = 11'd1998;
        #10;

        $finish;
    end

endmodule