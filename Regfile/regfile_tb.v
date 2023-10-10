`timescale 1ns/1ns
`include "regfile.v"

module regfile_tb;


reg clk;
reg rst;
reg [4:0] read_reg1;
reg [4:0] read_reg2;
reg [4:0] write_reg;
reg [31:0] write_data;
reg write_en; 

wire [31:0] read_data1;
wire [31:0] read_data2;

wire [31:0] log_reg_1;
wire [31:0] log_reg_2;
wire [31:0] log_reg_3;



regfile uut
(
    clk,
    rst,
    read_reg1,
    read_reg2,
    write_reg,
    write_data,
    write_en,
    read_data1,
    read_data2,
    log_reg_1,
    log_reg_2,
    log_reg_3
);

initial begin
    
    $dumpfile("regfile_tb.vcd");
    $dumpvars(0,regfile_tb);
    write_en = 1;
    clk = 0;
    #20;

    write_reg   = 5'd00001;
    write_data  = 32'h00001511;
    #20;

    clk = 1;
    #20;
    clk = 0;
    #20;

    write_reg   = 5'd00002;
    write_data  = 32'h00000123;
    #20;

    clk = 1;
    #20;
    clk = 0;
    #20;

    write_reg   = 5'd00003;
    write_data  = 32'h00000312;
    #20;

    clk = 1;
    #20;
    clk = 0;
    #20;





   // a = 32'h00000001;
    //b = 32'h00000002;
    //operation = 7'b0000000;
    //#20;

    //a = 32'h00000007;
    //b = 32'h00000002;
    //operation = 7'b0000001;
    //#20;


    $display("test done");

end
    
endmodule