module debouncer_sync #( // Módulo para eliminar el rebote del botón y sincronizar su señal al reloj del sistema
    parameter int COUNTER_MAX = 270000  // aprox. 10 ms con reloj de 27 MHz
)(
    input  logic clk,
    input  logic reset,
    input  logic noisy_in, // Señal del botón con rebote

    output logic clean_level, // Nivel limpio del botón (1 cuando se presiona, 0 cuando no)
    output logic clean_tick // Pulso de un ciclo de reloj cuando se detecta un cambio bueno (transición de 0 a 1)
);

    logic sync_0; // Primer flip-flop para sincronizar la señal del botón al reloj del sistema
    logic sync_1; // Segundo flip-flop para asegurar que la señal esté sincronizada y eliminar el rebote

    logic stable_state;
    logic [$clog2(COUNTER_MAX)-1:0] counter; 

    // Sincronizador de 2 flip-flops
    always_ff @(posedge clk or posedge reset) begin 
// En cada flanco del reloj se sincroniza la señal del botón a través de llos dos flip-flops para eliminar el rebote
        if (reset) begin // Si se resetea, se ponen ambos flip-flops en 0
            sync_0 <= 1'b0;
            sync_1 <= 1'b0;
        end else begin // Si no se resetea, se actualizan los flip-flops con la señal del botón 
        // sync_0 toma el valor de noisy_in y sync_1 toma el valor de sync_0
            sync_0 <= noisy_in;
            sync_1 <= sync_0;
        end
    end

    // Antirrebote
    always_ff @(posedge clk or posedge reset) begin  
// En cada flanco del reloj se verifica si la señal sincronizada ha cambiado de estado 
// y se mantiene estable durante el tiempo necesario para considerar que es un cambio válido
        if (reset) begin
            stable_state <= 1'b0;
            clean_level  <= 1'b0;
            clean_tick   <= 1'b0;
            counter      <= '0;
        end else begin // Si no se resetea, se verifica si la señal sincronizada ha cambiado de estado
            clean_tick <= 1'b0;

            if (sync_1 == stable_state) begin // Si la señal sincronizada es igual al estado estable actual, se resetea el contador
                counter <= '0;
            end else begin
                if (counter == COUNTER_MAX - 1) begin
                    stable_state <= sync_1;
                    clean_level  <= sync_1;
                    counter      <= '0;

                    if (sync_1 == 1'b1)
                        clean_tick <= 1'b1;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
        end
    end

endmodule