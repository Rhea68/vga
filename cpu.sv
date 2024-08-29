`include "alucodes.sv"
module cpu_top #( parameter n = 8,Psize = 5,Isize =20) // data bus width
(   input logic CLOCK_50,
    input logic RESET_KEY,
    output logic [7:0] VGA_B,
    output logic VGA_BLANK_N,
    output logic VGA_CLK,
    output logic [7:0] VGA_G,
    output logic VGA_HS,
    output logic [7:0] VGA_R,
    output logic VGA_SYNC_N,
    output logic VGA_VS   
);  

    logic rst_n;
    logic [Psize-1:0] ProgAddress;
    logic [Isize-1:0] I;
    logic [n-1:0] Rdata1, Rdata2;
    logic [n-1:0] result;
    logic [n-1:0] addr;
    logic [n-1:0] data_in;
    logic [n-1:0] Wdata;
    logic [7:0] dout;          // RAM的输出数据
    logic [7:0] RAMAddress;   // CPU访问的RAM地址       
    logic sw;
	logic w;
	logic outp; 
	logic inp;
logic PCincr,PCabsbranch;
logic LT;
logic [1:0] ALUfunc; // ALU function
logic imm; // immediate operand signal
logic [n-1:0] b; // output from imm MUX
logic [7:0] mem [255:0];

assign rst_n = RESET_KEY; 


//------------- code starts here ---------
// module instantiations
	
pc  #(.Psize(Psize)) progCounter (
        .clk(CLOCK_50),
        .nreset(rst_n),
        .PCincr(PCincr),
        .PCabsbranch(PCabsbranch),        
        .Branchaddr(I[Psize-1:0]), 
        .PCout(ProgAddress)
		);

prog #(.Psize(Psize),.Isize(Isize)) 
      progMemory (.ProgAddress(ProgAddress),.I(I));

decoder  D (.opcode(I[Isize-1:Isize-4]),
            .LT(LT),
            .PCincr(PCincr),		
            .PCabsbranch(PCabsbranch), 
            .inp(inp),
			.w(w),
			.imm(imm),
			.outp(outp),
		    .ALUfunc(ALUfunc),
		    .sw(sw)		   
			);

regs   #(.n(n))  gpr(
        .clk(CLOCK_50),
		.nreset(rst_n),
		.w(w),
        .Wdata(Wdata),		
		.Raddr1(I[Isize-5:Isize-8]),  // reg %d number
		.Raddr2(I[Isize-9:Isize-12]), // reg %s number
        .Rdata1(Rdata1),
		.Rdata2(Rdata2)
		);
		

alu    #(.n(n))  iu(
       .a(Rdata1),
	   .b(b),
	   .result(result),
       .ALUfunc(ALUfunc)
       ); // ALU result -> destination reg
	   
branch   #(.n(n))  br(
       .Rdata1(Rdata1),
	   .Rdata2(Rdata2),
       .LT(LT)
	   );
	   
RAM    #(.n(n))  ra(
       .clk(CLOCK_50),
       .RAMAddress(RAMAddress),       
	   .din(Rdata2),
	   .sw(sw),
	   .outp(outp),
	   .dout(dout)
	   ); 
	   
ROM    #(.n(n))  ro(
       .ROMAddress(Rdata1),
       .data_in(data_in)
       	  );  
		  
vga vga_inst (
        .CLOCK_50(CLOCK_50),
        .RESET_KEY(RESET_KEY),
        .VGA_B(VGA_B),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_CLK(VGA_CLK),
        .VGA_G(VGA_G),
        .VGA_HS(VGA_HS),
        .VGA_R(VGA_R),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_VS(VGA_VS),
        .RAM_address(addr),  // 将CPU中的地址信号连接到VGA
        .RAM_data(dout)  // VGA模块从RAM读取数据
    );

// create MUX for immediate operand
assign b = (imm)? I[n-1:0] : Rdata2;

assign Wdata=(inp)? data_in: result;

assign RAMAddress=(outp)? addr: result;

/*always_ff @(posedge clk or negedge nreset)
begin
	if (!nreset) // sync reset
                outport <= 1'b0;
	else if(outp)
                outport <= 1'b1;
end*/
endmodule