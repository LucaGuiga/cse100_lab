module ringCounter
  (
    input        clk,
    input        advance,
    input        reset,
    output [3:0] Ring
   );
   
   
   // FDRE's 
   
   FDRE #(.INIT(1'b1) ) ffOne (.C(clk),.R(reset),.CE(advance),.D(Ring[3]),.Q(Ring[0]));
   FDRE #(.INIT(1'b0) ) ffTwo (.C(clk),.R(reset),.CE(advance),.D(Ring[0]),.Q(Ring[1]));
   FDRE #(.INIT(1'b0) ) ffThree (.C(clk),.R(reset),.CE(advance),.D(Ring[1]),.Q(Ring[2]));
   FDRE #(.INIT(1'b0) ) ffFour (.C(clk),.R(reset),.CE(advance),.D(Ring[2]),.Q(Ring[3]));


endmodule
