//-----------------------------------------------------
// File Name: opcodes.sv
// Function: opcodes for decoder
// Author: rz
// Last rev. 24/06/2024
//-----------------------------------------------------

 `define ADDI      4'b0001  // ADDI %d, %s, imm;  %s = %d + imm

 `define MULI      4'b0010  // MUL %d, %s, imm ;  %s =%d * imm  
 
 `define LOAD     4'b0011  //load from ROM
 
 `define BLT       4'b0100  //branch less than
 
 `define FINISH      4'b0101  //show finish
 
 `define STORE     4'b0110  //store word in RAM
 
 `define ADD      4'b0111  // ADD 
 
 `define SUB      4'b1000  // SUB 