module tb_stopwatch;

reg clk;
reg rst_n;
reg start;
reg stop;
reg reset;

wire [7:0] minutes;
wire [5:0] seconds;
wire [1:0] status;

// Instantiate DUT
stopwatch_top dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .stop(stop),
    .reset(reset),
    .minutes(minutes),
    .seconds(seconds),
    .status(status)
);


initial clk = 0;
always #5 clk = ~clk;

// Stimulus
initial begin
    rst_n = 0;
    start = 0;
    stop  = 0;
    reset = 0;

    repeat (2) @(posedge clk);
    rst_n = 1;

    start = 1;
    @(posedge clk);
    start = 0;

    repeat (50) @(posedge clk);

    stop = 1;
    @(posedge clk);
    stop = 0;

    repeat (30) @(posedge clk);

    start = 1;
    @(posedge clk);
    start = 0;

    repeat (50) @(posedge clk);

    reset = 1;
    @(posedge clk);
    reset = 0;

    repeat (30) @(posedge clk);

    $finish;
end

initial begin
    $monitor("T=%0t | min=%0d sec=%0d status=%b",
              $time, minutes, seconds, status);
end

endmodule
