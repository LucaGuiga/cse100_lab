`timescale 1ns / 1ps



module test_benchMsgChk();
    reg clk, s, d;
    wire e, p;
    
    
    MsgChk
    UUT (
        .clk(clk),
        .s(s),
        .d(d),
        .e(e),
        .p(p)
    );
    
    parameter PERIOD = 40;
    parameter real DUTY_CYCLE =  0.5;
    
    
    initial
    begin
    s = 1'b0;
    d = 1'b0;
    clk = 1'b1;
    forever
        begin
        # (PERIOD-(PERIOD*DUTY_CYCLE)) clk = ~clk;
        end
    end


    initial
    begin
    #2020;
    //#40;
    s = 1'b0;
    d = 1'b0;
    #40;
    s = 1'b1;
    d = 1'b1;
    #40;
    s = 1'b0;
    d = 1'b1;
    #40;
    s = 1'b0;
    d = 1'b0;
    #40;
    s = 1'b0;
    d = 1'b0;
    #40;
    s = 1'b1;
    d = 1'b1;
    #40;
    s = 1'b0;
    d = 1'b1;
    #40;
    s = 1'b1;
    d = 1'b1;
    #40;
    s = 1'b1;
    d = 1'b1;
    #40;
    s = 1'b0;
    d = 1'b0;
    #40;
    s = 1'b1;
    d = 1'b1;
    #40;
    s = 1'b0;
    d = 1'b0;
    #40;
    s = 1'b1;
    d = 1'b1;
    #40;
    s = 1'b0;
    d = 1'b1;
    #40;
    s = 1'b0;
    d = 1'b0;
    #40;
    s = 1'b1;
    d = 1'b0;
    #40;
    s = 1'b0;
    d = 1'b0;
    #40;
    s = 1'b0;
    d = 1'b1;
    #40;
    s = 1'b0;
    d = 1'b0;
    #40;
    s = 1'b1;
    d = 1'b0;

    end
    




endmodule
