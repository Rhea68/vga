module testpicoRISC;
    logic CLOCK_50, RESET_KEY;
    logic [7:0] VGA_B;
    logic VGA_BLANK_N;
    logic VGA_CLK;
    logic [7:0] VGA_G;
    logic VGA_HS;
    logic [7:0] VGA_R;
    logic VGA_SYNC_N;
    logic VGA_VS; 
	logic rst_n;
	cpu_top c1(.*);
	initial
		begin
		CLOCK_50='0;		
		RESET_KEY = '1;
 		#4ns RESET_KEY = '0;
 		#4ns RESET_KEY = '1;
		forever #2ns CLOCK_50=~CLOCK_50;		
		end
		
		initial
		begin
		VGA_CLK='0;
		forever #4ns VGA_CLK=~VGA_CLK;
		end
		
endmodule
