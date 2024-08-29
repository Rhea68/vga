//Description:VGA显示的时序

//VGA parameter define
`define VGA_640X480_60FPS_25MHz
//`define VGA_1024X768_70FPS_75MHz


//main define
//640X480_60FPS_25MHz
`ifdef VGA_640X480_60FPS_25MHz

`define	H_FRONT  12'd16
`define	H_SYNC 	 12'd96  
`define	H_BACK 	 12'd48  
`define	H_DISP	 12'd640 
`define	H_TOTAL	 12'd800 	
 				
`define	V_FRONT	 12'd10  
`define	V_SYNC 	 12'd2  
`define	V_BACK 	 12'd33 
`define	V_DISP 	 12'd480   
`define	V_TOTAL	 12'd525

`endif

/*
//1024X768_70FPS_75MHz
`ifdef VGA_1024X768_70FPS_75MHz

`define	H_FRONT	12'd24
`define	H_SYNC 	12'd136  
`define	H_BACK 	12'd144  
`define	H_DISP	12'd1024 
`define	H_TOTAL	12'd1328 	
 				
`define	V_FRONT	12'd3  
`define	V_SYNC 	12'd6  
`define	V_BACK 	12'd29 
`define	V_DISP 	12'd768   
`define	V_TOTAL	12'd806

`endif

*/


