`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Accumulator
// Description: Based on SAP-1 architecture, Digital Computer Electronics, Fig 8-1
//////////////////////////////////////////////////////////////////////////////////

module Accumulator(
    input   Clock,
    inout   [7:0] data_bus,
    output  [7:0] alu_output,
    input   enable_input,
    input   enable_output
    );
    reg [7:0] register;
    
    //-------------Initial conditions-----------------------------
    initial 
    begin
        register <=8'b0000_0000; //initialize the register to start at 0
    end
    
    //-------------Clock independent actions-----------------------------
    assign data_bus = (enable_output) ? register : 8'bzzzz_zzzz;
    assign alu_output = register;
    
    //-------------Every clock cycle-----------------------------
    always @ (posedge Clock)
        begin //Determine whether to load value from DATABUS into the register
            if (enable_input)
                register = data_bus;
        end

endmodule
