`timescale 1ns / 1ps
module TopLevel(

input clkin,
input btnR, 
input btnU, 
input btnC, 
input [15:0] sw, 

output [15:0] led,
output [3:0] an,
output [6:0] seg
    );
    // Qsec Clock 
wire clk, qsec, digsel;

qsec_clks slowit (
    .clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel), .qsec(qsec)
);
    //Lfsr 
wire [7:0] Lfsr;

lfsr rand_num (
.clk(clk), .reset(btnR), .Lfsr(Lfsr)
);

    //Target 
 wire [3:0] target;
 wire load_tar;
 
 Target Tar(
 .clk(clk), .reset(btnR), .load(load_tar), .D(Lfsr[3:0]), .Q(target)
 );
 
    // Time Counter
wire [5:0] Count;
wire reset_time, inc, reset_count, utc_reset ;

assign inc = qsec & ~reset_time;
assign reset_utc = (Count[5] & Count[4] & Count[3] & Count[2] & Count[1] & Count[0]) ? 1'b1 : 1'b0;
assign reset_count = utc_reset | reset_time;
time_counter timer (
.clk(clk), .inc(inc), .reset(reset_count), .Count(Count)
);
 
    //2 sec and 4 sec timing
wire two_secs, four_secs;
//wire [5:0] Count;

assign two_secs =(~Count[5]& ~Count[4] &  Count[3] & ~Count[2] & ~Count[1] & ~Count[0]); 
assign four_secs = (~Count[5]& Count[4] &  ~Count[3] & ~Count[2] & ~Count[1] & ~Count[0]);

     //EdgeDetector 
wire btnC_out, btnU_out; 

EdgeDetector EdgeC (.clk(clk), .reset(1'b0), .button(btnC), .edge_o(btnC_out));
EdgeDetector EdgeU (.clk(clk), .reset(1'b0), .button(btnU), .edge_o(btnU_out));

    // Match / Timeout 
wire match, timeout;
wire [5:0] target_timedout, time6;
        //Timeout
assign target_timedout = {target, 2'b11};
assign time6 = ~(target_timedout ^ Count);

assign timeout = &time6[5:0];
       //Match 
wire [5:0] target_qsec;
wire[7:0] tar_sub1, tar_add1, tar_add2, tar_sub2, diff_sub1, diff_add1, diff_zero, diff_sub2, diff_add2;
 
assign target_qsec = {2'b00, target, 2'b00}; 
// -1 
AddSub8 sub1 (.A(target_qsec), .B(8'd1), .sub(1'b1), .S(tar_sub1), .ovfl());

AddSub8 sub2 (.A(target_qsec), .B(8'd2), .sub(1'b1), .S(tar_sub2), .ovfl());
// +1
AddSub8 add1 (.A(target_qsec), .B(8'd1), .sub(1'b0), .S(tar_add1), .ovfl());

AddSub8 add2 (.A(target_qsec), .B(8'd2), .sub(1'b0), .S(tar_add2), .ovfl());
//Equality checker 
assign diff_sub1 = tar_sub1 ^{2'b00, Count};
assign diff_add1 = tar_add1 ^ {2'b00, Count};
assign diff_sub2 = tar_sub2 ^{2'b00, Count};
assign diff_add2 = tar_add2 ^ {2'b00, Count};
assign diff_zero = (target_qsec) ^ {2'b00, Count};

wire equal_sub1, equal_add1, equal_zero, equal_sub2, equal_add2;
wire within_halfsec;

assign equal_sub1 = ~|diff_sub1;
assign equal_add1 =  ~|diff_add1;
assign equal_sub2 = ~|diff_sub2;
assign equal_add2 =  ~|diff_add2;
assign equal_zero = ~|diff_zero;
assign within_halfsec = equal_sub1 | equal_add1 | equal_sub2 | equal_add2 |equal_zero;
assign match = within_halfsec & btnU_out;



    //FSM 
 wire show_tar, load_num;
 wire shl, shr;
 wire fsm_good, fsm_lose, display_on, flash; // FSM outputs
wire [15:0] nextLed;  
    FSM StateMach(
        .clk(clk), .reset(btnR), .go(btnC_out), .stop(btnU_out), .four_secs(four_secs), .two_secs(two_secs), .match(match), .timeout(timeout), 
        .load_tar(load_tar), .show_tar(show_tar), .reset_time(reset_time), .load_num(load_num), .shr(shr), .shl(shl), .fsm_good(fsm_good), .fsm_lose(fsm_lose), .display_on(display_on)
    );

    //LED SHIFTER 
//wire [15:0] nextLed;
    led_shifter Score (
    .clk(clk), .reset(btnR), .inp(fsm_good), .shl(shl), .shr(shr), .Leds(nextLed)
    );
   assign led = nextLed;
    // DISPLAY 
wire [3:0] ring;
wire [15:0] display_val;
wire [3:0] hex_out;

wire win_hold1, lose_hold1;
wire win_hold2, lose_hold2;
wire prev_good, prev_lose;
wire enter_win = fsm_good & ~prev_good;
wire enter_lose = fsm_lose & ~prev_lose;


FDRE #(.INIT(1'b0)) WINhold  (.C(clk), .CE(1'b1), .R(btnR), .D(win_hold1),  .Q(win_hold2));
FDRE #(.INIT(1'b0)) LOSEhold (.C(clk), .CE(1'b1), .R(btnR), .D(lose_hold1), .Q(lose_hold2));

assign win_hold1  = btnR ? 1'b0 : (win_hold2  | enter_win);
assign lose_hold1 = btnR ? 1'b0 : (lose_hold2 | enter_lose);

    ringCounter RingCount (
    .clk(clk), .advance(digsel), .reset(btnR), .Ring(ring)
    );
                                                                                                                                          
    assign display_val = show_tar ? {12'b0,target} : (sw[15] & ~win_hold2 & ~lose_hold2) ? {10'b0,Count[5:0]} : lose_hold1 ? 16'h105E : win_hold1 ? 16'h900d : 16'h0000; 
    
    
    
    selector Sel(
    .Sel(ring), .N(display_val), .H(hex_out)
    );
    
     
    hex7seg hexSeg (
    .N(hex_out), .Seg(seg)
    );
   
  assign flash = (fsm_good | fsm_lose) & Count[1];
  
  assign an = ~display_on ? 4'b1111 : flash ? 4'b1111 : ~ring;


  

endmodule
