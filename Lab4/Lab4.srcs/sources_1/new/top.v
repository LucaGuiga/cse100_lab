`timescale 1ns / 1ps


module top (
    input        clkin,
    input [15:0] sw,
    input        btnU,
    input        btnC,
    input        btnR,
    output [3:0]  an,
    output [6:0]  seg,
    output [15:0] led,
    output        dp
);

    wire clk;
    wire digsel;
    wire qsec;

    qsec_clks u_clks(
        .clkin(clkin),
        .greset(btnR),
        .clk(clk),
        .digsel(digsel),
        .qsec(qsec)
    );


// lfsr
    wire [7:0] Lfsr;
    lfsr u_lfsr(
        .clk(clk),
        .reset(btnR),
        .Lfsr(Lfsr)
    );


// target

	wire [3:0] Target;
	wire load_targ;

    target targ (
	.clk(clk), 
	.reset(btnR), 
	.load(load_targ), 
	.D(Lfsr[3:0]), 
	.Q(Target)
	);


    // counter
	wire [5:0] Count;
	wire time_res, inc, count_res, res_utc;
	
	assign inc = ~time_res & qsec;
	assign res_utc = (Count[5] & Count[4] & Count[3] & Count[2] & Count[1] & Count[0]) ? 1'b1 :1'b0;
	assign count_res = time_res | res_utc;
	
	time_counter timer (
		.clk(clk), 
		.inc(inc), 
		.reset(count_res), 
		.Count(Count)
	    );

    // Two/Four sec timing
    assign two_secs = (~Count[5] & ~Count[4] & Count[3] & ~Count[2] & ~Count[1] & ~Count[0]);
    assign four_secs = (~Count[5] & Count[4] & ~Count[3] & ~Count[2] & ~Count[1] & ~Count[0]);


    // Edge Detectors
    wire edgeC;
    wire edgeU;

    edgeDetector showC(
        .clk(clk),
        .reset(1'b0),
        .btnU(btnC),
        .edge_o(edgeC)
    );

    edgeDetector showU(
        .clk(clk),
        .reset(1'b0),
        .btnU(btnU),
        .edge_o(edgeU)
    );

    // Match & Timeout
    wire match, timeout;
    wire [5:0] timeRanOut, time6;

    // timeout
    assign timeRanOut = {Target, 2'b11};
    assign time6 = ~(timeRanOut ^ Count);
    
    assign timeout = &time6[5:0];
    
    // match
    wire [7:0] targ_qsec;
    wire [7:0] tarAdd1, tarSub1, tarAdd2, tarSub2, differentAdd1, differentSub1, differentZero, differentAdd2, differentSub2;
    
    assign targ_qsec = {2'b00, Target, 2'b00};
    // -1
    AddSub8 sub1 (.A(targ_qsec), .B(8'd1), .sub(1'b1), .S(tarSub1), .ovfl());
    AddSub8 sub2 (.A(targ_qsec), .B(8'd2), .sub(1'b1), .S(tarSub2), .ovfl());
    // +1
    AddSub8 add1 (.A(targ_qsec), .B(8'd1), .sub(1'b0), .S(tarAdd1), .ovfl());
    AddSub8 add2 (.A(targ_qsec), .B(8'd2), .sub(1'b0), .S(tarAdd2), .ovfl());
    
    // check equality
    assign differentSub1 = tarSub1^{2'b00, Count};
    assign differentAdd1 = tarAdd1^{2'b00, Count};
    assign differentSub2 = tarSub2^{2'b00, Count};
    assign differentAdd2 = tarAdd2^{2'b00, Count};
    assign differentZero = (targ_qsec)^{2'b00, Count};
    
    wire eqS1, eqA1, eqS2, eqA2, eqZero;
    wire h_sec; // within half a second
    
    assign eqS1 = ~|differentSub1;
    assign eqA1 = ~|differentAdd1;
    assign eqS2 = ~|differentSub2;
    assign eqA2 = ~|differentAdd2;
    assign eqZero = ~|differentZero;
    assign h_sec = eqS1 | eqA1 | eqS2 | eqA2 | eqZero;
    assign match = h_sec & edgeU;
    
    // FSM

    wire show_tar, load_num;
    wire shl, shr;
    wire fsm_good, fsm_lose, displayOn, flash; //fsm outputs
    wire [15:0] nextLed;
    
    fsm FSM_TIME (
    .clk(clk),
    .reset(btnR),
    .go(edgeC),
    .stop(edgeU),
    .four_secs(four_secs), .two_secs(two_secs),
    .match(match),
    .timeout(timeout),
    
    .load_target(load_targ),
    .show_target(show_tar),
    .reset_timer(time_res),
    .load_numbers(load_num),
    .shr(shr),
    .shl(shl),
    .fsm_good(fsm_good),
    .fsm_lose(fsm_lose),
    .display_on(displayOn)
    );
   

    // ------------------------------------------------------------
    // LED shifter
    // win: shift in 1 on left shift, lose: shift in 0 on right shift
    // ------------------------------------------------------------
    wire [15:0] Leds;

    led_shifter u_leds(
        .clk(clk),
        .inp(fsm_good),          // win shifts in 1, lose shifts in 0 (since shl=0 on lose)
        .shl(shl),
        .shr(shr),
        .reset(btnR),
        .Leds(Leds)
    );

    assign led = Leds;


    // Display scan: ringCounter -> selector -> hex7seg
    wire [3:0] Ring;
    wire [15:0] valueDisplay;
    wire [3:0] hexOut;
    
    wire holdW1, holdL1;
    wire holdW2, holdL2;
    
    wire enterWin = fsm_good;
    wire enterLose = fsm_lose;

    FDRE #(.INIT(1'b0)) holdW (.C(clk), .CE(1'b1), .R(btnR), .D(holdW1), .Q(holdW2));
    FDRE #(.INIT(1'b0)) holdL (.C(clk), .CE(1'b1), .R(btnR), .D(holdL1), .Q(holdL2));    

    assign holdW1 = btnR ? 1'b0 : (holdW2 | enterWin);
    assign holdL1 = btnR ? 1'b0 : (holdL2 | enterLose);
    
    ringCounter u_ring(
        .clk(clk),
        .advance(digsel),
        .reset(btnR),
        .Ring(Ring)
    );

    assign valueDisplay = show_tar ? {12'b0, Target} : (sw[15] & ~holdW2 & ~holdL2) ? {10'b0, Count[5:0]} : holdL1 ? 16'h105E : holdW1 ? 16'h900d : 16'h0000;

    selector u_sel(
        .Sel(Ring),
        .N(valueDisplay),
        .H(hexOut)
    );

    hex7seg u_hex(
        .N(hexOut),
        .seg(seg)
    );

    assign flash = (fsm_lose | fsm_good) & Count[1];
    assign an = ~displayOn ? 4'b1111 : flash ? 4'b1111 : ~Ring;
    // decimal point not used
    assign dp = 1'b1;

endmodule