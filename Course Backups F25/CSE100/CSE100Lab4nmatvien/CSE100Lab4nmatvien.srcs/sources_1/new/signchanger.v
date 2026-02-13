`timescale 1ns / 1ps
// signchanger.v

module signchanger(
  input [7:0] A_i,
  input sign_i,
  output [7:0] D_o,
  output ovfl_o
);

  wire [7:0] A_to_add, B_to_add;
  wire [7:0] sum_w;
  wire [3:0] sc = A_i[3:0]; // holding score

  wire [3:0] inv;
  assign inv[0] = sc[0] ^ sign_i;
  assign inv[1] = sc[1] ^ sign_i;
  assign inv[2] = sc[2] ^ sign_i;
  assign inv[3] = sc[3] ^ sign_i;

  wire [3:0] mag;
  wire carry1, carry2, carry3;

  assign mag[0] = inv[0] ^ sign_i;
  assign carry1 = inv[0] & sign_i;

  assign mag[1] = inv[1] ^ carry1;
  assign carry2 = inv[1] & carry1;

  assign mag[2] = inv[2] ^ carry2;
  assign carry3 = inv[2] & carry2;

  assign mag[3] = inv[3] ^ carry3;

  wire [3:0] tens;
  assign tens[0] = sign_i;
  assign tens[1] = sign_i;
  assign tens[2] = sign_i;
  assign tens[3] = sign_i;

  assign A_to_add = {4'b0000, mag};
  assign B_to_add = {tens};
  assign sum_w = {tens, mag};

  // final outputss
  assign D_o = sum_w;
  assign ovfl_o = 1'b0;

endmodule
