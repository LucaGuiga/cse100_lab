`timescale 1ns / 1ps
// fsm.v
// One-hot Mealy FSM
// States: IDLE, SHOW, PLAY, WIN, LOSE

module fsm(
    input  clk_i,
    input  Go_i,
    input  anysw_i,
    input  match_i,
    input  two_secs_i,
    input  four_secs_i,
    input  won_i,
    input  lost_i,
    output load_target_o,
    output reset_timer_o,
    output inc_score_o,
    output dec_score_o,
    output show_target_o,
    output flash_score_o,
    output flash_led_o
);

//onehot states and next state
  wire S_IDLE, S_SHOW, S_PLAY, S_WIN, S_LOSE;
  wire nIDLE, nSHOW, nPLAY, nWIN, nLOSE;

// events in the game
  wire start      = Go_i & (~anysw_i) & (~won_i) & (~lost_i);
  wire correct    = anysw_i &  match_i;
  wire wrong      = anysw_i & (~match_i);
  wire timeout    = two_secs_i;
  wire done_show  = correct | wrong | timeout;
  wire not_term   = (~won_i) & (~lost_i);

//next state logic
  assign nIDLE = (S_IDLE & not_term & (~start)) | (S_PLAY & not_term & four_secs_i);
  assign nSHOW = (S_IDLE & start) | (S_SHOW & (~done_show));
  assign nPLAY = (S_SHOW & done_show) | (S_PLAY & (~four_secs_i) & not_term);
  assign nWIN  = (S_WIN) | ((S_IDLE | S_PLAY) & won_i);
  assign nLOSE = (S_LOSE) | ((S_IDLE | S_PLAY) & lost_i);

// FDRE States
  FDRE #(.INIT(1'b1)) ff_idle (.C(clk_i), .CE(1'b1), .R(1'b0), .D(nIDLE), .Q(S_IDLE));
  FDRE #(.INIT(1'b0)) ff_show (.C(clk_i), .CE(1'b1), .R(1'b0), .D(nSHOW), .Q(S_SHOW));
  FDRE #(.INIT(1'b0)) ff_play (.C(clk_i), .CE(1'b1), .R(1'b0), .D(nPLAY), .Q(S_PLAY));
  FDRE #(.INIT(1'b0)) ff_win  (.C(clk_i), .CE(1'b1), .R(1'b0), .D(nWIN ), .Q(S_WIN ));
  FDRE #(.INIT(1'b0)) ff_lose (.C(clk_i), .CE(1'b1), .R(1'b0), .D(nLOSE), .Q(S_LOSE));

  wire good_last_q;
  wire set_good  = S_SHOW & correct;
  wire clr_good  = S_SHOW & (wrong | timeout);

  wire good_last_d = (set_good & 1'b1) | ((~set_good) & (~clr_good) & good_last_q);
  
  FDRE #(.INIT(1'b0)) ff_good (.C(clk_i), .CE(1'b1), .R(1'b0), .D(good_last_d), .Q(good_last_q));

// mealy fsm outputs
  wire loadTarget = S_IDLE & start;
  wire rtime = (S_IDLE & start) | (S_SHOW & done_show);
  wire incScore = S_SHOW & correct;
  wire decScore = S_SHOW & (wrong | timeout);
  wire flashScore = S_PLAY & good_last_q;
  wire flashLed = S_PLAY & (~good_last_q);


  assign load_target_o = loadTarget;
  assign reset_timer_o = rtime;
  assign inc_score_o = incScore;
  assign dec_score_o = decScore;
  assign show_target_o = S_SHOW;
  assign flash_score_o = flashScore;
  assign flash_led_o = flashLed;

endmodule
