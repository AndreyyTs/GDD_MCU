module gownak (
    clk,
    PC,
    instruction,

    //ALU
    i_a,
    i_b,
    operation,
    i_result,
    over,



    reg_0,
    reg_1,
    reg_2,
    reg_3,
    reg_4,
    reg_5

);
    input   reg clk;                //тактовый сигнал
    output  reg [31:0]  PC;             // Program Counter
    output  reg [31:0]  instruction;    
    reg [31:0] FLAG;    // флаговый регистр 

    // инициализация регистров
    initial 
    begin
        PC =            32'h00000000;
        FLAG =          32'h00000000;
    end
    

    // тут 32бит x 32шт регистра общего назначения
    output reg [31:0] registers[0:31];
    initial 
    begin
        registers[0] = 1;
        for (integer i = 0; i < 32; i = i + 1) 
        begin
            registers[i] <= 32'b0;
        end
    end
    output  reg [31:0]  reg_0,reg_1,reg_2,reg_3,reg_4,reg_5;
    assign reg_0 = registers[0];
    assign reg_1 = registers[1];
    assign reg_2 = registers[2];
    assign reg_3 = registers[3];
    assign reg_4 = registers[4];
    assign reg_5 = registers[5];


    // тактовый блок
    always @(posedge clk) 
    begin
        PC <= PC + 1;
    end

   
    instruction_memory instruction_memory_gate (
      .address(PC),
      .instruction(instruction)     
    );


    ///////////////////////////////////
    output reg [4:0]    i_a;
    output reg [4:0]    i_b;
    output reg [5:0]    operation;
    output reg [4:0]    i_result;
    output reg [31:0]   over;

    assign operation = instruction[32:26];
    assign i_result  = instruction[14:10];
    assign i_a       = instruction[9:5];
    assign i_b       = instruction[4:0];


    // инструкция записи в регистр
    always @(negedge clk) 
    begin
        if (operation == 6'b010000)
        begin
            registers[i_result] <= instruction[9:0];
        end
    end

    // ALU
    always @(negedge clk) begin
        // выбираем операцию на основе входного кода операции
        case (operation)  
            6'b000001: registers[i_result] <= registers[i_a] + registers[i_b];      // сложение
            6'b000010: registers[i_result] <= registers[i_a] - registers[i_b];      // вычитание
            6'b000011: registers[i_result] <= registers[i_a] * registers[i_b];      // умножение
            6'b000100: registers[i_result] <= registers[i_a] / registers[i_b];      // деление
            6'b000101: registers[i_result] <= registers[i_a] & registers[i_b];      // AND
            6'b000110: registers[i_result] <= registers[i_a] | registers[i_b];      // OR
            6'b000111: registers[i_result] <= registers[i_a] ^ registers[i_b];      // XOR
            6'b001000: registers[i_result] <= ~(registers[i_a] | registers[i_b]);   // NOR result = ~(a | b);
            6'b001001: registers[i_result] <= registers[i_a] << i_b;     // сдвиг влево result = a << b;
            6'b001010: registers[i_result] <= registers[i_a] >> i_b;     // арифметический сдвиг вправо result = a >> b;
            6'b001011: registers[i_result] <= registers[i_a] >>> i_b;     // логический сдвиг вправо       // сложение result = a >>> b;

            6'b100000: PC <= (PC ^ PC) + instruction[25:0] - 1;                 //приыжок без условия 
            //6'b100001: begin if (registers[0] == 0) begin PC <= (PC ^ PC) + instruction[20:0] - 1 end end;                 //приыжок если выбранный регистр равен 0
          //6'b100001:  PC <= ((registers[0] == 32'b0)&(instruction[15:0]-1)) | ((registers[0] != 32'b0)&PC);                 //приыжок если выбранный регистр равен 0
            6'b100001:  PC <= (registers[0] == 32'b0) ? (instruction[15:0]-1) : PC;
            //ФОРМАТ           iiiiiiRRRRRadresadresadresadresa
            //memory[15]   = 32'b10001000000000000000000000000111;   // прыжок если регистр равен 0

            6'b100010:  PC <= (registers[i_a] > registers[i_b]) ? (instruction[26:10]-1) : PC;

        endcase
    end


    //alu alu_gate (
    //  .address(PC),
    //  .instruction(instruction)     
    //);

    //input [31:0] a,             // первый операнд
    //input [31:0] b,             // второй операнд
    //input [5:0]  operation,     // код операции
    //output reg [31:0] result,    // результат
    //output reg [31:0] over // для остатока или переполнение

    
    
endmodule


