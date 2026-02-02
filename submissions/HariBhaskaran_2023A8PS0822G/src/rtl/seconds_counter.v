module seconds_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       enable,
    input  wire       reset,
    output reg  [5:0] seconds,
    output reg        sec_count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || reset) begin
        seconds   <= 6'd0;
        sec_count <= 1'b0;
    end else begin
        sec_count <= 1'b0;

        if (enable) begin
            if (seconds == 6'd59) begin
                seconds   <= 6'd0;
                sec_count <= 1'b1;
            end else begin
                seconds <= seconds + 6'd1;
            end
        end
    end
end

endmodule
