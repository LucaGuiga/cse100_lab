module fsm(
    input  clk,
    input  reset,
    input  go,
    input  stop,
    input  four_secs,
    input  two_secs,
    input  match,
    input  timeout,
    
    output load_target,
    output show_target,
    output reset_timer,
    output load_numbers,
    output shr,
    output shl,
    output fsm_good,
    output fsm_lose,
    output display_on,
    output flash
);

    // One-hot state bits (present state)
    wire IDLE;
    wire LOAD_TARGET;
    wire SHOW_TARGET;
    wire TIMING;
    wire WIN_FLASH;
    wire LOSE_FLASH;
    wire HOLD_RESULT;

    // Next-state bits
    wire nIDLE;
    wire nLOAD_TARGET;
    wire nSHOW_TARGET;
    wire nTIMING;
    wire nWIN_FLASH;
    wire nLOSE_FLASH;
    wire nHOLD_RESULT;

    // Next-state equations (Moore, one-hot style)
    // Matches the working reference structure:
    // IDLE -> LOAD_TARGET -> SHOW_TARGET -> TIMING -> (WIN_FLASH or LOSE_FLASH) -> HOLD_RESULT -> (go -> LOAD_TARGET)

    // IDLE holds until go.
    // On reset, force IDLE to be the only state bit high.
    assign nIDLE =
        reset |
        (IDLE & ~go);

    // LOAD_TARGET is entered on go, from IDLE or from HOLD_RESULT.
    // Block it during reset so we do not create multiple 1s.
    assign nLOAD_TARGET =
        ~reset &
        ( (IDLE & go) | (HOLD_RESULT & go) );

    // SHOW_TARGET begins right after LOAD_TARGET and holds until two_secs.
    assign nSHOW_TARGET =
        ~reset &
        ( LOAD_TARGET | (SHOW_TARGET & ~two_secs) );

    // TIMING begins when SHOW_TARGET completes and runs until stop or timeout.
    assign nTIMING =
        ~reset &
        ( (SHOW_TARGET & two_secs) | (TIMING & ~(stop | timeout)) );

    // WIN_FLASH runs when stop happens and match is true.
    assign nWIN_FLASH =
        ~reset &
        ( (TIMING & stop & match) | (WIN_FLASH & ~four_secs) );

    // LOSE_FLASH runs if timeout happens, or stop happens and match is false.
    assign nLOSE_FLASH =
    ~reset &
    ( (TIMING & (timeout | (stop & ~match)) & ~(stop & match))
      | (LOSE_FLASH & ~four_secs) );


    // HOLD_RESULT happens after the 4-second flash completes.
    // It holds the final message on-screen until go starts next round.
    assign nHOLD_RESULT =
        ~reset &
        ( (WIN_FLASH & four_secs) | (LOSE_FLASH & four_secs) | (HOLD_RESULT & ~go) );

    // State FFs (async reset to 0, but we drive IDLE high via nIDLE=1 on reset)
    FDRE #(.INIT(1'b1)) s_idle        (.C(clk), .CE(1'b1), .R(reset), .D(nIDLE),        .Q(IDLE));
    FDRE #(.INIT(1'b0)) s_load        (.C(clk), .CE(1'b1), .R(reset), .D(nLOAD_TARGET), .Q(LOAD_TARGET));
    FDRE #(.INIT(1'b0)) s_show_target (.C(clk), .CE(1'b1), .R(reset), .D(nSHOW_TARGET), .Q(SHOW_TARGET));
    FDRE #(.INIT(1'b0)) s_timing      (.C(clk), .CE(1'b1), .R(reset), .D(nTIMING),      .Q(TIMING));
    FDRE #(.INIT(1'b0)) s_win_flash   (.C(clk), .CE(1'b1), .R(reset), .D(nWIN_FLASH),   .Q(WIN_FLASH));
    FDRE #(.INIT(1'b0)) s_lose_flash  (.C(clk), .CE(1'b1), .R(reset), .D(nLOSE_FLASH),  .Q(LOSE_FLASH));
    FDRE #(.INIT(1'b0)) s_hold        (.C(clk), .CE(1'b1), .R(reset), .D(nHOLD_RESULT), .Q(HOLD_RESULT));

    // Moore outputs (depend only on current state bits)

    // Load + show target
    assign load_target = LOAD_TARGET;
    assign show_target = SHOW_TARGET;

    // More aggressive reset_timer (mirrors their reset_time intent)
    // - during LOAD_TARGET
    // - at the moment SHOW_TARGET completes (two_secs)
    // - at the moment TIMING resolves into WIN or LOSE
    assign reset_timer =
        LOAD_TARGET |
        (SHOW_TARGET & two_secs) |
        (TIMING & stop & match) |
        (TIMING & (timeout | (stop & ~match)));

    // Latch/display number hook (same as their load_num)
    assign load_numbers = LOAD_TARGET;

    // Shift pulses (one cycle) when flash completes
    assign shl = WIN_FLASH & four_secs;
    assign shr = LOSE_FLASH & four_secs;

    // Flash modes
    assign fsm_good = WIN_FLASH;
    assign fsm_lose  = LOSE_FLASH;
    assign display_on = (HOLD_RESULT | LOSE_FLASH | WIN_FLASH | SHOW_TARGET | LOAD_TARGET);
    assign flash = HOLD_RESULT;

endmodule