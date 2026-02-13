module selector(
    input [3:0] Sel,
    input [15:0] N,
    output [3:0] H
    );
                    // 0001                                                         0010                                                        0100                                                            1000
   assign H = ~{4{Sel[3]}}&~{4{Sel[2]}}&~{4{Sel[1]}}&{4{Sel[0]}}&N[3:0]|~{4{Sel[3]}}&~{4{Sel[2]}}&{4{Sel[1]}}&~{4{Sel[0]}}&N[7:4]|~{4{Sel[3]}}&{4{Sel[2]}}&~{4{Sel[1]}}&~{4{Sel[0]}}&N[11:8]|{4{Sel[3]}}&~{4{Sel[2]}}&~{4{Sel[1]}}&~{4{Sel[0]}}&N[15:12];
   
   
endmodule
