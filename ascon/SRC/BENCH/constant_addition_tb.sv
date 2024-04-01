`timescale 1ns/1ps

import ascon_pack::*;

module constant_addition_tb ();

	type_state constant_add_s;
	logic[3:0] round_s; //4 bits
	type_state constant_add_o_s;
	
	constant_addition DUT(
		.constant_add_i(constant_add_s),
		.round_i(round_s),
		.constant_add_o(constant_add_o_s)
		);
		
	initial 
		begin 
		
			constant_add_s[0] = 64'h80400c0600000000;
			constant_add_s[1] = 64'h0001020304050607;
			constant_add_s[2] = 64'h08090a0b0c0d0e0f;
			constant_add_s[3] = 64'h0011223344556677;
			constant_add_s[4] = 64'h8899aabbccddeeff;
			
			round_s = 0;
			#20;
			round_s = 1; //ça prend toujours l'entrée, ça ne garde pas en mémoire !
			#20;
			round_s = 2;
			#20
			round_s = 3;
			#20;
			round_s = 4; //ça prend toujours l'entrée, ça ne garde pas en mémoire !
			#20;
			round_s = 5;
			#20;
			round_s = 6; //ça prend toujours l'entrée, ça ne garde pas en mémoire !
			#20;
			round_s = 7;
			#20
			round_s = 8;
			#20;
			round_s = 9; //ça prend toujours l'entrée, ça ne garde pas en mémoire !
			#20;
			round_s = 10;
			#20;
			round_s = 11;
			
			
		end 
	endmodule : constant_addition_tb
			
