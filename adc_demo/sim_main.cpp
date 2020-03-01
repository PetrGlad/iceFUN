#include <verilated.h>

#include "VAdcDemo.h"

int main(int argc, char** argv, char** env) {
    // Prevent unused variable warnings
    if (0 && argc && argv && env) {}


    VAdcDemo* top = new VAdcDemo;

    // Simulate until $finish
    while (!Verilated::gotFinish()) {
        top->eval();
    }

    top->final();
    delete top;
    exit(0);
}
