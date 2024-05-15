# ASIC Blocks

This the the next phase after SynthCraft, which is more heavily focused on synthesis and hardening more complex blocks using OpenROAD_flow_scirpts, evaluating PPA outcomes against design desisions at RTL Design stage and architecture stage.

## Repo orgainzation

Each directory in the base is a self contained project, oftern containing multiple verisons of a specific design.  
Tests, PPA results and rtl source is containded in the respective directories.


## Highlights

### SRAM based FIFO
Used asap7 fakeram to generate SRAM macro on chip. Created a SRAM based FIFO, which does require read and write pointers, unlike the FIFO [here](https://github.com/aakash-n-gupta/SynthCraft), which is register based and has implicit reads from the FIFO head.

**Add interesing findings and results**