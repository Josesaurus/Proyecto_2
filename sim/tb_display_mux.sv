`timescale 1ns/1ps

module tb_display_mux;

    logic clk;
    logic reset;

    logic [3:0] digit0;
    logic [3:0] digit1;
    logic [3:0] digit2;
    logic [3:0] digit3;

    logic [6:0] seg;
    logic [3:0] an;

    display_mux #(
        .COUNTER_BITS(4)
    ) dut (
        .clk(clk),
        .reset(reset),
        .digit0(digit0),
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3),
        .seg(seg),
        .an(an)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_display_mux.vcd");
        $dumpvars(0, tb_display_mux);

        clk   = 1'b0;
        reset = 1'b1;

        digit0 = 4'd4;
        digit1 = 4'd3;
        digit2 = 4'd2;
        digit3 = 4'd1;

        #20;
        reset = 1'b0;

        #300;

        digit0 = 4'd8;
        digit1 = 4'd9;
        digit2 = 4'd9;
        digit3 = 4'd1;

        #300;

        $finish;
    end

endmodule