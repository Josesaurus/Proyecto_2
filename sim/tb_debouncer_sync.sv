`timescale 1ns/1ps

module tb_debouncer_sync;

    logic clk;
    logic reset;
    logic noisy_in;
    logic clean_level;
    logic clean_tick;

    debouncer_sync #(
        .COUNTER_MAX(5)
    ) dut (
        .clk(clk),
        .reset(reset),
        .noisy_in(noisy_in),
        .clean_level(clean_level),
        .clean_tick(clean_tick)
    );

    always #5 clk = ~clk; // reloj de 100 MHz para simulación

    initial begin
        $dumpfile("tb_debouncer_sync.vcd");
        $dumpvars(0, tb_debouncer_sync);

        clk      = 1'b0;
        reset    = 1'b1;
        noisy_in = 1'b0;

        #20;
        reset = 1'b0;

        // Simulación de rebote al presionar
        noisy_in = 1'b1; #10;
        noisy_in = 1'b0; #10;
        noisy_in = 1'b1; #10;
        noisy_in = 1'b0; #10;
        noisy_in = 1'b1;

        // Se deja estable en 1
        #100;

        // Simulación de soltar tecla
        noisy_in = 1'b0; #10;
        noisy_in = 1'b1; #10;
        noisy_in = 1'b0; #10;
        noisy_in = 1'b1; #10;
        noisy_in = 1'b0;

        // Se deja estable en 0
        #100;

        $finish;
    end

endmodule