`timescale 1ns/1ns
`include "gownak.sv"

module test_gownak;


reg clk;
reg [31:0]  PC;
reg [31:0]  instruction;

reg [4:0]   i_a;
reg [4:0]   i_b;
reg [5:0]   operation;
reg [4:0]   i_result;
reg [31:0]  over;


 
reg [31:0]  reg_0;
reg [31:0]  reg_1;
reg [31:0]  reg_2;
reg [31:0]  reg_3;
reg [31:0]  reg_4;
reg [31:0]  reg_5;



gownak uut(clk, PC, instruction,
            i_a, i_b, operation, i_result, over,
            
            reg_0,reg_1,reg_2,reg_3,reg_4,reg_5);

    initial begin
        
        $dumpfile("test_gownak.vcd");
        $dumpvars(0,test_gownak);
        clk = 0;




        #1000 $finish;
        $display("test done");

    end
    always #5 clk = ~clk;
    
endmodule