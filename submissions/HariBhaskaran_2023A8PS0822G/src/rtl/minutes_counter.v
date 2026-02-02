module minutes_counter(
    input  wire       rst_n,
    input  wire       clk,
    input  wire       sec_count,
    input  wire       reset,
    output reg [7:0]  minutes
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || reset) begin
        minutes <= 8'd0;
    end else if (sec_count) begin
        if (minutes == 8'd99)
            minutes <= 8'd0;
        else
            minutes <= minutes + 8'd1;
    end
end

endmodule
