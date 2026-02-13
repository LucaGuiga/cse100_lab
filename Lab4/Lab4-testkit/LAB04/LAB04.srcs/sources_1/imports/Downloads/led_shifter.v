module led_shifter(
    input clk,
    input inp,  // Value to shift in, left, or right. ("in" is a keyword)
    input shl, // Shift left, one bit per clock cycle
    input shr, // Shift right, one bit per clock cycle.
    input reset,
    output [15:0] Leds
);
    // Your code here
    wire [15:0] shl_value; 
    wire [15:0] shr_value; 
    wire [15:0] nextLED; 
    
    
    //shifter 
    assign shl_value = {Leds[14:0], inp}; 
    assign shr_value = {inp, Leds[15:1]};
    assign nextLED =  (shr & ~shl) ? shr_value : (shl & ~shr) ? shl_value : Leds;
    
    FDRE # (.INIT(1'b0)) L0 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[0]), .Q(Leds[0]));
    FDRE # (.INIT(1'b0)) L1 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[1]), .Q(Leds[1]));
    FDRE # (.INIT(1'b0)) L2 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[2]), .Q(Leds[2]));
    FDRE # (.INIT(1'b0)) L3 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[3]), .Q(Leds[3]));
    FDRE # (.INIT(1'b0)) L4 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[4]), .Q(Leds[4]));
    FDRE # (.INIT(1'b0)) L5 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[5]), .Q(Leds[5]));
    FDRE # (.INIT(1'b0)) L6 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[6]), .Q(Leds[6]));
    FDRE # (.INIT(1'b0)) L7 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[7]), .Q(Leds[7]));
    FDRE # (.INIT(1'b0)) L8 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[8]), .Q(Leds[8]));
    FDRE # (.INIT(1'b0)) L9 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[9]), .Q(Leds[9]));
    FDRE # (.INIT(1'b0)) L10 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[10]), .Q(Leds[10]));
    FDRE # (.INIT(1'b0)) L11 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[11]), .Q(Leds[11]));
    FDRE # (.INIT(1'b0)) L12 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[12]), .Q(Leds[12]));
    FDRE # (.INIT(1'b0)) L13 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[13]), .Q(Leds[13]));
    FDRE # (.INIT(1'b0)) L14 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[14]), .Q(Leds[14]));
    FDRE # (.INIT(1'b0)) L15 (.C(clk), .R(reset), .CE(1'b1), .D(nextLED[15]), .Q(Leds[15]));
    
endmodule
