`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: SAP1
// Description: Based on SAP-1 architecture, Digital Computer Electronics, Fig 8-1
//////////////////////////////////////////////////////////////////////////////////


module SAP1(
    input   ManualCLK,      //Manual pushbutton clock pulse
    input   CLK100MHZ,      //Onboard 100MHz clock
    input   CLK_SEL,        //Toggle switch to define which clock: manual or onboard
    input   RST_BTN,        //Pushbutton to Reset the program  
    output  LED0,            //Used to indicate clock pulse
    output  LED1,            //Used to indicate error
    output [7:0] OUT_DISP,
    output [2:0] T_STATE,
    output [3:0] PC_BUS
);
  
    // Buses and control signals
    wire        CLK;
    wire [7:0]  BUS;
    wire        RST;
    wire        fHLT;
    wire        fCP;
    wire        fEP;
    wire        fMI;
    wire        fRO;
    wire        fII;
    wire        fIO;
    wire        fAI;
    wire        fAO;
    wire        fSU;
    wire        fEU;
    wire        fBI;
    wire        fOI;
    wire [7:0]  ALU_A;
    wire [7:0]  ALU_B;
    wire [3:0]  BUS_CTRL;
    
    assign RST = ~RST_BTN;
    
   
    Clock Clock(
        .SysClock(CLK),
        .ClockSelect(CLK_SEL),
        .MasterClock(CLK100MHZ),
        .ManualClock(ManualCLK),
        .Clear(RST),
        .Halt(fHLT),
        .LEDClock(LED0)
        );

    ProgramCounter PC(
        .Clock(CLK),
        .Clear(RST),
        .enable_output(fCP),
        .enable_increment(fEP),
        .databus(BUS),
        .PC_bus(PC_BUS)
        );

    Accumulator RegA(
        .Clock(CLK),
        .data_bus(BUS),
        .alu_output(ALU_A),
        .enable_input(fAI),
        .enable_output(fAO)
        );

    register RegB(
        .Clock(CLK),
        .data_bus(BUS),
        .alu_output(ALU_B),
        .enable_input(fBI)
        );

    ALU ALU(
        .data_bus(BUS),
        .regA(ALU_A),
        .regB(ALU_B),
        .enable_ouput(fEU),
        .AddSub(fSU)
        );
 
    MAR MAR(
        .Clock(CLK),
        .enable_input(fMI),
        .enable_output(fRO),
        .data_bus(BUS)
        );

    OutputRegister Output(
        .Clock(CLK),
        .data_bus(BUS),
        .enable_input(fOI),
        .out_display(OUT_DISP)
        );

    InstructionRegister IR(
        .Clock(CLK),
        .Clear(RST),
        .enable_input(fII),
        .enable_output(fIO),
        .data_bus(BUS),
        .controller(BUS_CTRL)
    );
 
    ControllerSequence Controller(
        .Clock(CLK),
        .Clear(RST),
        .opcode(BUS_CTRL),
        .HLT(fHLT),
        .CP(fCP),
        .EP(fEP),
        .MI(fMI),
        .RO(fRO),
        .II(fII),
        .IO(fIO),
        .AI(fAI),
        .AO(fAO),
        .SU(fSU),
        .EU(fEU),
        .BI(fBI),
        .OI(fOI),
        .T_State(T_STATE),
        .error_LED(LED1)
        );

endmodule
