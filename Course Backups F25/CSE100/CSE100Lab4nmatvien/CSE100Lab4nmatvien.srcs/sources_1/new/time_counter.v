`timescale 1ns/1ps
// time_counter.v

module time_counter(
    input clk,
    input en_qsec,
    input rtime,
    output twosecs,
    output foursecs,
    output [4:0] q
);
    // current count
    wire [4:0] count_now;

    // ripple +1
    wire [4:0] count_plus1;
    wire carry0to1, carry1to2, carry2to3, carry3to4;

    assign count_plus1[0] = count_now[0] ^ en_qsec;
    assign carry0to1 = count_now[0] & en_qsec;

    assign count_plus1[1] = count_now[1] ^ carry0to1;
    assign carry1to2 = count_now[1] & carry0to1;

    assign count_plus1[2] = count_now[2] ^ carry1to2;
    assign carry2to3 = count_now[2] & carry1to2;

    assign count_plus1[3] = count_now[3] ^ carry2to3;
    assign carry3to4 = count_now[3] & carry2to3;

    assign count_plus1[4] = count_now[4] ^ carry3to4;

    // next state
    wire keep_count = (~rtime) & (~en_qsec);
    wire step_count = (~rtime) & ( en_qsec);
    wire clear_count = rtime;

    wire [4:0] next_count;
    assign next_count = ({5{clear_count}} & 5'b00000) | ({5{keep_count }} & count_now) | ({5{step_count }} & count_plus1);

    // FDREs
    FDRE #(.INIT(1'b0)) c0_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(next_count[0]), .Q(count_now[0]));
    FDRE #(.INIT(1'b0)) c1_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(next_count[1]), .Q(count_now[1]));
    FDRE #(.INIT(1'b0)) c2_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(next_count[2]), .Q(count_now[2]));
    FDRE #(.INIT(1'b0)) c3_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(next_count[3]), .Q(count_now[3]));
    FDRE #(.INIT(1'b0)) c4_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(next_count[4]), .Q(count_now[4]));

    // equal detect for the times
    wire is_8 = (~count_now[4]) & ( count_now[3]) & (~count_now[2]) & (~count_now[1]) & (~count_now[0]);
    wire is_16 = ( count_now[4]) & (~count_now[3]) & (~count_now[2]) & (~count_now[1]) & (~count_now[0]);

    assign twosecs = is_8;
    assign foursecs = is_16;

    assign q = count_now;
endmodule
