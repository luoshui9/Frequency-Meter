`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2021 06:10:55 PM
// Design Name: 
// Module Name: clk_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_gen #(parameter N = 10) // N = period. So N = 10  <-> it takes 10 internal clock period to produce 1 output period
    (
    input clk_in,
    output reg clk_out
    );
    
    
    reg [ $clog2(N/2): 0] counter;
    reg [$clog2(N/2): 0] bound = N/2;
    
    initial begin
        clk_out = 0;
    end
    
    always @(posedge clk_in) begin
        counter <= counter + 1'd1;
        if(counter == bound) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
    end
endmodule
