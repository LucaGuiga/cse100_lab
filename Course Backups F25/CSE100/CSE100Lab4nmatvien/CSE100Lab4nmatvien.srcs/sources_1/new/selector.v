`timescale 1ns / 1ps
// selector.v
// 4-bit wide 4-1 mux

module selector(
    input [15:0] N_i,
    input [3:0] sel_onehot,
    output [3:0] N_out
);

wire [3:0] N0, N1, N2, N3;
assign N0 = N_i[3:0];
assign N1 = N_i[7:4];
assign N2 = N_i[11:8];
assign N3 = N_i[15:12];

// onehot mux
assign N_out = ({4{sel_onehot[0]}} & N0) | ({4{sel_onehot[1]}} & N1) | ({4{sel_onehot[2]}} & N2) | ({4{sel_onehot[3]}} & N3);

endmodule
