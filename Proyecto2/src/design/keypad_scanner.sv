module keypad_scanner #( // Módulo para escanear un teclado matriz de 4x4 y detectar qué tecla se está presionando
    parameter int SCAN_MAX = 27000  // aprox. 1 ms con reloj de 27 MHz
)(
    input  logic       clk,
    input  logic       reset,

    input  logic [3:0] rows,       // entradas desde las filas del teclado
    output logic [3:0] cols,       // salidas hacia las columnas del teclado

    output logic [3:0] row_detected, // Indica que fila tiene una tecla presionada (1 en la posición de la fila detectada)
    output logic [3:0] col_detected, // 1 en la posición de la columna activa
    output logic       key_pressed
);

    logic [$clog2(SCAN_MAX)-1:0] scan_counter; 
    logic [1:0] col_index;

    // Contador para cambiar de columna cada cierto tiempo
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            scan_counter <= '0;
            col_index    <= 2'd0;
        end else begin
            if (scan_counter == SCAN_MAX - 1) begin
                scan_counter <= '0;
                col_index    <= col_index + 1'b1;
            end else begin
                scan_counter <= scan_counter + 1'b1;
            end
        end
    end

    // Activación de columnas, una a la vez
    always_comb begin
        case (col_index)
            2'd0: cols = 4'b0001;
            2'd1: cols = 4'b0010;
            2'd2: cols = 4'b0100;
            2'd3: cols = 4'b1000;
            default: cols = 4'b0001;
        endcase
    end

    // Detección de tecla
    always_comb begin
        key_pressed  = 1'b0;
        row_detected = 4'b0000;
        col_detected = cols;

        if (rows != 4'b0000) begin
            key_pressed  = 1'b1;
            row_detected = rows;
        end
    end

endmodule