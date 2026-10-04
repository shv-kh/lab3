`timescale 1ns/1ps

import alu_common::*;

task correctono;

    input alu_op_t fn;
    input alu_op_t expected_fn;
    input logic [1:0] reg_ctrl;
    input logic [1:0] expected_reg_ctrl;

    begin
        if (fn != expected_fn) begin
            $display("Error on line %d, fn-output: %s doesn't match expected fn-output %s", `__LINE__, fn, expected_fn);
            $stop;
        end
        if (reg_ctrl != expected_reg_ctrl) begin
            $display("Error on line %d, reg-control: %b doesn't match expected reg-control: %b", `__LINE__, reg_ctrl, expected_reg_ctrl);
            $stop;
        end
    end
endtask

    module tb_aluctrl ();

    logic clk;
    logic rst;
    logic enter;
    logic sign;
    alu_op_t fn;
    logic [1:0] reg_ctrl;
    
    initial clk = 1'b0;
    always #(period/2) clk = ~clk;

    localparam int period = 1000;

    initial begin

        rst = 1'b0; //reset to initial 
        #(period)
        rst = 1'b1; // "turn off" reset, assuming it maintains this off-state until changed again?
        #(period)
        enter = 1'b0;
        sign = 1'b0; // potentially an issue with X until this point, so enter/sign_prev are X in the controller
        #(period)
        correctono(fn, INPUT_A, reg_ctrl, 2'b01); // can the expected fn be put like this, so by the name it's given in the alu_common file, or does it have to be in binary?
        #(period)
        
        enter = 1'b1; // next state --> fn = INPUT_B
        #(period)
        enter = 1'b0;
        correctono(fn, INPUT_B, reg_ctrl, 2'b10);
        #(period)

        sign = 1'b1;
        #(period)
        sign = 1'b0;
        correctono(fn, INPUT_B, reg_ctrl, 2'b10);
        #(period)

        enter = 1'b1; // next state --> fn = S_ADD
        #(period)
        enter = 1'b0;
        correctono(fn, S_ADD, reg_ctrl, 2'b11);
        #(period)

        sign = 1'b1; // next --> U_ADD
        #(period)
        sign = 1'b0;
        correctono(fn, U_ADD, reg_ctrl, 2'b11);
        #(period)

        sign = 1'b1; // next --> S_ADD
        #(period)
        sign = 1'b0;
        correctono(fn, S_ADD, reg_ctrl, 2'b11);
        #(period)

        enter = 1'b1; // next state --> fn = S_SUB
        #(period)
        enter = 1'b0;
        correctono(fn, S_SUB, reg_ctrl, 2'b11);
        #(period)

        sign = 1'b1; // next --> U_SUB  
        #(period)
        sign = 1'b0;
        correctono(fn, U_SUB, reg_ctrl, 2'b11);
        #(period)

        enter = 1'b1; // next state --> fn = U_MOD
        #(period)
        enter = 1'b0;
        correctono(fn, U_MOD3, reg_ctrl, 2'b11);
        #(period)

        sign = 1'b1; // next --> S_MOD  
        #(period)
        sign = 1'b0;
        correctono(fn, S_MOD3, reg_ctrl, 2'b11);
        #(period)

        enter = 1'b1; // next state --> fn = S_ADD
        #(period)
        enter = 1'b0;
        correctono(fn, S_ADD, reg_ctrl, 2'b11);
        #(period)

        rst = 1'b0;
        #(period)
        correctono(fn, INPUT_A, reg_ctrl, 2'b01);
        #(period)

        $display("all passed");
        $finish;
    end

    alu_ctrl alu_ctrl_inst (
        .clk(clk),
        .rst(rst),
        .enter(enter),
        .sign(sign),
        .fn(fn),
        .reg_ctrl(reg_ctrl)
    );

endmodule

