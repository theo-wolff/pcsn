`timescale 1ns/1ps

import ascon_pack::*;

module top_level_tb();

	logic start_s;
	logic data_valid_s; 
	logic [63:0] data_s;
	logic [127:0] key_s;
	logic [127:0] nonce_s;
	logic clock_s;
	logic resetb_s;
	
	logic cipher_valid_s; 
	logic end_s;
	logic [63:0] cipher_s;
	logic [127:0] tag_s;
	
	top_level DUT(
		.start_i(start_s),
		.data_valid_i(data_valid_s),
		.data_i(data_s),
		.key_i(key_s),
		.nonce_i(nonce_s),
		.clock_i(clock_s),
		.resetb_i(resetb_s),
		
		.cipher_valid_o(cipher_valid_s),
		.end_o(end_s),
		.cipher_o(cipher_s),
		.tag_o(tag_s)
		);
		
	initial 
		begin 
			clock_s=0;
			forever #5 clock_s =~ clock_s; //période de 10ns
		end
	
	initial 
		begin
			key_s = 128'h000102030405060708090A0B0C0D0E0F;
			nonce_s = 128'h00112233445566778899AABBCCDDEEFF;
			data_s = 64'h3230323380000000; 
			
			start_s = 0;
			resetb_s=0;
			data_valid_s=0;
			
			#5;
			resetb_s=1;
			#15;
			start_s=1; //state1, faut faire passer init_select à 1 ?
			
			
			#200;
			start_s = 0;
			#5;
			data_valid_s = 1;
			
			#20;
			data_valid_s = 0;
			
			
			#200;
			data_s = 64'h436F6E636576657A;
			#10;
			data_valid_s = 1;
			#20;
			data_valid_s = 0;
			#250;
			data_s = 64'h204153434F4E2065;
			#10;
			data_valid_s = 1;
			#10;
			data_valid_s = 0;
			#250;
			data_s = 64'h6E2053797374656D;
			#10;
			data_valid_s = 1;
			#10; 
			data_valid_s = 0;
			#250;
			data_s = 64'h566572696C6F6780;
			#10;
			data_valid_s = 1;
			#10;
			data_valid_s = 0;
				
		end 
		

endmodule: top_level_tb
	
