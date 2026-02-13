`timescale 1ns / 1ps



module AddSub8(
    input [7:0] A,
    input [7:0] B,
    input sub, 
    output [7:0] S,
    output ovfl
    
  
    
    );
    
    wire [7:0] Z = B ^ {8{sub}}; 
    wire unused_count;
    
    adder8 add(.A(A), .B(Z), .cin(sub), .S(S), .ovfl(ovfl), .cout(unused_count));
    
endmodule
