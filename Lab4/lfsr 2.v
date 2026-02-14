module lfsr(
    input clk,
    input reset,
    output [7:0] Lfsr
   
);
    wire [3:0] xorInter;
    assign xorInter = (Lfsr[0] ^ Lfsr[5] ^ Lfsr[6] ^ Lfsr[7]);
    
    FDRE #(.INIT(1'b1)) ff1 (.C(clk), .CE(1'b1), .R(reset), .D(xorInter), .Q(Lfsr[0]));
    FDRE #(.INIT(1'b0)) ff2 (.C(clk), .CE(1'b1), .R(reset), .D(Lfsr[0]), .Q(Lfsr[1]));
    FDRE #(.INIT(1'b0)) ff3 (.C(clk), .CE(1'b1), .R(reset), .D(Lfsr[1]), .Q(Lfsr[2]));
    FDRE #(.INIT(1'b0)) ff4 (.C(clk), .CE(1'b1), .R(reset), .D(Lfsr[2]), .Q(Lfsr[3]));
    FDRE #(.INIT(1'b0)) ff5 (.C(clk), .CE(1'b1), .R(reset), .D(Lfsr[3]), .Q(Lfsr[4]));
    FDRE #(.INIT(1'b0)) ff6 (.C(clk), .CE(1'b1), .R(reset), .D(Lfsr[4]), .Q(Lfsr[5]));
    FDRE #(.INIT(1'b0)) ff7 (.C(clk), .CE(1'b1), .R(reset), .D(Lfsr[5]), .Q(Lfsr[6]));
    FDRE #(.INIT(1'b0)) ff8 (.C(clk), .CE(1'b1), .R(reset), .D(Lfsr[6]), .Q(Lfsr[7]));
    
    // this is a bus of 8 bit that give a random value. 
    
    
    
endmodule
