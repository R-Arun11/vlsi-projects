module vending_machine_tb;

    // Inputs
    reg clk;
    reg rst;
    reg cancel;
    reg [1:0] product_select;
    reg [1:0] coin_input;

    // Outputs
    wire dispense_A;
    wire dispense_B;
    wire dispense_C;
    wire [5:0] change_return;

    // Instantiate the Unit Under Test (UUT)
    vending_machine uut (
        .clk(clk),
        .rst(rst),
        .cancel(cancel),
        .product_select(product_select),
        .coin_input(coin_input),
        .dispense_A(dispense_A),
        .dispense_B(dispense_B),
        .dispense_C(dispense_C),
        .change_return(change_return)
    );

    // Clock generator
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        $display("Starting Vending Machine Testbench");
        $monitor("Time: %0t | Balance Returned: %d | Dispense A: %b, B: %b, C: %b",
                 $time, change_return, dispense_A, dispense_B, dispense_C);

        // Initialize signals
        clk = 0;
        rst = 1;
        cancel = 0;
        product_select = 2'b11; // Invalid (no selection)
        coin_input = 2'b00;

        // Reset the machine
        #10;
        rst = 0;

        // === Test 1: Insert 5 ? Buy A ===
        #10;
        coin_input = 2'b01; // Insert 5
        #10;
        coin_input = 2'b00; // Stop inserting

        #10;
        product_select = 2'b00; // Select A
        #10;
        product_select = 2'b11; // De-select

        // === Test 2: Insert 10 ? Try C (should fail) ===
        #10;
        coin_input = 2'b10; // Insert 10
        #10;
        coin_input = 2'b00;

        #10;
        product_select = 2'b10; // Select C
        #10;
        product_select = 2'b11;

        // === Test 3: Insert 10 more ? Try C again (should work) ===
        #10;
        coin_input = 2'b10; // Insert 10 more
        #10;
        coin_input = 2'b00;

        #10;
        product_select = 2'b10; // Select C again
        #10;
        product_select = 2'b11;

        // === Test 4: Insert 10 ? Press Cancel ===
        #10;
        coin_input = 2'b10; // Insert 10
        #10;
        coin_input = 2'b00;

        #10;
        cancel = 1; // Press cancel
        #10;
        cancel = 0;

        // === Test 5: Try to buy B with no balance (should fail) ===
        #10;
        product_select = 2'b01; // Try Product B
        #10;
        product_select = 2'b11;

        // === Test 6: Inventory Depletion Test for Product A ===
        $display("\nInventory Depletion Test: Product A");

        // Buy product A 3 times (stock is 3 now)
        repeat (3) begin
            #10;
            coin_input = 2'b01; // Insert 5
            #10;
            coin_input = 2'b00;

            #10;
            product_select = 2'b00; // Select A
            #10;
            product_select = 2'b11; // De-select
        end

        // Try to buy product A 4th time (stock should be 0, no dispense)
        #10;
        coin_input = 2'b01; // Insert 5
        #10;
        coin_input = 2'b00;

        #10;
        product_select = 2'b00; // Select A (should NOT dispense)
        #10;
        product_select = 2'b11; // De-select

        // Press cancel to return coin
        #10;
        cancel = 1;
        #10;
        cancel = 0;

        #20;
        $display("Inventory depletion test complete.");
        #20;
        $display("Test complete.");
        $finish;
    end

endmodule

