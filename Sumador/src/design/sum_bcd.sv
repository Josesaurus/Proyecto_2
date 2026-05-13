module bcd_adder_4digit (
    input  logic [15:0] a,     // Primer operando BCD
    input  logic [15:0] b,     // Segundo operando BCD
    output logic [15:0] sum,   // Resultado de la suma en BCD
    output logic        cout   // Acarreo final (quinto dígito)
);
    // Registros temporales de 5 bits para capturar el acarreo en el 5to bit
    logic [4:0] d0, d1, d2, d3; 

    always_comb begin
        // --- UNIDADES ---
        d0 = a[3:0] + b[3:0];
        if (d0 > 9) d0 = d0 + 6; 
        sum[3:0] = d0[3:0];

        // --- DECENAS ---
        d1 = a[7:4] + b[7:4] + d0[4];
        if (d1 > 9) d1 = d1 + 6;
        sum[7:4] = d1[3:0];

        // --- CENTENAS ---
        d2 = a[11:8] + b[11:8] + d1[4];
        if (d2 > 9) d2 = d2 + 6;
        sum[11:8] = d2[3:0];

        // --- MILES ---
        d3 = a[15:12] + b[15:12] + d2[4];
        if (d3 > 9) d3 = d3 + 6;
        sum[15:12] = d3[3:0];

        // Acarreo final de la suma completa
        cout = d3[4];
    end
endmodule