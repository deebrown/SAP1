`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: ProgramCounter
// Description: Based on SAP-1 architecture, Digital Computer Electronics, Fig 8-1
//////////////////////////////////////////////////////////////////////////////////


module ProgramCounter(
    input   Clock,
    input   Clear,
    input   enable_output, //Flag, output register onto bus 
    input   enable_increment, //Flag, increment program counter
    output  [7:0] databus,
    output  [3:0] PC_bus
    );
    reg [3:0] reg_pc;       
    
    //-------------Initial conditions-----------------------------
    initial 
    begin
        reg_pc <=4'b0000; //initialize the counter to start a 0
    end

    //-------------Output to databus condition-----------------------------
    assign databus = (enable_output) ? reg_pc : 8'bzzzz_zzzz; //if output is enabled, put out on the BUS
    assign PC_bus = reg_pc; //Always update LED indicators with current value
    
    //-------------perform action every positive edge of the clock----------
    always @ (posedge Clock or posedge Clear)
    begin
        if(Clear)
            reg_pc = 0; //if Clear = 1, reset register to 0
        else if (enable_increment) //if EP =1, increment PC by 1
            reg_pc = reg_pc+1;
    end

endmodule