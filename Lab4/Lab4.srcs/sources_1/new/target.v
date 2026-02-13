`timescale 1ns / 1ps


module target(
    input clk,
    input reset,
    input load,
    input [3:0] D,
    output [3:0] Q
    );
    
    wire [3:0] Qinter;

    FDRE #(.INIT(1'b0)) Q_one (.C(clk),.R(reset),.CE(load),.D(D[0]),.Q(Qinter[0]));
    FDRE #(.INIT(1'b0)) Q_two (.C(clk),.R(reset),.CE(load),.D(D[1]),.Q(Qinter[1]));
    FDRE #(.INIT(1'b0)) Q_three (.C(clk),.R(reset),.CE(load),.D(D[2]),.Q(Qinter[2]));
    FDRE #(.INIT(1'b0)) Q_four (.C(clk),.R(reset),.CE(load),.D(D[3]),.Q(Qinter[3]));
    
    assign Q = Qinter; 
    
endmodule
