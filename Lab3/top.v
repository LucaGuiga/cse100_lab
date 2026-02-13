module top(
input clkin,
input btnU,
input btnD,
input btnR,
input btnC,
input btnL,
input [15:0] sw,
output [15:0] led,
output [3:0] an,
output [6:0] seg,
output dp
);


// wire clk; // system clock assignment
wire digsel; // I was told to use this as output from the new digsel file

wire [15:0] Q16;
wire utc16;
wire dtc16;

wire blockC;
assign blockC = &Q16[15:2];

wire up_eff;
wire dw_eff;



labCnt_clks slowit (
    .clkin(clkin),
    .greset(btnR),   // this is supposed to be the only use of button R
    .clk(clk),
    .digsel(digsel)
  );


wire edgeU;
wire edgeD;

edgeDetector edU (
    .clk(clk),
    .reset(1'b0),     // reset is 0 not btnR, we were told not to use reset for registers.
    .btnU(btnU),    // btnU assignment
    .edge_o(edgeU)
  );

edgeDetector edD (
    .clk(clk),
    .reset(1'b0),     // again using 1 bit 0
    .btnU(btnD),    // btnD assignment
    .edge_o(edgeD)
  );

assign up_eff = edgeU | (btnC & ~blockC);
assign dw_eff = edgeD;

countUD16L cnt16 (
    .clk(clk),
    .reset(1'b0),
    .up(up_eff),
    .dw(dw_eff),
    .ld(btnL),
    .Din(sw),
    .Q(Q16),
    .utc(utc16),
    .dtc(dtc16)
  );


wire [3:0] Ring;

ringCounter rc (
    .clk(clk),
    .advance(digsel),
    .reset(1'b0),
    .Ring(Ring)
  );



wire [3:0] H;

  selector sel (
    .Sel(Ring),
    .N(Q16),
    .H(H)
  );

  hex7seg h7 (
    .N(H),        
    .seg(seg)     
  );



  assign an = ~Ring;

  // dp off (active-low on Basys3)
  assign dp = 1'b1;

  assign led[15]   = utc16;
  assign led[0]    = dtc16;
  assign led[14:1] = 14'b0;



endmodule