`include "UartTx.v"
`include "UartRx.v"

/*
    Implements iceFUN DAC protocol:
    1. Send DAC id over UART (#1 - 0xA1, #2 - 0xA2, #3 - 0xA3, #4 - 0xA4).
    2. Receive via UART 2 bytes with 10 bit measured value.

    Required serial protocol format: 250k baud, 1 start, 8 data, 1 stop, no parity
    See also https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter
*/
module AdcReader (
    input clock12MHz,
    output serialOut,
    input serialIn,
    output [9:0] value
);

    localparam uartTicksPerCycle = 48; // 250 KHz

    wire sent;
    reg [7:0] sendData;
    reg sendReq = 0;
    UartTx #(
            .TICKS_PER_CYCLE(uartTicksPerCycle)
        )
        uartTx
        (
            .clock(clock12MHz),
            .sendRequest(sendReq),
            .sendData(sendData),
            .serial(serialOut),
            .sendComplete(sent)
        );

    reg readyForRx = 0;
    wire [7:0] recvData;
    wire dataReady;

    UartRx #(
            .TICKS_PER_CYCLE(uartTicksPerCycle)
        )
        uartRx
        (
            .clock(clock12MHz),
            .serialIn(serialIn),
            .readyForRx(readyForRx),
            .data(recvData),
            .complete(dataReady)
        );

    reg [9:0] measurement;
    assign value = measurement;

    localparam S_INIT = 0, S_ADC_REQ_1 = 1, S_ADC_RECV_1 = 2, S_ADC_REQ_2 = 3, S_ADC_RECV_2 = 4;
    reg [2:0] state = S_INIT;


    always @ (posedge clock12MHz) begin
        case (state)
            S_INIT: begin
                sendData <= 8'hA1;
                sendReq <= 1;
                state <= S_ADC_REQ_1;
            end
            S_ADC_REQ_1: begin
                if (sent) begin
                    sendReq <= 0;
                    readyForRx <= 1;
                    state <= S_ADC_RECV_1;
                end
            end
            S_ADC_RECV_1: begin
                if (dataReady) begin
                    readyForRx <= 0;
                    measurement[7:0] <= recvData;
                    state <= S_ADC_REQ_2;
                end
            end
            S_ADC_REQ_2: begin
                // Wait for serial reader to get ready for next frame
                if (!dataReady) begin
                    readyForRx <= 1;
                    state <= S_ADC_RECV_2;
                end
            end
            S_ADC_RECV_2: begin
                if (dataReady) begin
                    readyForRx <= 0;
                    measurement[9:8] <= recvData[1:0];
                    state <= S_INIT;
                end
            end
        endcase
    end
endmodule