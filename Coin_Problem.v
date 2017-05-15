`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2017 02:56:59 PM
// Design Name: 
// Module Name: Coin_Problem
// Project Name: 
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


module Coin_Problem( Incorrect,Correct, cent_25, cent_10, cent_5, cent_1,rst_n);
    input   cent_25,
            cent_10,
            cent_5,
            cent_1
            ;
    input rst_n;
    output Incorrect;   //change dump
    output Correct;     //Motor enable
    
    reg sum;
    reg holder;
    //assign sum = 25*cent_25 + 10*cent_10 + 5*cent_5 + cent_1;
    always@(negedge rst_n)
        begin
            sum <= 0;
            holder <= 0;
            Correct <= 0;
            Incorrect <= 0;
        end
    always@(posedge cent_25)
        begin
            Correct <= 0;
            Incorrect <= 0;
            holder <= 25;
            sum <= holder + sum;
            if (sum == 51)
                begin
                    Correct <= 'b 1;
                end
            else if(sum > 51)
                begin
                    Incorrect <= 'b 1;
                end
        end
    always@(posedge cent_10)
        begin
            Correct <= 0;
            Incorrect <= 0;
            holder <= 10;
            sum <= holder + sum;
            if (sum == 51)
                begin
                    Correct <= 'b 1;
                end
            else if(sum > 51)
                begin
                    Incorrect <= 'b 1;
                end
        end
    always@(posedge cent_5)
        begin
            Correct <= 0;
            Incorrect <= 0;
            holder <= 5;
            sum <= holder + sum;
            if (sum == 51)
                begin
                    Correct <= 'b 1;
                end
            else if(sum > 51)
                begin
                    Incorrect <= 'b 1;
                end
        end
    always@(posedge cent_1)
        begin
            Correct <= 0;
            Incorrect <= 0;
            holder <= 1;
            sum <= holder + sum;
            if (sum == 51)
                begin
                    Correct <= 'b 1;
                end
            else if(sum > 51)
                begin
                    Incorrect <= 'b 1;
                end
        end

endmodule
