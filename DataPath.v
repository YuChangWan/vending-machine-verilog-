`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:46:48 06/19/2018 
// Design Name: 
// Module Name:    DataPath 
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
module DataPath(
	 input CLK,input RST,
	 input LD_A,input LD_B,input LD_C,input LD_D,input LD_E, input LD_CNT, input LD_MEM,
	 input CD_D,input CD_CNT,
	 input Sel_DIV_IN,
	 input [1:0] Sel_A_IN,input [1:0] Sel_ADD_IN,input [1:0] Sel_DIVISOR,
	 input [1:0] Kind,input [2:0] Cups,
	 
	 input [6:0] americano_price,input [6:0] ratte_price,
	 
	 output Z,
	 output Z2,
	 output exceed,
	 output ready,
	 output [6:0] A
	 );
	 reg enough;
	 reg [1:0] C;
	 reg [2:0] D;
	 reg [6:0] A,B,E,CNT,ADD_IN,divisor,cost,sum,quotient,remainder,remain_money;
	 reg [6:0] A_IN,MEM[1:0];
	 wire [6:0]  DIV_IN;
	 
	 //MUX
	 always@(Sel_ADD_IN)
		case(Sel_ADD_IN)
			2'b00: ADD_IN = 1;
			2'b01: ADD_IN = 2;
			2'b10: ADD_IN = 10;
			2'b11: ADD_IN = 20;
			default:ADD_IN = 1;
		endcase
	 //adder
	 always@(ADD_IN or A)
		begin
			sum = ADD_IN+A;
		end
	 //MUX
	 always@(Sel_A_IN or sum or remain_money)
		case(Sel_A_IN)
			2'b00: A_IN = sum;
			2'b01: A_IN = sum;
			2'b10: A_IN = 20;
			2'b11: A_IN = remain_money;
			default: A_IN = sum;
		endcase
	 //reg A
	 always@(posedge CLK)
		begin
			if(RST) A <= 0;
			else if(LD_A) A <= A_IN;
		end
	 
	 //MUX
	 assign DIV_IN = Sel_DIV_IN ? A : B;
	 //MUX
	 always@(Sel_DIVISOR)
		case(Sel_DIVISOR)
			2'b00: divisor = 1;
			2'b01: divisor = 2;
			2'b10: divisor = 10;
			2'b11: divisor = 20;
			default: divisor = 1;
		endcase
	 //divider
	 always@(DIV_IN or divisor)
		begin
			remainder = DIV_IN%divisor;
			quotient = DIV_IN/divisor;
		end
	 //exceed
	 assign exceed = A>20;	
	 
	 //reg B
	 always@(posedge CLK)
		begin
			if(RST) B <= 0;
			else if(LD_B) B <= remainder;
		end
	 //CNT, Counter
	 always@(posedge CLK)
		begin
			if(LD_CNT)CNT <= quotient;
			else if(CD_CNT) CNT <= CNT-1;
		end
	 //Z, zero detect 
	 assign Z = (CNT==0);
	 //reg C , Kind
	 always@(posedge CLK)
		begin
			if(RST) C <= 0;
			else if(LD_C) C<= Kind;
		end
	 //reg D, cups, count
	 always@(posedge CLK)
		begin
			if(RST) D <= 0;
			else if(LD_D) D<= Cups;
			else if(CD_D) D<= D-1;
		end
	 //Z2, zero detect	
	 assign Z2 = (D==0);
	 //reg E, save cost
	 always@(posedge CLK)
		begin
			if(RST) E <= 0;
			else if(LD_E) E<= cost;
		end
	 //multiflier, get cost 
	 always@(C or D)
		begin
			if(C==2'b01) cost = MEM[0]*D;
			else if(C==2'b10)cost = MEM[1]*D;
			else cost = 0;
		end
	 //substractor, sum - cost
	 always@(A or E)
		begin
			enough = A>=E;
			remain_money = A-E;
		end
	 assign ready = enough&&(C>0)&&(D>0);
	 //MEM, change price
	 always@(posedge CLK)
		begin
			if(LD_MEM)
				begin
					MEM[0]<=americano_price;
					//MEM[1]<=ratte_price;
				end
		end
	 
endmodule
