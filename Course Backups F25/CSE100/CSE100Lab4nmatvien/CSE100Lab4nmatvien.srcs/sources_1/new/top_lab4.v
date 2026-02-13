`timescale 1ns/1ps
module top_lab4(
    input clkin,
    input btnC,
    input btnR,
    input [15:0] sw,
    output [3:0] an,
    output [6:0] seg,
    output [15:0] led
);
    // clock / enables
    wire clk, digsel, qsec;
    qsec_clks u_clks (.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel), .qsec(qsec));
    
    // btnC ensuring just one pulse / press
    wire btnC_s0, btnC_s1, btnC_s1_d;
    FDRE #(.INIT(1'b0)) btn_sync0 (.C(clk), .CE(1'b1), .R(1'b0), .D(btnC),    .Q(btnC_s0));
    FDRE #(.INIT(1'b0)) btn_sync1 (.C(clk), .CE(1'b1), .R(1'b0), .D(btnC_s0), .Q(btnC_s1));
    FDRE #(.INIT(1'b0)) btn_prev  (.C(clk), .CE(1'b1), .R(1'b0), .D(btnC_s1), .Q(btnC_s1_d));
    wire go = btnC_s1 & (~btnC_s1_d);
    
    // btnR resync (for ring reset)
    wire rst_s0, rst_sync;
    FDRE #(.INIT(1'b0)) rst_ff0 (.C(clk), .CE(1'b1), .R(1'b0), .D(btnR),   .Q(rst_s0));
    FDRE #(.INIT(1'b0)) rst_ff1 (.C(clk), .CE(1'b1), .R(1'b0), .D(rst_s0), .Q(rst_sync));
    
    // target path
    wire [7:0] lfsr_q;  lfsr u_lfsr (.clk_i(clk), .q_o(lfsr_q));
    wire [3:0] target_q;
    wire [15:0] dec_q;
    target u_target (.clk(clk), .ce(load_target), .d(lfsr_q[3:0]), .q(target_q));
    decoder u_decoder (.n(target_q), .q(dec_q));
    
    // FSM outputsd
    wire reset_timer, inc_score, dec_score, show_target, flash_score, flash_led;
    
    // timers
    wire twosecs, foursecs; wire [4:0] time_q;
    time_counter u_time (.clk(clk), .en_qsec(qsec), .rtime(reset_timer), .twosecs(twosecs), .foursecs(foursecs), .q(time_q));
    
    // score keep
    wire [3:0] score_q; wire score_sign; wire won, lost;
    score_counter u_score (.clk(clk), .inc(inc_score), .dec(dec_score), .q(score_q), .sign(score_sign), .won(won), .lost(lost));
    
    // Game FSM
    wire anysw = | sw[15:0];
    wire match = ~( |(sw ^ dec_q));
    fsm u_fsm(.clk_i(clk), .Go_i(go), .four_secs_i(foursecs), .two_secs_i(twosecs), .match_i(match), .anysw_i(anysw), .won_i(won), .lost_i(lost), .load_target_o(load_target),  .reset_timer_o(reset_timer), .inc_score_o(inc_score), .dec_score_o(dec_score), .show_target_o(show_target), .flash_score_o(flash_score), .flash_led_o(flash_led));
    
    // the blinking maker
    wire blink_q, blink_d; assign blink_d = blink_q ^ qsec;
    FDRE #(.INIT(1'b0)) blink_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(blink_d), .Q(blink_q));
    wire blink = blink_q;
    
    // wwhen we go into led's for winning, losing, or flash
    wire led_mode = won | flash_led | lost;
    wire led_mode_q;
    FDRE #(.INIT(1'b0)) ledmode_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(led_mode), .Q(led_mode_q));
    wire led_mode_start = led_mode & (~led_mode_q);
    
    //toggle when led mode is going
    wire blink_slow_q, blink_slow_d;
    wire toggle_en = qsec & blink_q & led_mode;
    assign blink_slow_d = (~led_mode_start) & (blink_slow_q ^ toggle_en);
    FDRE #(.INIT(1'b0)) blink_slow_ff (.C(clk), .CE(1'b1), .R(1'b0), .D(blink_slow_d), .Q(blink_slow_q));
    wire blink_slow = blink_slow_q;
    
    // LEDs
    // Blink to 16 bits
    wire [15:0] blink_bus = {16{blink_slow}};

    // blinking just the target
    wire [15:0] leds_play_wrong = dec_q & blink_bus;

    // if not won, then wrong or loss
    wire mode_wrong = (~won) & (flash_led | lost);
    
    assign led = ({16{won}} & blink_bus) | ({16{mode_wrong}} & leds_play_wrong); // PLAY-wrong or LOST: blink target pattern
    
    // 7-seg packing
    wire [7:0] sc_do;
    signchanger u_signchg (.A_i({4'b0000,score_q}), .sign_i(score_sign), .D_o(sc_do), .ovfl_o());
    
    wire [3:0] D0 = sc_do[3:0];
    wire [3:0] D1 = sc_do[7:4];
    wire [3:0] D2 = 4'h0;
    wire [3:0] D3 = target_q;
    
    // scan + select
    wire [3:0] an_raw, sel_oh, N_mux;
    ring_counter u_ring (.clk_i(clk), .digsel_i(digsel), .rst_i(rst_sync), .an_o(an_raw), .sel_o(sel_oh));
    selector u_sel  (.N_i({D3, D2, D1, D0}), .sel_onehot(sel_oh), .N_out(N_mux));
    
    // negative dash thing and segment drives
    wire mag_nz = score_q[3] | score_q[2] | score_q[1] | score_q[0];
    wire need_tens = score_sign & mag_nz;
    wire dash_now = sel_oh[1] & need_tens;
    hex7seg u_hex (.N_i(N_mux), .losedashthing_i(dash_now), .seg_o(seg));
    
    // anode for active low
    wire [3:0] blank_mask;
    wire blank_score = (flash_score | won) & (~blink);
    assign blank_mask[3] = ~show_target;
    assign blank_mask[2] = 1'b1;
    assign blank_mask[1] = (~need_tens) | blank_score;
    assign blank_mask[0] = blank_score;
    assign an = an_raw | blank_mask;
    
endmodule