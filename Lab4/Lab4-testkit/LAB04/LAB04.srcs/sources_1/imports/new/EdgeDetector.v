`timescale 1ns / 1ps


module EdgeDetector
(
input clk,
input reset, 
input button,
output edge_o

);
    
wire [1:0] Q;
assign edge_o = Q[0] & ~Q[1];

FDRE #(.INIT(1'b0)) d1 (.Q(Q[0]), .C(clk), .CE(1'b1), .R(reset), .D(button));
FDRE #(.INIT(1'b0)) d2 (.Q(Q[1]), .C(clk), .CE(1'b1), .R(reset), .D(Q[0]));
 
endmodule
