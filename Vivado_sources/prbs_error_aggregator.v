`timescale 1ns / 1ps


module prbs_error_aggregator (
    input  wire clk,
    input  wire rst_n,
    
    // Entradas de los 8 receptores
    input  wire [7:0] bit_errors_in, 
    input  wire       din_valid,      // valid del receptor OFDM
    input  wire       clear_counters, // Reset manual 
    
    // Salidas para visualización y cálculo de BER
    output reg  [63:0] total_error_count,
    output wire [31:0] total_error_high,
    output wire [31:0] total_error_low,
    
    output reg  [63:0] total_bits_count,
    output wire [31:0] bits_count_high,
    output wire [31:0] bits_count_low,
    output wire [7:0]  individual_errors_sync
);

    assign individual_errors_sync = bit_errors_in;
    assign bits_count_low  = total_bits_count[31:0];
    assign bits_count_high = total_bits_count[63:32];
    
    assign total_error_low  = total_error_count[31:0];
    assign total_error_high = total_error_count[63:32];

    // Lógica para contar cuántos errores hay en este ciclo (0 a 8)
    reg [3:0] errors_this_cycle;
    integer i;

    always @(*) begin
        errors_this_cycle = 0;
        // Solo contamos errores si la señal valid es alta
        if (din_valid) begin
            for (i = 0; i < 8; i = i + 1) begin
                if (bit_errors_in[i]) begin
                    errors_this_cycle = errors_this_cycle + 1;
                end
            end
        end
    end

    // Acumuladores
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            total_error_count <= 64'd0;
            total_bits_count  <= 64'd0;
        end else if (clear_counters) begin
            total_error_count <= 64'd0;
            total_bits_count  <= 64'd0;
        end else if (din_valid) begin
            // Sumamos los errores encontrados
            total_error_count <= total_error_count + errors_this_cycle;
            // Sumamos los 8 bits que se han procesado en este ciclo
            total_bits_count  <= total_bits_count + 64'd8;
        end
    end

endmodule
