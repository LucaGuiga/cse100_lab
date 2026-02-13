module countUD16L(
input clk,
input reset,
input up,
input dw,
input ld,
input [15:0] Din,
output [15:0] Q,
output utc,
output dtc
);


//-----------------------------------
// 16-bit Counter (countUD16L)
// Built from two 8-bit counters
// Proper carry between lower → upper
// utc when 0xFFFF
// dtc when 0x0000
//-----------------------------------

wire utc_lo, dtc_lo;
wire utc_hi, dtc_hi;
wire up_hi, dw_hi;



// calling the countUD8L module

countUD8L counter1 (
.clk(clk), 
.reset(reset), 
.up(up), 
.dw(dw), 
.ld(ld), 
.Din(Din[7:0]), 
.Q(Q[7:0]), 
.utc(utc_lo), 
.dtc(dtc_lo)
);


assign up_hi = up & utc_lo;
assign dw_hi = dw & dtc_lo;


countUD8L counter2 (
.clk(clk), 
.reset(reset), 
.up(up_hi), 
.dw(dw_hi), 
.ld(ld), 
.Din(Din[15:8]), 
.Q(Q[15:8]), 
.utc(utc_hi), 
.dtc(dtc_hi)
);


assign utc = utc_lo & utc_hi;
assign dtc = dtc_lo & dtc_hi;


endmodule