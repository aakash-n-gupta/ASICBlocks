# ASIC Blocks

This the the next phase after SynthCraft, which is more heavily focused on synthesis and hardening more complex blocks using OpenROAD_flow_scirpts, evaluating PPA outcomes against design desisions at RTL Design stage and architecture stage.

## Repo orgainzation

Each directory in the base is a self contained project, oftern containing multiple verisons of a specific design.  
Tests, PPA results and rtl source is containded in the respective directories.

<!-- Add desing methodology section Highlighst from CV -->

## Greatest Common Divisor

### (Reference Design) 16-bit GCD from OpenROAD-flow-scripts

    finish critical path delay
    378.9124 ps

    finish report_design_area
    Design area 46 u^2 23% utilization.

    Number of cells:                302

### 16-Bit GCD with optimized datapath

    finish critical path delay
    522.3355 ps

    finish report_design_area
    Design area 101 u^2 13% utilization.

    Number of cells:                818

<!-- Add testbench workload results and show how the optimized design is faster??, for a larger workload -->

## FIFO Designs
Used asap7 fakeram to generate SRAM macro on chip. Created a SRAM based FIFO, which does require read and write pointers, unlike the FIFO [here](https://github.com/aakash-n-gupta/SynthCraft), which is register based and has implicit reads from the FIFO head.

### SRAM based FIFO

    finish critical path delay
    310.9659 ps

    finish report_design_area
    Design area 405 u^2 7% utilization.

    BUFx2_ASAP7_75t_R               9
    DFFHQNx1_ASAP7_75t_R           16
    fakeram7_256x32                 1

### Register based FIFO

    finish critical path delay
    724.2125 ps

    finish report_design_area
    Design area 3077 u^2 11% utilization.

    BUFx2_ASAP7_75t_R            1889
    DFFHQNx1_ASAP7_75t_R         4142

It is abundantly clear that using register (Flip-Flop) based is of no use!