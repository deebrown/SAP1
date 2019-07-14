`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Register (ex. RegB, RegC)
// Description: Based on SAP-1 architecture, Digital Computer Electronics, Fig 8-1
//////////////////////////////////////////////////////////////////////////////////

module register(
    input Clock,
    input [7:0] data_bus,
    output [7:0] alu_output,
    input enable_input
    );
    reg [7:0] register;
    
    //-------------Initial conditions-----------------------------
    initial 
    begin
        register <=8'b0000_0000; //initialize the counter to start a 0
    end
    
    //-------------Clock independent actions-----------------------------
    assign alu_output = register;
    
    //-------------Every clock cycle-----------------------------
    always @ (posedge Clock)
        begin //Determine whether to load value from DATABUS into the register
            if (enable_input)
                register = data_bus;
        end

endmodule