`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: Controller Sequence
// Description: Based on SAP-1 architecture, Digital Computer Electronics, Fig 8-1
//////////////////////////////////////////////////////////////////////////////////

module ControllerSequence(
    input Clock,
    input Clear,
    input [3:0] opcode,
    output reg HLT,
    output reg CP,EP,
    output reg MI,
    output reg RO,
    output reg II, IO,
    output reg AI, AO,
    output reg SU, EU,
    output reg BI,
    output reg OI,
    output reg [2:0] T_State,
    output reg error_LED
    );

    parameter LDA = 4'b0001;
    parameter ADD = 4'b0010;
    parameter SUB = 4'b0011;
    parameter OUT = 4'b0100;
    parameter HALT = 4'b1111;
   
    typedef enum {T1, T2, T3, T4, T5, T6} statetype; //T-States
    statetype state, nextstate;
    
//-------------Initial conditions-----------------------------
    initial 
    begin
        HLT <= 1'b0;
        {CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI}<=12'b0;
        state <= T1;
        T_State <= 3'd0;
        error_LED <= 0;
    end
    
//-------------Next state logic-----------------------------
    always @ (posedge Clock)
    begin
            state <= nextstate;
    end
    
//-------------Every clock cycle-----------------------------
    always @ (negedge Clock or posedge Clear)
    begin
        if(Clear)
        begin
            {HLT,CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI}<=13'b0;
            nextstate <= T1;
            T_State <= 3'd0;
            error_LED <= 0;
        end            
        else
        begin
            error_LED <= 0;
            case (state)
                T1 : begin //CP | MI
                        T_State <= 3'd1;
                        {CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI}<=12'b1010_0000_0000;
                        nextstate <= T2;
                    end
                T2 : begin //RO | II | EP
                        {CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI}<=12'b0101_1000_0000;
                        T_State <= 3'd2;
                        nextstate <= T3;
                    end
                T3 : begin
                        T_State <= 3'd3;
                        case (opcode)
                            LDA, ADD, SUB : {CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI} <= 12'b0010_0100_0000; //MI|IO
                            OUT : {CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI} <= 12'b0000_0001_0001; // AO|OI
                            HALT : {HLT,CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI} <= 13'b1_0000_0000_0000; // HLT
                            default : error_LED <= 1;
                        endcase
                        nextstate <= T4;
                     end
                T4 : begin
                        T_State <= 3'd4;
                        case (opcode)
                            LDA : {CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI}<=12'b0001_0010_0000; //RO|AI 
                            ADD, SUB : {CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI}<=12'b0001_0000_0010; //RO|BI
                            OUT : {CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI}<=12'b0; //0;
                            HALT : HLT <=1;
                            default : error_LED <= 1;
                        endcase
                        nextstate <= T5;
                     end
                T5 : begin
                        T_State <= 3'd5;
                        case (opcode)
                            LDA,OUT : {CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI}<=12'b0; //0
                            ADD     : {CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI}<=12'b0000_0010_0100; //EU|AI
                            SUB     : {CP,EP,MI,RO,II,IO,AI,AO,SU,EU,BI,OI}<=12'b0000_0010_1100; //SU|EU|AI
                            HALT    : HLT <=1;
                            default : error_LED <= 1;
                        endcase
                        nextstate <= T1;
                     end
            endcase
        end    
    end
endmodule
