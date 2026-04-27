//FSM = Maquina de Estados Finitos
/* 
Ejemplo:   
key_value = 4'd5  - tecla 5
key_value = 4'hA  - tecla A
key_value = 4'hB  - tecla B
key_value = 4'hC  - tecla C 

Teclas usadas:
0-9 = ingresar dígitos
A   = terminar número A y pasar a número B
B   = terminar número B y mostrar resultado
C   = borrar/reiniciar

*/

module input_fsm ( 
    // FSM para manejar la entrada de números a través del teclado y controlar cuándo mostrar el resultado
    input  logic        clk,
    input  logic        reset,

    input  logic [3:0]  key_value, 
    input  logic        key_tick,
    input  logic        key_valid,

    output logic [9:0]  number_a, // Primer número de entrada
    output logic [9:0]  number_b, // Segundo número de entrada
    output logic        show_result // Indica que ya debe enseñar la suma
);

    typedef enum logic [1:0] { 
        // 3 estados de la FSM: 
        // ingresar primer número, ingresar segundo número, mostrar resultado
        ENTER_A,
        ENTER_B,
        RESULT
    } state_t;

    state_t state_reg, state_next; // Registros para el estado actual y el siguiente

    // Estos registros se actualizan en cada ciclo de reloj para avanzar en la FSM
    logic [9:0] number_a_next;
    logic [9:0] number_b_next;
    logic       show_result_next;

    logic is_digit;

    // is_digit es una señal que indica si la tecla presionada es un numero (0-9) o no 
    // Sirve para saber si se debe actualizar el número actual o cambiar de estado
    assign is_digit = (key_value <= 4'd9);

    always_ff @(posedge clk or posedge reset) begin 
        // En cada flanco del clk se actualizan los registros del estado y los números
        if (reset) begin // Si se resetea, se vuelve al estado inicial y se limpian los números y la señal de mostrar resultado
            state_reg   <= ENTER_A; 
            number_a    <= 10'd0; 
            number_b    <= 10'd0;
            show_result <= 1'b0;
        end else begin // Si no se resetea, se actualizan los registros con los valores calculados en el bloque combinacional
            state_reg   <= state_next;
            number_a    <= number_a_next;
            number_b    <= number_b_next;
            show_result <= show_result_next;
        end
    end

    always_comb begin 
    // Aquí se decide que va a pasar
    // Primero se deja todo igual. Si no se presiona nada, el sistema conserva su valor
        state_next       = state_reg;
        number_a_next    = number_a;
        number_b_next    = number_b;
        show_result_next = show_result;

        if (key_tick && key_valid) begin // Solo hace algo cuando se presiona una tecla nueva
            case (state_reg)

                ENTER_A: begin //PRIMER ESTADO: Ingresar el primer número
                    show_result_next = 1'b0;

                    if (is_digit) begin 
                    // Si se presionó un número, se actualiza number_a multiplicando el valor actual por 10 y sumando el nuevo dígito
                    // Por ejemplo: number_a = 0*10 + 1 = 1
                        if (number_a <= 10'd99)
                            number_a_next = (number_a * 10) + key_value;
                    end

                    // A = pasar al segundo número
                    else if (key_value == 4'hA) begin 
                        state_next = ENTER_B;
                    end

                    // C = borrar todo
                    else if (key_value == 4'hC) begin
                        number_a_next    = 10'd0;
                        number_b_next    = 10'd0;
                        show_result_next = 1'b0;
                        state_next       = ENTER_A;
                    end
                end

                /* O sea: 
                Se presiona 1:
                number_a = 0*10 + 1 = 1

                Se presiona 2:
                number_a = 1*10 + 2 = 12

                Se presiona 3:
                number_a = 12*10 + 3 = 123
                 */

                ENTER_B: begin // SEGUNDO ESTADO: Ingresar el segundo número
                    show_result_next = 1'b0;

                    if (is_digit) begin
                        // La misma idea de antes
                        if (number_b <= 10'd99)
                            number_b_next = (number_b * 10) + key_value;
                    end

                    // B = calcular / mostrar resultado
                    else if (key_value == 4'hB) begin
                        show_result_next = 1'b1;
                        state_next       = RESULT;
                    end

                    // C = borrar todo
                    else if (key_value == 4'hC) begin
                        number_a_next    = 10'd0;
                        number_b_next    = 10'd0;
                        show_result_next = 1'b0;
                        state_next       = ENTER_A;
                    end
                end

                RESULT: begin
                    // C = borrar y empezar de nuevo
                    if (key_value == 4'hC) begin
                        number_a_next    = 10'd0;
                        number_b_next    = 10'd0;
                        show_result_next = 1'b0;
                        state_next       = ENTER_A;
                    end
                end

                default: begin 
                    state_next       = ENTER_A;
                    number_a_next    = 10'd0;
                    number_b_next    = 10'd0;
                    show_result_next = 1'b0;
                end

            endcase
        end
    end

endmodule