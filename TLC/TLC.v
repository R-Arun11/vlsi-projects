module TLC (
    input clk, rst,
    input Sa, Sb, Sc, Sd,  // Sensors
    output reg Ra, Ya, Ga,
    output reg Rb, Yb, Gb,
    output reg Rc, Yc, Gc,
    output reg Rd, Yd, Gd
);

    // Timing parameters
    parameter GTH = 8,   // Highway green duration
              GTS = 5,   // Service green duration
              YT = 2;   // Yellow duration (same for both)

    // FSM states
    parameter s0 = 2'b00,  // Highway Green
              s1 = 2'b01,  // Highway Yellow
              s2 = 2'b10,  // Service Green
              s3 = 2'b11;  // Service Yellow

    reg [1:0] state, next_state;
    reg [4:0] timer;

    // State & timer logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= s0;
            timer <= 0;
        end else begin
            state <= next_state;

            if (state != next_state)
                timer <= 0;
            else
                timer <= timer + 1;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case(state)
            // Highway green, Service red
            s0: if ((timer >= GTH - 1) && (Sb || Sd))
                    next_state = s1;
                else
                    next_state = s0;

            // Highway yellow, Service red
            s1: if (timer >= YT - 1)
                    next_state = s2;
                else
                    next_state = s1;

            // Service green, Highway red
            s2: if ((timer >= GTS - 1) && ((Sa || Sc) && ~(Sb || Sd)))
                    next_state = s3;
                else
                    next_state = s2;

            // Service yellow, Highway red
            s3: if (timer >= YT - 1)
                    next_state = s0;
                else
                    next_state = s3;

            default: next_state = s0;
        endcase
    end

    // Output logic (Moore FSM)
    always @(*) begin
        // Turn off all lights
        Ra = 0; Ya = 0; Ga = 0;
        Rb = 0; Yb = 0; Gb = 0;
        Rc = 0; Yc = 0; Gc = 0;
        Rd = 0; Yd = 0; Gd = 0;

        case (state)
            // Highway green, Service red
            s0: begin
                Ga = 1; Gc = 1;
                Rb = 1; Rd = 1;
            end

            // Highway yellow, Service red
            s1: begin
                Ya = 1; Yc = 1;
                Rb = 1; Rd = 1;
            end

            // Service green, Highway red
            s2: begin
                Ra = 1; Rc = 1;
                Gb = 1; Gd = 1;
            end

            // Service yellow, Highway red
            s3: begin
                Ra = 1; Rc = 1;
                Yb = 1; Yd = 1;
            end
        endcase
    end

endmodule

