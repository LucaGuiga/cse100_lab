`timescale 1ns / 1ps
// hex7seg.v

module hex7seg(
    input [3:0] N_i,
    input losedashthing_i,
    output [6:0] seg_o
);

wire n3 = N_i[3];
wire n2 = N_i[2];
wire n1 = N_i[1];
wire n0 = N_i[0];
wire [6:0] seg_int;

//truth table
assign seg_int[6] = ((~n3 & ~n2 & ~n1 & n0) | (~n3 & n2 & ~n1 & ~n0) | (n3 & ~n2 & n1 & n0) | (n3 & n2 & ~n1 & n0)) | losedashthing_i; // A

assign seg_int[5] = ((~n3 & n2 & ~n1 & n0) | (~n3 & n2 & n1 & ~n0) | (n3 & ~n2 & n1 & n0) | (n3 & n2 & ~n1 & ~n0) | (n3 & n2 & n1 & ~n0) | (n3 & n2 & n1 & n0)) | losedashthing_i; // B

assign seg_int[4] = ((~n3 & ~n2 & n1 & ~n0) | (n3 & n2 & ~n1 & ~n0) | (n3 & n2 & n1 & ~n0) | (n3 & n2 & n1 & n0)) | losedashthing_i; // C

assign seg_int[3] = ((~n3 & ~n2 & ~n1 &  n0) | (~n3 & n2 & ~n1 & ~n0) | (~n3 & n2 & n1 & n0) | (n3 & ~n2 & n1 & ~n0) | (n3 & n2 & n1 & n0)) | losedashthing_i; // D

assign seg_int[2] = ((~n3 & ~n2 & ~n1 & n0) | (~n3 & ~n2 & n1 & n0) | (~n3 & n2 & ~n1 & ~n0) | (~n3 & n2 & ~n1 &  n0) | (~n3 & n2 & n1 &  n0) | (n3 & ~n2 & ~n1 & n0)) | losedashthing_i; // E

assign seg_int[1] = ((~n3 & ~n2 & ~n1 & n0) | (~n3 & ~n2 & n1 & ~n0) | (~n3 & ~n2 & n1 & n0) | (~n3 & n2 & n1 & n0) | (n3 & n2 & ~n1 & n0)) | losedashthing_i; // F

assign seg_int[0] = ((~n3 & ~n2 & ~n1 & ~n0) | (~n3 & ~n2 & ~n1 & n0) | (~n3 & n2 & n1 & n0) | (n3 & n2 & ~n1 & ~n0)) & (~losedashthing_i); // G
// G needs &~losedashthing_i bc needs to show on (middle bar is G)

// display pin
assign seg_o[0] = seg_int[6]; // CA = A
assign seg_o[1] = seg_int[5]; // CB = B
assign seg_o[2] = seg_int[4]; // CC = C
assign seg_o[3] = seg_int[3]; // CD = D
assign seg_o[4] = seg_int[2]; // CE = E
assign seg_o[5] = seg_int[1]; // CF = F
assign seg_o[6] = seg_int[0]; // CG = G

endmodule
