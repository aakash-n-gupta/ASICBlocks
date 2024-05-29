// Verilator top module for Multiplier

// Basic include files needed for C++
#include <stdlib.h>
#include <iostream>

// Common Verilator include files that give us trace and verilator routines
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vmult.h"
#include "Vmult___024root.h"

#define MAX_SIM_TIME 500
vluint64_t simtime = 0;
vluint64_t cycles = 0;

// need to give inputs to DUT
void input_stimulut(Vmult* mult, vluint64_t &simtime, uint32_t a_i, uint32_t b_i)
{
    mult->a_i = a_i;
    mult->b_i = b_i;
    mult->ld_input_i = 1;
    mult->resetn_i = 1;
}

int main(int argc, char** argv)
{
    Verilated::commandArgs(argc, argv);

    Vmult *mult = new Vmult;

    Verilated::traceEverOn(true);
    VerilatedVcdC *trace = new VerilatedVcdC;
    mult->trace(trace, 5);
    trace->open("mult.vcd");


    while (simtime < MAX_SIM_TIME)
    {
        mult->clk_i ^= 1;
        mult->eval();
        simtime++;
        trace->dump(simtime);
        if (mult->clk_i == 1)
        {
            cycles++;
        }
        input_stimulut(mult, simtime, 753, 91);
        mult->ld_input_i = 0;
        input_stimulut(mult, simtime, 0, 0);
        
    }
    trace->close();
    delete mult;
    exit(EXIT_SUCCESS);
    

}