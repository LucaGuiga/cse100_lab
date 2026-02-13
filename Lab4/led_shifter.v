module led_shifter(
    input clk,
    input inp,  // Value to shift in, left, or right. ("in" is a keyword)
    input shl, // Shift left, one bit per clock cycle
    input shr, // Shift right, one bit per clock cycle.
    input reset,
    output [15:0] Leds
);
    
    
    // this one is weird
    // input is always gonig to be a one or a zero
    // shift l 'shl' is just saying basically if 'inp' is a 1 shift left one clock cycle or 'once'
    // shift r 'shr' is saying if 'inp' is a 0 shift right one clock cycle or 'once'
    // 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    // 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1   <- so input was 1, shl was activated
    // 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1   <- input was 1 again, shl was activated
    // 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1   <- input was 0, original variable passed to output
    // 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1   <- input was 1 again, shr was activated
    
    
    // these are the possible outputs
    
    wire [15:0] next_leds;
    
    assign next_leds = shl ? {Leds[14:0], inp} : shr ? {inp, Leds[15:1]} : Leds;
    
    
    FDRE #(.INIT(1'b0)) ff1 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[0]), .Q(Leds[0]));
    FDRE #(.INIT(1'b0)) ff2 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[1]), .Q(Leds[1]));
    FDRE #(.INIT(1'b0)) ff3 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[2]), .Q(Leds[2]));
    FDRE #(.INIT(1'b0)) ff4 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[3]), .Q(Leds[3]));
    FDRE #(.INIT(1'b0)) ff5 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[4]), .Q(Leds[4]));
    FDRE #(.INIT(1'b0)) ff6 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[5]), .Q(Leds[5]));
    FDRE #(.INIT(1'b0)) ff7 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[6]), .Q(Leds[6]));
    FDRE #(.INIT(1'b0)) ff8 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[7]), .Q(Leds[7]));
    FDRE #(.INIT(1'b0)) ff9 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[8]), .Q(Leds[8]));
   FDRE #(.INIT(1'b0)) ff10 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[9]), .Q(Leds[9]));
  FDRE #(.INIT(1'b0)) ff11 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[10]), .Q(Leds[10]));
  FDRE #(.INIT(1'b0)) ff12 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[11]), .Q(Leds[11]));
  FDRE #(.INIT(1'b0)) ff13 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[12]), .Q(Leds[12]));
  FDRE #(.INIT(1'b0)) ff14 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[13]), .Q(Leds[13]));
  FDRE #(.INIT(1'b0)) ff15 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[14]), .Q(Leds[14]));
  FDRE #(.INIT(1'b0)) ff16 (.C(clk), .CE(shl^shr), .R(reset), .D(next_leds[15]), .Q(Leds[15]));
   
   
    
endmodule
