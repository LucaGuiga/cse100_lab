module mux8bit
  (input [7:0] A
  ,input [7:0] B
  ,input Sel
  ,output [7:0] C);

assign C = (~{8{Sel}}&A)|({8{Sel}}&B);

endmodule


module adder8
   (input [7:0] A
   ,input [7:0] B
   ,input cin
   ,output [7:0] S
   ,output cout
   ,output ovfl
   );
        
wire [6:0]inter;

FA zeroeth (.a(A[0]),.b(B[0]),.cin(cin),.C(S[0]),.Cout(inter[0]),.ovfl());
FA firsteth (.a(A[1]),.b(B[1]),.cin(inter[0]),.C(S[1]),.Cout(inter[1]),.ovfl());
FA secondth (.a(A[2]),.b(B[2]),.cin(inter[1]),.C(S[2]),.Cout(inter[2]),.ovfl());
FA thirdth (.a(A[3]),.b(B[3]),.cin(inter[2]),.C(S[3]),.Cout(inter[3]),.ovfl());
FA fourth (.a(A[4]),.b(B[4]),.cin(inter[3]),.C(S[4]),.Cout(inter[4]),.ovfl());
FA fifth (.a(A[5]),.b(B[5]),.cin(inter[4]),.C(S[5]),.Cout(inter[5]),.ovfl());
FA sixth (.a(A[6]),.b(B[6]),.cin(inter[5]),.C(S[6]),.Cout(inter[6]),.ovfl());

FA seventh (.a(A[7]),.b(B[7]),.cin(inter[6]),.C(S[7]),.Cout(cout),.ovfl());


//assign ovfl = (~A[7]&~B[7]&S[7]) | (A[7]&B[7]&~S[7]);
assign ovfl = inter[6];

endmodule



module FA
(
input a,
input b,
input cin,
output C,
output Cout,
output ovfl
);

assign C = (~a&~b&cin) | (~a&b&~cin) | (a&~b&~cin) | (a&b&cin);
assign Cout = (~a&b&cin) | (a&~b&cin) | (a&b&~cin) | (a&b&cin);

endmodule



module AddSub8
(input [7:0] A,
 input [7:0] B,
 input sub,
 output [7:0] S,
 output ovfl
);


wire [7:0] inter;

mux8bit OutSub (.A(B), .B(~B), .Sel(sub), .C(inter));
adder8 outadder (.A(A), .B(inter), .cin(sub), .S(S), .cout(), .ovfl(ovfl));

endmodule




module countUD8L 
  (input        clk,
    input        reset,
    input        up,
    input        dw,
    input        ld,
    input [7:0]  Din,
    output [7:0] Q,
    output utc,
    output dtc);

// -----------------------------------------------------------------------------
// intent / spec shape (what the autograder expects from the error logs):
// - reset -> Q = 0
// - ld has highest priority -> Q loads Din
// - else if exactly one of up/dw is 1 -> Q increments or decrements by 1
// - else hold
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// need an edge detector for up/down
// (in this cleaned version, we use do_ud + sub for count control)
// -----------------------------------------------------------------------------

// Q storage bus (registered state)
wire [7:0] Qr;
assign Q = Qr;

// exactly-one-pressed detector
wire do_ud;
assign do_ud = up ^ dw;          // 1 if exactly one pressed

// subtract control (down wins only when up=0, dw=1)
wire sub;
assign sub = dw & ~up;           // 1 only when down

// -----------------------------------------------------------------------------
// Module to +/- 1
// make sure the subtractor is only subtracting 1!
// -----------------------------------------------------------------------------
wire [7:0] qUDmux;
AddSub8 addsub8
  (.A(Qr)
  ,.B(8'b00000001)
  ,.sub(sub)
  ,.S(qUDmux)
  ,.ovfl()
  );

// -----------------------------------------------------------------------------
// nextQ logic WITHOUT ?: and WITHOUT reductions
// nextQ =
//   if ld        -> Din
//   else if do_ud-> qUDmux
//   else         -> Qr (hold)
// -----------------------------------------------------------------------------
wire sel_load;
assign sel_load = ld;

wire sel_count;
assign sel_count = (~ld) & do_ud;

wire sel_hold;
assign sel_hold = (~ld) & (~do_ud);

wire [7:0] nextQ;
assign nextQ =
  ({8{sel_load}}  & Din)   |
  ({8{sel_count}} & qUDmux)|
  ({8{sel_hold}}  & Qr);

// -----------------------------------------------------------------------------
// FDREs for Q (each register written explicitly)
// -----------------------------------------------------------------------------
FDRE #(.INIT(1'b0)) qff0 (.C(clk),.R(reset),.CE(1'b1),.D(nextQ[0]),.Q(Qr[0]));
FDRE #(.INIT(1'b0)) qff1 (.C(clk),.R(reset),.CE(1'b1),.D(nextQ[1]),.Q(Qr[1]));
FDRE #(.INIT(1'b0)) qff2 (.C(clk),.R(reset),.CE(1'b1),.D(nextQ[2]),.Q(Qr[2]));
FDRE #(.INIT(1'b0)) qff3 (.C(clk),.R(reset),.CE(1'b1),.D(nextQ[3]),.Q(Qr[3]));
FDRE #(.INIT(1'b0)) qff4 (.C(clk),.R(reset),.CE(1'b1),.D(nextQ[4]),.Q(Qr[4]));
FDRE #(.INIT(1'b0)) qff5 (.C(clk),.R(reset),.CE(1'b1),.D(nextQ[5]),.Q(Qr[5]));
FDRE #(.INIT(1'b0)) qff6 (.C(clk),.R(reset),.CE(1'b1),.D(nextQ[6]),.Q(Qr[6]));
FDRE #(.INIT(1'b0)) qff7 (.C(clk),.R(reset),.CE(1'b1),.D(nextQ[7]),.Q(Qr[7]));

// -----------------------------------------------------------------------------
// utc / dtc WITHOUT reductions (no &Q or |Q)
// -----------------------------------------------------------------------------
assign utc = Q[0]&Q[1]&Q[2]&Q[3]&Q[4]&Q[5]&Q[6]&Q[7];
assign dtc = ~(Q[0]|Q[1]|Q[2]|Q[3]|Q[4]|Q[5]|Q[6]|Q[7]);

endmodule



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


module time_counter(
    input clk,
    input inc,
    input reset,
    output [5:0] Count
);

wire [15:0] Qtemp;

countUD16L cnt16 (
    .clk(clk),
    .reset(reset),
    .up(inc),
    .dw(1'b0),
    .ld(1'b0),
    .Din(count),
    .Q(Qtemp),
    .utc(),
    .dtc()
  );

assign Count = Qtemp [5:0]; 


endmodule
