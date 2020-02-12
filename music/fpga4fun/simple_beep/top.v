/*
* (c) https://www.fpga4fun.com
*
  * ported to iceFun FPGA by Hirosh Dabui <hirosh@dabui.de>
  */
module top (
 input clk12MHz,
 output spkp,
 output spkm
);

wire clk;
assign spkp = speaker;
assign spkm = ~speaker;
// 25 MHz PLL
SB_PLL40_CORE #(
 .FEEDBACK_PATH("SIMPLE"),
 .DIVR(4'b0000),         // DIVR =  0
 .DIVF(7'b1000010),      // DIVF = 66
 .DIVQ(3'b101),          // DIVQ =  5
 .FILTER_RANGE(3'b001)   // FILTER_RANGE = 1
) uut (
 .LOCK(locked),
 .RESETB(1'b1),
 .BYPASS(1'b0),
 .REFERENCECLK(clk12MHz),
 .PLLOUTCORE(clk)
);

reg [15:0] counter;
always @(posedge clk) counter <= counter+1;

// and use the most significant bit (MSB) of the counter to drive the speaker
 assign speaker = counter[15];
endmodule
