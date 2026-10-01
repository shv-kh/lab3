`timescale 1ns/1ps

module reg_update (
    input logic clk,
    input logic rst,
    input logic [1:0] reg_ctrl,
    input logic [7:0] reg_input, 
    output logic [7:0] a,
    output logic [7:0] b
    );

    logic [7:0] a_next, b_next;

    always_ff @(posedge clk) begin : update_registers
        if (rst) begin
            a <= '0;
            b <= '0;
        end
        else begin
            a <= a_next;
            b <= b_next;
        end
    end

    always_comb begin : next_register
        a_next = a;
        b_next = b;

        case (reg_ctrl)
            2'b0,2'b01: 
                a_next = reg_input;
            2'b10:
                b_next = reg_input;
            2'b11: begin
                a_next = a;
                b_next = b;
            end
            default: begin //probably redundant but gave an error/warning
                a_next = a;
                b_next = b;
            end
        endcase
    end
    
endmodule
