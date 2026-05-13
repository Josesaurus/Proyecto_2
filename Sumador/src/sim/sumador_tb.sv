`timescale 1ns / 1ps

module sumador_tb();
    logic clk;
    logic rst;
    logic [3:0] key_in;
    logic valid;
    logic [15:0] num_out;

    // Instancia de la Unidad Bajo Prueba (UUT)
    sumador uut (.*);

    // Generación de reloj (100MHz)
    always #5 clk = ~clk;

    // Tarea para simular la presión de una tecla
    task press_key(input [3:0] key);
        begin
            key_in = key;
            valid = 1;
            #10;
            valid = 0;
            #40; // Espera entre teclas
        end
    endtask

    initial begin
        // Inicialización
        clk = 0;
        rst = 1;
        key_in = 0;
        valid = 0;
        #20 rst = 0;

        // --- TEST 1: Ingresar número en NUM_A (ej. 12) ---
        $display("Ingresando 12 en Operando A...");
        press_key(4'h1);
        press_key(4'h2);
        
        // --- TEST 2: Pasar a NUM_B e ingresar número (ej. 9) ---
        $display("Cambiando a B e ingresando 9...");
        press_key(4'hB); // Tecla de comando B
        press_key(4'h9);

        // --- TEST 3: Ver resultado de la suma (12 + 9 = 21) ---
        $display("Cambiando a SUM_C...");
        press_key(4'hC);
        #20;
        if (num_out == 16'h0021) $display("Suma Correcta: 21");
        else $display("Error en suma: %h", num_out);

        #100 $finish;
    end
endmodule