`timescale 1ns/1ps

module tb_fsm;

reg clk;
reg reset;
reg go;
reg stop;
reg four_secs;
reg two_secs;
reg match;
reg timeout;

wire load_target;
wire show_target;
wire reset_timer;
wire load_numbers;
wire shr;
wire shl;
wire fsm_good;
wire fsm_lose;
wire display_on;
wire flash;

fsm dut(
    .clk(clk),
    .reset(reset),
    .go(go),
    .stop(stop),
    .four_secs(four_secs),
    .two_secs(two_secs),
    .match(match),
    .timeout(timeout),
    .load_target(load_target),
    .show_target(show_target),
    .reset_timer(reset_timer),
    .load_numbers(load_numbers),
    .shr(shr),
    .shl(shl),
    .fsm_good(fsm_good),
    .fsm_lose(fsm_lose),
    .display_on(display_on),
    .flash(flash)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin
    reset = 1;
    go = 0;
    stop = 0;
    two_secs = 0;
    four_secs = 0;
    match = 0;
    timeout = 0;

    #20;
    reset = 0;

    // win
    #200
    #10 go = 1; 
    #10 go = 0;
    
    #20 two_secs = 1; 
    #10 two_secs = 0;
    
    #20 match = 1; 
        stop = 1; 
    #10 stop = 0;
    
    #40 four_secs = 1; 
    #10 four_secs = 0;
    match = 0;

    // lose
    #10
    #20 go = 1; 
    #10 go = 0;
    
    #20 two_secs = 1; 
    #10 two_secs = 0;
    #30 timeout = 1;
    
    #40 four_secs = 1; 
    #10 four_secs = 0;
    timeout = 0;

    // lose
    #20 go = 1; 
    #10 go = 0;
    
    #20 two_secs = 1; 
    #10 two_secs = 0;
    
    #20 match = 0; 
        stop = 1; 
    #10 stop = 0;
    
    #40 four_secs = 1; 
    #10 four_secs = 0;
end

endmodule