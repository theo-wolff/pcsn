`timescale 1ns/1ps

import ascon_pack::*;

module permutation_xor_tb ();

	logic clock_s;
	logic resetb_s;
	logic select_s;
	type_state permutation_i_s;
	logic [3:0] round_s;
	type_state permutation_o_s;
	logic [63:0] data_xor_up_s;
	logic [255:0] data_xor_down_s;
	logic ena_xor_up_s;
	logic ena_xor_down_s;
	logic ena_reg_state_s;
	
	
	permutation_xor DUT(
		.clock_i(clock_s),
		.resetb_i(resetb_s),
		.select_i(select_s),
		.permutation_i(permutation_i_s),
		.round_i(round_s),
		.data_xor_up_i(data_xor_up_s),
		.data_xor_down_i(data_xor_down_s),
		.ena_xor_up_i(ena_xor_up_s),
		.ena_xor_down_i(ena_xor_down_s),
		.ena_reg_state_i(ena_reg_state_s),
		.permutation_o(permutation_o_s)
	);
	
	
	initial 
		begin 
			clock_s = 0;
			forever #5 clock_s =~ clock_s;
		end 
		
	initial 
		begin 
			permutation_i_s[0] = 64'h1b1354db77e0dbb4;
			permutation_i_s[1] = 64'h6f140401cfa0873c;
			permutation_i_s[2] = 64'hd7e8abaf45f2885a;
			permutation_i_s[3] = 64'hc0c5777fa661625e;
			permutation_i_s[4] = 64'hfc4374d28210928c;
			data_xor_up_s = 64'h3230323380000000; //padding 1 puis que 0
			data_xor_down_s = 64'h1;
			ena_xor_up_s = 1;
			ena_xor_down_s = 0;
			ena_reg_state_s = 1;
			select_s = 1;
			resetb_s = 0;
			round_s = 6;
			
			#5;
			resetb_s = 1;
			#10;
			select_s = 0;
			ena_xor_up_s=0;
			round_s = 7;
			#10;
			round_s = 8;
			#10;
			round_s = 9;
			#10;
			round_s = 10;
			#10;
			round_s = 11;
			#10;
			ena_xor_down_s = 1;
			
			

			
		end 
		
endmodule : permutation_xor_tb












