`timescale 1ns/1ps

import alu_common::*;

module alu_top (
    input logic clk,
    input logic rst,
    input logic b_enter,
    input logic b_sign,
    input logic [7:0] alu_input, //needs defining in the constraints file??
    output logic [6:0] seven_seg,
    output logic [3:0] anode,
    output logic [3:0] rest_anode
    );

    // SIGNAL DEFINITIONS
    logic enter;
    logic ctrlsign;
    alu_op_t fn; // alu_op_t in the actual module, should it be the same thing here?
    logic [1:0] reg_ctrl;
    logic [7:0] a;
    logic [7:0] b;
    logic [7:0] aluresult;
    logic overflow;
    logic alusign;
    logic[9:0] bcdout;

    assign rest_anode = 4'b1111;

    // DEVELOP THE STRUCTURE OF ALU TOP HERE

    // To provide a clean signal out of a bouncy one coming from a push button:
    debouncer debouncer_enter (
        .clk(clk),
        .rst(rst),
        .button_in(b_enter),
        .button_out(enter)
    );

    debouncer debouncer_sign (
        .clk(clk),
        .rst(rst),
        .button_in(b_sign),
        .button_out(ctrlsign)
    );

    alu_ctrl alk_ctrl_inst (
        .clk(clk),
        .rst(rst),
        .enter(enter),
        .sign(ctrlsign),
        .fn(fn),
        .reg_ctrl(reg_ctrl)
    );

    reg_update reg_update_inst (
        .clk(clk),
        .rst(rst),
        .reg_ctrl(reg_ctrl),
        .reg_input(alu_input),
        .a(a), 
        .b(b)
    );

    alu alu_freda_inst (
        .a(a),
        .b(b),
        .fn(fn), 
        .result(aluresult),
        .overflow(overflow),
        .sign(alusign)
    );

    binary2bcd binary2bcd_inst (
        .binary_in(aluresult),
        .bcd_out(bcdout)
    );

    seven_seg_driver seg_inst (
        .clk(clk),
        .rst(rst),
        .bcd_digit(bcdout),
        .sign(alusign),
        .overflow(overflow),
        .digit_anode(anode),
        .segment(seven_seg)
    );


endmodule
