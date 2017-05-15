`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Happy Napalm
// Engineer: Church
// 
// Create Date: 03/17/2017 10:40:43 AM
// Design Name: 
// Module Name: Fifo_problem_2a
// Project Name: 499 Final
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////
//This design is for a same clock speed FIFO.
//Module 1 passes to FIFO that is then picked by Module 2
//Read cannot read until Write, but Write can pass Read
//Will OVERWRITE information if Read is SLOWER than Write
//Will STALL Read if Read is FASTER than Write
//If Busy flag is passed to Module 2, then the clock speed can be accounted for. It will still operate if the information is passed slowly

module Fifo_problem_2a(Busy,Full_Flag,Read_Data,Write_Data,Read_Clk,Write_Clk,rst_n);
    input Read_Clk,Write_Clk;                                       //Dual Input Clocks to drive the read and write buses
    input rst_n;                                                    //Negative Edge Reset Input
    input [15:0] Write_Data;                                        //16 wide input bus
    output [15:0] Read_Data;                                        //16 wide output bus
    output Full_Flag;                                               //Full flag
    output Busy;                                                    //A stall while filling the buffer
    
    reg Read_Ptr = 0, Write_Ptr = 0, 
        Read_Next = Read_Ptr + 1, Write_Next = Write_Ptr + 1;       //pointer establishing stuff
    reg [1023:0] data_bus;                                          //address bus of information. Might not work
    
    always@(posedge Write_Clk or negedge rst_n)                     //On Write Clock Pulse Up, or Release of Reset
        begin
            if (rst_n)                                              //reset the system,  
                begin
                    Read_Ptr <= 0;                                  //Reset Pointer
                    Write_Ptr <= 0;                                 //Reset Pointer
                    data_bus <= 1024'b0;                            //Reset Data Bus
                end
            else
                begin
                    if (Write_Ptr == 1023)                          //If Write Ptr hits top of data bus
                        begin
                            Write_Ptr = 0;                          //Set Write Ptr back to zero
                        end
                    else
                        begin    
                            data_bus[Write_Ptr] <= Write_Data;      //Data bus item tied to write ptr gets incoming data if not reset and not address 1023
                        end    
                end
        end
                                                                    //Use falling edge to adjust the ptr
    always@(negedge Write_Clk)                                      //On Write Clock Pulse Down
        begin
            if(data_bus[Write_Ptr] != 0)                            //If data bus item tied to Write ptr is not equal to Zero
                begin
                    Write_Ptr <= Write_Next;                        //Write Ptr increments
                end
            Write_next = Write_Ptr + 1;                             //Write next increments for next loop, will not increment if Reset
        end
        
    always@(posedge Read_Clk)                                       //On Rising Edge of Read Clock
        begin
            if(Write_Ptr == Read_Ptr)                               //Check if Write_Ptr equals Read_Ptr
                    begin
                        Busy <= 1;                                  //If True then Busy Flag is raised and nothing else happens
                    end
                else 
                    begin
                        Busy <= 0;                                  //If False, then Busy Flag lowered
                    end
            if (Busy == 0)                                          //If the Busy Flay is lowered
            begin
                Read_Data <= data_bus[Read_Ptr];                    //Read_Data gets Data Bus item tied to Read_Ptr
            end
        end
    always@(negedge Read_Clk)                                       //On Falling Edge of Read Clock
        begin
            if (Busy == 0)                                          //Check the Busy Flag
                begin
                    Read_Ptr <= Read_Next;                          //If Busy flag is lowered, increment the Read_Ptr
                end
            Read_Next = Read_Ptr + 1;                               //Increment the Read_Ptr, will not increment if Reset of stalled with Busy Flag
        end


endmodule
