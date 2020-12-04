#include <verilated.h>
#include "Vsim_top.h"


int main(int argc, char** argv, char** _env) {
    Verilated::commandArgs(argc, argv);
    Vsim_top* top = new Vsim_top();
    vluint64_t clock = 0;
    while (!Verilated::gotFinish() && clock < 1000) {
        top->clk = (clock % 2) == 0;
        top->clock = clock / 2;
        top->eval();
        clock++;
    }
    top->final();
    delete top;
    exit(0);
}