module instruction_memory 
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

        memory[0]   = 32'b00000000000000000000000000000000;   // NOP
        //ФОРМАТ          iiiiii           RRRRRaaaaaaaaaa
        memory[1]   = 32'b01000000000000000000010000011110;   // запись A = 30 в регистр 1
        //ФОРМАТ          iiiiii           RRRRRaaaaaaaaaa
        memory[2]   = 32'b01000000000000000000100000010010;   // запись B = 18 в регистр 2

        memory[3]   = 32'b00000000000000000000000000000000;   // NOP

        //                iiiiii           RRRRRaaaaabbbbb
        memory[4]   = 32'b00001000000000000000000000100010;   // REG_0 = A - B

        memory[5]   = 32'b10000100000000000000000010000000;   // прыжок если REG_0 равен 0


        //ФОРМАТ          iiiiii                aaaaabbbbb
        memory[6]   = 32'b10001000000000000010010000100010;   // прыжок если A > B
        //                iiiiii           RRRRRaaaaabbbbb
        memory[7]   = 32'b00001000000000000000100001000001;   // B = B - A

        //ФОРМАТ           iiiiiiAGRESAGRESAGRESAGRESAGRESA           
        memory[8]   = 32'b10000000000000000000000000000011;   // прыжок без условия

        //                iiiiii           RRRRRaaaaabbbbb
        memory[9]   = 32'b00001000000000000000010000100010;   // A = A - B

        //ФОРМАТ           iiiiiiAGRESAGRESAGRESAGRESAGRESA           
        memory[10]   = 32'b10000000000000000000000000000011;   // прыжок без условия



        //ФОРМАТ          iiiiii           RRRRRaaaaabbbbb
        //memory[3]   = 32'b00001000000000000000000000100010;    // вычетание  REG_0 = A - B
        //ФОРМАТ           iiiiiiRRRRRadresadresadresadresa
        //memory[4]   = 32'b1000010000000000000000010000000;   // прыжок в конец если REG_0 равен 0






        /*
        // инструкции в памяти тут, 
        // формат = 32'hXXXXXXXX;
        // i - инструкция R - результат а - 1 операнд b - второй операнд 
        //ФОРМАТ          iiiiii           RRRRRaaaaabbbbb      
        memory[0]   = 32'b00000000000000000000000000000000;   // NOP
        // проверка ALU
        memory[1]   = 32'b01000000000000000000000001100000;   // запись
        memory[2]   = 32'b01000000000000000000010000100000;   // запись
        memory[3]   = 32'b00000100000000000000100000000001;   // сложение
        memory[4]   = 32'b00001000000000000000100000000001;   // вычетание 
        memory[5]   = 32'b00001100000000000000100000000001;   // умножение
        memory[6]   = 32'b00010000000000000000100000000001;   // деление
        memory[7]   = 32'b00010100000000000000100000000001;   // AND
        memory[8]   = 32'b00011000000000000000100000000001;   // OR
        memory[9]   = 32'b00011100000000000000100000000001;   // XOR
        memory[10]  = 32'b00100000000000000000100000000001;   // NOR
        memory[11]  = 32'b00100100000000000000100000000001;   // сдвиг влево result = a << b;
        memory[12]  = 32'b00101000000000000000100000000001;   // арифметический сдвиг вправо result = a >> b;
        memory[13]  = 32'b00101100000000000000100000000001;   // логический сдвиг вправо       // сложение result = a >>> b;

        // проверка JMP
        //ФОРМАТ          iiiiiiAGRESAGRESAGRESAGRESAGRESAG            
        //memory[14]   = 32'b10000000000000000000000000000010;   // прыжок без условия
        memory[14]   = 32'b00000000000000000000000000000000;     // NOP


        memory[15]   = 32'b00000000000000000000000000000000;   // NOP
        memory[16]   = 32'b00000000000000000000000000000000;   // NOP
        //ФОРМАТ           iiiiiiRRRRRadresadresadresadresa
      //memory[17]   = 32'b10000100000000000000000000000010;   // прыжок если регистр равен 0
        memory[17]   = 32'b01000000000000000000000000000000;
        memory[18]   = 32'b10000100000000000000000000000100;   // прыжок если регистр равен 0


        memory[19]   = 32'b00000000000000000000000000000000;   // NOP
        memory[20]   = 32'b00000000000000000000000000000000;   // NOP
        memory[21]   = 32'b00000000000000000000000000000000;   // NOP


        // тут дальше заполняй память
        */
    end

    // чтение инструкции из памяти
    always @(*) 
    begin
        // достаточно 8 бит адреса, поскольку у нас всего 256 инструкций
        instruction = memory[address[7:0]]; 
        //i_result    = instruction[15:10];
        //i_a         = instruction[10:5];
        //i_b         = instruction[5:0];
    end

    

    

endmodule


module alu (
    input [31:0] a,             // первый операнд
    input [31:0] b,             // второй операнд
    input [5:0]  operation,     // код операции
    output reg [31:0] result,    // результат
    output reg [31:0] over // для остатока или переполнение

);

    always @(*) begin

        // по умолчанию устанавливаем результат в 0
        result = 32'b0;
        
        // выбираем операцию на основе входного кода операции
        case (operation)

            7'b000001: result = a + b;          // сложение
            7'b000010: result = a - b;          // вычитание
            7'b000011: result = a * b;          // умножение
            7'b000100: result = a / b;          // деление
            7'b000101: result = a & b;          // AND
            7'b000110: result = a | b;          // OR
            7'b000111: result = a ^ b;          // XOR
            7'b001000: result = ~(a | b);       // NOR
            7'b001001: result = a << b;         // сдвиг влево
            7'b001010: result = a >> b;         // арифметический сдвиг вправо
            7'b001011: result = a >>> b;        // логический сдвиг вправо

            //7'b010000: result = a ;             // запись в регистр
            // тут доп операции
        endcase
    end
    
endmodule







