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
    
    always_ff @(posedge clk) begin
        if (rst) begin
            current_state <= LOAD_A;
        end else begin
            current_state <= next_state;
        end
    end
    
    always_comb begin
        reg_ctrl = 2'b00;
    
        case (current_state)
            LOAD_A: begin
                fn = INPUT_A;
                if (enter) begin
                    next_state = LOAD_B;
                    reg_ctrl = 2'b01;
                end else begin
                    next_state = LOAD_A;
                end
            end
            
            LOAD_B:begin
                fn = INPUT_B;
                if (enter) begin
                    next_state = ADD;
                    reg_ctrl = 2'b10;
                end else begin
                    next_state = LOAD_B;
                end
            end
            
            ADD: begin
                if (enter) begin
                    next_state = SUB;
                    reg_ctrl = 2'b11;
                end else begin
                    next_state = ADD;
                    reg_ctrl = 2'b11;
                end
                if (sign) begin
                    fn = S_ADD;
                end else begin
                    fn = U_ADD;
                end
            end
            
            SUB: begin
                if(enter) begin
                    next_state = MOD3;
                    reg_ctrl = 2'b11;
                end else begin
                    next_state = SUB;
                    reg_ctrl = 2'b11;
                end
                if (sign) begin
                    fn = S_SUB;
                end else begin
                    fn = U_SUB;
                end
            end
            
            MOD3: begin
                if(enter) begin
                    next_state = ADD;
                    reg_ctrl = 2'b11;
                end else begin
                    next_state = MOD3;
                    reg_ctrl = 2'b11;
                end
                if (sign) begin
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
