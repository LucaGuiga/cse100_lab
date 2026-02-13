`timescale 10ns / 10ps


module edgeDetector(
    input clk,
    input reset, // you might not use this pot.
    input btnU,
    output edge_o  // edge is a keyword, so we'll use _o here
    );
    
    wire [1:0] interQ;
    
    FDRE #(.INIT(1'b1) ) ffOne (.C(clk),.R(reset),.CE(1),.D(btnU),.Q(interQ[1]));
    FDRE #(.INIT(1'b0) ) ffTwo (.C(clk),.R(reset),.CE(1),.D(interQ[1]),.Q(interQ[0]));
    
    assign edge_o = btnU & ~interQ[1] & ~interQ[0];
    
   
endmodule
