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

// LED matrix driver.

module LedDisplay (
	// Device connections
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

	// Displayed data (LED states, 4 bytes, one byte per row)
	input [7:0] leds1,
	input [7:0] leds2,
	input [7:0] leds3,
	input [7:0] leds4,
	);

	// Row scan clock
	reg [11:0] clock = 12'b0;

	always @ (posedge clk12MHz) begin
        clock <= clock + 1;
    end

	assign row = clock[11:10];

	// Select LED rows sequentially in cycle
	assign { lcol4, lcol3, lcol2, lcol1 } = ~(1 << row);

	// Map row state to the port pins
	wire [7:0] led_row;
	assign { led8, led7, led6, led5, led4, led3, led2, led1 } = ~led_row[7:0];
	always @ (row) begin
		case (row)
			0: led_row = leds1;
			1: led_row = leds2;
			2: led_row = leds3;
			3: led_row = leds4;
    	endcase
    end
endmodule
