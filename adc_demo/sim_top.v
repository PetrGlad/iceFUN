`include "AdcDemo.v"

module sim_top(
    input clk,
    input [63:0] clock,

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
    output tx
    );

    AdcDemo dut(
        clk,
        led1,
        led2,
        led3,
        led4,
        led5,
        led6,
        led7,
        led8,
        lcol1,
        lcol2,
        lcol3,
        lcol4,

        out0,
        out1,
        out2,
        out3,
        out4,
        out5,
        out6,
        out7,

        rx,
        tx
    );

    initial begin
        $display("Starting");
    end
    always @ (posedge clk)
    begin
        $display("time=%4d", clock);
        if (clock > 40) begin
            $display("Bye.");
            $finish;
        end
    end
endmodule
