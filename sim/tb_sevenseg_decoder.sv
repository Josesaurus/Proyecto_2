`timescale 1ns/1ps

module tb_sevenseg_decoder;

    logic [3:0] digit;
    logic [6:0] seg;

    sevenseg_decoder dut (
        .digit(digit),
        .seg(seg)
    );

    initial begin
        $dumpfile("tb_sevenseg_decoder.vcd");
        $dumpvars(0, tb_sevenseg_decoder);

        digit = 4'd0; #10;
        digit = 4'd1; #10;
        digit = 4'd2; #10;
        digit = 4'd3; #10;
        digit = 4'd4; #10;
        digit = 4'd5; #10;
        digit = 4'd6; #10;
        digit = 4'd7; #10;
        digit = 4'd8; #10;
        digit = 4'd9; #10;

        // Valor no decimal, debe mostrar error/guion según tu decoder
        digit = 4'hA; #10;

        $finish;
    end

endmodule