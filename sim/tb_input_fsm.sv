`timescale 1ns/1ps

module tb_input_fsm;

    logic clk;
    logic reset;

    logic [3:0] key_value;
    logic       key_tick;
    logic       key_valid;

    logic [9:0] number_a;
    logic [9:0] number_b;
    logic       show_result;

    input_fsm dut (
        .clk(clk),
        .reset(reset),
        .key_value(key_value),
        .key_tick(key_tick),
        .key_valid(key_valid),
        .number_a(number_a),
        .number_b(number_b),
        .show_result(show_result)
    );

    always #5 clk = ~clk;

    task press_key(input logic [3:0] value);
        begin
            @(negedge clk);
            key_value = value;
            key_valid = 1'b1;
            key_tick  = 1'b1;

            @(negedge clk);
            key_tick  = 1'b0;
        end
    endtask

    initial begin
        $dumpfile("tb_input_fsm.vcd");
        $dumpvars(0, tb_input_fsm);

        clk       = 1'b0;
        reset     = 1'b1;
        key_value = 4'd0;
        key_tick  = 1'b0;
        key_valid = 1'b0;

        #20;
        reset = 1'b0;

        // Ingresar 123
        press_key(4'd1);
        press_key(4'd2);
        press_key(4'd3);

        // A = pasar al segundo número
        press_key(4'hA);

        // Ingresar 456
        press_key(4'd4);
        press_key(4'd5);
        press_key(4'd6);

        // B = mostrar resultado
        press_key(4'hB);

        #50;

        // C = borrar
        press_key(4'hC);

        #50;

        $finish;
    end

endmodule