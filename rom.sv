
//-----------------------------------------------------
module ROM #(parameter n = 8) (
input logic [7:0] ROMAddress,//0-255
output logic [n-1:0] data_in); 

logic [n-1:0] image_ROM [255:0];

initial
   
    $readmemh("ROM.hex", image_ROM);
  
always_comb
  data_in = image_ROM[ROMAddress];
  
endmodule 