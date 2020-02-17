/*
 *
 *  Copyright(C) 2018 Gerald Coe, Devantech Ltd <gerry@devantech.co.uk>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any purpose with or
 *  without fee is hereby granted, provided that the above copyright notice and
 *  this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO
 *  THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
 *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
 *  DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
 *  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 *  CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

`include "led_display.v"

module top (
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
	output lcol4,
);

// This is "video memory", state of these bits appears on the led display.
	wire [7:0] leds1;
	wire [7:0] leds2;
	wire [7:0] leds3;
	wire [7:0] leds4;

// Instantiate the led display module
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
	);

    reg [48:0] counter = 48'hDeadBeef0000;

	always @ (posedge clk12MHz) begin
        counter <= counter + 1;
    end

	assign { leds4, leds3, leds2, leds1 } = counter[48:17];

endmodule
