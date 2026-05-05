`timescale 1ns/1ps

module tb_key_decoder;

    logic [3:0] row_detected;
    logic [3:0] col_detected;
    logic [3:0] key_value;
    logic       key_valid;

    key_decoder dut (
        .row_detected(row_detected),
        .col_detected(col_detected),
        .key_value(key_value),
        .key_valid(key_valid)
    );

    initial begin
        $dumpfile("tb_key_decoder.vcd");
        $dumpvars(0, tb_key_decoder);

        // Tecla 1
        row_detected = 4'b0001;
        col_detected = 4'b0001;
        #10;

        // Tecla 5
        row_detected = 4'b0010;
        col_detected = 4'b0010;
        #10;

        // Tecla 9
        row_detected = 4'b0100;
        col_detected = 4'b0100;
        #10;

        // Tecla 0
        row_detected = 4'b1000;
        col_detected = 4'b0010;
        #10;

        // Tecla A
        row_detected = 4'b0001;
        col_detected = 4'b1000;
        #10;

        // Tecla B
        row_detected = 4'b0010;
        col_detected = 4'b1000;
        #10;

        // Tecla C
        row_detected = 4'b0100;
        col_detected = 4'b1000;
        #10;

        // Combinación inválida
        row_detected = 4'b0000;
        col_detected = 4'b0000;
        #10;

        $finish;
    end

endmodule