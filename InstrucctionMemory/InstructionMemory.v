module InstructionMemory 
(
    address,      // адрес инструкции
    instruction   // адрес инструкции
);

    input   wire [31:0] address;        // адрес инструкции
    output  reg  [31:0] instruction;    // адрес инструкциии

    // 256 x 32-битная память
    reg [31:0] memory [0:255]; 
    initial 
    begin
        // инструкции в памяти тут, 
        // формат = 32'hXXXXXXXX;
        memory[0] = 32'h00000123; 
        memory[1] = 32'h00000321; 
        memory[2] = 32'h00000001;
        memory[3] = 32'h00000002;
        memory[4] = 32'h00000003;
        memory[5] = 32'h00000003;
        memory[6] = 32'h00000003;
        // тут дальше заполняй память
    end

    // чтение инструкции из памяти
    always @(address) 
    begin
        // достаточно 8 бит адреса, поскольку у нас всего 256 инструкций
        instruction = memory[address[7:0]]; 
    end

endmodule
