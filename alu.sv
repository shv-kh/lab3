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

    // take the a-vector and calculate mux-value regardless of input signal and only output if fn shows the correct thing
    logic [7:0] signed_shifted_a;

    always_comb begin : mux_pipeline
        signed_shifted_a = a;
        if (fn == 3'b111) // can input the actual state-name as condition?
            if (a[7] == 1'b1)
                signed_shifted_a = a + 8'd129; // not a problem to not have an else because of the default?

        if (signed_shifted_a >= 8'd192)
            signed_shifted_a = signed_shifted_a - 8'd192;
        if (signed_shifted_a >= 8'd96)
            signed_shifted_a = signed_shifted_a - 8'd96;
        if (signed_shifted_a >= 8'd48)
            signed_shifted_a = signed_shifted_a - 8'd48;
        if (signed_shifted_a >= 8'd24)
            signed_shifted_a = signed_shifted_a - 8'd24;
        if (signed_shifted_a >= 8'd12)
            signed_shifted_a = signed_shifted_a - 8'd12;
        if (signed_shifted_a >= 8'd6)
            signed_shifted_a = signed_shifted_a - 8'd6;
        if (signed_shifted_a >= 8'd3)
            signed_shifted_a = signed_shifted_a - 8'd3;
        
    end


// output MUX
    always_comb begin : output_mux
        case (fn)
            3'b111:
                result = signed_shifted_a;
            3'b100:
                result = signed_shifted_a;
        

        endcase

    end




    
endmodule


/* if fn == 100 
        mod3 unsigned

    if fn == 111
        mod3 signed


        */