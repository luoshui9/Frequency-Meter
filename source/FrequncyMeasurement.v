`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 04:00:44 PM
// Design Name: 
// Module Name: FrequncyMeasurement
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


module FrequncyMeasurement(
        input clk,
        input level,
        input reset_n,
        output [24:0]measured,
        output done
    );
    
    wire tick;
    wire p_edge;
    wire signalDone;
    assign done = signalDone;
    
    edge_detector edgeDetector(
         .clk(clk), 
         .reset_n(reset_n),
         .level(level),
         .p_edge(p_edge), 
         .n_edge(), 
         ._edge()
    );
    
    localparam period = 50_000_000;
    timer_input #($clog2(period)+1) timer(
     .clk(clk),
     .reset_n(reset_n),
     .enable(1),
     .FINAL_VALUE(period),
//    output [BITS - 1:0] Q,
    .done(signalDone)
    );
    

    
    reg resetDelay;
    
    always@(posedge clk,negedge reset_n) begin
        if(~reset_n)
            resetDelay <= 0;
        else
            resetDelay <= signalDone;
    end       
     
    udl_counter #(.BITS(25)) counter(
        .clk(clk),
        .reset_n(~resetDelay),
        .enable(p_edge),
        .up(1), //when asserted the counter is up counter; otherwise, it is a down counter
        .load(0),
        .D(),
        .Q(measured)
    );



    
    
endmodule
