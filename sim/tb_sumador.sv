`timescale 1ns/1ps

module tb_sumador;

    logic [9:0]  number_a;
    logic [9:0]  number_b;
    logic [10:0] result;

    sumador dut (
        .number_a(number_a),
        .number_b(number_b),
        .result(result)
    );

    initial begin
        $dumpfile("tb_sumador.vcd");
        $dumpvars(0, tb_sumador);

        number_a = 10'd0;
        number_b = 10'd0;
        #10;

        number_a = 10'd123;
        number_b = 10'd456;
        #10;

        number_a = 10'd999;
        number_b = 10'd999;
        #10;

        number_a = 10'd250;
        number_b = 10'd750;
        #10;

        number_a = 10'd1;
        number_b = 10'd999;
        #10;

        $finish;
    end

endmodule