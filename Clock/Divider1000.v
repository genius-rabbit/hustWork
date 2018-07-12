`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:23:29 04/02/2018 
// Design Name: 
// Module Name:    Divider1000 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Divider1000(
	input CLK_50M,
	input nCLR,
	output reg CLK_1HzOut
    );
	 
	 parameter N=25;
	 parameter CLK_Freq=50000000;//50000000
	 parameter OUT_Freq=100;
	 reg [N-1:0] CountDiv;
	 
	 always@(posedge CLK_50M or negedge nCLR)begin
		if(~nCLR)begin
			CLK_1HzOut<=0;
			CountDiv<=0;
		end
		
		else begin
			if(CountDiv<(CLK_Freq/(2*OUT_Freq)-1))
				CountDiv<=CountDiv+1'b1;
			else begin
				CountDiv<=0;
				CLK_1HzOut<=~CLK_1HzOut;
			end
		 end
		end
endmodule
