`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: ALU
// Description: Based on SAP-1 architecture, Digital Computer Electronics, Fig 8-1
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    output [7:0] data_bus,
    input [7:0] regA,
    input [7:0] regB,
    input enable_ouput,
    input AddSub
    );

//-------------Clock independent actions-----------------------------
    assign data_bus = (enable_ouput) ? ((AddSub) ? (regA - regB) : (regA + regB)) : 8'bzzzz_zzzz;

endmodule

