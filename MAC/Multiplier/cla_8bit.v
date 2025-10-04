module cla_8bit(
    input [7:0] a, b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [3:0] sum_low, sum_high;
    wire c4;
    wire P_low, G_low;
    wire P_high, G_high; // dummy wires for upper CLA

    // Lower 4-bit CLA
    cla_4bit cla_low (a[3:0], b[3:0], cin, sum_low, c4, P_low, G_low);

    // Upper 4-bit CLA
    cla_4bit cla_high (a[7:4], b[7:4], (G_low | (P_low & cin)), sum_high, cout, P_high, G_high);

    assign sum = {sum_high, sum_low};

endmodule

