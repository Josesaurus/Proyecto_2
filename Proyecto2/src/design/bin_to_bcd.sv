module bin_to_bcd ( // Convierte un número binario de 11 bits a su representación en BCD 
// para mostrarlo en 4 dígitos de 7 segmentos
    input  logic [10:0] binary_in, // Número binario de entrada (0 a 2047)

    output logic [3:0] thousands, 
    output logic [3:0] hundreds,
    output logic [3:0] tens,
    output logic [3:0] ones
);

    integer value; // Variable temporal para realizar las divisiones de los numerops y obtener los dígitos

    always_comb begin 
        value = binary_in; // Se asigna el valor de entrada a la variable temporal para realizar las divisiones

        thousands = value / 1000;
        value     = value % 1000;

        hundreds  = value / 100;
        value     = value % 100;

        tens      = value / 10;
        ones      = value % 10;
    end

endmodule