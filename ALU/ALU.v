module ALU (
    input [31:0] a,             // первый операнд
    input [31:0] b,             // второй операнд
    input [6:0]  operation,     // код операции
    output reg [31:0] result    // результат
);

    always @(*) begin

        // по умолчанию устанавливаем результат в 0
        result = 32'b0;
        
        // выбираем операцию на основе входного кода операции
        case (operation)
            7'b0000000: result = a + b;          // сложение
            7'b0000001: result = a - b;          // вычитание
            7'b0000010: result = a * b;          // умножение
            7'b0000011: result = a / b;          // деление
            7'b0000100: result = a & b;          // AND
            7'b0000101: result = a | b;          // OR
            7'b0000110: result = a ^ b;          // XOR
            7'b0000111: result = ~(a | b);       // NOR
            7'b0001000: result = a << b;         // сдвиг влево
            7'b0001001: result = a >> b;         // арифметический сдвиг вправо
            7'b0001010: result = a >>> b;        // логический сдвиг вправо
            // тут доп операции
        endcase
    end
    
endmodule
