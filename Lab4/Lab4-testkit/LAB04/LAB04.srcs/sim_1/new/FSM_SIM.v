module FSM_SIM();

   reg clk, reset, go, stop, four_secs, two_secs, match, timeout;
   wire load_tar, show_tar, reset_time, load_num, flash, shr, shl, fsm_good, fsm_lose, display_on;
    
    FSM
    UUT (
        .clk(clk),
        .reset(reset),
        .go(go),
        .stop(stop),
        .four_secs(four_secs),
        .two_secs(two_secs),
        .match(match),
        .timeout(timeout),
        .load_tar(load_tar),
        .show_tar(show_tar),
        .reset_time(reset_time),
        .load_num(load_num),
        .flash(flash),
        .shr(shr),
        .shl(shl),
        .fsm_good(fsm_good),
        .fsm_lose(fsm_lose),
        .display_on(display_on)
        );
        
    parameter PERIOD = 40;
    parameter real DUTY_CYCLE = 0.5;


	initial    // Clock process for clk
	begin
		clk = 1'b1;
       forever
         begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = ~clk;
         end
	  end
	
	initial
	begin
	stop = 1'b0;
	go = 1'b0;
	reset = 1'b0;
	timeout = 1'b0;
	two_secs = 1'b0;
	four_secs = 1'b0;
	#80;
	go = 1'b1;
	#42; 
	go = 1'b0;
	#80;
	two_secs = 1'b1;
	#40;
	two_secs = 1'b0;
	#40;
	timeout = 1'b1;
	#40;
	timeout = 1'b0;
	#80;
	four_secs = 1'b1;
	#40;
	four_secs = 1'b0;
	#80;
	go = 1'b1;
	#42;
	go = 1'b0;
	#80;
	two_secs = 1'b1;
	#40;
	two_secs = 1'b0;
	#80;
	match = 1'b1;
	#40;
	match = 1'b0;
	#80; 
	four_secs = 1'b1;
	#40;
	four_secs = 1'b0;
	
	
	end
	


endmodule

