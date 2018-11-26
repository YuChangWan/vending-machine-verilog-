`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:50:10 06/20/2018
// Design Name:   UUT
// Module Name:   /home/ise/ise_projects/Term/TestBench.v
// Project Name:  Term
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: UUT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBench;

	// Inputs
	reg CLK;
	reg Done;
	reg TakeOut;
	reg Start;
	reg Return;
	reg Manage;
	reg Confirm;
	reg Americano;
	reg Ratte;
	reg Cup1;
	reg Cup2;
	reg Cup3;
	reg Cup4;
	reg Cup5;
	reg Coin50;
	reg Coin100;
	reg Coin500;
	reg Coin1000;
	reg [6:0] Americano_price;
	reg [6:0] Ratte_price;

	// Outputs
	wire Return50;
	wire Return100;
	wire Return500;
	wire Return1000;
	wire Making;
	wire Coffee;
	wire [6:0] Sum;

	// Instantiate the Unit Under Test (UUT)
	UUT uut (
		.CLK(CLK), 
		.Done(Done), 
		.TakeOut(TakeOut), 
		.Start(Start), 
		.Return(Return), 
		.Manage(Manage), 
		.Confirm(Confirm), 
		.Americano(Americano), 
		.Ratte(Ratte), 
		.Cup1(Cup1), 
		.Cup2(Cup2), 
		.Cup3(Cup3), 
		.Cup4(Cup4), 
		.Cup5(Cup5), 
		.Coin50(Coin50), 
		.Coin100(Coin100), 
		.Coin500(Coin500), 
		.Coin1000(Coin1000), 
		.Americano_price(Americano_price), 
		.Ratte_price(Ratte_price),  
		.Return50(Return50), 
		.Return100(Return100), 
		.Return500(Return500), 
		.Return1000(Return1000), 
		.Making(Making), 
		.Coffee(Coffee),
		.Sum(Sum)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		Done = 0;
		TakeOut = 0;
		Start = 0;
		Return = 0;
		Manage = 0;
		Confirm = 0;
		Americano = 0;
		Ratte = 0;
		Cup1 = 0;
		Cup2 = 0;
		Cup3 = 0;
		Cup4 = 0;
		Cup5 = 0;
		Coin50 = 0;
		Coin100 = 0;
		Coin500 = 0;
		Coin1000 = 0;
		Americano_price = 0;
		Ratte_price = 0;

		// Wait 100 ns for global reset to finish
		#340;
		// Add stimulus here
		Manage=1;#100;
		Manage=0;
		#100;
		Americano_price=4;Ratte_price=6;#100;
		Confirm=1;#100;
		Confirm=0;#100;
		Americano_price=0;Ratte_price=0;
		#200;
		Coin100=1;#100;
		Coin100=0;
		#200;
		Coin100=1;#100;
		Coin100=0;
		#200;
		Coin100=1;#100;
		Coin100=0;
		#1100;
		Americano=1;#100;
		Americano=0;
		#100;
		Cup1=1;#100;
		Cup1=0;
		#200;
		Start=1;#100;
		Start=0;
		#400;
		Done = 1;#100;
		Done = 0;
		#200;
		TakeOut=1;#100;
		TakeOut=0;
		#1000;
		Return=1;#100;
		Return=0;
	end
		always
			begin
				CLK=1'b0;#50;CLK=1'b1;#50;
			end
endmodule

