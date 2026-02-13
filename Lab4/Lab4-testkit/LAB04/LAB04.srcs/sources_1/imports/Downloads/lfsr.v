module lfsr(
    input clk,
    input reset,
    output [7:0] Lfsr
);
    // Your code here.
    wire xor1;
    
    assign xor1 = Lfsr[5] ^ Lfsr[6] ^ Lfsr[7] ^ Lfsr[0];
    
    FDRE #(.INIT(1'b1)) RND0 (.C(clk), .R(reset), .CE(1'b1), .D(xor1), .Q(Lfsr[0]));
    FDRE #(.INIT(1'b0)) RND1 (.C(clk), .R(reset), .CE(1'b1), .D(Lfsr[0]), .Q(Lfsr[1]));
    FDRE #(.INIT(1'b0)) RND2 (.C(clk), .R(reset), .CE(1'b1), .D(Lfsr[1]), .Q(Lfsr[2]));
    FDRE #(.INIT(1'b0)) RND3 (.C(clk), .R(reset), .CE(1'b1), .D(Lfsr[2]), .Q(Lfsr[3]));
    FDRE #(.INIT(1'b0)) RND4 (.C(clk), .R(reset), .CE(1'b1), .D(Lfsr[3]), .Q(Lfsr[4]));
    FDRE #(.INIT(1'b0)) RND5 (.C(clk), .R(reset), .CE(1'b1), .D(Lfsr[4]), .Q(Lfsr[5]));
    FDRE #(.INIT(1'b0)) RND6 (.C(clk), .R(reset), .CE(1'b1), .D(Lfsr[5]), .Q(Lfsr[6]));
    FDRE #(.INIT(1'b0)) RND7 (.C(clk), .R(reset), .CE(1'b1), .D(Lfsr[6]), .Q(Lfsr[7]));
endmodule
