`timescale 1ns/1ps
// score_counter.v
// 4-bit 2's compl counter

module score_counter(
    input clk,
    input inc,
    input dec,
    output [3:0] q,
    output sign,
    output won,
    output lost
);
  // state
  wire [3:0] score_now;

  // terminals
  wire is_plus4 = (~score_now[3]) & score_now[2] & (~score_now[1]) & (~score_now[0]);
  wire is_minus4 = score_now[3] & score_now[2] & (~score_now[1]) & (~score_now[0]);
  assign won = is_plus4;
  assign lost = is_minus4;

  // score_now + 1
  wire [3:0] score_next; wire carry1, carry2, carry3;
  assign score_next[0] = ~score_now[0];
  assign carry1 = score_now[0];
  assign score_next[1] = score_now[1]^carry1;
  assign carry2 = score_now[1] & carry1;
  assign score_next[2] = score_now[2] ^ carry2;
  assign carry3 = score_now[2] & carry2;
  assign score_next[3] = score_now[3] ^ carry3;

  // score_now - 1
  wire [3:0] score_down; wire borrow1, borrow2, borrow3;
  assign score_down[0] = ~score_now[0];
  assign borrow1 = ~score_now[0];
  assign score_down[1] = score_now[1] ^ borrow1;
  assign borrow2 = (~score_now[1]) & borrow1;
  assign score_down[2] = score_now[2] ^ borrow2;
  assign borrow3 = (~score_now[2]) & borrow2;
  assign score_down[3] = score_now[3] ^ borrow3;

  // choose next
  wire inc_req = inc & (~dec);
  wire dec_req = dec & (~inc);
  wire take_inc = inc_req & (~is_plus4);
  wire take_dec = dec_req & (~is_minus4);

  wire [3:0] d = ({4{take_inc}} & score_next) | ({4{take_dec}} & score_down) | ({4{(~take_inc) & (~take_dec)}} & score_now);

  // flops
  FDRE #(.INIT(1'b0)) ff0 (.C(clk), .CE(1'b1), .R(1'b0), .D(d[0]), .Q(score_now[0]));
  FDRE #(.INIT(1'b0)) ff1 (.C(clk), .CE(1'b1), .R(1'b0), .D(d[1]), .Q(score_now[1]));
  FDRE #(.INIT(1'b0)) ff2 (.C(clk), .CE(1'b1), .R(1'b0), .D(d[2]), .Q(score_now[2]));
  FDRE #(.INIT(1'b0)) ff3 (.C(clk), .CE(1'b1), .R(1'b0), .D(d[3]), .Q(score_now[3]));

  // ouputs
  assign q = score_now;
  assign sign = score_now[3];

endmodule
