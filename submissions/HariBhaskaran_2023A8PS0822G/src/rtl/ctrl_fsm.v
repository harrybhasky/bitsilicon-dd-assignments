module ctrl_fsm (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       start,
    input  wire       stop,
    input  wire       reset,
    output reg        count_enable,
    output reg [1:0]  status
);

localparam IDLE    = 2'b00;
localparam RUNNING = 2'b01;
localparam PAUSED  = 2'b10;

reg [1:0] state, next_state;

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

// Next-state logic
always @(*) begin
    next_state = state;

    case (state)
        IDLE:    if (start) next_state = RUNNING;
        RUNNING: if (stop)  next_state = PAUSED;
        PAUSED:  if (start) next_state = RUNNING;
        default: next_state = IDLE;
    endcase

    if (reset)
        next_state = IDLE;
end

// Registered outputs (Moore FSM)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        status       <= IDLE;
        count_enable <= 1'b0;
    end else begin
        status       <= next_state;
        count_enable <= (next_state == RUNNING);
    end
end

endmodule
