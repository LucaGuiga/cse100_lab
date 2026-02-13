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




module SignChanger
(input [7:0] A,
 input sign,
 output [7:0] D,
 output ovfl
);

wire [7:0] Ainter;
wire [7:0] Binter;

wire [7:0] Ainv;
wire temp;

assign Ainv = {~A[7], ~A[6], ~A[5], ~A[4], ~A[3], ~A[2], ~A[1], ~A[0]};

//A input - > iunverter ~A

// A input -> adder +1

//mux regular input OR inverted A +1

adder8 signchanger (.A(Ainv), .B(1), .cin(0), .S(Ainter), .cout(), .ovfl(ovfl));
mux8bit outsignA (.A(Ainter), .B(A), .Sel(sign), .C(D));

endmodule



