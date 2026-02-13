module oct2ssd
  (input d2
  ,input d1
  ,input d0
  ,input btnD

  ,output CA
  ,output CB
  ,output CC
  ,output CD 
  ,output CE
  ,output CF 
  ,output CG 
  ,output dp
  
  ,output AN0
  ,output AN1
  ,output AN2
  ,output AN3
   );

  assign CA = (~d2&~d1&d0)|(d2&~d1&~d0);
  assign CB = (~d2&~d1&d0)|(d2&~d1&d0)|(d2&d1&~d0);
  assign CC = (~d2&~d1&d0)|(~d2&d1&~d0);
  assign CD = (~d2&~d1&d0)|(d2&~d1&~d0)|(d2&d1&d0);
  assign CE = (~d2&d1&d0)|(d2&~d1&~d0)|(d2&~d1&d0)|(d2&d1&d0);
  assign CF = (~d2&d1&~d0)|(~d2&d1&d0)|(d2&d1&d0);
  assign CG = (~d2&~d1&~d0)|(~d2&~d1&d0);
  assign dp = btnD;
  
  assign AN0 = 1'b0;
  assign AN1 = 1'b1;
  assign AN2 = 1'b1;
  assign AN3 = 1'b1;

endmodule