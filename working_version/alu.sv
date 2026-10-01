`timescale 1ns/1ps

import alu_common::*;

module alu (
    input logic [7:0] a,
    input logic [7:0] b,
    input alu_op_t fn,
    output logic [7:0] result,
    output logic overflow,
    output logic sign
    );
    
    logic [8:0] signed_b, signed_a, result_ext;
    
    always_comb begin
        overflow = 1'b0;
        signed_a = 9'b0;
        signed_b = 9'b0;
        result_ext = 9'b0;
        result = 8'b0;
        sign = 1'b0;
    
        case (fn)
            INPUT_A: begin
                result = a;
            end
            INPUT_B: begin
                result = b;
            end
            U_ADD: begin
                result = a + b;
                overflow = (result < a); 
                sign = 1'b0;
            end
            
            U_SUB: begin
                signed_a = {1'b0,a};
                signed_b = (~{1'b0,b}) + 9'd1;
                result_ext = signed_a + signed_b; 
                result = result_ext[8:0]; // correct result in 2's complement will fit in [8:0], negative if result_ext[8] = 1. 
                if (result_ext[8] == 1) begin 
                    sign = 1'b1;
                    result = ~result + 8'd1;
                end 
                else 
                    sign = 1'b0;
            end
            
            U_MOD3, S_MOD3: begin
                sign = 1'b0;
                if (fn == S_MOD3 && a[7] == 1) 
                    signed_a = {1'b1,a} + 9'd129;
                else signed_a = {1'b0,a};
                if (signed_a >= 9'd192) 
                    signed_a = signed_a + 9'b101000000;
                if (signed_a >= 9'd96)
                    signed_a = signed_a + 9'b110100000;
                if (signed_a >= 9'd48)
                    signed_a = signed_a + 9'b111010000;
                if (signed_a >= 9'd24)
                    signed_a = signed_a + 9'b111101000;
                if (signed_a >= 9'd12)
                    signed_a = signed_a + 9'b111110100;
                if (signed_a >= 9'd6)
                    signed_a = signed_a + 9'b111111010;
                if (signed_a >= 9'd3)
                    signed_a = signed_a + 9'b111111101;
                result = signed_a[7:0];
            end
            
            S_ADD: begin
                result = a + b;
                overflow = (a[7] != result[7] && b[7] != result[7]); // is it certain that the interpretation is that overflow is outside of [-128, 127]?
                if (result[7] == 1) begin
                    result = ~result + 9'd1;
                    sign = 1'b1;
                end 
                else 
                    sign = 1'b0;
            end

            S_SUB: begin 
                signed_b = ~{b[7], b} + 9'd1;
                signed_a = {a[7], a};
                result_ext = signed_a + signed_b;
                sign = result_ext[8];
                overflow = 1'b0;
                if ((!a[7] && b[7] && result_ext[7]) || (a[7] && !b[7] && !result_ext[7]))
                    overflow = 1'b1;
                if (sign)
                    result_ext = ~result_ext + 9'b1;
                result = result_ext[7:0];
            end
        endcase
        
    end
            
    
endmodule
