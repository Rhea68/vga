//-----------------------------------------------------
// File Name : ram.sv
// Function : picoRISC 32 x n registers, %0 == 0
// Author: rz
// Last rev. 24/06/2024
//-----------------------------------------------------
module RAM #(parameter n=8)
(input logic clk,
 input logic sw, 
 input logic outp,
 input logic [n-1:0] din,
 input logic [7:0] RAMAddress,// up to 256 address
 output logic [n-1:0] dout
 );

	logic [7:0] mem [255:0];

	always_comb
	   begin
	   if(outp)
		$writememh("memory_hex.hex", mem);
	   end
	   
always_ff @(posedge clk)  	   
	begin
		if (sw)
            mem[RAMAddress] <= din;

		 dout <= mem[RAMAddress];
	end

endmodule