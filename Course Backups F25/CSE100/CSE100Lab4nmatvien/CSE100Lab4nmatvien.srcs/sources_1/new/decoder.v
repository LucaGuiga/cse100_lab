`timescale 1ns/1ps
//decoder.v
// 4-to-16 one-hot decoder

module decoder(
    input [3:0] n,
    output [15:0] q
);

// one hot minterms
    assign q[0] = (~n[3] & ~n[2] & ~n[1] & ~n[0]); // 0000

    assign q[1] = (~n[3] & ~n[2] & ~n[1] & n[0]); // 0001

    assign q[2] = (~n[3] & ~n[2] & n[1] & ~n[0]);// 0010

    assign q[3] = (~n[3] & ~n[2] & n[1] & n[0]);// 0011

    assign q[4] = (~n[3] & n[2] & ~n[1] & ~n[0]);// 0100

    assign q[5] = (~n[3] & n[2] & ~n[1] & n[0]);// 0101

    assign q[6] = (~n[3] & n[2] & n[1] & ~n[0]);// 0110

    assign q[7] = (~n[3] & n[2] & n[1] & n[0]);// 0111

    assign q[8] = (n[3] & ~n[2] & ~n[1] & ~n[0]);// 1000
    
    assign q[9] = (n[3] & ~n[2] & ~n[1] & n[0]);// 1001

    assign q[10] = (n[3] & ~n[2] & n[1] & ~n[0]);// 1010

    assign q[11] = (n[3] & ~n[2] & n[1] & n[0]);// 1011

    assign q[12] = (n[3] & n[2] & ~n[1] & ~n[0]);// 1100

    assign q[13] = (n[3] & n[2] & ~n[1] & n[0]);// 1101

    assign q[14] = (n[3] & n[2] & n[1] & ~n[0]);// 1110

    assign q[15] = (n[3] & n[2] & n[1] & n[0]);// 1111

endmodule
