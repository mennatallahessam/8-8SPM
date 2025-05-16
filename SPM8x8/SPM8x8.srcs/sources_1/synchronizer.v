module synchronizer(
    input clk, sig,
    output sig1
    );
    wire meta;
    
    DFF dff1(.clk(clk), .d(sig), .q(meta));
    DFF dff2(.clk(clk), .d(meta), .q(sig1));
endmodule