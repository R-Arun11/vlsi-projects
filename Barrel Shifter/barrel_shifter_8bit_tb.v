module barrel_shifter_8bit_tb;

    reg  [7:0] data_in;
    reg  [2:0] smt;
    reg  [1:0] mode;
    wire [7:0] data_out;

    barrel_shifter_8bit uut (
        .data_in(data_in),
        .smt(smt),
        .mode(mode),
        .data_out(data_out)
    );

    task show;
        input [7:0] din;
        input [2:0] sa;
        input [1:0] md;
        input [7:0] dout;
        begin
            $display("Time=%0t | data_in=%b | smt=%0d | mode=%b (%0d) | data_out=%b",
                     $time, din, sa, md, md, dout);
        end
    endtask

    integer i;
    initial begin

        // -------- Directed tests --------
        data_in = 8'b10101010; smt = 3; mode = 2'b00; #10; show(data_in, smt, mode, data_out);
        data_in = 8'b10101010; smt = 2; mode = 2'b01; #10; show(data_in, smt, mode, data_out);
        data_in = 8'b11110000; smt = 1; mode = 2'b10; #10; show(data_in, smt, mode, data_out);
        data_in = 8'b11010101; smt = 3; mode = 2'b11; #10; show(data_in, smt, mode, data_out);

        // -------- Randomized tests --------
        for (i = 0; i < 10; i = i + 1) begin
            data_in = $random & 8'hFF;   // 8-bit random
            smt     = $random & 3'b111;  // 3-bit random (0-7)
            mode    = $random & 2'b11;   // 2-bit random (0-3)
            #10;
            show(data_in, smt, mode, data_out);
        end

        $finish;
    end

endmodule

