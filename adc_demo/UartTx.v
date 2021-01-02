`include "ClockDivider.v"

/*
    Serial transmitter.
    Format: 1 start bit, 8 data bits, 1 stop bit.
    1. Set data.
    2. Set and hold sendRequest until sendComplete.
    3. Transmission is done when sendComplete.
*/
module UartTx #(
        parameter TICKS_PER_CYCLE = 48
) (
    input clock,
    input sendRequest,
    input [7:0] sendData,

    output serialOut,
    output sendComplete
);

    wire serialClock;
    ClockDivider #(
            .TICKS_PER_CYCLE(TICKS_PER_CYCLE)
        )
        uartClock
        (
            .clockIn(clock),
            .clockOut(serialClock)
        );

	reg [4:0] sendBitCount = 0; // Including start/stop bits.
	reg [9:0] sendBits;
	reg sending = 0;
	reg sent = 0;
    assign sendComplete = sent;

	reg tx = 1;
    assign serialOut = tx;

	always @ (posedge serialClock) begin
	    if (sendRequest) begin
            if (!sending && !sent) begin
            	sendBits <= {1'b1, sendData, 1'b0};
                sendBitCount <= 10;
                sending <= 1;
            end else if (serialClock) begin
                if (sendBitCount > 0) begin
                    sendBitCount <= sendBitCount - 1;
                    tx <= sendBits[0];
                    sendBits <= sendBits >> 1;
                end else begin
                    tx <= 1;
                    sending <= 0;
                    sent <= 1;
                end
            end
		end else
		    sent <= 0;
    end

endmodule