//VGA显示界面控制
module vga_disp
#(
	parameter	H_DISP	=	640			,
	parameter	V_DISP =	480 		
)
(
	input	wire			clk_in			,
	input	wire			rst_n			,
	input	wire	[11:0]	x_pos			,
	input	wire	[11:0]	y_pos			,
	input wire   [7:0] ram_data,   // 从RAM读取的8位灰度值
	output	reg 	[7:0]	data_out		 
);



    localparam start_x = (H_DISP - 16) / 2;
    localparam start_y = (V_DISP - 16) / 2;
    localparam end_x = start_x + 16;
    localparam end_y = start_y + 16;

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n)
            data_out <= 8'b0; // 初始化为黑色
        else if (x_pos >= start_x && x_pos < end_x && y_pos >= start_y && y_pos < end_y)
            data_out <= {ram_data}; // 中心显示16x16图像
        else
            data_out <= 8'b0; // 屏幕其他位置显示黑色
    end

endmodule