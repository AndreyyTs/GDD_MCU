`timescale 1ns/1ns
`include "InstructionMemory.v"

module InstructionMemory_tb;


reg [31:0] address;
wire [31:0] instruction;

InstructionMemory uut(address,instruction);

initial begin
    
    $dumpfile("InstructionMemory_tb.vcd");
    $dumpvars(0,InstructionMemory_tb);

    address = 32'h00000000;
    #20;
    address = 32'h00000001;
    #20;
    address = 32'h00000002;
    #20;
    address = 32'h00000003;
    #20;

    $display("test done");

end
    
endmodule