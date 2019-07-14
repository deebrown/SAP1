`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Clock Module
// Description: Based on SAP-1 architecture, Digital Computer Electronics, Fig 8-1
//////////////////////////////////////////////////////////////////////////////////

module Clock(
    output SysClock,
    input ClockSelect,
    input MasterClock,
    input ManualClock,
    input Clear,
    input Halt,
    output LEDClock
    );
    reg creg = 1'b0;
    reg [24:0] ccnt = 25'd0;
    
    
    //-------------Clock independent actions-----------------------------
    assign SysClock = ClockSelect ? (creg & ~Halt) : (ManualClock & ~Halt);
    assign LEDClock = SysClock;
    
    //-------------Astable clock-----------------------------
    always @ (posedge MasterClock or posedge Clear)
    begin
        if (Clear)
        begin
            ccnt <= 0;
            creg <= 0;
        end
        else
        begin
            // 1Hz Clock
            {ccnt, creg} <= (ccnt == 25'd9_999_999) ? {25'd0, ~creg} : { ccnt + 1'b1, creg};
        end
    end
        

endmodule