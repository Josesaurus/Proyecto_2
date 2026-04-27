module top ( 
    input  logic clk,
    input  logic reset,

    input  logic [3:0] rows,
    output logic [3:0] cols,

    output logic [6:0] seg,
    output logic [3:0] an
);
    
    // Señales internas

    logic [3:0] row_detected;
    logic [3:0] col_detected;
    logic raw_key_pressed;

    logic clean_key_level;
    logic clean_key_tick;

    logic [3:0] key_value;
    logic key_valid;

    logic [9:0] number_a;
    logic [9:0] number_b;

    logic [10:0] sum_result;

    logic [3:0] thousands;
    logic [3:0] hundreds;
    logic [3:0] tens;
    logic [3:0] ones;

    logic show_result;
   
    // Escaneo del teclado
    
    keypad_scanner u_keypad_scanner (
        .clk(clk),
        .reset(reset),
        .rows(rows),
        .cols(cols),
        .row_detected(row_detected),
        .col_detected(col_detected),
        .key_pressed(raw_key_pressed)
    );
    
    // Antirrebote
    
    debouncer_sync u_debouncer (
        .clk(clk),
        .reset(reset),
        .noisy_in(raw_key_pressed),
        .clean_level(clean_key_level),
        .clean_tick(clean_key_tick)
    );
    
    // Decodificador de tecla
    
    key_decoder u_key_decoder (
        .row_detected(row_detected),
        .col_detected(col_detected),
        .key_value(key_value),
        .key_valid(key_valid)
    );
    
    // FSM de entrada    

    input_fsm u_input_fsm (
        .clk(clk),
        .reset(reset),
        .key_value(key_value),
        .key_tick(clean_key_tick),
        .key_valid(key_valid),
        .number_a(number_a),
        .number_b(number_b),
        .show_result(show_result)
    );
    
    // Sumador    

    sumador u_sumador (
        .number_a(number_a),
        .number_b(number_b),
        .result(sum_result)
    );
    
    // Binario a BCD    

    bin_to_bcd u_bin_to_bcd (
        .binary_in(sum_result),
        .thousands(thousands),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );
    
    // Display multiplexado    

    display_mux u_display_mux (
        .clk(clk),
        .reset(reset),
        .digit0(ones),
        .digit1(tens),
        .digit2(hundreds),
        .digit3(thousands),
        .seg(seg),
        .an(an)
    );

endmodule