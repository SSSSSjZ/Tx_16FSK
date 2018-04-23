`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2017 11:42:50 PM
// Design Name: 
// Module Name: data_buffer
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


module data_buffer(	// 10240depth寄存器存放高层传输的数据（已提前放入）,次级寄存器每次取出512depth的数据
    clk,
    rst,
	En,
	datain_bit,		// 高层传输数据（未开放）
	
	// addr_10k_on,
	addr_10k_buff,	// 存10240bit数据，寄存器地址
	// dout_10k,
	// turning,
	// wea,
	// addra,
	// din_Data_rom,
	// douta,	

	add_rom,		// 输出寄存器的地址
	read_rom,		// 输出数据
	web,			// 写使能开关，在读完一组数据512位后，第513位处写0，通知buff数据已经读完
	write_rom		// 写数据，长置0（仅在通知时打开使能信号）
		
    );
input clk;
input rst;
input En;
input datain_bit;

input [9:0]add_rom;
input web;
input write_rom;
output read_rom;

output [13:0]addr_10k_buff;
// output addr_10k_on;
// output dout_10k;
// output turning;
// output wea;
// output [9:0]addra;
// output din_Data_rom;
// output douta;
//////////////////////////////////////////////////////////////////
reg [4:0]state;
reg [13:0]addr_10k_buff;
reg addr_10k_on;
always @(posedge clk or negedge rst)	// 次级寄存器请求数据，前级寄存器地址步进输出数据
	if(~rst)
		addr_10k_buff <= 14'b0;
	else if(addr_10k_on)
		begin
			if(addr_10k_buff == 14'd10239)
				addr_10k_buff <= 14'b0;
			else
				addr_10k_buff <= addr_10k_buff + 14'b1;
		end
wire dout_10k;
wire wea_10k_buff;						// 未开放的高层传输数据通道
assign wea_10k_buff = 1'b0;
reg [13:0]addr_10k_in;
blk_mem_gen_0 blk_mem_gen_0 (
  .clka(clk),    // input wire clka
  .ena(En),      // input wire ena
  .wea(wea_10k_buff),      // input wire [0 : 0] wea
  .addra(addr_10k_in),  // input wire [13 : 0] addra
  .dina(datain_bit),    // input wire [0 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(En),      // input wire enb
  .addrb(addr_10k_buff),  // input wire [13 : 0] addrb
  .doutb(dout_10k)  // output wire [0 : 0] doutb
);
//////////////////////////////////////////////////////////////////
reg temp_wea;
reg wea;
reg [9:0]addra;
always @(posedge clk)				// 修正由于读取延迟造成的数据延迟，打开次级寄存器写使能
	begin
		temp_wea <= addr_10k_on;
	end
always @(posedge clk or negedge rst)
	if(~rst)
		wea <= 1'b0;
	else if(temp_wea)
		wea <= 1'b1;
	else if(addra == 10'd512)
		wea <= 1'b0;

wire din_Data_rom;					// 在1状态停留在512位，在wea高时次级寄存器地址步进，写入数据
assign din_Data_rom = (addra == 10'd512)?1'b1:dout_10k;
reg flag_clc;
always @(posedge clk or negedge rst)
	if(~rst)
		addra <= 10'd512;
	else if(state == 5'b1)
		addra <= 10'd512;
	else if(flag_clc)
		addra <= 10'b0;
	else if(wea)
		begin
			if(addra == 10'd512)
				addra <= 10'd512;
			else
				addra <= addra + 10'b1;
		end

wire read_rom;
wire douta;
Data_rom Data_rom (
	.clka(clk),    // input wire clka
	.ena(En),      // input wire ena
	.wea(wea),      // input wire [0 : 0] wea
	.addra(addra),  // input wire [9 : 0] addra
	.dina(din_Data_rom),    // input wire [0 : 0] dina
	.douta(douta),  // output wire [0 : 0] douta
	.clkb(clk),    // input wire clkb
	.enb(En),      // input wire enb
	.web(web),      // input wire [0 : 0] web
	.addrb(add_rom),  // input wire [9 : 0] addrb
	.dinb(write_rom),    // input wire [0 : 0] dinb
	.doutb(read_rom)  // output wire [0 : 0] doutb
);

////////////////////////////////////////////////////
// reg [4:0]state;
reg turning;
reg [31:0]delay_count_1us;
always @(posedge clk or negedge rst)
	if(~rst)
		begin
			addr_10k_in <= 14'b0;
			addr_10k_on <= 1'b0;
			state <= 5'b0;
		end
	else
		case(state)
			5'b0: begin		// 初始化，等待使能信号
					addr_10k_in <= 14'b0;
					addr_10k_on <= 1'b0;
					flag_clc <= 1'b0;
					turning <= 1'b0;
					delay_count_1us <= 32'b0;
					if(En)
						state <= 5'b1;
				end
			5'b1: begin		// 检测512位数据为0，说明数据已被读取，可以开始写新一轮数据
					if((addra == 10'd512)&&(~douta))
						begin
							flag_clc <= 1'b1;	// 1个clk，将地址寄存器初始化置0
							state <= 5'b10;
						end
				end
			5'b10: begin
					flag_clc <= 1'b0;
					if(addra == 10'b0)		// 初始化完毕，开始录入数据
						begin
							addr_10k_on <= 1'b1;
							state <= 5'b100;
						end
				end
			5'b100: begin	
					if(addr_10k_buff == 14'd10239)	// 如果10240depth寄存器完成一轮输出，做标记
						turning <= 1'b1;
					if(addra == 10'd509)	// 数据输出完毕，停止输出（有延迟）
						begin
							addr_10k_on <= 1'b0;
							state <= 5'b1000;
						end
					else
						state <= 5'b100;
				end
			5'b1000: begin
					if(addr_10k_buff == 14'd10239)	// 如果10240depth寄存器完成一轮输出，做标记
						turning <= 1'b1;
					if((addra == 10'd512)&&(douta))	// 确认第512位已写入1
						state <= 5'b10000;
					else
						state <= 5'b1000;
				end
			5'b10000: begin
					if(turning)		// 10240depth一轮数据输出结束，延迟1ms，然后进行新一轮
						begin
							delay_count_1us <= delay_count_1us + 32'b1;
							if(delay_count_1us >= 32'd80000)
								state <= 5'b0;
							else
								state <= 5'b10000;
						end
					else
						state <= 5'b0;	// 回归初始态
				end
		endcase














endmodule
