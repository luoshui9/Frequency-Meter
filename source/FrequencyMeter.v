`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 03:59:46 PM
// Design Name: 
// Module Name: FrequencyMeter
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


module FrequencyMeter(
        input [15:0]i,
        input clk,
        input reset_n,
        output [7:0]AN,                             //seven-segment selector output
        output DP,
        output [6:0]sseg
    );
        
     wire [24:0]measured,data_r,avgValue;   
     wire measurementDone;       
     wire level;
     wire tick;
     
    timer_input #(16) signalGen(
         .clk(clk),
         .reset_n(reset_n),
         .enable(1),
         .FINAL_VALUE(i),       // using switches to control the period. 
    //    output [BITS - 1:0] Q,
        .done(level)
    );
    
    FrequncyMeasurement measurement(
         .clk(clk),
         .level(level),
         .reset_n(reset_n),
         .measured(measured),
         .done(measurementDone)
    );

    wire [1:0]address_w;
    wire [1:0]address_r;
    udl_counter #(.BITS(2)) addressCounter(
         .clk(clk),
         .reset_n(reset_n),
         .enable(measurementDone),
         .up(1), //when asserted the counter is up counter; otherwise, it is a down counter
         .load(0),
         .D(),
         .Q(address_w)
        );  
        
    reg_file #(.ADDR_WIDTH(2), .DATA_WIDTH(25)) register(
         .clk(clk),
         .we(measurementDone),
         .address_w(address_w), 
         .address_r(address_r),
         .data_w(measured),
         .data_r(data_r)    
        );   
              
    wire active;
    
    localparam period = 50_000_000;
    timer_input #($clog2(period)+1) timer(
         .clk(clk),
         .reset_n(reset_n),
         .enable(1),
         .FINAL_VALUE(period),
    //    output [BITS - 1:0] Q,
        .done(active)
    );

   wire avgDone;
   Avg_computer avgCom(
         .clk(clk),
         .active(active),
         .reset_n(reset_n),
         .data(data_r),
         .address_r(address_r),
         .done(avgDone),
         .avg(avgValue)
    );    
   wire [24:0]avgKeep; 
   reg_file #(.ADDR_WIDTH(0), .DATA_WIDTH(25)) dataKeeper(
         .clk(clk),
         .we(avgDone),
         .address_w(1'b0), 
         .address_r(1'b0),
         .data_w(avgValue),
         .data_r(avgKeep)    
        );   
    
    wire [25:0]freq = avgKeep > 0 ? ({1'b0,avgKeep} - 1) * 2 : 'b0;

    wire [31:0] BCD;
    
    bin2bcd #(.W(26)) btob(  
         .bin(freq), 
         .bcd(BCD)   
     ); // bcd {...,thousands,hundreds,tens,ones}
    
     sseg_driver #(.DesiredHz(10000),.ClockHz(100_000_000)) driver
    (
         .clk(clk),
         .reset_n(reset_n),
         .i0({1'b1,BCD[3:0],1'b1}),
         .i1({1'b1,BCD[7:4],1'b1}),
         .i2({1'b1,BCD[11:8],1'b1}),
         .i3({1'b1,BCD[15:12],1'b1}),
         .i4({1'b1,BCD[19:16],1'b1}),
         .i5({1'b1,BCD[23:20],1'b1}),
         .i6({1'b1,BCD[27:24],1'b1}),
         .i7({1'b1,BCD[31:28],1'b1}),         //numbers
         .AN(AN),                             //seven-segment selector output
         .DP(DP),
         .sseg(sseg)
    );
    
endmodule
