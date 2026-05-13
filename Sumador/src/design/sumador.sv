module sumador (
    input  logic clk,
    input  logic rst,
    input  logic [3:0]  key_in,
    input  logic        valid,
    output logic [15:0] num_out
);

    logic [15:0] n1, n2, res;
    logic carry;

    // Instancia del motor de cálculo BCD
    bcd_adder_4digit unit_arit (
        .a(n1),
        .b(n2),
        .sum(res),
        .cout(carry)
    );

    // Instancia del sistema de control e interfaz
    sumador_control unit_ctrl (
        .clk(clk),
        .rst(rst),
        .key_in(key_in),
        .valid(valid),
        .bcd_sum(res),
        .bcd_cout(carry),
        .num_1(n1),
        .num_2(n2),
        .num_out(num_out)
    );

endmodule