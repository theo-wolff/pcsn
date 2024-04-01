`timescale 1ns/1ps

module top_level import ascon_pack::*;
(
	input logic start_i, 
	input logic data_valid_i, 
	input logic [63:0] data_i,
	input logic [127:0] key_i,
	input logic [127:0] nonce_i,
	input logic clock_i, 
	input logic resetb_i,
	
	output logic cipher_valid_o, 
	output logic end_o,
	output logic [63:0] cipher_o,
	output logic [127:0] tag_o
	
);

logic [3:0] round_s;
logic [1:0] block_s;

logic enable_cpt_s, init_a_s, init_b_s, enable_block_s, init_select_s, init_block_s, ena_xor_up_s, ena_xor_down_s, ena_reg_state_s;

logic [1:0] conf_xor_down_s;

logic [2:0] [255:0] data_xor_down_s;

//assign data_xor_down_s = {128'h0, key_i};

logic [63:0] IV, cypher_test_s;

assign IV = 64'h80400C0600000000;

type_state permutation_in_s, permutation_out_s;

assign permutation_in_s = {IV, key_i, nonce_i};

	FSM FSM_1
	(
		.start_i(start_i), 
		.data_valid_i(data_valid_i),
		.round_i(round_s),
		.block_i(block_s),
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		
		.cipher_valid_o(cipher_valid_o),
		.end_o(end_o),
		.enable_cpt_o(enable_cpt_s),
		.init_a_o(init_a_s),
		.init_b_o(init_b_s),
		.ena_block_o(enable_block_s),
	 	.init_select_o(init_select_s),
	 	.init_block_o(init_block_s),
		.ena_xor_up_o(ena_xor_up_s), 
		.ena_xor_down_o(ena_xor_down_s),
		.ena_reg_state_o(ena_reg_state_s),
		.conf_xor_down_o(conf_xor_down_s) 
		
	);
	
	cpt_round cpt_round_1
	(
		.enable_cpt_i(enable_cpt_s),
		.init_a_i(init_a_s),
		.init_b_i(init_b_s),
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		
		.counter_o(round_s)
	);
	
	cpt_blocks cpt_blocks_1
	(
		.enable_block_i(enable_block_s),
		.init_block_i(init_block_s),
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		
		.counter_block_o(block_s)
	);


	//trois cas possibles pour la data en aval 
	assign data_xor_down_s[0] = {128'h0, key_i};
		
	assign data_xor_down_s[1] = 256'h1;
		
	assign data_xor_down_s[2] = {key_i, 128'h0};
	
	permutation_xor permutation_xor_1
	(
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.select_i(init_select_s),
		.permutation_i(permutation_in_s),
		.round_i(round_s),
		.data_xor_up_i(data_i),
		.data_xor_down_i(data_xor_down_s[conf_xor_down_s]),
		.ena_xor_up_i(ena_xor_up_s),
		.ena_xor_down_i(ena_xor_down_s),
		.ena_reg_state_i(ena_reg_state_s),
		.permutation_o(permutation_out_s),
		.cypher_test_o(cypher_test_s)
	);
	 
	assign cipher_o = (cipher_valid_o)?cypher_test_s:0;  
	assign tag_o = (end_o)?permutation_out_s[3:4]:0;
endmodule: top_level








