`include "../cores/LedDisplay.v"

module AdcDemo (
	input clk12MHz,
	output led1,
	output led2,
	output led3,
	output led4,
	output led5,
	output led6,
	output led7,
	output led8,
	output lcol1,
	output lcol2,
	output lcol3,
	output lcol4//,

//    input rx,
//    output tx
);

	reg [7:0] leds1;
	reg [7:0] leds2 = 0;
	reg [7:0] leds3 = 0;
	reg [7:0] leds4;

 	LedDisplay display (
		.clk12MHz(clk12MHz),
		.led1(led1),
		.led2(led2),
		.led3(led3),
		.led4(led4),
		.led5(led5),
		.led6(led6),
		.led7(led7),
		.led8(led8),
		.lcol1(lcol1),
		.lcol2(lcol2),
		.lcol3(lcol3),
		.lcol4(lcol4),

		.leds1(leds1),
		.leds2(leds2),
		.leds3(leds3),
		.leds4(leds4),
		.leds_pwm(6)
	);

    // Serial protocol: 250k baud, 1 start, 8 data, 1 stop, no parity

	localparam TICKS_PER_CYCLE = 48;
    reg [5:0] serialClock = 0;
	always @ (posedge clk12MHz) begin
		// Ticking at 250KHz
		if (serialClock < TICKS_PER_CYCLE)
			serialClock <= serialClock + 1;
		else
			serialClock <= 0;
    end

    // ----------------------------------------------------
    // Transmission

//	reg [7:0] sendData;
	reg sending;
//	reg txLine;
//	assign tx = txLine;
	reg sent;

//	reg [4:0] sendBitCount = 5'b0;
//	reg [9:0] sendBits;

//	always @ (posedge sending) begin
//		sendBits <= {1'b0, sendData, 1'b1};
//		sendBitCount <= $bits(sendBits);
//    end
//
//	always @ (serialClock == 0) begin
//		if (sendBitCount > 0) begin
//		    sendBitCount <= sendBitCount - 1;
//		    // TODO Trying little-endian (reverse if this does not work).
//			txLine <= sendBits[0];
//			sendBits <= sendBits >> 1;
//		end else begin
//			txLine <= 1;
//			sending <= 0;
//		end
//    end

    // ----------------------------------------------------
    // Receiving

//    reg [15:0] recvData;
//    reg [3:0] recvBitCount;
//    reg receiving = 0;

//    always @ (negedge rx) begin
//        // TODO reading already or start?
//        // reading - ignore
//        // otherwise start shifting in
//    end

    // TODO read cycle (triggered above)

    // ----------------------------------------------------
    // DAC protocol

    // Generating some example events
    /* verilator lint_off UNOPTFLAT */
    reg [39:0] clock = 0;
    /* verilator lint_on UNOPTFLAT */
    always @ (posedge clk12MHz) begin
        clock <= clock + 1;
    end

    assign leds1 = clock[24:17];
    assign leds4 = {6'b0, sending, sent}; // Debug ; {tx, sending, 4'b0000, receiving, rx}; // Debug

//    initial begin
//        sending <= 1;
//        sent <= 0;
//    end

    always @ (posedge clock[21]) begin
//            if (sending) begin
//                sending <= 0;
//                sent <= 1;
//            end else begin
//                sending <= 1;
//                sent <= 0;
//            end
        if (sending == sent) begin
            {sent, sending} <= 2'b10;
        end else begin
            {sent, sending} <= {sending, sent};
        end
    end

//    always @ (posedge clock[21]) begin
//        leds1 <= clock[27:20]; // Debug
//        leds2 <= clock[7:0]; // 8'h02;
//        leds3 <= 1;

        // X1 - 0xA1
        // X2 - 0xA2
        // X3 - 0xA3
        // X4 - 0xA4
//	    sendData <= 8'hA1;
//        sending <= !sent;
//    end

//    always @ (posedge sent) begin
//        leds1 <= 8'h05; // Debug
//        leds2 <= 8'h4; // recvData[7:0];
//        leds3 <= 8'h8; // recvData[15:7];
//        {leds1, leds2, leds3} <= {8'h05, 8'h4, 8'h8};


//        recvBitCount <= 16;
//        receiving <= 1;
//    end

//    always @ (negedge receiving) begin
//        leds1 <= 3; // Debug
//
//        leds2 <= 8'h88; // recvData[7:0];
//        leds3 <= 8'h44; // recvData[15:7];
//    end
endmodule
