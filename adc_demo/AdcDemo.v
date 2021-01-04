`default_nettype none

`include "../cores/LedDisplay.v"

// J1 code is from git@github.com:jamesbowman/j1.git
// Copied it here to simplify debugging
// Modifications to cross.fs:
// 1. 16 bit hex output is reuired from Forth firmware assembler (32bit uses wrong word ordering)
// 2. Remove 'bootloader' and 'main' functions requirement from cross.fs
// 3. Use ./build output path
// common.h renamed to common.v
`include "j1/j1.v"

`include "AdcReader.v"

module AdcDemo #(
    parameter WIDTH = 32
) (
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

    output out0,
    output out1,
    output out2,
    output out3,
    output out4,
    output out5,
    output out6,
    output out7,

    input rx,
    output tx,

    input sw1
);

	reg [7:0] leds1;
	reg [7:0] leds2;
	reg [7:0] leds3;
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

    // ----------------------------------------------------
    // J1 CPU experiment

    wire cpuClock = clk12MHz;

    reg [15:0] program_mem [0:255];
    initial $readmemh("build/icefun-fw.hex", program_mem);

    localparam data_mem_size = 512;
    localparam mem_addr_width = $clog2(data_mem_size + 1);
    reg [WIDTH-1:0] data_mem [0:data_mem_size];

    reg resetq = 1; // j1 in
    wire io_wr; // j1 out
    wire mem_wr; // j1 out
    wire [15:0] mem_addr; // j1 out
    reg [WIDTH-1:0] dout; // j1 out
    reg [WIDTH-1:0] mem_din; // j1 in
    reg [WIDTH-1:0] io_din; // j1 in

    wire [12:0] code_addr; // j1 out
    reg [15:0] insn; // j1 in

    /* verilator lint_off UNUSED */
    reg j1_err_addr_overflow;
    /* verilator lint_on UNUSED */

    j1 #(.WIDTH(WIDTH)) cpu (
        .clk(cpuClock),
        .resetq(resetq),

        .io_wr(io_wr),
        .io_din(io_din),

        .mem_addr(mem_addr),
        .mem_wr(mem_wr),
        .dout(dout),
        .mem_din(mem_din),

        .code_addr(code_addr),
        .insn(insn)
    );

    reg [7:0] probe8;
    assign {out7, out6, out5, out4, out3, out2, out1, out0} = probe8;

    // Select actually availiable address bits, since only subset of CPU address space is covered by RAM,
    wire [mem_addr_width - 1:0] phy_mem_addr = mem_addr[mem_addr_width - 1:0];

    wire [9:0] adc_value_1;
    wire [9:0] adc_value_2;
    wire [9:0] adc_value_3;
    wire [9:0] adc_value_4;

    always @(posedge cpuClock) begin
        probe8 <= {mem_wr, io_wr, rx, tx, adc_value_1[3:0]}; // DEBUG
        $display("pc=%x mem_addr=%x mem_wr=%x io_wr=%x ", code_addr, mem_addr, mem_wr, io_wr); // DEBUG

        if (mem_wr)
            data_mem[phy_mem_addr] <= dout;
        if (io_wr) begin
            case (mem_addr)
                'h10: leds1 <= dout[7:0];
                'h11: leds2 <= dout[7:0];
                'h12: leds3 <= dout[7:0];
                'h13: leds4 <= dout[7:0];
            endcase
        end

        /* XXX On reads both memory and io values are provided since J1 does not
            provide any indication which one it needs this time.
            It lets J1 to save one cycle when reading (?).
        */
        mem_din <= data_mem[phy_mem_addr];
        case (mem_addr)
            'h0: io_din <= {22'b0, adc_value_1};
            'h1: io_din <= {22'b0, adc_value_2};
            'h2: io_din <= {22'b0, adc_value_3};
            'h3: io_din <= {22'b0, adc_value_4};
            default: io_din <= 0;
        endcase

        insn <= program_mem[code_addr[7:0]];
        j1_err_addr_overflow <= |code_addr[12:7];
    end

    // assign leds4 = {io_wr, mem_wr, mem_addr[1:0], j1_err_addr_overflow, code_addr[2:0]}; // DEBUG
    // assign leds1 = adc_value_1[7:0];
    // assign leds2 = {6'b0, adc_value_1[9:8]};

    AdcReader adc (
            .clock12MHz(clk12MHz),
            .serialOut(tx),
            .serialIn(rx),
            .value1(adc_value_1),
            .value2(adc_value_2),
            .value3(adc_value_3),
            .value4(adc_value_4)
        );

    // ----------------------------------------------------
    // Switch bounce test

    reg [7:0] bounceCounter;
    reg swState;
    always @(posedge clk12MHz) begin
        if (swState != sw1) begin
            swState <= sw1;
            bounceCounter <= bounceCounter + 1;
        end
    end
    // assign leds4 = bounceCounter[7:0];

endmodule
