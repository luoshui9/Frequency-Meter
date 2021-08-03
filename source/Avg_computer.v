`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 04:15:13 PM
// Design Name: 
// Module Name: Avg_computer
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


module Avg_computer(
        input clk,
        input active,
        input reset_n,
        input [24:0]data,
        output [1:0]address_r,
        output done,
        output [24:0]avg
    );  
    wire load;
    wire [26:0]sum;
    
    Accumulator_control_FSM control(
         .active(active),
         .clk(clk),
         .reset_n(reset_n),
         .address_r(address_r),
         .load(load),
         .done(done)
    );
    
    accumulator_generic #(.BITS(27)) accumulator(
        .x({2'b00,data}),
        .op_set(0),
        .reset_n(~active),
        .clk(clk), 
        .load(load),
        .y(sum)
    );
    
    wire [26:0]shift = sum >> 2;
    assign avg = shift[24:0];
    
endmodule
