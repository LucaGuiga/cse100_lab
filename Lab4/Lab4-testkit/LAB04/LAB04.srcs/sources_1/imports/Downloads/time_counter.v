module time_counter(
    input clk,
    input inc,
    input reset,
    output [5:0] Count
);
    // Your code here
    wire [15:0] Q; 
    wire utc16, dtc16;
    
    
   countUD16L TimeCounter (.clk(clk), .reset(reset), .up(inc), .dw(1'b0), .ld(1'b0), .Din(16'b0), .Q(Q), .utc(utc16), .dtc(utc16));
                                                    //unused   //unused              //unused                                         
    assign Count = Q[5:0];
endmodule

module countUD16L
(
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
    
wire [7:0] Q0, Q1;
wire utc_0, utc_1, dtc_0, dtc_1, up_0, down_0, up_1, down_1;

assign up_0 = up, 
       dw_0 = dw,
       up_1 = up & utc_0, 
       dw_1 = dw & dtc_0;




countUD8L LOW
( 
.clk(clk), .reset(reset), .up(up_0), .dw(dw_0), .ld(ld), .Q(Q[7:0]), .Din(Din[7:0]), .utc(utc_0), .dtc(dtc_0)
);    

countUD8L HIGH 
(
.clk(clk), .reset(reset), .up(up_1), .dw(dw_1), .ld(ld), .Q(Q[15:8]), .Din(Din[15:8]), .utc(utc_1), .dtc(dtc_1)
);
// first 8 bits are handeled until 00FF (low)
//next 8 same thing excpet it handled  at FFFF (high) 
assign Q = {Q1, Q0};
assign utc = utc_0 & utc_1;
assign dtc = dtc_0 & dtc_1;

endmodule
module countUD8L
  (
    input clk,
    input reset,
    input up,
    input dw,
    input ld,
    input [7:0] Din,
    output [7:0] Q,
    output utc,
    output dtc
   );

   // Your code here
   wire [7:0] INC_val;
   wire [7:0] DEC_val;
   
   wire [7:0] Q_next;
   wire d_ld, d_up, d_dw, d_hold;
   
   assign d_ld = ld;
   assign d_up = up & ~dw & ~ld;
   assign d_dw = ~up & dw &~ld;
   assign d_hold = ~ld & ~(up ^ dw); 
   
   assign Q_next = ({8{d_ld}} & Din) | ({8{d_up}} & INC_val) | ({8{d_dw}} & DEC_val) | ({8{d_hold}} & Q); 
   
   assign utc = &Q; //all 1's 
   assign dtc = ~|Q; // all 0's 
   
   
   adder8 INC
   ( 
   .A(Q), .B (8'b00000001), .cin(1'b0), .S(INC_val), .cout(), .ovfl()
   );
   
   adder8 DEC
   (
   .A(Q), .B (8'hFF), .cin(1'b0), .S(DEC_val), .cout(), .ovfl()
   );
   
   FDRE #(.INIT(1'b0)) Q0 (.C(clk), .R(reset), .CE(1'b1), .D(Q_next[0]), .Q(Q[0]));
   FDRE #(.INIT(1'b0)) Q1 (.C(clk), .R(reset), .CE(1'b1), .D(Q_next[1]), .Q(Q[1]));
   FDRE #(.INIT(1'b0)) Q2 (.C(clk), .R(reset), .CE(1'b1), .D(Q_next[2]), .Q(Q[2]));
   FDRE #(.INIT(1'b0)) Q3 (.C(clk), .R(reset), .CE(1'b1), .D(Q_next[3]), .Q(Q[3]));
   FDRE #(.INIT(1'b0)) Q4 (.C(clk), .R(reset), .CE(1'b1), .D(Q_next[4]), .Q(Q[4]));
   FDRE #(.INIT(1'b0)) Q5 (.C(clk), .R(reset), .CE(1'b1), .D(Q_next[5]), .Q(Q[5]));
   FDRE #(.INIT(1'b0)) Q6 (.C(clk), .R(reset), .CE(1'b1), .D(Q_next[6]), .Q(Q[6]));
   FDRE #(.INIT(1'b0)) Q7 (.C(clk), .R(reset), .CE(1'b1), .D(Q_next[7]), .Q(Q[7]));
  
endmodule

//adder8.v from LAB02

module full_add(
    input a, 
    input b,
    input cin,
    output s, 
    output counter,
    output ovfl

);
assign s = a ^ b ^ cin; 
assign counter = (a&b) | (a&cin) | (b&cin); 

endmodule



module adder8(
   input [7:0] A
   ,input [7:0] B
   ,input cin
   ,output [7:0] S
   ,output cout
   ,output ovfl
   );
 
 wire [8:0] car;
 
 assign car[0] = cin;
 
 full_add full_add0 (.a(A[0]), .b(B[0]), .cin(car[0]), .s(S[0]), .counter(car[1]), .ovfl());       
 full_add full_add1 (.a(A[1]), .b(B[1]), .cin(car[1]), .s(S[1]), .counter(car[2]), .ovfl()); 
 full_add full_add2 (.a(A[2]), .b(B[2]), .cin(car[2]), .s(S[2]), .counter(car[3]), .ovfl()); 
 full_add full_add3 (.a(A[3]), .b(B[3]), .cin(car[3]), .s(S[3]), .counter(car[4]), .ovfl()); 
 full_add full_add4 (.a(A[4]), .b(B[4]), .cin(car[4]), .s(S[4]), .counter(car[5]), .ovfl()); 
 full_add full_add5 (.a(A[5]), .b(B[5]), .cin(car[5]), .s(S[5]), .counter(car[6]), .ovfl()); 
 full_add full_add6 (.a(A[6]), .b(B[6]), .cin(car[6]), .s(S[6]), .counter(car[7]), .ovfl()); 
 full_add full_add7 (.a(A[7]), .b(B[7]), .cin(car[7]), .s(S[7]), .counter(car[8]), .ovfl()); 
    
    assign cout = car[8];
    assign ovfl = car[7] ^ car[8];
endmodule
