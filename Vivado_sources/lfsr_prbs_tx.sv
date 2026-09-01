`timescale 1ns / 1ps

module lfsr_prbs_tx #(
    parameter WIDTH = 7,          
    parameter [31:0] TAPS = 96,  // 0x60 en decimal, selección de los bits de la XOR 
    parameter [31:0] SEED = 90   // 0x5A en decimal, punto de partida 
) (
    input  wire clk,
    input  wire rst_n,
    input  wire enable,
    output wire dout,
    output wire [WIDTH-1:0] state
);

    reg [WIDTH-1:0] state_reg;
    wire feedback;

    assign state = state_reg;
    assign dout  = state_reg[WIDTH-1];
    
    // Feedback -> XOR de los bits seleccionados por TAPS
    assign feedback = ^(state_reg & TAPS[WIDTH-1:0]);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg <= SEED[WIDTH-1:0];
        end else if (enable) begin
            state_reg <= {state_reg[WIDTH-2:0], feedback};
        end
    end

endmodule
