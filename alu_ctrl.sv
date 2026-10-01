`timescale 1ns/1ps

import alu_common::*;

module alu_ctrl (
    input logic clk,
    input logic rst,
    input logic enter,
    input logic sign,
    output alu_op_t fn,
    output logic [1:0] reg_ctrl
    );
    
    typedef enum logic [2:0] {
        LOAD_A,
        LOAD_B,
        ADD,
        SUB,
        MOD3
    } state_type;
    
    state_type current_state, next_state;
    
    logic signed_op, next_signed_op, enter_pressed, enter_prev;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            current_state <= LOAD_A;
            signed_op <= 1'b0;
            enter_prev <= 1'b1;
        end else begin
            current_state <= next_state;
            signed_op <= next_signed_op;
            enter_prev <= enter;
        end
    end
    
    always_comb begin
        reg_ctrl = 2'b11;
        next_state = current_state;
        next_signed_op = signed_op;
        
        enter_pressed = enter && !enter_prev;
        
        if (sign)
            next_signed_op = 1;
         
        case (current_state)
            LOAD_A: begin
                fn = INPUT_A;
                reg_ctrl = 2'b01;
                if (enter_pressed) begin
                    next_state = LOAD_B;
                end 
            end
            
            LOAD_B:begin
                fn = INPUT_B;                
                reg_ctrl = 2'b10;
                if (enter_pressed) 
                    next_state = ADD;
            end
            
            ADD: begin
                if (enter_pressed) 
                    next_state = SUB;
                if (signed_op) begin
                    fn = S_ADD;
                end else begin
                    fn = U_ADD;
                end
            end
            
            SUB: begin
                if(enter_pressed) begin
                    next_state = MOD3;
                end 
                if (signed_op) begin
                    fn = S_SUB;
                end else begin
                    fn = U_SUB;
                end
            end
            
            MOD3: begin
                if(enter_pressed) begin
                    next_state = ADD;
                end 
                if (signed_op) begin
                    fn = S_MOD3;
                end else begin
                    fn = U_MOD3;
                end
            end
            
            default: begin
                fn = INPUT_A;
                next_state = LOAD_A;
            end
          endcase
    end

endmodule
