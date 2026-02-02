#include <verilated.h>
#include "Vstopwatch_top.h"
#include <iostream>
#include <iomanip>
#include <verilated_vcd_c.h>

vluint64_t sim_time = 0;

// advance simulation by one clock cycle
void tick(Vstopwatch_top* dut, VerilatedVcdC* tfp) {
    // falling edge
    dut->clk = 0;
    dut->eval();
    tfp->dump(sim_time++);

    // rising edge
    dut->clk = 1;
    dut->eval();
    tfp->dump(sim_time++);
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    Vstopwatch_top* dut = new Vstopwatch_top;
    VerilatedVcdC* tfp = new VerilatedVcdC;

    dut->trace(tfp, 99);
    tfp->open("trace.vcd");


    // initialize signals
    dut->clk   = 0;
    dut->rst_n = 0;   // active-low reset
    dut->start = 0;
    dut->stop  = 0;
    dut->reset = 0;

    // apply reset
    for (int i = 0; i < 5; i++) tick(dut, tfp);
    dut->rst_n = 1;

    std::cout << "Reset complete\n";

    // start stopwatch
    dut->start = 1;
    tick(dut, tfp);
    dut->start = 0;

    std::cout << "Stopwatch started\n";

    // run for some time
    for (int i = 0; i < 70; i++) {
        tick(dut, tfp);

        // print once per second (adjust if your clock divider differs)
        if (i % 1 == 0) {
            std::cout
                << "Time = "
                << std::setw(2) << std::setfill('0') << (int)dut->minutes
                << ":"
                << std::setw(2) << std::setfill('0') << (int)dut->seconds
                << "  Status=" << (int)dut->status
                << std::endl;
        }
    }

    // pause stopwatch
    dut->stop = 1;
    tick(dut, tfp);
    dut->stop = 0;

    std::cout << "Stopwatch paused\n";

    for (int i = 0; i < 10; i++) tick(dut, tfp);

    // resume stopwatch
    dut->start = 1;
    tick(dut, tfp);
    dut->start = 0;

    std::cout << "Stopwatch resumed\n";

    for (int i = 0; i < 20; i++) {
        tick(dut, tfp);
        std::cout
            << "Time = "
            << std::setw(2) << std::setfill('0') << (int)dut->minutes
            << ":"
            << std::setw(2) << std::setfill('0') << (int)dut->seconds
            << std::endl;
    }

    // reset stopwatch
    dut->reset = 1;
    tick(dut, tfp);
    dut->reset = 0;

    std::cout << "Stopwatch reset\n";

    tick(dut, tfp);

    std::cout
        << "Final Time = "
        << std::setw(2) << std::setfill('0') << (int)dut->minutes
        << ":"
        << std::setw(2) << std::setfill('0') << (int)dut->seconds
        << std::endl;

    tfp->close();
    delete tfp;
    delete dut;
    return 0;
}
