`timescale 1ns/1ps

module FSM import ascon_pack::*;
(
	input logic start_i,
	input logic data_valid_i,
	input logic [3:0] round_i,
	input logic [1:0] block_i,
	input logic clock_i,
	input logic resetb_i,
	
	output logic cipher_valid_o,
	output logic enable_cpt_o,
	output logic end_o,
	output logic init_a_o,
	output logic init_b_o,
	output logic ena_block_o,
	output logic init_select_o,
	output logic init_block_o,
	output logic ena_xor_up_o, 
	output logic ena_xor_down_o,
	output logic ena_reg_state_o,
	output logic [1:0] conf_xor_down_o 
	 
);





typedef enum{state0, set_cpt, init_state, init, end_init, xor_a1, wait_a1, init_2, end_init_2, xor_r, wait_p1, init_r, end_init_r, xor_p2, wait_r, init_4, end_init_4, xor_p3, wait_p3, init_5, end_init_5,xor_p4, wait_p4, init_6, end_init_6, end_tb} state_t;

state_t current_state, next_state; 

//sequentiel: mémorise l'état courant 

always_ff @(posedge clock_i or negedge resetb_i) // ou always_ff @(posedge clock_i, negedge resetb_i)??
begin: seq_0
	if(resetb_i == 0)
		current_state <= state0;
	else
		current_state <= next_state;
end: seq_0



always_comb
begin: comb_0
	case (current_state)
	
	
	
		state0: if(start_i)
			next_state = set_cpt;
		else
			next_state = state0;
			
		set_cpt:
			next_state = init_state;
			
		init_state: 
			next_state = init;
		
		init: if(round_i<10)
			next_state = init;
		else
			next_state = end_init;
		
		end_init: if(data_valid_i)
			next_state = xor_a1;
		else
			next_state = wait_a1;
		
		wait_a1: if(data_valid_i == 0)
			next_state = wait_a1;
		else 
			next_state = xor_a1;
			
		xor_a1: 
			next_state = init_2;
		
		init_2: if(round_i<10)
			next_state = init_2; 
		else 
			next_state = end_init_2;
		
		end_init_2: if(data_valid_i == 0)
			next_state = wait_p1;
		else
			next_state = xor_r;
		
		wait_p1: if(data_valid_i == 0)
			next_state = wait_p1;
		else 
			next_state = xor_r;
		
		xor_r: next_state = init_r;
		
		init_r: if(round_i<10)
			next_state = init_r; 
		else 
			next_state = end_init_r;
			
		end_init_r: begin 
			if(block_i < 3) begin //on récupère les 4 ciphers 
				if(data_valid_i == 0)
					next_state = wait_r;
				else
				next_state = xor_r;
				end
			else 
				next_state = end_tb;
			end
		
		wait_r: if(data_valid_i == 0)
			next_state = wait_r;
		else 
			next_state = xor_r;
		
		end_tb: next_state = state0;
			
		default: next_state = state0;
	endcase;
end: comb_0

//combinatoire des sorties 
always_comb
begin: comb_1
	//remise à zéro à chaque coup de clock 
	cipher_valid_o = 0;
	enable_cpt_o=0;
	end_o = 0;
	init_a_o=0;
	init_b_o=0;
	ena_block_o=0;
	init_block_o = 0;
	init_select_o = 0;
	ena_xor_up_o = 0;
	ena_xor_down_o = 0;
	ena_reg_state_o = 0;
	conf_xor_down_o = 2'b00;
	
	case (current_state)
	
		state0: //NOP
			
		set_cpt: begin  //set compteur 
			init_a_o = 1;
			enable_cpt_o= 1;
			end
			
		init_state: begin 	//initial state
			init_select_o = 1;
			enable_cpt_o = 1;
			ena_reg_state_o = 1;
			end 
		
		init: begin 
			ena_reg_state_o = 1;
			enable_cpt_o = 1;
			end
			
		end_init: begin  
			ena_xor_down_o=1;
			conf_xor_down_o=0;
			init_b_o=1;
			enable_cpt_o=1;
			ena_reg_state_o=1;
			end
			
		xor_a1: begin 
			ena_xor_up_o = 1;
			enable_cpt_o = 1;
			ena_reg_state_o = 1;
			end
			
		wait_a1: begin
			ena_reg_state_o=0;
			enable_cpt_o=0;
			end 
			
		init_2: begin 
			enable_cpt_o=1;
			ena_reg_state_o = 1;
			end
		
		end_init_2: begin 
			ena_xor_down_o = 1;
			enable_cpt_o = 1;
			ena_reg_state_o = 1;
			conf_xor_down_o = 1;
			init_b_o = 1;
			ena_block_o=1;
			init_block_o=1; // lancement du compteur de blocks 
			end 
		
		xor_r: begin 
			ena_xor_up_o = 1;
			enable_cpt_o = 1;
			ena_reg_state_o = 1;
			cipher_valid_o = 1;
			end
			
		wait_p1: begin 	
			ena_reg_state_o = 0;
			enable_cpt_o = 0;
			ena_block_o = 0;
			end
		
		init_r: begin 
			enable_cpt_o =1;
			ena_reg_state_o = 1;
			end
			
		end_init_r: begin 
			enable_cpt_o = 1;
			ena_reg_state_o = 1;
			ena_block_o = 1;
			if(block_i==2) begin //pour lancer p12
				ena_xor_down_o = 1;
				conf_xor_down_o = 2;
				init_a_o=1;
				end
			else if(block_i==3) begin //fin de p12
				ena_xor_down_o = 1;
				conf_xor_down_o = 0;
				end
			else 
				init_b_o = 1; //lancer les p6
			end
		
		wait_r: begin
			ena_reg_state_o = 0;
			enable_cpt_o = 0;
			end 
		
		end_tb: end_o = 1;
			

		default: cipher_valid_o = 0;

	endcase;
end: comb_1

endmodule: FSM
	
	
	
	
	
	
	

