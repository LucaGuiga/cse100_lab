`timescale 1ns / 1ps



module topLevel
(input [7:0]sw,
 input btnU,
 input btnR,
 input clkin,
 
 output [6:0]seg,
 output dp,
 output [3:0]an,
 output [7:0]led
);

wire [7:0] D;
wire ovfl;
wire dig_sel;
wire [6:0] low_hex_seg;
wire [6:0] hi_hex_seg;


assign led[0] = sw[0];
assign led[1] = sw[1];
assign led[2] = sw[2];
assign led[3] = sw[3];
assign led[4] = sw[4];
assign led[5] = sw[5];
assign led[6] = sw[6];
assign led[7] = sw[7];
assign led[8] = 0;




assign an[0] = dig_sel;
assign an[1] = ~dig_sel;
assign an[2] = 1;
assign an[3] = 1;;


SignChanger sc 
(
.A(sw),
.sign(~btnU),
.D(D),
.ovfl(ovfl)
);


hex7seg low_seg
(
.N(D[3:0]),
.seg(low_hex_seg)
);

hex7seg hi_seg
(.N(D[7:4]),
.seg(hi_hex_seg)
);

mux8bit mux_seg
(
.A({low_hex_seg}), .B({hi_hex_seg}), .Sel(dig_sel), .C(seg)
);

lab2_digsel dig_inst 
(
.clkin(clkin),
.greset(btnR),
.digsel(dig_sel)
);
assign dp = ~(ovfl & btnU);
endmodule
