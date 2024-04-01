`timescale 1ns/1ps

import ascon_pack::*;

module diffusion_layer_tb ();

	type_state diffusion_i_s;
	type_state diffusion_o_s;
	
diffusion_layer DUT(
	.diffusion_i(diffusion_i_s),
	.diffusion_o(diffusion_o_s)
	);
	
	initial 
		begin
			diffusion_i_s[0] = 64'h8859263f4c5d6e8f;
			diffusion_i_s[1] = 64'h00c18e8584858607;
			diffusion_i_s[2] = 64'h7f7f7f7f7f7f7f8f;
			diffusion_i_s[3] = 64'h80c0848680808070;
			diffusion_i_s[4] = 64'h8888888a88888888;
		end
endmodule: diffusion_layer_tb
