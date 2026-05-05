`timescale 1ns/1ps

module tb_keypad_scanner;

    logic clk;
    logic reset;

    logic [3:0] rows;
    logic [3:0] cols;

    logic [3:0] row_detected;
    logic [3:0] col_detected;
    logic       key_pressed;

    keypad_scanner #(
        .SCAN_MAX(4)
    ) dut (
        .clk(clk),
        .reset(reset),
        .rows(rows),
        .cols(cols),
        .row_detected(row_detected),
        .col_detected(col_detected),
        .key_pressed(key_pressed)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_keypad_scanner.vcd");
        $dumpvars(0, tb_keypad_scanner);

        clk   = 1'b0;
        reset = 1'b1;
        rows  = 4'b0000;

        #20;
        reset = 1'b0;

        // Sin tecla
        #50;

        // Simular tecla presionada en fila 1
        rows = 4'b0001;
        #80;

        // Soltar tecla
        rows = 4'b0000;
        #50;

        // Simular tecla presionada en fila 3
        rows = 4'b0100;
        #80;

        // Soltar tecla
        rows = 4'b0000;
        #50;

        $finish;
    end

endmodule