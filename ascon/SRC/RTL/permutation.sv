`timescale 1ns/1ps

module permutation import ascon_pack::*;
(
	input logic clock_i,
	input logic resetb_i,
	input logic select_i,
	input type_state permutation_i,
	input logic [3:0] round_i,
	output type_state permutation_o
);

	type_state state_to_pc;
	type_state addition_o_s;
	type_state substitution_o_s;
	type_state diffusion_o_s;
	
	assign state_to_pc = (select_i)?permutation_i:permutation_o; //multiplex
	
	constant_addition constant_addition_u
	(	
		.constant_add_i(state_to_pc),
		.round_i(round_i),
		.constant_add_o(addition_o_s)
	);
	
	substitution_layer substituion_layer_u
	(
		.substitution_i(addition_o_s),
		.substitution_o(substitution_o_s)
	);
	
	diffusion_layer diffusion_layer_u
	(
		.diffusion_i(substitution_o_s),
		.diffusion_o(diffusion_o_s)
	);
	
//Register 
	always @ (posedge clock_i, negedge resetb_i) begin
		if (resetb_i == 1'b0) begin 
			permutation_o <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0};
		end
		else begin 
			permutation_o <= diffusion_o_s;
		end
	end		
	
endmodule
	
	
	
	
	
	
	
	
	
	
	
	
	
	
