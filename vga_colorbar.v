//=======================================================
`include "vga_param.v"

module vga(	
	input 		          		CLOCK_50,		
	input						RESET_KEY,
	//////////// VGA //////////
	output		     [7:0]		VGA_B,
	output		          		VGA_BLANK_N,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,
	output [7:0] RAM_address,    // RAM地址，用于读取像素数据
    input [7:0] RAM_data         // 从RAM读取的8位灰度数据
);


//=======================================================
//  REG/WIRE declarations
//=======================================================
wire		rst_n	;
wire		clk_75m	;
wire		clk_25m	;
wire		locked	;

wire	[7:0] data_temp; // 8位灰度数据
wire	[11:0]	x_pos		;
wire	[11:0]	y_pos		;


//=======================================================
//  main code
//=======================================================
assign rst_n = RESET_KEY & locked ;

//生成不同频率的时钟
pll	clk_gen (
	.rst ( ~RESET_KEY ),
	.refclk ( CLOCK_50 ),
	.outclk_0 ( clk_75m ),
	.outclk_1 ( clk_25m ),
	.locked ( locked )
	);

//生成VGA时序
vga_ctrl
#(
	. H_FRONT (`H_FRONT)	,
	. H_SYNC  (`H_SYNC )	,
	. H_BACK  (`H_BACK )	,
	. H_DISP  (`H_DISP )	,
	. H_TOTAL (`H_TOTAL) 	,
	. V_FRONT (`V_FRONT)	,
	. V_SYNC  (`V_SYNC )	,
	. V_BACK  (`V_BACK )	,
	. V_DISP  (`V_DISP )	,
	. V_TOTAL (`V_TOTAL)	
)vga_ctrl_inst
(
	. clk_in		(clk_25m	)	,//clk_75m	)	,
	. rst_n			(rst_n		)	,
	. data_in		(data_temp	)	,
	. data_en		()	,
	. x_pos			(x_pos		)	,
	. y_pos			(y_pos		)	,

	. vga_hs		(VGA_HS		)	,
	. vga_vs		(VGA_VS		)	,
	. vga_de		()	,
	. vga_r			(VGA_R		)	,//红色分量
	. vga_g			(VGA_G		)	,//绿色分量
	. vga_b			(VGA_B		)	,//蓝色分量

	. vga_clk		(VGA_CLK	)	,
	. vga_sync_n	(VGA_SYNC_N	)	,
	. vga_blank_n	(VGA_BLANK_N)	
);

 assign RAM_address = (y_pos >= ((480 - 16) / 2) && y_pos < ((480 - 16) / 2 + 16) && 
                          x_pos >= ((640 - 16) / 2) && x_pos < ((640 - 16) / 2 + 16)) ? 
                          ((y_pos - ((480 - 16) / 2)) * 16 + (x_pos - ((640 - 16) / 2))) : 8'b0;
//生成现实的图像
vga_disp
#(
	. H_DISP	(`H_DISP )	,
	. V_DISP  	(`V_DISP )		
)vga_disp_inst
(
	. clk_in	(clk_25m)	,//clk_75m	)	,
	. rst_n		(rst_n	)	,
	. x_pos		(x_pos	)	,
	. y_pos		(y_pos	)	,
    . ram_data  (RAM_data) ,       // 从外部RAM或处理器读取的8位灰度数据
	. data_out	(data_temp)	 
);

endmodule
