//-----------------------------------------------------
// File Name : prog.sv
// Function : Program memory Psize x Isize - reads from file prog.hex
// Author: rz 
// Last rev. 24/06/2024
//-----------------------------------------------------
module prog #(parameter Psize = 5, Isize = 20) // psize - address width, Isize - instruction width
(input logic [Psize-1:0] ProgAddress,
output logic [Isize-1:0] I); // I - instruction code

logic [Isize-1:0] progMem[16:0];

initial
   
    $readmemh("prog.hex", progMem);
  
always_comb
  I = progMem[ProgAddress];
  
endmodule 