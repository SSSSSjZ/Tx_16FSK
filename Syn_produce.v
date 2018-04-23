`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2017 07:55:11 PM
// Design Name: 
// Module Name: Syn_produce
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

/////////////////////////////rom delay 2.5 peroid///////////////////////////
module Syn_produce(clk,			// 时钟
                    en,			// 使能开关
                    flag_end,	// 结束标志位
                    modu_Q,		// Q路输出
                    modu_I		// I路输出
    );
input clk;
input en;
output flag_end;
output [11:0]modu_Q;
output [11:0]modu_I;

reg [11:0]addra;			// 同步序列rom寄存器地址
wire [11:0]douta_Q;			// rom-Q路
reg [11:0]modu_Q;			// 实际Q路输出

wire [11:0]douta_I;			// rom-I路
reg [11:0]modu_I;			// 实际I路输出

Syn_sin Syn_sin (
  .clka(clk),    // input wire clka
  .ena(en),      // input wire ena
  .addra(addra),  // input wire [11 : 0] addra
  .douta(douta_Q)  // output wire [11 : 0] douta
);
Syn_cos Syn_cos (
  .clka(clk),    // input wire clka
  .ena(en),      // input wire ena
  .addra(addra),  // input wire [11 : 0] addra
  .douta(douta_I)  // output wire [11 : 0] douta
);
always @(posedge clk)	// 长度3072
    if(~en)
        addra <= 12'b0;
    else if(addra == 12'd3071)
        addra <= 12'd3071;
    else
        addra <= addra + 12'b1;
always @(negedge clk)	// 调节寄存器输出和实际输出的时延（2clk）
    if(~en)
        modu_Q <= 12'bz;
    else if(addra > 12'b1)
        modu_Q <= douta_Q;
always @(negedge clk)	// 调节寄存器输出和实际输出的时延（2clk）
    if(~en)
        modu_I <= 12'bz;        
    else if(addra > 12'b1)
        modu_I <= douta_I;
reg [1:0]delay_rom;		// 调节寄存器输出和实际输出的时延（2clk）
wire flag_end;			// 结束标志位
always @(posedge clk)
    if(addra != 12'd3071)
        delay_rom <= 1'b0;
    else if(delay_rom == 2'b10)
        delay_rom <= delay_rom;
    else
        delay_rom <= delay_rom + 1'b1;
        
assign flag_end = (delay_rom == 2'b10)?1'b1:1'b0;
    

endmodule