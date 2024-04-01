`timescale 1ns/1ps

//import ascon_pack::*;

module constant_addition import ascon_pack::*;
(
	input type_state constant_add_i,
	input logic[3:0] round_i, //4 bits
	output type_state constant_add_o
);

	assign constant_add_o[0] = constant_add_i[0];
	assign constant_add_o[1] = constant_add_i[1]; //connexion de fils 
	assign constant_add_o[3] = constant_add_i[3];
	assign constant_add_o[4] = constant_add_i[4];
	
	assign constant_add_o[2][7:0] = constant_add_i[2][7:0]^round_constant[round_i];
	assign constant_add_o[2][63:8] = constant_add_i[2][63:8];
	
endmodule //constant_addition
