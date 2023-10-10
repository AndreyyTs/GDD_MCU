`timescale 1ns/1ns
`include "ALU.v"

module ALU_tb;


reg [31:0] a;
reg [31:0] b;

reg [6:0] operation;


wire [31:0] result;

ALU uut(a, b, operation, result);

initial begin
    
    $dumpfile("ALU_tb.vcd");
    $dumpvars(0,ALU_tb);

    a = 32'h00000001;
    b = 32'h00000002;
    operation = 7'b0000000;
    #20;

    a = 32'h00000007;
    b = 32'h00000002;
    operation = 7'b0000001;
    #20;


    $display("test done");

end
    
endmodule