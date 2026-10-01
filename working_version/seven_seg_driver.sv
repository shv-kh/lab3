`timescale 1ns/1ps

module seven_seg_driver (
    input logic clk,
    input logic rst,
    input logic [9:0] bcd_digit,
    input logic sign,
    input logic overflow,
    output logic [3:0] digit_anode,
    output logic [6:0] segment
    );

    logic [3:0] left;
    logic [3:0] mid;
    logic [3:0] right;
    logic [15:0] counter;
    logic [3:0] to_display;

    assign left = {2'b0, bcd_digit[9:8]};
    assign mid = bcd_digit[7:4];
    assign right = bcd_digit[3:0];

    always_ff @(posedge clk) begin : counter_update
        if (!rst)
            counter <= '0;
        else
            counter <= counter + 1;
    end 

    always_comb begin : segment_selector // can be improved --> Freda version 
        digit_anode = 4'b1111;
        to_display = '0;

        if ((0 < counter) && (counter < 2**14)) begin
        digit_anode = 4'b1110;
        to_display = right;
        end
        else if ((2**14 < counter) && (counter < 2**15)) begin
        digit_anode = 4'b1101;
        to_display = mid;
        end 
        else if ((2**15 < counter) && (counter < 3*2**14)) begin
        digit_anode = 4'b1011;
        to_display = left;
        end
        else if ((3*2**14 < counter) && (counter < 2**16)) begin
        digit_anode = 4'b0111;
        to_display = 4'b1111; 
        if (sign)
            to_display = 4'b1011;
        if (overflow)
            to_display = 4'b1010;
        end
    end

        always_comb begin // 7 bit output instead of 8 like in the last lab --> hardwire the 8th bit to something in the constraints file??
        case (to_display)
            4'b0000: // 0
                segment = 7'b1000000;
            4'b0001: // 1
                segment = 7'b1111001;
            4'b0010: // 2
                segment = 7'b0100100;
            4'b0011: // 3
                segment = 7'b0110000;
            4'b0100: // 4
                segment = 7'b0011001;
            4'b0101: // 5
                segment = 7'b0010010;
            4'b0110: // 6
                segment = 7'b0000010;
            4'b0111: // 7
                segment = 7'b1111000;
            4'b1000: // 8
                segment = 7'b0000000;
            4'b1001: // 9
                segment = 7'b0010000;
            4'b1010: // F
                segment = 7'b0001110;
            4'b1011: // minus-sign
                segment = 7'b0111111;
            default: segment = 7'b1111111;
        endcase
    end
/////////////////////////////////////////////////////////////////////okay to have the output with leading 0's?
    
endmodule 


// if sign: enable "g" on the display for the leftmost 