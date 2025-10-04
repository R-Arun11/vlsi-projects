module mac_4x4_tb;

    reg clk, rst, en;
    reg [3:0] a, b;
    wire [15:0] mac_out;

    // Instantiate the MAC
    mac_4x4 uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .a(a),
        .b(b),
        .mac_out(mac_out)
    );

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test input values
    reg [3:0] a_vals[0:4];
    reg [3:0] b_vals[0:4];
    integer expected_result;
    integer i;

    initial begin
        // Initialize
        rst = 1;
        en = 0;
        a = 0;
        b = 0;
        expected_result = 0;

        // Example multiply-accumulate pairs:
        // 4×3 = 12
        // 2×2 = 4
        // 1×5 = 5
        // 3×3 = 9
        // Total = 30
        a_vals[0] = 4; b_vals[0] = 3;
        a_vals[1] = 2; b_vals[1] = 2;
        a_vals[2] = 1; b_vals[2] = 5;
        a_vals[3] = 3; b_vals[3] = 3;
        a_vals[4] = 0; b_vals[4] = 0;  // idle input

        #12 rst = 0;  // release reset

        // Apply inputs with enable
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            en = 1;
            a = a_vals[i];
            b = b_vals[i];
        end

        // Stop feeding inputs
        @(posedge clk);
        en = 0;
        a = 0;
        b = 0;

        // Let pipeline finish (3 extra cycles)
        repeat (5) @(posedge clk);

        expected_result = 4*3 + 2*2 + 1*5 + 3*3;  // = 30
        $display("Expected MAC result: %d", expected_result);
        $display("Actual MAC result:   %d", mac_out);

        if (mac_out == expected_result)
            $display("MAC test PASSED");
        else
            $display("MAC test FAILED");

        $finish;
    end

endmodule

