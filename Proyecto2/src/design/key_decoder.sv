module key_decoder ( 
    // Decodifica la combinación de filas y columnas detectadas por el escáner del teclado
    input  logic [3:0] row_detected,
    input  logic [3:0] col_detected,

    output logic [3:0] key_value,
    output logic       key_valid
);

    always_comb begin
        key_value = 4'h0;
        key_valid = 1'b1;

        case ({row_detected, col_detected}) 
        // Se combinan las filas y columnas detectadas para identificar la tecla 

            // Columna 0
            8'b0001_0001: key_value = 4'h1;
            8'b0010_0001: key_value = 4'h4;
            8'b0100_0001: key_value = 4'h7;
            8'b1000_0001: key_value = 4'hE; // *

            // Columna 1
            8'b0001_0010: key_value = 4'h2;
            8'b0010_0010: key_value = 4'h5;
            8'b0100_0010: key_value = 4'h8;
            8'b1000_0010: key_value = 4'h0;

            // Columna 2
            8'b0001_0100: key_value = 4'h3;
            8'b0010_0100: key_value = 4'h6;
            8'b0100_0100: key_value = 4'h9;
            8'b1000_0100: key_value = 4'hF; // #

            // Columna 3
            8'b0001_1000: key_value = 4'hA;
            8'b0010_1000: key_value = 4'hB;
            8'b0100_1000: key_value = 4'hC;
            8'b1000_1000: key_value = 4'hD;

            default: begin
                key_value = 4'h0;
                key_valid = 1'b0;
            end
        endcase
    end

endmodule