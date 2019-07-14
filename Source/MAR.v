`timescale 1ns / 1ps
//`include "instructions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Memory address register + ROM
// Description: Based on SAP-1 architecture, Digital Computer Electronics, Fig 8-1
//////////////////////////////////////////////////////////////////////////////////


module MAR(
    input Clock,
    input enable_input,
    input enable_output,
    inout [7:0] data_bus
    );
    reg [3:0] ADDR;
    reg [7:0] ram [0:15]; // Memory array
    parameter LDA = 4'b0001;
    parameter ADD = 4'b0010;
    parameter SUB = 4'b0011;
    parameter OUT = 4'b0100;
    parameter HALT = 4'b1111;

//-------------Initial conditions-----------------------------
    initial 
    begin
        ADDR <=4'b0000; //initialize the counter to start a 0
        
        //Code resides here
        ram[0]  <= {LDA,  4'd13}; //LDA 13
        ram[1]  <= {OUT,  4'd00}; //OUT
        ram[2]  <= {ADD,  4'd14}; //ADD 14
        ram[3]  <= {OUT,  4'd00}; //OUT
        ram[4]  <= {SUB,  4'd15}; //SUB 15
        ram[5]  <= {OUT,  4'd00}; //OUT
        ram[6]  <= {HALT, 4'd00}; //HALT
        ram[7]  <= 8'b0000_0000; //
        ram[8]  <= 8'b0000_0000; //
        ram[9]  <= 8'b0000_0000; //
        ram[10] <= 8'b0000_0000; //
        ram[11] <= 8'b0000_0000; //
        ram[12] <= 8'b0000_0000; //
        ram[13] <= 8'd8; //Data 8
        ram[14] <= 8'd5; //Data 5
        ram[15] <= 8'd4; //Data 4
    end

    assign data_bus = (enable_output) ? ram[ADDR]: 8'bzzzz_zzzz;
    
    
    //-------------Every clock cycle-----------------------------
    always @ (posedge Clock)
        begin //Determine whether to load value from DATABUS into the register
            if(enable_input)
                ADDR = data_bus[3:0];
        end

endmodule
