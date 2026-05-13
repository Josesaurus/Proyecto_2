module sumador_control (
    input  logic clk,
    input  logic rst,
    input  logic [3:0]  key_in,   // Tecla desde el debouncer
    input  logic        valid,    // Pulso de tecla válida
    input  logic [15:0] bcd_sum,  // Resultado desde el sumador BCD
    input  logic        bcd_cout, // Acarreo desde el sumador BCD

    output logic [15:0] num_1,    // Primer operando para el sumador
    output logic [15:0] num_2,    // Segundo operando para el sumador
    output logic [15:0] num_out   // Valor final hacia el módulo display
);

    // Definición de estados
    typedef enum logic [1:0] {
        NUM_A      = 2'b00,
        NUM_B      = 2'b01,
        SUM_C      = 2'b10,
        OVERFLOW_D = 2'b11
    } state_t;

    state_t state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= NUM_A;
            num_1 <= 16'h0000;
            num_2 <= 16'h0000;
        end else if (valid) begin
            case (key_in)
                4'hA: state <= NUM_A;
                4'hB: state <= NUM_B;
                4'hC: state <= SUM_C;
                4'hD: state <= OVERFLOW_D;
                default: begin
                    case (state)
                        NUM_A: begin
                            num_1 <= {num_1[11:0], key_in}; // Shift left nibble
                        end
                        NUM_B: begin
                            num_2 <= {num_2[11:0], key_in}; // Shift left nibble
                        end
                        default: state <= NUM_A;
                    endcase
                end
            endcase
        end
    end

    // Mux de salida al display
    always_comb begin
        case (state)
            NUM_A:      num_out = num_1;
            NUM_B:      num_out = num_2;
            SUM_C:      num_out = bcd_sum;
            OVERFLOW_D: num_out = {15'd0, bcd_cout}; 
            default:    num_out = 16'h0000;
        endcase
    end
endmodule