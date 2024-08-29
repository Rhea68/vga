//-----------------------------------------------------
module pc #(parameter Psize = 5) // up to 32 instructions
(input logic clk, nreset, PCincr,PCabsbranch,
 input logic [Psize-1:0] Branchaddr,
 output logic [Psize-1 : 0]PCout
);

always_ff @(posedge clk or negedge nreset) // async reset
   if (!nreset) // sync reset
      PCout <= {Psize{1'b0}};
   else if (PCincr ) // increment  branch
      PCout <= PCout + 1'b1; 
   else if (PCabsbranch) // absolute branch
      PCout <= Branchaddr;
	 
	 
endmodule // module pc