module TLC_tb;

    reg clk, rst;
    reg Sa, Sb, Sc, Sd;
    wire Ra, Ya, Ga;
    wire Rb, Yb, Gb;
    wire Rc, Yc, Gc;
    wire Rd, Yd, Gd;

    // Instantiate the DUT
    TLC uut (
        .clk(clk),
        .rst(rst),
        .Sa(Sa), .Sb(Sb), .Sc(Sc), .Sd(Sd),
        .Ra(Ra), .Ya(Ya), .Ga(Ga),
        .Rb(Rb), .Yb(Yb), .Gb(Gb),
        .Rc(Rc), .Yc(Yc), .Gc(Gc),
        .Rd(Rd), .Yd(Yd), .Gd(Gd)
    );

    // Color name strings for display
    reg [79:0] color_A, color_B, color_C, color_D;

    // Encoded light values for waveform viewing
    reg [1:0] light_A, light_B, light_C, light_D;

    // Encodings
    localparam R = 2'b00,
               Y = 2'b01,
               G = 2'b10;

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        // Initial values
        rst = 1;
        Sa = 0; Sb = 0; Sc = 0; Sd = 0;

        // Hold reset
        #10 rst = 0;

        // Add traffic to service roads (north-south)
        #10 Sb = 1; Sd = 1;

        // Add highway traffic later
        #100 Sa = 1; Sc = 1;

        // Clear service road traffic
        #100 Sb = 0; Sd = 0;

        // Let the simulation run longer
        #100;

        $display("Testbench finished.");
        $finish;
    end

    // Drive light_* based on outputs
    always @(*) begin
        light_A = Ra ? R : (Ya ? Y : (Ga ? G : 2'b11));
        light_B = Rb ? R : (Yb ? Y : (Gb ? G : 2'b11));
        light_C = Rc ? R : (Yc ? Y : (Gc ? G : 2'b11));
        light_D = Rd ? R : (Yd ? Y : (Gd ? G : 2'b11));
    end

    // Light status display at each clock cycle
    always @(posedge clk) begin
        // Assign color strings
        if (Ra) color_A = "RED   ";
        else if (Ya) color_A = "YELLOW";
        else if (Ga) color_A = "GREEN ";
        else         color_A = "OFF   ";

        if (Rb) color_B = "RED   ";
        else if (Yb) color_B = "YELLOW";
        else if (Gb) color_B = "GREEN ";
        else         color_B = "OFF   ";

        if (Rc) color_C = "RED   ";
        else if (Yc) color_C = "YELLOW";
        else if (Gc) color_C = "GREEN ";
        else         color_C = "OFF   ";

        if (Rd) color_D = "RED   ";
        else if (Yd) color_D = "YELLOW";
        else if (Gd) color_D = "GREEN ";
        else         color_D = "OFF   ";

        // Display current state
        $display("Time: %4t | A: %s  B: %s  C: %s  D: %s | Sensors Sa:%b Sb:%b Sc:%b Sd:%b",
            $time, color_A, color_B, color_C, color_D,
            Sa, Sb, Sc, Sd
        );
    end

endmodule

