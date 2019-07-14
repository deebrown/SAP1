`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: OutputRegister
// Description: Based on SAP-1 architecture, Digital Computer Electronics, Fig 8-1
//////////////////////////////////////////////////////////////////////////////////

module OutputRegister(
    input Clock,
    input [7:0] data_bus,
    input enable_input,
    output [7:0] out_display
    );
    reg [7:0] register;
    
    //-------------Initial conditions-----------------------------
    initial 
    begin
        register <= 8'd0;
    end

    //-------------Clock independent actions-----------------------------
    assign out_display = register;
    
    //-------------Every clock cycle-----------------------------
    always @ (posedge Clock)
    begin //Determine whether to load value from DATABUS into the register
        if (enable_input)
            register = data_bus;
    end

endmodule
