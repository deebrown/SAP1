`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: InstructionRegister
// Description: Based on SAP-1 architecture, Digital Computer Electronics, Fig 8-1
//////////////////////////////////////////////////////////////////////////////////


module InstructionRegister(
    input Clock,
    input Clear,
    input enable_input,
    input enable_output,
    inout [7:0] data_bus,  //8bit input, 4 bit output
    output [3:0] controller
    );
    reg [7:0] register;


    //-------------Initial conditions-----------------------------
    initial 
    begin
        register <=8'b0000_0000; //initialize the register to start at 0
    end
    
    //-------------Clock independent actions-----------------------------
    assign data_bus = (enable_output) ? (8'h0F & register) : 8'bzzzz_zzzz; //If enabled, place data onto BUS
    assign controller = register[7:4]; //Pass on opcode to Control Sequence
    
    //-------------Every clock cycle-----------------------------
    always @ (posedge Clock or posedge Clear)
    begin //Determine whether to load value from DATABUS into the register
        if(Clear)
            register = 0;
        else if (enable_input)
            register = data_bus;
    end

endmodule
