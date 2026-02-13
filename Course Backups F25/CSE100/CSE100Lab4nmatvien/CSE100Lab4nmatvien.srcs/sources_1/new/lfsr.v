`timescale 1ns/1ps
// lfsr.v
// 8 bit lfsr

module lfsr(
    input clk_i,
    output [7:0] q_o
);

    // Current state from flops
    wire [7:0] q;
    
    wire feedback_a;
    wire feedback_b;
    wire feedback;

    assign feedback_a = q[7] ^ q[5];
    assign feedback_b = q[4] ^ q[3];
    assign feedback = feedback_a ^ feedback_b;

    // next state wires
    wire next7 = q[6];
    wire next6 = q[5];
    wire next5 = q[4];
    wire next4 = q[3];
    wire next3 = q[2];
    wire next2 = q[1];
    wire next1 = q[0];
    wire next0 = feedback;

    wire [7:0] d;

    // gates
    assign d[7] = (1'b1 & next7) | (1'b0 & q[7]);
    assign d[6] = (1'b1 & next6) | (1'b0 & q[6]);
    assign d[5] = (1'b1 & next5) | (1'b0 & q[5]);
    assign d[4] = (1'b1 & next4) | (1'b0 & q[4]);
    assign d[3] = (1'b1 & next3) | (1'b0 & q[3]);
    assign d[2] = (1'b1 & next2) | (1'b0 & q[2]);
    assign d[1] = (1'b1 & next1) | (1'b0 & q[1]);
    assign d[0] = (1'b1 & next0) | (1'b0 & q[0]);

    // 8 FDRES ; r
    FDRE #(.INIT(1'b0)) q0_ff (.C(clk_i), .CE(1'b1), .R(1'b0), .D(d[0]), .Q(q[0]));
    FDRE #(.INIT(1'b0)) q1_ff (.C(clk_i), .CE(1'b1), .R(1'b0), .D(d[1]), .Q(q[1]));
    FDRE #(.INIT(1'b0)) q2_ff (.C(clk_i), .CE(1'b1), .R(1'b0), .D(d[2]), .Q(q[2]));
    FDRE #(.INIT(1'b0)) q3_ff (.C(clk_i), .CE(1'b1), .R(1'b0), .D(d[3]), .Q(q[3]));
    FDRE #(.INIT(1'b0)) q4_ff (.C(clk_i), .CE(1'b1), .R(1'b0), .D(d[4]), .Q(q[4]));
    FDRE #(.INIT(1'b0)) q5_ff (.C(clk_i), .CE(1'b1), .R(1'b0), .D(d[5]), .Q(q[5]));
    FDRE #(.INIT(1'b0)) q6_ff (.C(clk_i), .CE(1'b1), .R(1'b0), .D(d[6]), .Q(q[6]));
    FDRE #(.INIT(1'b1)) q7_ff (.C(clk_i), .CE(1'b1), .R(1'b0), .D(d[7]), .Q(q[7]));

    // outputs
    wire [7:0] q_out_bus;
    assign q_out_bus[7] = q[7];
    assign q_out_bus[6] = q[6];
    assign q_out_bus[5] = q[5];
    assign q_out_bus[4] = q[4];
    assign q_out_bus[3] = q[3];
    assign q_out_bus[2] = q[2];
    assign q_out_bus[1] = q[1];
    assign q_out_bus[0] = q[0];

    assign q_o = q_out_bus;

endmodule
