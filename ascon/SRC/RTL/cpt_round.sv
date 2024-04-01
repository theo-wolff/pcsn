`timescale 1ns/1ps

module cpt_round import ascon_pack::*;
(
	input logic enable_cpt_i, 
	input logic init_a_i,
	input logic init_b_i,
	input logic clock_i, 
	input logic resetb_i,
	
	output logic [3:0] counter_o
);


logic [3:0] count_s;

always @(posedge clock_i, negedge resetb_i) begin 
	if(resetb_i == 1'b0) begin 
		count_s<=0;
	end
	else begin 
		if(enable_cpt_i== 1'b1) begin 
			if(init_a_i == 1'b1)
				count_s<=0;
			else if (init_b_i == 1'b1)
				count_s<=6;
			else 
				count_s <= count_s+1;
		end 
	end 
end

assign counter_o = count_s;
	
	
endmodule
