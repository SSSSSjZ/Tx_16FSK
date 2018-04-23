`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2017 10:42:03 AM
// Design Name: 
// Module Name: DDS_output
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


module DDS_output(clk,
                    rst,
                    freq,		// 频点
                    DDS_Q,		// Q路输出
                    DDS_I		// I路输出
    );
input clk,rst;
input [7:0]freq;
output [11:0]DDS_Q;
output [11:0]DDS_I;

reg [6:0]addra;		// 波形寄存器地址（一轮80点）
always @(posedge clk or negedge rst)
    if(~rst)
        addra <= 7'b0;
    else if(addra == 7'd79)
        addra <= 7'b0;
    else
        addra <= addra + 7'b1;
reg [7:0]switch_freq;	// 读入下一个频点（考虑rom延时问题）
always @(posedge clk or negedge rst)
    if(~rst)
        switch_freq <= 8'b0;
    else if(addra == 7'd2)
        switch_freq <= freq; 

// 波形输出
wire [11:0]sin_low_2;
freq_sin_low_2 freq_sin_low_2 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_low_2)  // output wire [11 : 0] douta
); 
wire [11:0]sin_low_6;
freq_sin_low_6 freq_sin_low_6 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_low_6)  // output wire [11 : 0] douta
); 
wire [11:0]sin_low_10;
freq_sin_low_10 freq_sin_low_10 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_low_10)  // output wire [11 : 0] douta
); 
wire [11:0]sin_low_14;
freq_sin_low_14 freq_sin_low_14 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_low_14)  // output wire [11 : 0] douta
);
wire [11:0]sin_low_18;
freq_sin_low_18 freq_sin_low_18 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_low_18)  // output wire [11 : 0] douta
);   
wire [11:0]sin_low_22;
freq_sin_low_22 freq_sin_low_22 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_low_22)  // output wire [11 : 0] douta
);              
wire [11:0]sin_low_26;
freq_sin_low_26 freq_sin_low_26 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_low_26)  // output wire [11 : 0] douta
);
wire [11:0]sin_low_30;
freq_sin_low_30 freq_sin_low_30 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_low_30)  // output wire [11 : 0] douta
); 
wire [11:0]sin_high_2;
freq_sin_high_2 freq_sin_high_2 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_high_2)  // output wire [11 : 0] douta
);
wire [11:0]sin_high_6;
freq_sin_high_6 freq_sin_high_6 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_high_6)  // output wire [11 : 0] douta
);
wire [11:0]sin_high_10;
freq_sin_high_10 freq_sin_high_10 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_high_10)  // output wire [11 : 0] douta
);
wire [11:0]sin_high_14;
freq_sin_high_14 freq_sin_high_14 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_high_14)  // output wire [11 : 0] douta
);
wire [11:0]sin_high_18;
freq_sin_high_18 freq_sin_high_18 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_high_18)  // output wire [11 : 0] douta
);
wire [11:0]sin_high_22;
freq_sin_high_22 freq_sin_high_22 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_high_22)  // output wire [11 : 0] douta
);
wire [11:0]sin_high_26;
freq_sin_high_26 freq_sin_high_26 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_high_26)  // output wire [11 : 0] douta
);
wire [11:0]sin_high_30;
freq_sin_high_30 freq_sin_high_30 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(sin_high_30)  // output wire [11 : 0] douta
);
//////////////////////////////////
wire [11:0]cos_low_2;
freq_cos_low_2 freq_cos_low_2 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(cos_low_2)  // output wire [11 : 0] douta
); 
wire [11:0]cos_low_6;
  freq_cos_low_6 freq_cos_low_6 (
    .clka(clk),    // input wire clka
    .ena(rst),      // input wire ena
    .addra(addra),  // input wire [6 : 0] addra
    .douta(cos_low_6)  // output wire [11 : 0] douta
);
wire [11:0]cos_low_10;
freq_cos_low_10 freq_cos_low_10 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(cos_low_10)  // output wire [11 : 0] douta
);
wire [11:0]cos_low_14;
  freq_cos_low_14 freq_cos_low_14 (
    .clka(clk),    // input wire clka
    .ena(rst),      // input wire ena
    .addra(addra),  // input wire [6 : 0] addra
    .douta(cos_low_14)  // output wire [11 : 0] douta
);
wire [11:0]cos_low_18;
freq_cos_low_18 freq_cos_low_18 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(cos_low_18)  // output wire [11 : 0] douta
);
wire [11:0]cos_low_22;
freq_cos_low_22 freq_cos_low_22 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(cos_low_22)  // output wire [11 : 0] douta
);
wire [11:0]cos_low_26;
freq_cos_low_26 freq_cos_low_26 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(cos_low_26)  // output wire [11 : 0] douta
);
wire [11:0]cos_low_30;
freq_cos_low_30 freq_cos_low_30 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(cos_low_30)  // output wire [11 : 0] douta
);
wire [11:0]cos_high_2;
freq_cos_high_2 freq_cos_high_2 (
  .clka(clk),    // input wire clka
  .ena(rst),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(cos_high_2)  // output wire [11 : 0] douta
);
wire [11:0]cos_high_6;
  freq_cos_high_6 freq_cos_high_6 (
    .clka(clk),    // input wire clka
    .ena(rst),      // input wire ena
    .addra(addra),  // input wire [6 : 0] addra
    .douta(cos_high_6)  // output wire [11 : 0] douta
);  
wire [11:0]cos_high_10;
  freq_cos_high_10 freq_cos_high_10 (
    .clka(clk),    // input wire clka
    .ena(rst),      // input wire ena
    .addra(addra),  // input wire [6 : 0] addra
    .douta(cos_high_10)  // output wire [11 : 0] douta
);  
wire [11:0]cos_high_14;
  freq_cos_high_14 freq_cos_high_14 (
    .clka(clk),    // input wire clka
    .ena(rst),      // input wire ena
    .addra(addra),  // input wire [6 : 0] addra
    .douta(cos_high_14)  // output wire [11 : 0] douta
);  
wire [11:0]cos_high_18;
  freq_cos_high_18 freq_cos_high_18 (
    .clka(clk),    // input wire clka
    .ena(rst),      // input wire ena
    .addra(addra),  // input wire [6 : 0] addra
    .douta(cos_high_18)  // output wire [11 : 0] douta
);  
wire [11:0]cos_high_22;
  freq_cos_high_22 freq_cos_high_22 (
    .clka(clk),    // input wire clka
    .ena(rst),      // input wire ena
    .addra(addra),  // input wire [6 : 0] addra
    .douta(cos_high_22)  // output wire [11 : 0] douta
);  
wire [11:0]cos_high_26;
  freq_cos_high_26 freq_cos_high_26 (
    .clka(clk),    // input wire clka
    .ena(rst),      // input wire ena
    .addra(addra),  // input wire [6 : 0] addra
    .douta(cos_high_26)  // output wire [11 : 0] douta
);  
wire [11:0]cos_high_30;
  freq_cos_high_30 freq_cos_high_30 (
    .clka(clk),    // input wire clka
    .ena(rst),      // input wire ena
    .addra(addra),  // input wire [6 : 0] addra
    .douta(cos_high_30)  // output wire [11 : 0] douta
);  
//////////////////////////////
reg [11:0]DDS_Q;
reg [11:0]DDS_I;     
always @(negedge clk)	// 依据频点输出波形数据-Q路
    if(~rst)
        DDS_Q <= 12'bz;
    else
        case(switch_freq)
			8'hE2: DDS_Q <= sin_low_30;
            8'hE6: DDS_Q <= sin_low_26;
            8'hEA: DDS_Q <= sin_low_22;
            8'hEE: DDS_Q <= sin_low_18;
            8'hF2: DDS_Q <= sin_low_14;
            8'hF6: DDS_Q <= sin_low_10;
            8'hFA: DDS_Q <= sin_low_6;
            8'hFE: DDS_Q <= sin_low_2;
            8'h02: DDS_Q <= sin_high_2;
            8'h06: DDS_Q <= sin_high_6;
            8'h0A: DDS_Q <= sin_high_10;  
            8'h0E: DDS_Q <= sin_high_14;
            8'h12: DDS_Q <= sin_high_18;
            8'h16: DDS_Q <= sin_high_22;
            8'h1A: DDS_Q <= sin_high_26;
            8'h1E: DDS_Q <= sin_high_30;
            default:DDS_Q <= 12'bz;
        endcase
always @(negedge clk)	// 依据频点输出波形数据-I路
    if(~rst)
        DDS_I <= 12'bz;
    else
        case(switch_freq)
            8'hE2: DDS_I <= cos_low_30;
            8'hE6: DDS_I <= cos_low_26;
            8'hEA: DDS_I <= cos_low_22;
            8'hEE: DDS_I <= cos_low_18;
            8'hF2: DDS_I <= cos_low_14;
            8'hF6: DDS_I <= cos_low_10;
            8'hFA: DDS_I <= cos_low_6;
            8'hFE: DDS_I <= cos_low_2;
            8'h02: DDS_I <= cos_high_2;
            8'h06: DDS_I <= cos_high_6;
            8'h0A: DDS_I <= cos_high_10;  
            8'h0E: DDS_I <= cos_high_14;
            8'h12: DDS_I <= cos_high_18;
            8'h16: DDS_I <= cos_high_22;
            8'h1A: DDS_I <= cos_high_26;
            8'h1E: DDS_I <= cos_high_30;
            default:DDS_I <= 12'bz;
        endcase

endmodule
