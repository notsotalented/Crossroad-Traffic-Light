`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2022 07:14:26 AM
// Design Name: 
// Module Name: ex1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clockDiv(
    input clk,
    //output reg clock_out,
    output reg clk_out
    );
    reg[30:0] counter = 31'd0;
    parameter div = 31'd125000000;
    always @(posedge clk)
    begin
    counter <= counter + 31'd1;
    if (counter >= (div - 1))
    counter <= 31'd0;
    clk_out <= (counter<div/2)?1'b1:1'b0;
    //c_out <= (clock_out >0)?2'b01:2'b10;
    end
endmodule
