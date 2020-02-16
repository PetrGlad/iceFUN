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

	// Scan clock
	reg [11:0] clock = 12'b0;

	// Row selector
	wire [3:0] led_col;

	// Row state
	wire [7:0] led_row;

	// Map the output to the port pins
	assign { led8, led7, led6, led5, led4, led3, led2, led1 } = led_row[7:0];
	assign { lcol4, lcol3, lcol2, lcol1 } = led_col[3:0];

	// Highlight LED rows sequentially in cycle
	always @ (posedge clk12MHz) begin
		case (clock[11:10])
			2'b00: begin
    			led_row[7:0] <= ~leds1[7:0];
				led_col[3:0] <= 4'b1110;
			end
			2'b01: begin
    			led_row[7:0] <= ~leds2[7:0];
				led_col[3:0] <= 4'b1101;
			end
			2'b10: begin
    			led_row[7:0] <= ~leds3[7:0];
				led_col[3:0] <= 4'b1011;
			end
			2'b11: begin
    			led_row[7:0] <= ~leds4[7:0];
				led_col[3:0] <= 4'b0111;
			end
    	endcase
    end

    always @ (posedge clk12MHz) begin
        clock <= clock + 1;
    end

endmodule
