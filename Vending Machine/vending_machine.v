module vending_machine (
    input clk,
    input rst,
    input cancel,
    input [1:0] product_select, // 00: A, 01: B, 10: C
    input [1:0] coin_input,     // 01: 5, 10: 10 (in units)
    output reg dispense_A,
    output reg dispense_B,
    output reg dispense_C,
    output reg [5:0] change_return // Amount of change returned
);

// Parameters for product prices (in units)
parameter PRICE_A = 5;
parameter PRICE_B = 10;
parameter PRICE_C = 20;

// Internal registers
reg [5:0] balance;
reg [3:0] stock_A;
reg [3:0] stock_B;
reg [3:0] stock_C;

reg [1:0] prev_product_select;

// Coin value decoder
wire [5:0] coin_value;
assign coin_value = (coin_input == 2'b01) ? 5 :
                    (coin_input == 2'b10) ? 10 : 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        balance <= 0;
        dispense_A <= 0;
        dispense_B <= 0;
        dispense_C <= 0;
        change_return <= 0;

        // Reset inventory
        stock_A <= 4;
        stock_B <= 3;
        stock_C <= 2;

        prev_product_select <= 2'b11; // Invalid initial value
    end 
    else begin
        // Reset outputs every clock cycle
        dispense_A <= 0;
        dispense_B <= 0;
        dispense_C <= 0;
        change_return <= 0;

        // Add coin if inserted
        if (coin_value > 0)
            balance <= balance + coin_value;

        // Handle cancel first (priority over purchase)
        if (cancel) begin
            change_return <= balance;
            balance <= 0;
        end
        else begin
            // Handle product selection only on rising edge (to avoid repeat dispensing)
            if (product_select != prev_product_select) begin
                case (product_select)
                    2'b00: begin // Product A
                        if (balance >= PRICE_A && stock_A > 0) begin
                            dispense_A <= 1;
                            balance <= balance - PRICE_A;
                            stock_A <= stock_A - 1;
                        end
                    end
                    2'b01: begin // Product B
                        if (balance >= PRICE_B && stock_B > 0) begin
                            dispense_B <= 1;
                            balance <= balance - PRICE_B;
                            stock_B <= stock_B - 1;
                        end
                    end
                    2'b10: begin // Product C
                        if (balance >= PRICE_C && stock_C > 0) begin
                            dispense_C <= 1;
                            balance <= balance - PRICE_C;
                            stock_C <= stock_C - 1;
                        end
                    end
                endcase
            end
        end

        // Track previous product select for edge detection
        prev_product_select <= product_select;
    end
end

endmodule

