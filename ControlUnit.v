`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:43:31 06/19/2018 
// Design Name: 
// Module Name:    ControlUnit 
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
module ControlUnit(
	input CLK,
	
	input Start,input Return,input Manage,input Confirm,	//from User
	input Americano,input Ratte,
	input Cup1,input Cup2,input Cup3,input Cup4,input Cup5,
	input Coin50,input Coin100,input Coin500,input Coin1000,
	input Done,input TakeOut,	//from system
	input Z,input Z2,input Exceed,input Ready,	//from Data Path
	
	output Making, output Coffee,
	output DROP50, output DROP100, output DROP500, output DROP1000,
	output RST, 
	output LD_A,output LD_B,output LD_C,output LD_D,output LD_E,output LD_CNT,output LD_MEM,
	output CD_D,output CD_CNT,
	output Sel_DIV_IN,
	output [1:0] Sel_A_IN,output [1:0] Sel_ADD_IN,output [1:0] Sel_DIVISOR,
	output [1:0] Kind,output [2:0] Cups
    );
	 reg RST,Making,Coffee,DROP50,DROP100,DROP500,DROP1000,LD_A,LD_B,LD_C,LD_D,LD_E, LD_CNT,LD_MEM, CD_CNT,CD_D, Sel_DIV_IN;
	 reg [1:0] Sel_A_IN, Sel_ADD_IN, Sel_DIVISOR, Kind;
	 reg [2:0] Cups;
	 reg [5:0] ActState, NextState;
	 
	 parameter INIT  =6'd1;
	 parameter IDLE  =6'd2;
	 parameter COIN0 =6'd3;
	 parameter COIN1 =6'd4;
	 parameter COIN2 =6'd5;
	 parameter COIN3 =6'd6;
	 parameter CHECK =6'd7;
	 parameter CALC  =6'd8;
	 parameter RET0  =6'd9;
	 parameter RET1  =6'd10;
	 parameter RET2  =6'd11;
	 parameter RET3  =6'd12;
	 parameter COFF0 =6'd13;
	 parameter COFF1 =6'd14;
	 parameter CUP0  =6'd15;
	 parameter CUP1  =6'd16;
	 parameter CUP2  =6'd17;
	 parameter CUP3  =6'd18;
	 parameter CUP4  =6'd19;
	 parameter CUP5  =6'd20;
	 parameter RET1a =6'd21;
	 parameter RET1b =6'd22;
	 parameter RET2a =6'd23;
	 parameter RET2b =6'd24;
	 parameter RET3a =6'd25;
	 parameter RET3b =6'd26;
	 parameter MAKE0 =6'd27;
	 parameter MAKE1 =6'd28;
	 parameter MAKE2 =6'd29;
	 parameter MAKE3 =6'd30;
	 parameter MANAGE0 =6'd31;
	 parameter MANAGE1 =6'd32;
	 parameter EXCEED =6'd33;
	 parameter MAKE0a =6'd34;
	 //next state logic
	 always@(ActState or Start or Americano or Ratte or Exceed or Ready or Return or 
		Manage or Confirm or Done or TakeOut or
		Coin50 or Coin100 or Coin500 or Coin1000 or 
		Cup1 or Cup2 or Cup3 or Cup4 or Cup5 or
		Z or Z2)
		begin
			case(ActState)
				INIT : NextState = IDLE;
				IDLE : begin
					if(Coin50) NextState = COIN0;
					else if(Coin100) NextState = COIN1;
					else if(Coin500) NextState = COIN2;
					else if(Coin1000) NextState = COIN3;
					else if(Americano) NextState = COFF0;
					else if(Ratte) NextState = COFF1;
					else if(Cup1) NextState = CUP0;
					else if(Cup2) NextState = CUP1;
					else if(Cup3) NextState = CUP2;
					else if(Cup4) NextState = CUP3;
					else if(Cup5) NextState = CUP4;
					else if(Return) begin
						if(Z)NextState = RET1;
						else NextState = RET0;
							end
					else if(Start&&Ready) NextState = MAKE0;
					else if(Manage) NextState = MANAGE0;
					else NextState = IDLE;
						end
				COIN0 : NextState = CHECK;
				COIN1 : NextState = CHECK;
				COIN2 : NextState = CHECK;
				COIN3 : NextState = CHECK;
				CHECK: begin
					if(Exceed) NextState = EXCEED;
					else NextState = IDLE;
						end
				EXCEED: NextState = RET1;
				RET0  : NextState = RET1;
				RET1  : NextState = RET1a;
				RET1a : begin
					if(Z) NextState = RET2;
					else NextState = RET1b;
						end
				RET1b : NextState = RET2;
				
				RET2  : NextState = RET2a;
				RET2a : begin
					if(Z) NextState = RET3;
					else NextState = RET2b;
						end
				RET2b : NextState = RET2a;
				
				RET3  : NextState = RET3a;
				RET3a : begin
					if(Z) NextState = IDLE;
					else NextState = RET3b;
						end
				RET3b : NextState = INIT;
						
				COFF0 : NextState = IDLE;
				COFF1 : NextState = IDLE;
				CUP0 : NextState = CALC;
				CUP1 : NextState = CALC;
				CUP2 : NextState = CALC;
				CUP3 : NextState = CALC;
				CUP4 : NextState = CALC;
				CALC : NextState = IDLE;
				MAKE0 : NextState = MAKE0a;//calculate
				MAKE0a: NextState = MAKE1;//calculate
				MAKE1 : begin
					if(Z2)NextState = IDLE; //loop start point
					else NextState = MAKE2;
					end
				MAKE2 : begin
					if(Done) NextState = MAKE3;
					else NextState = MAKE2;
					end
				MAKE3 : begin
					if(TakeOut) NextState = MAKE1;
					else NextState = MAKE3;
					end
				MANAGE0 : begin
					if(Confirm) NextState = MANAGE1;
					else NextState = MANAGE0;
					end
				MANAGE1 : NextState = INIT;
				default: NextState = INIT;
			endcase
		end
	 //output logic
	 always@(ActState)
		begin
			RST = 0; Kind = 0; Cups =0;
			CD_CNT = 0; CD_D = 0;
			LD_A = 0; LD_B = 0; LD_C = 0; LD_D = 0; LD_E = 0; LD_CNT = 0; LD_MEM = 0;
			Sel_DIV_IN = 0;
			Sel_A_IN = 0; Sel_ADD_IN = 0; Sel_DIVISOR = 0;
			DROP1000 = 0; DROP500 = 0; DROP100 = 0; DROP50 = 0;
			Making = 0; Coffee = 0;
			case(ActState)
				INIT : RST=1;
				IDLE :;
				COIN0 : begin 
					LD_A = 1;
					Sel_ADD_IN = 0;
					Sel_A_IN = 0;
					end
				COIN1 : begin 
					LD_A = 1;
					Sel_ADD_IN = 1;
					Sel_A_IN = 0;
					end 
				COIN2 : begin 
					LD_A = 1;
					Sel_ADD_IN = 2;
					Sel_A_IN = 0;
					end 
				COIN3 : begin 
					LD_A = 1;
					Sel_ADD_IN = 3;
					Sel_A_IN = 0;
					end 
				CHECK : begin
					LD_B = 1;
					LD_CNT = 1;
					Sel_DIV_IN = 1; //Aout
					Sel_DIVISOR =3; //20
					end
				EXCEED: begin
					LD_A =1;
					Sel_A_IN = 2;
					end
				RET0  : begin
					DROP1000 = 1;
					end
				RET1  : begin
					Sel_DIV_IN = 0;
					Sel_DIVISOR =2;
					LD_B = 1;
					LD_CNT = 1;
					end
				RET1a : ;
				RET1b : begin
					DROP500 = 1;
					end
				RET2  : begin
					Sel_DIV_IN = 0;
					Sel_DIVISOR =1;
					LD_B = 1;
					LD_CNT = 1;
					end
				RET2a : ;		
				RET2b  : begin
					DROP100 = 1;
					CD_CNT=1;
					end
						
				RET3  : begin
					Sel_DIV_IN = 0;
					Sel_DIVISOR =0;
					LD_B = 1;
					LD_CNT = 1;
					end
				RET3a : ;		
				RET3b  : begin
					DROP50 = 1;
					end
				COFF0 : begin
					LD_C = 1;
					Kind = 2'b01;
					end
				COFF1 : begin
					LD_C = 1;
					Kind = 2'b10;
					end
				CUP0 : begin
					LD_D = 1;
					Cups = 1;
					end
				CUP1 : begin
					LD_D = 1;
					Cups = 2;
					end
				CUP2 : begin
					LD_D = 1;
					Cups = 3;
					end
				CUP3 : begin
					LD_D = 1;
					Cups = 4;
					end
				CUP4: begin
					LD_D = 1;
					Cups = 5;
					end
				CALC: begin
					LD_E = 1;
					end
				MAKE0: begin
					LD_A = 1;
					Sel_A_IN =3;
					end
				MAKE0a : begin
					LD_B = 1;
					LD_CNT = 1;
					Sel_DIV_IN = 1; //Aout
					Sel_DIVISOR =3; //20
					end
				MAKE1: CD_D = 1;
				MAKE2: Making = 1;
				MAKE3: Coffee = 1;
				MANAGE0: ;
				MANAGE1: LD_MEM = 1;
				default;
			endcase
		end
	 //state register
	 always@(posedge CLK)
		begin
			ActState <= NextState;
		end
endmodule
