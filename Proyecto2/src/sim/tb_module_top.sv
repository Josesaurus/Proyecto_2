`timescale 1ns/1ps

module tb_module_top;

    logic [3:0] codigo_gray_pi;
    logic [2:0] pos_error_pi;
    logic button;

    logic [6:0] catodo_p0;
    logic [0:0] anodo_p0;
    logic [6:0] catodo_trans;
    logic [0:0] anodo_p1;
    logic [3:0] codigo_bin_led_p0;

    module_top dut (
        .codigo_gray_pi(codigo_gray_pi),
        .pos_error_pi(pos_error_pi),
        .button(button),
        .catodo_p0(catodo_p0),
        .anodo_p0(anodo_p0),
        .catodo_trans(catodo_trans),
        .anodo_p1(anodo_p1),
        .codigo_bin_led_p0(codigo_bin_led_p0)
    );

    initial begin
        $dumpfile("tb_module_top.vcd");
        $dumpvars(0, tb_module_top);

        $display("==============================================");
        $display("Inicio testbench module_top");
        $display("==============================================");

        // Caso 1: entrada 1011, sin botón
        codigo_gray_pi = 4'b1011;
        pos_error_pi   = 3'b000;
        button         = 1'b0;
        #10;
        $display("Caso1 -> in=%b pos=%b btn=%b leds=%b disp_in=%b disp_tx=%b an0=%b an1=%b",
                 codigo_gray_pi, pos_error_pi, button, codigo_bin_led_p0, catodo_p0, catodo_trans, anodo_p0, anodo_p1);

        // Caso 2: misma entrada, botón activo, sin error
        codigo_gray_pi = 4'b1011;
        pos_error_pi   = 3'b000;
        button         = 1'b1;
        #10;
        $display("Caso2 -> in=%b pos=%b btn=%b leds=%b disp_in=%b disp_tx=%b an0=%b an1=%b",
                 codigo_gray_pi, pos_error_pi, button, codigo_bin_led_p0, catodo_p0, catodo_trans, anodo_p0, anodo_p1);

        // Caso 3: misma entrada, botón activo, con error en bit 0
        codigo_gray_pi = 4'b1011;
        pos_error_pi   = 3'b001;
        button         = 1'b1;
        #10;
        $display("Caso3 -> in=%b pos=%b btn=%b leds=%b disp_in=%b disp_tx=%b an0=%b an1=%b",
                 codigo_gray_pi, pos_error_pi, button, codigo_bin_led_p0, catodo_p0, catodo_trans, anodo_p0, anodo_p1);

        // Caso 4: misma entrada, botón activo, con error en bit 6
        codigo_gray_pi = 4'b1011;
        pos_error_pi   = 3'b111;
        button         = 1'b1;
        #10;
        $display("Caso4 -> in=%b pos=%b btn=%b leds=%b disp_in=%b disp_tx=%b an0=%b an1=%b",
                 codigo_gray_pi, pos_error_pi, button, codigo_bin_led_p0, catodo_p0, catodo_trans, anodo_p0, anodo_p1);

        // Caso 5: nueva entrada
        codigo_gray_pi = 4'b0101;
        pos_error_pi   = 3'b100;
        button         = 1'b1;
        #10;
        $display("Caso5 -> in=%b pos=%b btn=%b leds=%b disp_in=%b disp_tx=%b an0=%b an1=%b",
                 codigo_gray_pi, pos_error_pi, button, codigo_bin_led_p0, catodo_p0, catodo_trans, anodo_p0, anodo_p1);

        $display("==============================================");
        $display("Fin testbench module_top");
        $display("==============================================");

        $finish;
    end

endmodule