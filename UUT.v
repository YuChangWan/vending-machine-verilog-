`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:50:51 06/20/2018 
// Design Name: 
// Module Name:    UUT 
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
module UUT(
	 input CLK,input Done, input TakeOut,
	 input Start, input Return, input Manage,input Confirm,
	 input Americano, input Ratte,
	 input Cup1,input Cup2,input Cup3,input Cup4,input Cup5,
	 input Coin50,input Coin100,input Coin500,input Coin1000,
	 input [6:0] Americano_price,input [6:0] Ratte_price,
	  
	 output Return50,output Return100,output Return500, output Return1000,
    output Making,output Coffee,
	 output [6:0] Sum
	 );
	 wire Z,Z2,Exceed,Ready;
	 wire LD_A,LD_B,LD_C,LD_D,LD_E,LD_CNT,LD_MEM,CD_D,CD_CNT,Sel_DIV_IN;
	 wire [1:0] Sel_A_IN,Sel_ADD_IN,Sel_DIVISOR,Kind;
	 wire [2:0] Cups;
	 DataPath datapath(CLK,RST,LD_A,LD_B,LD_C,LD_D,LD_E,LD_CNT,LD_MEM,
							CD_D,CD_CNT,Sel_DIV_IN,Sel_A_IN,Sel_ADD_IN,Sel_DIVISOR,
							Kind,Cups,Americano_price,Ratte_price,
							//out
							Z,Z2,Exceed,Ready,Sum);
	 ControlUnit controlunit(CLK, 
									Start,Return,Manage,Confirm,
									Americano,Ratte,
									Cup1,Cup2,Cup3,Cup4,Cup5,
									Coin50,Coin100,Coin500,Coin1000,Done, TakeOut,
									Z,Z2,Exceed,Ready,
									//out
									Making,Coffee,Return50,Return100,Return500,Return1000,RST, 
									LD_A,LD_B,LD_C,LD_D,LD_E,LD_CNT,LD_MEM,
									CD_D,CD_CNT,Sel_DIV_IN,Sel_A_IN,Sel_ADD_IN,Sel_DIVISOR,
									Kind,Cups
									);


endmodule
