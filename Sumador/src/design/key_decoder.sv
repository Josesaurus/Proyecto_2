module key_decoder (
    input  logic [1:0] scanned_row, // Índice de la fila activa (0 a 3) enviada por el escáner
    input  logic [3:0] col,         // Estado de las 4 columnas (leído desde los pines físicos)
    output logic [3:0] raw_key,     // Valor hexadecimal resultante de la tecla detectada
    output logic       fila_pres    // Bandera de detección de tecla presionada
);

    always_comb begin
        // Valores por defecto para evitar "latches": 
        // Si no se detecta nada, no hay presión y el valor es 0.
        fila_pres = 1'b0;
        raw_key   = 4'h0;
        
        case (scanned_row)
            // --- FILA 0 ---
            2'd0: if (col != 4'b0000) begin
                fila_pres = 1'b1;
                case (col)
                    4'b0001: raw_key = 4'h1; // Columna 0 -> Tecla 1
                    4'b0010: raw_key = 4'h2; // Columna 1 -> Tecla 2
                    4'b0100: raw_key = 4'h3; // Columna 2 -> Tecla 3
                    4'b1000: raw_key = 4'hA; // Columna 3 -> Tecla A
                    default: fila_pres = 1'b0;
                endcase
            end

            // --- FILA 1 ---
            2'd1: if (col != 4'b0000) begin
                fila_pres = 1'b1;
                case (col)
                    4'b0001: raw_key = 4'h4; // Columna 0 -> Tecla 4
                    4'b0010: raw_key = 4'h5; // Columna 1 -> Tecla 5
                    4'b0100: raw_key = 4'h6; // Columna 2 -> Tecla 6
                    4'b1000: raw_key = 4'hB; // Columna 3 -> Tecla B
                    default: fila_pres = 1'b0;
                endcase
            end

            // --- FILA 2 ---
            2'd2: if (col != 4'b0000) begin
                fila_pres = 1'b1;
                case (col)
                    4'b0001: raw_key = 4'h7; // Columna 0 -> Tecla 7
                    4'b0010: raw_key = 4'h8; // Columna 1 -> Tecla 8
                    4'b0100: raw_key = 4'h9; // Columna 2 -> Tecla 9
                    4'b1000: raw_key = 4'hC; // Columna 3 -> Tecla C
                    default: fila_pres = 1'b0;
                endcase
            end

            // --- FILA 3 ---
            2'd3: if (col != 4'b0000) begin
                fila_pres = 1'b1;
                case (col)
                    4'b0001: raw_key = 4'hE; // Tecla '*' (mapeada como E)
                    4'b0010: raw_key = 4'h0; // Tecla '0'
                    4'b0100: raw_key = 4'hF; // Tecla '#' (mapeada como F)
                    4'b1000: raw_key = 4'hD; // Tecla 'D'
                    default: fila_pres = 1'b0;
                endcase
            end
            
            default: fila_pres = 1'b0;
        endcase
    end
endmodule