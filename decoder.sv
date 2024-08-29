//---------------------------------------------------------
// File Name   : decoder.sv
// Function    : picoMIPS instruction decoder 
// Author: rz
// Last revised: 24/06/2024
//---------------------------------------------------------

`include "alucodes.sv"
`include "opcodes.sv"
//---------------------------------------------------------
module decoder
( input logic [3:0] opcode,// top 4 bits of instruction
input logic LT,
output logic PCincr,PCabsbranch,
output logic inp,
output logic w,
output logic imm,
output logic [1:0] ALUfunc,
output logic sw,
output logic outp
//output logic lw
);
   
//------------- code starts here ---------
// instruction decoder
//logic takeBranch; // temp variable to control conditional branching
always_comb 
begin	
  // set default output signal values for NOP instruction
   PCincr = 1'b1; // PC increments by default
   PCabsbranch = 1'b0; 
   ALUfunc = `RADD; 
   imm=1'b0;
   w=1'b0;   
   sw = 1'b0;
   //lw = 1'b0;
   outp = 1'b0;
   inp = 1'b0;
   case(opcode)     
     `ADD: begin // register-register
	        w = 1'b1; // write result to dest register
			ALUfunc =`RADD;
	      end
     `ADDI: begin // register-immediate
	        w = 1'b1; // write result to dest register
		  imm = 1'b1; // set ctrl signal for imm operand MUX
		  ALUfunc =`RADD;
	      end
	`SUB: begin // register-immediate
	        w = 1'b1; // write result to dest register
		  imm = 1'b1; // set ctrl signal for imm operand MUX
		  ALUfunc =`RSUB;
	      end  
	`MULI: begin  
	       w = 1'b1; // write result to dest register
		  imm = 1'b1; // set ctrl signal for imm operand MUX
		  ALUfunc =`RMUL;
	      end
	 `LOAD:begin
	        inp = 1'b1;
		    w=1'b1;           	  	   
           end 
		 
     `STORE:begin	
            w=1'b1; 	 
	        sw=1'b1;						
			ALUfunc =`RA;
         end
		 
	  `BLT:begin
	       imm=1'b1;
		   if (LT==1'b1)
		     begin
		     PCincr = 1'b0;		
		     PCabsbranch=1'b1;
			 end
		   end
	 `FINISH: begin
	           PCincr = 1'b0;
               outp = 1'b1;
              
           end 
   
	default:
	    $error("unimplemented opcode %h",opcode);
 
  endcase // opcode
  
end // always_comb

endmodule //module decoder --------------------------------