module top (
    input  logic       clk,      // Reloj maestro (Pin 52 - 27MHz)
    input  logic       reset,    // Botón de reset (Pin 3 - S1)

    // Interfaz física con el teclado matricial
    output logic [3:0] rows,     // Salidas hacia las filas del teclado
    input  logic [3:0] cols,     // Entradas desde las columnas del teclado

    // Interfaz física con el Display de 7 Segmentos
    output logic [3:0] an,       // Ánodos comunes (selector de dígito)
    output logic [6:0] seg       // Bus de segmentos [g-a]
);

    // --- Señales de Interconexión Interna ---
    logic rst;                  // Señal de reset sincronizada/invertida
    logic [3:0] key_value;      // Valor de la tecla estabilizada
    logic key_valid;            // Pulso de "tecla lista"
    logic [15:0] num_value;     // Valor (A, B o Suma) que se mostrará actualmente

    // Adaptación de Polaridad: 
    // Los botones en muchas placas de desarrollo son "Pull-up", 
    // enviando un 0 al presionar. Aquí lo invertimos para trabajar con lógica positiva.
    assign rst = ~reset;

    // ============================================================
    // 1. SUBSISTEMA DEL TECLADO
    // Encapsula el escaneo, la decodificación y el antirrebote.
    // ============================================================
    teclado_completo teclado_inst (
        .clk(clk),
        .rst(rst),
        .row(rows),      // Se conecta directamente a los pines externos
        .col(cols),      // Se conecta directamente a los pines externos
        .key_out(key_value),
        .valid(key_valid)
    );

    // ============================================================
    // 2. PROCESADOR ARITMÉTICO (SUMADOR BCD)
    // Almacena los números y realiza la suma corregida en base 10.
    // ============================================================
    sumador sumador_inst (
        .clk(clk),
        .rst(rst),
        .key_in(key_value),
        .valid(key_valid),
        .num_out(num_value) // El valor a mostrar depende del estado de la FSM
    );

    // ============================================================
    // 3. CONTROLADOR DE VISUALIZACIÓN
    // Toma el número de 16 bits y lo multiplexa en el display físico.
    // ============================================================
    display display_inst (
        .clk(clk),
        .rst(rst),
        .num_in(num_value),
        .enc_an(an),  // Control de ánodos comunes
        .enc_seg(seg)   // Control de segmentos (Lógica inversa)
    );

endmodule
