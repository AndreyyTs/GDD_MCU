`timescale 1ns/1ns
`include "data_memory.v"

module data_memory_tb;

reg clk;
reg rst;
reg [31:0] address;
reg [31:0] write_data;
reg write_en; 

wire [31:0] read_data;




data_memory uut
(
    clk,
    rst,
    address,
    write_data,
    write_en,
    read_data

);

initial begin
    
    $dumpfile("data_memory_tb.vcd");
    $dumpvars(0,data_memory_tb);

    write_en = 0;

    clk = 0;
    #20;

    address = 32'h00000000;
    #20;
    address = 32'h00000001;
    #20;
    address = 32'h00000002;
    #20;




    //write_en = 1;
    //clk = 0;
    //#20;

    //write_reg   = 5'd00001;
    //write_data  = 32'h00001511;
    //#20;

    //clk = 1;
    //#20;
    //clk = 0;
    //#20;

    //write_reg   = 5'd00002;
    //write_data  = 32'h00000123;
   // #20;

   // clk = 1;
    //#20;
    //clk = 0;
    //#20;

    //   = 5'd00003;
    //write_data  = 32'h00000312;
    //#20;

    //clk = 1;
    //#20;
    //clk = 0;
    //#20;





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