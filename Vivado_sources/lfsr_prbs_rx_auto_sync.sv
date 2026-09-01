`timescale 1ns / 1ps

module lfsr_prbs_rx_auto_sync #(
    parameter integer WIDTH = 7,
    parameter [WIDTH-1:0] TAPS = 7'h60, 
    parameter integer LOCK_MATCHES = 14
) (
    input  wire clk,
    input  wire rst_n,
    input  wire din,
    input  wire din_valid,
    output logic locked,
    output logic bit_error,
    output logic [WIDTH-1:0] lfsr_state
);

    logic [WIDTH-1:0] history;
    logic [31:0] match_count;
    
    // La predicción se hace sobre el estado actual del historial
    // En el TX: feedback = ^(state_reg & TAPS)
    wire prediction = ^(history & TAPS);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            locked <= 0;
            history <= 0;
            match_count <= 0;
            bit_error <= 0;
            lfsr_state <= 0;
        end else if (din_valid) begin
            bit_error <= 0;

            if (!locked) begin
                // Comparamos el bit que entra con la predicción del estado anterior
                if (din == prediction && history != 0) begin
                    if (match_count >= LOCK_MATCHES) begin
                        locked <= 1;
                        lfsr_state <= history; // Cargamos el estado que generó este bit
                    end else begin
                        match_count <= match_count + 1;
                    end
                end else begin
                    match_count <= 0;
                end
                
                // Actualizamos historial para la próxima predicción
                history <= {history[WIDTH-2:0], din};
                
            end else begin
                // MODO LOCKED
                // Predecimos cuál debería ser el bit según nuestro estado interno
                logic expected_bit;
                expected_bit = ^(lfsr_state & TAPS);
                
                // Comparamos (din es el feedback que generó el TX)
                if (din != expected_bit) begin
                    bit_error <= 1'b1;
                end
                
                // Avanzamos nuestro LFSR igual que el TX
                lfsr_state <= {lfsr_state[WIDTH-2:0], din}; 
            end
        end
    end
endmodule
