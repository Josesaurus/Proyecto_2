module display_mux #( // Mux para controlar 4 dígitos de 7 segmentos con un solo decodificador
    parameter int COUNTER_BITS = 16 
)(
    input  logic        clk,
    input  logic        reset,

    input  logic [3:0]  digit0, // unidades
    input  logic [3:0]  digit1, // decenas
    input  logic [3:0]  digit2, // centenas
    input  logic [3:0]  digit3, // miles

    output logic [6:0]  seg, // Salida para los segmentos (a, b, c, d, e, f, g)
    output logic [3:0]  an // Salida para los ánodos (an0, an1, an2, an3)
);

    logic [COUNTER_BITS-1:0] counter; // Contador que aumenta con cada flanco del reloj (27 MHz) 
    // Se usan altos para que sea mas lento
    logic [1:0] select; // Selecciona cuál dígito mostrar (00, 01, 10, 11)
    logic [3:0] current_digit; // El dígito actual que se va a mostrar

    always_ff @(posedge clk or posedge reset) begin // El contador se incrementa con cada flanco del reloj 
    // o se resetea si reset es alto
        if (reset)
            counter <= '0;
        else
            counter <= counter + 1'b1; 
    end

    assign select = counter[COUNTER_BITS-1 -: 2]; // Los bits más altos del contador se usan para seleccionar el dígito (cada 2^14 ciclos)

    always_comb begin // Basicamente el mux selecciona cuál dígito mostrar según el valor de select
        case (select)
            2'b00: begin
                current_digit = digit0;
                an = 4'b0001;
            end

            2'b01: begin
                current_digit = digit1;
                an = 4'b0010;
            end

            2'b10: begin
                current_digit = digit2;
                an = 4'b0100;
            end

            2'b11: begin
                current_digit = digit3;
                an = 4'b1000;
            end

            default: begin
                current_digit = 4'd0;
                an = 4'b0000;
            end
        endcase
    end

    sevenseg_decoder u_sevenseg_decoder ( // Se llama al decodificador de 7 segmentos
        .digit(current_digit),
        .seg(seg)
    );

endmodule