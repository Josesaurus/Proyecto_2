module sumador ( // Suma dos números de 10 bits y da un resultado de 11 bits para manejar el posible carry
    input  logic [9:0] number_a,
    input  logic [9:0] number_b,
    output logic [10:0] result
);

    always_comb begin // La suma se realiza de manera combinacional 
    // el resultado se actualiza inmediatamente cuando cambian las entradas
        result = number_a + number_b;
    end

endmodule