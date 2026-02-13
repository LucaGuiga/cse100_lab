`timescale 1ns / 1ps
module FSM(
    input clk, 
    input reset, //btnR
    input go, //btnC
    input stop, //btnU
    input two_secs, 
    input four_secs, 
    input match, //match if you hit btnU on time
    input timeout, //timeout singal
   
    
    output load_tar,
    output show_tar,
    output reset_time,
    output load_num, 
    output shl, 
    output shr, 
    output fsm_good, 
    output fsm_lose,
    output display_on,
    output flash
    );
    
    //State Logic 
    wire [6:0] next;
    wire [6:0] state;
    
    assign next[0] = reset ? 1'b1 :(state[0] & ~go)  ;
                                  
    assign next[1] = (state[0] & go) | (state[6] & go); 
                      
    assign next[2] = state[1] | (state[2] & ~two_secs) ;
                     
    assign next[3] = (state[2] & two_secs) | (state[3] & ~(stop | timeout));
                     
    assign next[4] = (state[3] & stop & match) | (state[4] & ~four_secs);
                     
    assign next[5] = (state[3] & (timeout | (stop & ~match))) | (state[5] & ~four_secs);
    
    assign next[6] = (state[4] & four_secs) | (state[5] & four_secs) | (state[6] & ~go);                                               
    //State FF
    FDRE #(.INIT(1'b1)) S_IDLE (.C(clk), .R(reset), .CE(1'b1), .D(next[0]), .Q(state[0]));
    FDRE #(.INIT(1'b0)) S_LOAD (.C(clk), .R(reset), .CE(1'b1), .D(next[1]), .Q(state[1]));
    FDRE #(.INIT(1'b0)) S_SHOW (.C(clk), .R(reset), .CE(1'b1), .D(next[2]), .Q(state[2]));
    FDRE #(.INIT(1'b0)) S_HIDE (.C(clk), .R(reset), .CE(1'b1), .D(next[3]), .Q(state[3]));
    FDRE #(.INIT(1'b0)) S_WIN  (.C(clk), .R(reset), .CE(1'b1), .D(next[4]), .Q(state[4]));
    FDRE #(.INIT(1'b0)) S_LOSE (.C(clk), .R(reset), .CE(1'b1), .D(next[5]), .Q(state[5]));
    FDRE #(.INIT(1'b0)) S_HOLD (.C(clk), .R(reset), .CE(1'b1), .D(next[6]), .Q(state[6]));
    
    

    //OUTPUTS 
    assign load_tar = state[1];
    assign show_tar = state[2];
    assign reset_time = (state[1]) | (state[2]& two_secs)| (state[3] & stop & match) | (state[3] & (timeout | (stop & ~match)));
    assign load_num = state[1];
    assign shl = state[4] & four_secs ;
    assign shr = (state[5] & four_secs);
    assign fsm_good = state[4];
    assign fsm_lose = state[5];
    assign display_on = (state[6] | state[5] | state[4] | state[2] | state[1]);
    assign flash = state[6];
    
    
endmodule
