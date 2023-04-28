module traffic_control(A_lights,B_lights,clk,rst_a,num_out,swe);
   
   input [1:0] swe;
   output reg [3:0] num_out;
   output reg [2:0] A_lights,B_lights; 
   input      clk;
   input      rst_a;
   reg [2:0] state;
   reg check0=0,check1=0,check2 = 0;
 
   parameter [1:0] One=2'b00;
   parameter [1:0] Two=2'b01;
   parameter [1:0] Three=2'b10;
   parameter [1:0] Four=2'b11;
   //reg clk_d;

   reg [2:0] count;
   
   //wire clk_out;
   
   //clockDiv clockDiv(clk,clk_out); //uncomment this line to test on FPGA. It scale the 125 MHz clk down to 1 Hz clk_out
   
   always @(posedge clk, posedge rst_a) //CHANGE: clk: testbench; clk_out: FPGA testing
     begin
     check0 = 0;
     check1 = 0;
     check2 = 0;
        if (rst_a)
            begin
                state=One;
                count =3'b000;
                num_out = 4'd7;
            end
        else if (!rst_a && swe == 2'b00)
            begin
                case (state)
                One :
                    begin
                        if (count==3'b111)
                            begin
                            count=3'b000;
                            num_out = 4'd3;
                            state=Two;
                            end
                        else
                            begin
                            count=count+3'b001;
                            num_out = num_out - 4'd1;
                            state=One;
                            end
                    end

                Two :
                    begin
                        if (count==3'b011)
                            begin
                            count=3'b000;
                            num_out = 4'd11;
                            state=Three;
                            end
                        else
                            begin
                            count=count+3'b001;
                            num_out = num_out - 4'd1;
                            state=Two;
                        end
                    end

               Three :
                    begin
                        if (count==3'b111)
                            begin
                            count=3'b0;
                            num_out = 4'd3;
                            state=Four;
                            end
                        else
                            begin
                            count=count+3'b001;
                            num_out = num_out - 1'd1;
                            state=Three;
                        end
                    end

            Four :
                begin
                    if (count==3'b011)
                        begin
                        count=3'b0;
                        num_out = 4'd7;
                        state=One;
                        end
                    else
                        begin
                        count=count+3'b001;
                        num_out = num_out - 1;
                        state=Four;
                        end
                    end
            endcase
        end
        else if (!rst_a && swe == 2'b01)
        begin
        check0 = 1;
        state=Four;
        count =3'b011;
        num_out = 4'd0;
        end
        else if (!rst_a && swe == 2'b10)
        begin
        check1 = 1;
        state=Four;
        count =3'b011;
        num_out = 4'd0;
        end
        else if (!rst_a && swe == 2'b11)
        begin
        check2 = 1;
        state=Two;
        count =3'b011;
        num_out = 4'd0;
        end
    end 


always @(state)
     begin
         case (state)
            One :
                begin
                    A_lights = 3'b001;
                    B_lights = 3'b100;
                end

            Two :
                begin
                    if (check2 == 1)
                        begin
                        A_lights = 3'b001;
                        B_lights = 3'b100;
                        end
                    else
                        begin    
                    A_lights = 3'b101;
                    B_lights = 3'b100;
                        end
                end

            Three :
                begin
                    A_lights = 3'b100;
                    B_lights = 3'b001;
                end

            Four :
                begin
                if (check0 == 1)
                    begin
                    A_lights = 3'b101;
                    B_lights = 3'b101;
                    end
                else if (check1 == 1)
                    begin
                    A_lights = 3'b100;
                    B_lights = 3'b001;
                    end
                else
                    begin
                    A_lights = 3'b100;
                    B_lights = 3'b101;
                    end
                end
            endcase
     end
endmodule
