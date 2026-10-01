`timescale 1ns/1ps

import alu_common::*;

// start of a testbench for binary-->bcd, might have issues, untested

task correctono;

    input logic [9:0] out;
    input logic [9:0] expected_out;
    input logic [7:0] in;
    input int line;

    begin
        if (out != expected_out) begin
            $display("Error for operation on line %d, expected output %b not equal actual output %b", line, expected_out, out);
            $display("Input = ", in);
            $stop;
        end
    end

endtask

module tb_bcd ();

    logic [7:0] binary_in;
    logic [9:0] bcd_out;

    localparam int period = 1000;

    initial begin

        binary_in = 8'd243;
        #(period);
        correctono(bcd_out, 10'b1001000011, binary_in, `__LINE__);
        #(period);


    $display("All tests passed!!!!!!");
    $finish;

    end

binary2bcd bcd_inst(
    .binary_in(binary_in),
    .bcd_out(bcd_out)
);


endmodule