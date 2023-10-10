module regfile (
    input clk,
    input rst,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    input write_en,
    output [31:0] read_data1,
    output [31:0] read_data2,

    output [31:0] log_reg_1,
    output [31:0] log_reg_2,
    output [31:0] log_reg_3
);
    // тут 32бит x 32шт регистра 
    reg [31:0] registers[31:0];

    // тут для профилирования
    assign log_reg_1 = registers[1];
    assign log_reg_2 = registers[2];
    assign log_reg_3 = registers[3];

    // регистры для чтения
    assign read_data1 = (read_reg1 == 5'd0) ? 32'd0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'd0) ? 32'd0 : registers[read_reg2];

    // куда срать
    always @(posedge clk or posedge rst) 
    begin
        if(rst) begin
            //registers <= (others => 32'd0);
        end else if(write_en && write_reg != 5'd0) 
        begin
            registers[write_reg] <= write_data;
        end
    end



endmodule