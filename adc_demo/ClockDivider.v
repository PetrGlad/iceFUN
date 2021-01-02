/*
    Divide input frequency by TICKS_PER_CYCLE.
    Duty cycle is not preserved.
*/
module ClockDivider #(
    parameter TICKS_PER_CYCLE = 2
) (
    input clockIn,
    output clockOut
);

    reg [5:0] serialClock = 0;
    assign clockOut = serialClock == 0;

	always @ (posedge clockIn) begin
		if (serialClock != 0)
			serialClock <= serialClock - 1;
		else
			serialClock <= TICKS_PER_CYCLE;
    end
endmodule
