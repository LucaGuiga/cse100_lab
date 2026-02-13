`timescale 1ns/1ps

module tb_top;

  reg         clkin;
  reg  [15:0] sw;
  reg         btnU;
  reg         btnC;
  reg         btnR;

  wire [3:0]  an;
  wire [6:0]  seg;
  wire [15:0] led;
  wire        dp;

  top dut(
    .clkin(clkin),
    .sw(sw),
    .btnU(btnU),
    .btnC(btnC),
    .btnR(btnR),
    .an(an),
    .seg(seg),
    .led(led),
    .dp(dp)
  );

  initial begin
    clkin = 1'b0;
    forever #5 clkin = ~clkin;
  end

  initial begin
    #30
    sw = 16'b0;
    btnU = 0;
    btnC = 0;
    btnR = 0;
    
    #100
    btnR = 0;
    
    #5000
    btnC = 1;
    #40
    btnC = 0;
    
    #2000
    btnU = 1;
    #20
    btnU = 0;
  end

endmodule