//发射端主文件 协调各部件工作
module main(clk,				// 工作时钟80M
			rst,				// 复位
			En,					// 工作使能信号
			// datain_bit,
			sigout_Q_sin,		// Q路调制输出
			sigout_I_cos, 		// I路调制输出
			
			// state,
			// addr_10k_on,
			// addr_10k_buff,
			// dout_10k,
			// turning,
			// wea,
			// addra_data_buffer,
			// din_Data_rom,
			// douta_data_buffer,	
			
			// add_rom,
			// read_rom,
			// web,
			// write_rom,
			// delay_end,
			// test_read_rom,
			// count,
			// test_read_rom_out,
			
			// DDS_freq
			work_start			// 开始工作信号
			);
input clk,rst;
input En;
// input datain_bit;
output [13:0]sigout_Q_sin;
output [13:0]sigout_I_cos;
output work_start;

// output [4:0]state;
// output [13:0]addr_10k_buff;
// output addr_10k_on;
// output dout_10k;
// output turning;
// output wea;
// output [9:0]addra_data_buffer;
// output din_Data_rom;
// output douta_data_buffer;

// output [9:0]add_rom;
// output read_rom;
// output web;
// output write_rom;	
// output [3:0]delay_end;

// output [9:0]test_read_rom;
// output [3:0]count;
// output [9:0]test_read_rom_out;

// output [7:0]DDS_freq;
//////////////////////////////////////////////////////////////////
parameter
		ideal = 5'b0,
		wait_En = 5'b1,					//等待数据中
		state_syn = 5'b10,				//发送同步序列
		state_subframe = 5'b100,		//发送子帧帧头
		state_data = 5'b1000,			//发送数据
		state_buffer = 5'b10000;		//发送完成，停止状态

wire clk,rst;
wire [13:0]sigout_Q_sin;
wire [13:0]sigout_I_cos;
 
reg [4:0]state;
reg [3:0]delay_end;
//////////////////////////////////////////////////////////////////
wire clk_10M;
reg flag_subframe;
	
reg Syn_En;						// 使能开关，工作时置1
wire Syn_end;					// 结束标志位，发送结束时置1
wire [11:0]Syn_modu_Q;			// Q路信号输出
wire [11:0]Syn_modu_I;			// I路信号输出
Syn_produce Syn_produce(clk,Syn_En,Syn_end,Syn_modu_Q,Syn_modu_I);	// 调用发送同步序列module

wire clk_2M;
clock_2M clock_2M(clk,flag_subframe,clk_2M);	// 调用2MHz式中module
/////////////////////////////////////////////////////////////////////////////////////////////////////
reg [9:0]add_rom;				// 输出地址
wire read_rom;					// 输出数据
wire web;						// 写使能开关，在读完一组数据512位后，第513位处写0，通知buff数据已经读完
wire write_rom;					// 写数据，长置0（仅在通知时打开使能信号）
assign write_rom = 1'b0;
wire datain_bit;				// 高层传输数据（未开放）
assign datain_bit = 1'b1;
wire [13:0]addr_10k_buff;		// 预存10240bit数据，寄存器地址
// wire addr_10k_on;
// wire dout_10k;
// wire turning;
// wire wea;
// wire [9:0]addra_data_buffer;
// wire din_Data_rom;
// wire douta_data_buffer;
// 数据暂存buff，存放高层传输数据，并按需求输出数据
data_buffer data_buffer(
    clk,
    rst,
	En,
	datain_bit,
	
	// addr_10k_on,
	addr_10k_buff,
	// dout_10k,
	// turning,
	// wea,
	// addra_data_buffer,
	// din_Data_rom,
	// douta_data_buffer,	
	
	add_rom,
	read_rom,
	web,
	write_rom	
		
    );
