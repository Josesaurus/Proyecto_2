`timescale 1ns/1ps

module tb_top;

    logic clk;
    logic reset;

    logic [3:0] rows;
    logic [3:0] cols;

    logic [6:0] seg;
    logic [3:0] an;

    top dut (
        .clk(clk),
        .reset(reset),
        .rows(rows),
        .cols(cols),
        .seg(seg),
        .an(an)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);

        clk   = 1'b0;
        reset = 1'b1;
        rows  = 4'b0000;

        #50;
        reset = 1'b0;

        // Simulación muy básica de actividad en teclado.
        // en el top real el scanner cambia cols internamente.
        #200;
        rows = 4'b0001;

        #500;
        rows = 4'b0000;

        #200;
        rows = 4'b0010;

        #500;
        rows = 4'b0000;

        #1000;

        $finish;
    end

endmodule