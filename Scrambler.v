// 扰码器
// 初值为0001011101


module Scrambler(
    clk,		// 2MHz时钟,上升沿读取数据，下降沿输出结果
    rst,
    datain,		// 数据读入
    dataout,	// 输出
    reg_scr		// 扰码寄存器
    );
    
    input clk;
    input rst;
    input datain;
    output dataout;
    output [9:0]reg_scr;
reg dataout;  

always @(negedge clk or negedge rst)
    if(~rst)
        dataout <= 1'bz;
    else
        dataout <= datain^reg_scr[0];

reg [9:0]reg_scr;
always @(posedge clk or negedge rst)
    if(~rst)
        reg_scr <= 10'b0001011101;
    else
        reg_scr <= {reg_scr[8:0],reg_scr[6]^reg_scr[9]};



  
endmodule
