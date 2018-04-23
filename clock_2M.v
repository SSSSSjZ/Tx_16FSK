`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2017 07:49:39 PM
// Design Name: 
// Module Name: clock_2M
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


module clock_2M(clk,
                en,
                clk_2M
    );
input clk;
input en;
output clk_2M;

reg [6:0]count;
reg clk_2M;

always @(posedge clk)
    if(~en)
        count <= 7'b0;
    else if(count == 7'd19)
        count <= 7'd0;
    else
        count <= count + 7'b1;
always @(posedge clk)
    if(~en)
        clk_2M <= 1'b0;
    else if(count == 7'd19)
        clk_2M <= ~clk_2M;


endmodule
