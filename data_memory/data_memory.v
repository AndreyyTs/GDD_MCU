module data_memory (
    input clk,
    input rst,
    input [31:0] address,
    input [31:0] write_data,
    input write_en,
    output [31:0] read_data
);

    // память с размером 1024x32
    reg [31:0] memory [0:1023];

    initial 
    begin
        // формат = 32'hXXXXXXXX;
        memory[0] = 32'h00001488;
        memory[1] = 32'h00000123; 
        memory[2] = 32'h00000321; 
        memory[2] = 32'h00000228; 
    end

    // чтение данных
    assign read_data = memory[address];
    

    // логика записи данных
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // тут надо сделать инициализацию памяти 
           
        end else if (write_en) begin
            memory[address] <= write_data;
        end
    end

endmodule