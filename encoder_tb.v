`timescale 1ns/1ps

module encoder_tb();
    
    localparam WIDTH = 16;
    parameter POS_W = $clog2(WIDTH);

    reg     [WIDTH-1:0]   vector;
    wire    [POS_W-1:0]   position;
    wire                  is_onehot;
    wire                  parity;

    encoder #(
        .WIDTH(WIDTH),
        .POS_W(POS_W)
    )  encoder_tb_inst ( 
        .vector    (vector),
        .position    (position),
        .is_onehot     (is_onehot),
        .parity    (parity)
    );  
    
    // always begin
    //     clock = 1'b0; #5;
    //     clock = 1'b1; #5;
    // end
    
     initial begin
        $dumpvars;
        
        vector = 3; #5;
        vector = 'b10100; #5;
        vector = 1; #5;
        vector = 8; #5;
        vector = 7; #5;
        
        $finish;
    end
    

endmodule