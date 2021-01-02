/*
    Serial receiver.
    Format: 1 start bit, 8 data bits, 1 stop bit.
    1. Set and hold readyForRx until dataReady is signaled.

*/
module UartRx #(
    parameter TICKS_PER_CYCLE = 48
) (
    input clock,
    input serialIn,
    input readyForRx,

    output [7:0] data,
    output complete
);

    reg [3:0] recvBitIdx = 0;
    reg [5:0] rxClock = 0;
    reg receiving = 0;
    reg dataReady = 0;
    assign complete = dataReady;

    reg [7:0] recvData;
    assign data = recvData;

    always @ (posedge clock) begin
        if (readyForRx) begin
            if (!dataReady) begin
                if (receiving) begin
                    if (rxClock == 0) begin
                        if (recvBitIdx == 0) begin // Also skips stop bit
                            receiving <= 0;
                            dataReady <= 1;
                        end else begin
                            recvData <= {serialIn, recvData[7:1]};
                            recvBitIdx <= recvBitIdx - 1;
                            rxClock <= TICKS_PER_CYCLE;
                        end
                    end else
                        rxClock <= rxClock - 1;
                end else if (~serialIn) begin // Start bit low
                    receiving <= 1;
                    recvBitIdx <= 9;
                    rxClock <= 5; // Add small sampling delay, just in case.
                end
            end
        end else
            dataReady <= 0;
    end

endmodule
