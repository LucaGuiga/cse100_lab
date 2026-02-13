`timescale 1ns / 1ps
// ring_counter.v
// 4-bit ring counter (onehot)

module ring_counter(
    input clk_i,
    input digsel_i,
    input rst_i,
    output [3:0] an_o,
    output [3:0] sel_o
);

wire q3, q2, q1, q0;
wire d3, d2, d1, d0;
wire [3:0] ring_o;
assign ring_o = {q3, q2, q1, q0};

wire advance_i = (~rst_i) &  digsel_i;
wire hold_i    = (~rst_i) & (~digsel_i);

assign d3 = (advance_i &ring_o[0]) | (hold_i &ring_o[3]);
assign d2 = (advance_i &ring_o[3]) | (hold_i &ring_o[2]);
assign d1 = (advance_i &ring_o[2]) | (hold_i &ring_o[1]);
assign d0 = (advance_i &ring_o[1]) | (hold_i &ring_o[0]) | rst_i;  // force 0bit high on rst

// FDRE Flipflops
FDRE #(.INIT(1'b0)) ff3 (.Q(q3), .C(clk_i), .CE(1'b1), .D(d3), .R(1'b0));
FDRE #(.INIT(1'b0)) ff2 (.Q(q2), .C(clk_i), .CE(1'b1), .D(d2), .R(1'b0));
FDRE #(.INIT(1'b0)) ff1 (.Q(q1), .C(clk_i), .CE(1'b1), .D(d1), .R(1'b0));
FDRE #(.INIT(1'b1)) ff0 (.Q(q0), .C(clk_i), .CE(1'b1), .D(d0), .R(1'b0));

// outputs
assign sel_o = ring_o;
assign an_o  = ~ring_o;

endmodule
