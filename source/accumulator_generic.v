`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 04:42:17 PM
// Design Name: 
// Module Name: accumulator_generic
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


module accumulator_generic #(parameter BITS = 4)(
        input [BITS-1:0]x,
        input op_set,
        input reset_n,
        input clk, load,
        output [BITS-1:0]y
    );
        
        wire [BITS-1:0] sum;                                     // the output of the adder
        wire loadInput = load | ~reset_n;                    //  if load = 1 or reset, then load.
        wire [BITS-1:0]D_input = reset_n ? sum : {(BITS-1){1'b0}};      // D_input would be Sum if not reset, 
                                                            //                  0000 if reset
        wire [BITS-1:0]q_reg;                                   // Output of the register
                
        simple_register_load #(BITS) registers
        (
            .clk(clk),
            .load(loadInput),
            .I(D_input),
            .Q(q_reg)
        );
        
        adder_subtractor #(.n(BITS)) adder
        (
             .x(q_reg), 
             .y(x),
             .add_n(op_set),
             .s(sum),
             .c_out(),
             .overflow()
        );
        
        assign y = q_reg;
    
endmodule
