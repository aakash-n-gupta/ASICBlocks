
`timescale 1ns / 1ns

module subtractor_tb;

    // Parameters
    parameter WIDTH = 8;

    // Inputs
    logic [WIDTH-1:0] a_i;
    logic [WIDTH-1:0] b_i;

    // Outputs
    logic [WIDTH-1:0] a_sub;
    logic [WIDTH-1:0] b_sub;

    // Instantiate Adder module
    subtractor #(WIDTH) DUT (.*);

    // Clock generation
    logic clk = 0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize inputs
        a_i = '0;   // Example values, change as needed
        b_i = '0;

        // Apply stimulus for a_i few clock cycles
        #12;

        // Dump VDC file
        // $dumpfile("output/subtractor.vcd");
        // $dumpvars(0, subtractor_tb);

        // Print header
        $display("Time\t a_i\t b_i\t a_sub\t b_sub");

        // Manual tests for edge cases
        a_i = '0;
        b_i = 255;
        #20;

        // Iterate through test cases
        repeat (100) begin
            // Print inputs
            $display("%0t\t %d\t %d\t %d\t %d", $time, a_i, b_i, a_sub, b_sub);

            // Change inputs for next iteration (Example: increment a_i)
            a_i = $urandom % (2**WIDTH);
            b_i = $urandom % (2**WIDTH);
            #10;
            // Wait for some time
        end
        // End simulation
        $finish;
    end

endmodule
