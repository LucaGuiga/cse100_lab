module selector(
    input [3:0] Sel,
    input [15:0] N,
    output [3:0] H
    );
    
   // Your code here!
   assign H = {4{Sel[0]}} & N[3:0] | 
              {4{Sel[1]}} & N[7:4] | 
              {4{Sel[2]}} & N[11:8] | 
              {4{Sel[3]}} & N[15:12];
  // the input of our RC tells this which 4 bit seg to work with the hex7 
  // because each an can only read 4 bits at a time 
   
endmodule
