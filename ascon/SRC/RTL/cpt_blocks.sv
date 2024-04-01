`timescale 1ns/1ps

module cpt_blocks import ascon_pack::*;
(
	input logic enable_block_i, 
	input logic init_block_i,
	input logic clock_i, 
	input logic resetb_i,
	
	output logic [3:0] counter_block_o
);


logic [3:0] count_s;

always @(posedge clock_i, negedge resetb_i) begin 
	if(resetb_i == 1'b0) begin 
		count_s<=0;
	end
	else begin 
		if(enable_block_i== 1'b1) begin 
			if(init_block_i == 1'b1)
				count_s<=0;
			else 
				count_s <= count_s+1;
		end 
	end 
end

assign counter_block_o = count_s;
	
	
endmodule
