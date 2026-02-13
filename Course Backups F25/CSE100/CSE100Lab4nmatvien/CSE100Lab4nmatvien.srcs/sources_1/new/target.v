`timescale 1ns/1ps
// target.v

module target(
    input clk,
    input ce,
    input [3:0] d,
    output [3:0] q
);

    // Current stored value (outputs of the flops)
    wire [3:0] target_now;

    wire [3:0] ce_bus;
    assign ce_bus = {ce, ce, ce, ce};
    wire [3:0] next_target;

    assign next_target[0] = (ce_bus[0] & d[0]) | ((~ce_bus[0]) & target_now[0]);
    assign next_target[1] = (ce_bus[1] & d[1]) | ((~ce_bus[1]) & target_now[1]);
    assign next_target[2] = (ce_bus[2] & d[2]) | ((~ce_bus[2]) & target_now[2]);
    assign next_target[3] = (ce_bus[3] & d[3]) | ((~ce_bus[3]) & target_now[3]);

    // FDREs with CE high
    FDRE #(.INIT(1'b0)) q0_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(next_target[0]), .Q(target_now[0]));
    FDRE #(.INIT(1'b0)) q1_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(next_target[1]), .Q(target_now[1]));
    FDRE #(.INIT(1'b0)) q2_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(next_target[2]), .Q(target_now[2]));
    FDRE #(.INIT(1'b0)) q3_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(next_target[3]), .Q(target_now[3]));

    // module outptu
    assign q = target_now;

endmodule
