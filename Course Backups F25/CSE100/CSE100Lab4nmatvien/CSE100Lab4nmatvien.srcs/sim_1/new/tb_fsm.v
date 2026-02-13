`timescale 1ns/1ps
module tb_fsm;

  // setting the singnals
  reg clk=1'b0, Go=1'b0, anysw=1'b0, foursecs=1'b0, twosecs=1'b0, match=1'b0, won=1'b0, lost=1'b0;
  wire LoadTarget, RTime, IncScore, DecScore, ShowTarget, FlashScore, FlashLed;

  // setting the edges, clock
  initial begin
    #5; forever #5 clk = ~clk;
  end

  // testing set of fsm
  fsm testing (.clk_i(clk), .Go_i(Go), .anysw_i(anysw), .match_i(match), .two_secs_i(twosecs), .four_secs_i(foursecs), .won_i(won), .lost_i(lost), .load_target_o(LoadTarget), .reset_timer_o(RTime), .inc_score_o(IncScore), .dec_score_o(DecScore), .show_target_o(ShowTarget), .flash_score_o(FlashScore), .flash_led_o(FlashLed));

  initial begin
    // settle 5 cycles
    #50;

    // Correct Scenario
    Go = 1'b1; #10; Go = 1'b0; // Idle to Show
    #40; // wait 4 full clock cycles
    anysw = 1'b1; match = 1'b1; // correct
    #20;
    anysw = 1'b0; match = 1'b0;
    #60; // PLAY
    foursecs = 1'b1; #10; foursecs = 1'b0; // end PLAY

    // 500 ns spacing between testcases (TA said so in intro)
    #500;

    // Wrong Scenario
    Go = 1'b1; #10; Go = 1'b0; // IDLE to SHOW
    #40; // wait 4 ful clock cycles
    anysw = 1'b1; match = 1'b0; // wrong
    #20;
    anysw = 1'b0; match = 1'b0;
    #60; // PLAY
    foursecs = 1'b1; #10; foursecs = 1'b0; // end PLAY

    #500;
    #200;
    $finish;
  end

endmodule
