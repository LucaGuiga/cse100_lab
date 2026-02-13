module ringCounter
  (
    input clk,
    input advance,
    input reset,
    output [3:0] Ring
   );
   


FDRE #(.INIT(1'b1)) FF0 (.Q(Ring[0]), .C(clk), .CE(advance), .R(reset), .D(Ring[3]));
FDRE #(.INIT(1'b0)) FF1 (.Q(Ring[1]), .C(clk), .CE(advance), .R(reset), .D(Ring[0]));
FDRE #(.INIT(1'b0)) FF2 (.Q(Ring[2]), .C(clk), .CE(advance), .R(reset), .D(Ring[1]));
FDRE #(.INIT(1'b0)) FF3 (.Q(Ring[3]), .C(clk), .CE(advance), .R(reset), .D(Ring[2]));

// one ring is passing a 1 at each positive edge of the clock 
//kinda like digsel 
// 1 0 0 0 (ring 0) 
// 0 1 0 0 (ring 1) 
// 0 0 1 0 ( ring 2) 
// 0 0 0 1 (ring 3) 
endmodule
