module stopwatch_top (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire        stop,
    input  wire        reset,
    output wire [7:0]  minutes,
    output wire [5:0]  seconds,
    output wire [1:0]  status
);

wire count_enable;
wire sec_count;

ctrl_fsm fsm (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .stop(stop),
    .reset(reset),
    .count_enable(count_enable),
    .status(status)
);

seconds_counter sec (
    .clk(clk),
    .rst_n(rst_n),
    .enable(count_enable),
    .reset(reset),
    .seconds(seconds),
    .sec_count(sec_count)
);

minutes_counter min (
    .clk(clk),
    .rst_n(rst_n),
    .sec_count(sec_count),
    .reset(reset),
    .minutes(minutes)
);

endmodule
