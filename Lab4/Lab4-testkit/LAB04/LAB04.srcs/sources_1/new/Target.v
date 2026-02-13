`timescale 1ns / 1ps

module Target(
    input clk, 
    input reset, 
    input load, 
    input [3:0] D, 
    output [3:0] Q 
    );
    
    wire [3:0] Q_in;
    
    FDRE # (.INIT(3'b0)) Q0 (.C(clk), .R(reset), .CE(load), .D(D[0]), .Q(Q_in[0]));
    FDRE # (.INIT(3'b0)) Q1 (.C(clk), .R(reset), .CE(load), .D(D[1]), .Q(Q_in[1]));
    FDRE # (.INIT(3'b0)) Q2 (.C(clk), .R(reset), .CE(load), .D(D[2]), .Q(Q_in[2]));
    FDRE # (.INIT(3'b0)) Q3 (.C(clk), .R(reset), .CE(load), .D(D[3]), .Q(Q_in[3]));

    assign Q = Q_in;
endmodule
