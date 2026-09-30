`timescale 1ns/1ps

module binary2bcd (
    input logic [7:0] binary_in,
    output logic [9:0] bcd_out
    );

    /*

    If I'm not mistaken the lack of a clk input above implies that this should be fully combinational, 
    in which case I don't see how the below sort of ugly repetitive structure can be avoided 

    */


    always_comb begin

    logic [17:0] shiftreg;
    shiftreg = {10'b0, binary_in}; 

    shiftreg = {shiftreg[14:0], 3'b000}; //shift 3 bits in the first step since no part can be >4 after the first two shifts
    if (shiftreg[15:12] > 4'd4)
        shiftreg[15:12] = shiftreg[15:12] + 4'd3; 
    if (shiftreg[11:8] > 4'd4)
        shiftreg[11:8] = shiftreg[11:8] + 4'd3;

    shiftreg = {shiftreg[16:0], 1'b0}; //4 shifts done
    if (shiftreg[15:12] > 4'd4)
        shiftreg[15:12] = shiftreg[15:12] + 4'd3;
    if (shiftreg[11:8] > 4'd4)
        shiftreg[11:8] = shiftreg[11:8] + 4'd3;

    shiftreg = {shiftreg[16:0], 1'b0}; //5 shifts done
    if (shiftreg[15:12] > 4'd4)
        shiftreg[15:12] = shiftreg[15:12] + 4'd3;
    if (shiftreg[11:8] > 4'd4)
        shiftreg[11:8] = shiftreg[11:8] + 4'd3;

    shiftreg = {shiftreg[16:0], 1'b0}; //6 shifts done
    if (shiftreg[15:12] > 4'd4)
        shiftreg[15:12] = shiftreg[15:12] + 4'd3;
    if (shiftreg[11:8] > 4'd4)
        shiftreg[11:8] = shiftreg[11:8] + 4'd3;

    shiftreg = {shiftreg[16:0], 1'b0}; //7 shifts done
    if (shiftreg[15:12] > 4'd4)
        shiftreg[15:12] = shiftreg[15:12] + 4'd3;
    if (shiftreg[11:8] > 4'd4)
        shiftreg[11:8] = shiftreg[11:8] + 4'd3;

    shiftreg = {shiftreg[16:0], 1'b0};

    bcd_out = shiftreg[17:8];

    end


endmodule

