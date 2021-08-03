`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 04:18:03 PM
// Design Name: 
// Module Name: Accumulator_control_FSM
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


module Accumulator_control_FSM(
        input active,
        input clk,
        input reset_n,
        output reg [1:0]address_r,
        output reg load,
        output done
    );
    
        reg [3:0] state_reg, state_next;
    parameter s0 = 0, s1 = 1, s2 = 2, s3 =3,s4 = 4,s5=5,s6=6,s7=7,s8=8;
    
    // Sequential state registers
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            state_reg <= s0;
        else
            state_reg <= state_next;
    end
    
    // Next state logic
    always @(*)
    begin
        case(state_reg)
            s0: if (active) state_next = s1;
                else       state_next = s0;
            s1: state_next = s2; 
            s2: state_next = s3;
            s3: state_next = s4;
            s4: state_next = s5;
            s5: state_next = s6;
            s6: state_next = s7;
            s7: state_next = s8;
            s8: state_next = s0;
            default: state_next = s0;                
        endcase
    end
    
    // Output logic

    always@(*) begin
        load = 0;
        address_r = 0;    
        
        if(state_reg == s1 | state_reg == s3 | state_reg == s5 | state_reg == s7 )
            load = 1;
        else
            load = 0;
        if((state_reg == s2) | (state_reg == s3))
            address_r = 1;   
        else if((state_reg == s4) | (state_reg == s5)) 
            address_r = 2;   
        else if((state_reg == s6) | (state_reg == s7)) 
            address_r = 3;   
        else
            address_r = 0;    
    end
    
    assign done = (state_reg == s8);
    
endmodule
