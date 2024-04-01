`timescale 1ns/1ps

module permutation_xor import ascon_pack::*;
(
	input logic clock_i,
	input logic resetb_i,
	input logic select_i,
	input type_state permutation_i,
	input logic [3:0] round_i,
	input logic [63:0] data_xor_up_i,
	input logic [255:0] data_xor_down_i,
	input logic ena_xor_up_i,
	input logic ena_xor_down_i,
	input logic ena_reg_state_i,
	output type_state permutation_o,
	output [63:0] cypher_test_o
);

	type_state mux_to_xor_up_s, xor_up_to_const_add_s, const_add_to_subs_s, subs_to_diff_s, diff_to_xor_down_s, xor_down_to_reg_s;
	
	assign mux_to_xor_up_s = (select_i)?permutation_i:permutation_o; //multiplex
	
//up xor
	assign xor_up_to_const_add_s[0] = (ena_xor_up_i)?mux_to_xor_up_s[0]^data_xor_up_i : mux_to_xor_up_s[0];
	

	assign xor_up_to_const_add_s[1] = mux_to_xor_up_s[1];
	assign xor_up_to_const_add_s[2] = mux_to_xor_up_s[2];
	assign xor_up_to_const_add_s[3] = mux_to_xor_up_s[3];
	assign xor_up_to_const_add_s[4] = mux_to_xor_up_s[4];
	
	assign cypher_test_o = xor_up_to_const_add_s[0]; //récupération du cipher 

	constant_addition constant_addition_u
	(	
		.constant_add_i(xor_up_to_const_add_s),
		.round_i(round_i),
		.constant_add_o(const_add_to_subs_s)
	);
	
	substitution_layer substituion_layer_u
	(
		.substitution_i(const_add_to_subs_s),
		.substitution_o(subs_to_diff_s)
	);
	
	diffusion_layer diffusion_layer_u
	(
		.diffusion_i(subs_to_diff_s),
		.diffusion_o(diff_to_xor_down_s)
	);
	
//down xor

	assign xor_down_to_reg_s[0] = diff_to_xor_down_s[0];
	assign xor_down_to_reg_s[1] = (ena_xor_down_i)?diff_to_xor_down_s[1]^data_xor_down_i[255:192] : diff_to_xor_down_s[1];
	assign xor_down_to_reg_s[2] = (ena_xor_down_i)?diff_to_xor_down_s[2]^data_xor_down_i[191:128] : diff_to_xor_down_s[2];
	assign xor_down_to_reg_s[3] = (ena_xor_down_i)?diff_to_xor_down_s[3]^data_xor_down_i[127:64] : diff_to_xor_down_s[3];
	assign xor_down_to_reg_s[4] = (ena_xor_down_i)?diff_to_xor_down_s[4]^data_xor_down_i[63:0] : diff_to_xor_down_s[4];

	
//Rappel : X0 : bits de poids fort d'où [255:192] pour 1

//Register 
	always @ (posedge clock_i, negedge resetb_i) begin
		if (resetb_i == 1'b0) begin 
			permutation_o <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0};
		end
		else begin 
			if(ena_reg_state_i) begin
				permutation_o <= xor_down_to_reg_s;
			end
		end
	end		
	
endmodule
	
	
	
	
	
	
	
	
	
	
	
	
	
	
