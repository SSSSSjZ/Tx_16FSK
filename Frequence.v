module Frequence(rst,
			datain,
			clk_load,				// 2MHz时钟,上升沿读取数据，下降沿输出结果
			freq,
			data_read
			);
input rst,clk_load;
input [1:0]datain;
output [7:0]freq;
output [3:0]data_read;

reg [3:0]count_load;				// 两个clk
always @(posedge clk_load or negedge rst)
	if(~rst)
		count_load = 4'b01;
	else if(count_load == 4'b01)
		count_load = 4'b0;
	else
		count_load = count_load + 4'b1;

reg [3:0]data_read;					// 两个clk的读入数据映射一个频点
always @(posedge clk_load or negedge rst)
	if(~rst)
		data_read = 4'b0;
	else
		data_read = {data_read[1:0],datain};

reg [7:0]freq;						//??		
always @(negedge clk_load or negedge rst)
	if(~rst)
		freq = 8'b0;
	else if(count_load == 4'b01)
		case(data_read)				
			4'b0000: freq = 8'hE2;	//负数-30MHz
			4'b0001: freq = 8'hE6;	//负数-26
			4'b0010: freq = 8'hEA;	//负数-22
			4'b0011: freq = 8'hEE;	//负数-18
			4'b0100: freq = 8'hF2;	//负数-14
			4'b0101: freq = 8'hF6;	//负数-10
			4'b0110: freq = 8'hFA;	//负数-6
			4'b0111: freq = 8'hFE;	//负数-2
			4'b1000: freq = 8'h02;	// 2
			4'b1001: freq = 8'h06;	// 6
			4'b1010: freq = 8'h0A;	// 10
			4'b1011: freq = 8'h0E;	// 14
			4'b1100: freq = 8'h12;	// 18
			4'b1101: freq = 8'h16;	// 22
			4'b1110: freq = 8'h1A;	// 26
			4'b1111: freq = 8'h1E;	// 30
		endcase		
		
//////////////////////////////////////////////////////////////////////////////		

		
		
		
		
endmodule