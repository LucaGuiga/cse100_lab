module MsgChk(
input clk,
input s,
input d,
output e,
output p);
wire [1:0] Q;
wire [1:0] D;
MsgChkEq FsmEqs (
.s(s),
.d(d),
.Q(Q),
.e(e),
.p(p),
.D(D));
FDRE #(.INIT(1'b0)) Q0_FF (
.C(clk),
.R(1'b0),
.CE(1'b1),
.D(D[0]),
.Q(Q[0]));
FDRE #(.INIT(1'b0)) Q1_FF (
.C(clk),
.R(1'b0),
.CE(1'b1),
.D(D[1]),
.Q(Q[1]));
endmodule
module MsgChkEq(
input s,
input d,
input [1:0] Q,
output e,
output p,
output [1:0] D);
assign D[1] = s&d&~Q[1]&~Q[0] | ~s&d&Q[0]&~Q[1] | ~s&~d&Q[1] | ~s&~Q[0]&Q[1];
assign D[0] = s&~d&~Q[1]&~Q[0] | ~s&d&Q[1] | ~s&~d&Q[0];
assign e = s&Q[0] | s&Q[1];
assign p = s&d&Q[1]&~Q[0] | s&~d&Q[1]&Q[0];
endmodule