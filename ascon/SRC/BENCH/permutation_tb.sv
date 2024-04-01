`timescale 1ns/1ps

import ascon_pack::*;

module permutation_tb ();

	logic clock_s;
	logic resetb_s;
	logic select_s;
	type_state permutation_i_s;
	logic [3:0] round_s;
	type_state permutation_o_s;
	
	permutation DUT(
		.clock_i(clock_s),
		.resetb_i(resetb_s),
		.select_i(select_s),
		.permutation_i(permutation_i_s),
		.round_i(round_s),
		.permutation_o(permutation_o_s)
	);
	
	
	initial 
		begin 
			clock_s = 0;
			forever #5 clock_s =~ clock_s;
		end 
		
	initial 
		begin 
			permutation_i_s[0] = 64'h80400c0600000000;
			permutation_i_s[1] = 64'h0001020304050607;
			permutation_i_s[2] = 64'h08090a0b0c0d0e0f;
			permutation_i_s[3] = 64'h0011223344556677;
			permutation_i_s[4] = 64'h8899aabbccddeeff;
			select_s = 1;
			resetb_s = 0;
			round_s = 0;
			
			#10;
			resetb_s = 1;
			#5;
			select_s = 0;
			round_s = 1;
			#10;
			round_s = 2;
			#10;
			round_s = 3;
			#10;
			round_s = 4;
			#10;
			round_s = 5;
			#10;
			round_s = 6;
			#10;
			round_s = 7;
			#10;
			round_s = 8;
			#10;
			round_s = 9;
			#10;
			round_s = 10;
			#10;
			round_s = 11;
			
		end 
		
endmodule : permutation_tb












