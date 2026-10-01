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
    
    logic [1:0]next_reg_ctrl;
    logic signed_op, next_signed_op;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            current_state <= LOAD_A;
            reg_ctrl <= 2'b0;
            signed_op <= 1'b0;
        end else begin
            current_state <= next_state;
            reg_ctrl <= next_reg_ctrl;
            signed_op <= next_signed_op;
        end
    end
    
    always_comb begin
        next_reg_ctrl = reg_ctrl;
        next_state = current_state;
        next_signed_op = signed_op;
        
        if (sign)
            next_signed_op = 1;
         
        case (current_state)
            LOAD_A: begin
                fn = INPUT_A;
                next_reg_ctrl = 2'b01;
                if (enter)
                    next_state = LOAD_B;
            end
            
            LOAD_B:begin
                fn = INPUT_B;
                next_reg_ctrl = 2'b10;
                if (enter) 
                    next_state = ADD;
            end
            
            ADD: begin
                next_reg_ctrl = 2'b11;
                if (enter) 
                    next_state = SUB;
                if (signed_op) begin
                    fn = S_ADD;
                end else begin
                    fn = U_ADD;
                end
            end
            
            SUB: begin
                next_reg_ctrl = 2'b11;
                if(enter) begin
                    next_state = MOD3;
                end 
                if (signed_op) begin
                    fn = S_SUB;
                end else begin
                    fn = U_SUB;
                end
            end
            
            MOD3: begin
                next_reg_ctrl = 2'b11;
                if(enter) begin
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
            end
          endcase
    end

endmodule