//////////////////////////////////////////////////////////////////////////////////
reg work_start;					// 通过判别10240bit寄存器的地址，每次循环发送时，地址为1时置1，时长1个clk
always @(posedge clk)
	if(~rst)
		work_start <= 1'b0;
	else if(~En)
		work_start <= 1'b0;
	else if(state == wait_En)
		begin
			if(addr_10k_buff == 14'b1)
				work_start <= 1'b1;
			else
				work_start <= work_start;
		end
	else
		work_start <= 1'b0;
/////////////////////////////////////////////////
// reg [9:0]add_rom;			// 输出数据寄存器的地址，平时置于512位，检测到1说明数据已存入寄存器，写0说明数据已读完待更新
reg dataout;					
always @(posedge clk_2M or negedge rst)
    if(~rst)
        add_rom <= 10'd512;
    else if(state == ideal)
        add_rom <= 10'd512;
    else if(state == state_subframe)	// 工作在输出子帧帧头状态时，提前将地址置0
        add_rom <= 10'b0;
    else if(add_rom == 10'd512)			// 到512位时保持状态，准备写0
        add_rom <= 10'd512;
    else								// 工作在输出数据状态时，步进1bit/1clk
        add_rom <= add_rom + 10'b1;
reg datain;						// 在输出数据状态时，读取输出数据
wire flag_new;					// 在等待数据状态，读取输出数据，为1说明新数据已存入
assign flag_new = ((add_rom == 10'd512)&&(state == wait_En))?read_rom:1'b0;
always @(negedge clk_2M)
    if(state == state_data)
        datain <= read_rom;
////////////////////////////////////////////		
// reg [9:0]test_read_rom;		// 检测提前存入的数据输出是否为2进制10位步进为1的一列数
// reg [3:0]count;
// always @(negedge clk_2M or negedge rst)
	// if(~rst)
		// count <= 4'b0;
    // else if(state == state_data)
		// begin
			// if(count == 4'd9)
				// count <= 4'b0;
			// else
				// count <= count + 4'b1;
		// end
// always @(negedge clk_2M or negedge rst)
	// if(~rst)
		// test_read_rom <= 10'b0;
    // else if(state == state_data)
        // test_read_rom[count] <= read_rom;
// reg [9:0]test_read_rom_out;
// always @(negedge clk_2M)
	// if(count == 4'd0)
		// test_read_rom_out <= {test_read_rom[0],test_read_rom[1],test_read_rom[2],test_read_rom[3],test_read_rom[4],test_read_rom[5],test_read_rom[6],test_read_rom[7],test_read_rom[8],test_read_rom[9]};
/////////////////////////////////////////////////
reg read_end;					// 通知状态机数据地址已经扫完一轮
always @(negedge clk_2M)
    if(state == ideal)
        read_end <= 1'b0;
    else if((add_rom >= 10'd511)&&(state == state_data))
        read_end <= 1'b1;
    else
        read_end <= 1'b0;
// wire web;					// 数据已读完，打开写使能
assign web = (delay_end == 4'd5)?1'b1:1'b0;   

////////////////////////////////////////////////////////////////////////////////////////////////////
reg [4:0]count_wait_datarom;	// 调节帧头时长，数据地址、实际输出数据时间、扰码器、编码器、映射频率、输出频率数据，7项之间的时间顺序
always @(negedge clk_2M)
	if(~flag_subframe)
		count_wait_datarom <= 5'b0;
	else if(count_wait_datarom == 5'd16)
		count_wait_datarom <= 5'd16;
	else
		count_wait_datarom <= count_wait_datarom + 5'b1;
wire flag_Scrambler_on;			// 12clk时打开扰码器使能
assign flag_Scrambler_on = (count_wait_datarom >= 5'd12)?1:0;
wire flag_code_on;				// 13clk时打开卷积器使能
assign flag_code_on = (count_wait_datarom >= 5'd13)?1:0;
wire flag_freq_on;				// 14clk时打开频点映射器使能（两个clk的卷积器输出数据映射一个频点）
assign flag_freq_on = (count_wait_datarom >= 5'd14)?1:0; 
wire flag_FSK_on;				// 16clk时打开输出频率数据使能
assign flag_FSK_on = (count_wait_datarom >= 5'd16)?1:0; 

wire Scrambler_out;				// 扰码器输出
wire [9:0]reg_scr;				// 扰码器状态监控
// 调用扰码器module
Scrambler Scrambler(clk_2M,flag_Scrambler_on,datain,Scrambler_out,reg_scr);

wire [1:0]code_out;				// 卷积器输出
// 调用卷积器module
coding coding(flag_code_on,Scrambler_out,code_out,clk_2M);

wire [7:0]freq;					// 映射频点输出
wire [3:0]data_read;			// 数据读取寄存器监控
// 频点映射器module
Frequence Frequence(flag_freq_on,code_out,clk_2M,freq,data_read);


reg flag_DDS_head;				// 判别，输出帧头时，恒为-30MHz，输出数据时依据读入的频点信息
wire [7:0]DDS_freq;				// 实际读入频点
assign	DDS_freq =(flag_DDS_head)?8'hE2:freq;	// 前8位为帧头，数据恒为-30MHz：前级转化的频点
wire [11:0]DDS_Q;				//　ＤＤＳ的Ｑ路输出
wire [11:0]DDS_I;				// DDS的I路输出
// DDS module 
DDS_output DDS_output(clk,flag_subframe,DDS_freq,DDS_Q,DDS_I);

assign sigout_Q_sin = (state == state_syn)?{Syn_modu_Q,2'b0}:{DDS_Q,2'b0};	// 同步序列Q路输出：DDS Q路输出
assign sigout_I_cos = (state == state_syn)?{Syn_modu_I,2'b0}:{DDS_I,2'b0};	// 同步序列I路输出：DDS I路输出
///////////////////////////////////////////////////////////////////
reg [3:0]count_head;			// 调节帧头和数据之间的衔接
always @(posedge clk_2M or negedge rst)
	if(~rst)
		count_head <= 4'b0;
	else if(state != state_subframe)
		count_head <= 4'b0;
	else
		count_head <= count_head + 4'b1;

always @(posedge clk_2M or negedge rst)		// 调节数据从ram读取结束到DDS输出结束之间的延时
	if(~rst)
		delay_end <= 4'b0;
	else if(state != state_buffer)
		delay_end <= 4'b0;
	else
		delay_end <= delay_end + 4'b1;

///////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst)
	if(~rst)
		begin
			state <= ideal;
			flag_DDS_head <= 1'b1;
			Syn_En <= 1'b0;
			flag_subframe <= 1'b0;			
		end
	else
		case(state)
			ideal: begin		// 初始化变量，等待系统工作的使能信号
					flag_DDS_head <= 1'b1;
					Syn_En <= 1'b0;
					flag_subframe <= 1'b0;
					if(En)
						state <= wait_En;
					else
						state <= ideal;
				end
			wait_En: begin		// 等待新输入存入
					if(flag_new)
						state <= state_syn;
				end
			state_syn: begin	// 输出同步序列
					flag_subframe <= 1'b0;
					Syn_En <=1'b1;		// 打开module使能开关
					if(Syn_end == 1'b1)	// 检测到结束标志，关闭使能开关，向下一状态跳跃
						begin
							Syn_En <= 1'b0;
							state <= state_subframe;
						end
					else	
						state <= state_syn;
				end
			state_subframe: begin	// 打开DDS模块，输出帧头
					flag_DDS_head <= 1'b1;
					flag_subframe <= 1'b1;
					if(count_head == 4'd12)	// 计算时间，准备输出数据
						state <= state_data;
				end
			state_data: begin	// 通过7项时间调节器，输出数据
					if(flag_FSK_on)
						flag_DDS_head <= 1'b0;
					flag_subframe <= 1'b1;
					if(read_end)	// ram读取结束
						state = state_buffer;
					else
						state <= state_data;
				end
			state_buffer: begin	// 等待DDS输出结束
					if(delay_end == 4'd6)
						begin
							flag_DDS_head <= 1'b1;
							flag_subframe <= 1'b0;
							if(En)	// 使能持续开关打开，系统继续工作，准备下一次发送
								state <= wait_En;
							else	
								state <= ideal;
						end
					else
						state <= state_buffer;
				end
			default:state <= ideal;
		endcase

endmodule
