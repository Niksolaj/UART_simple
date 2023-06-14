`timescale 1 ns/1ps
module UART_top_tb;
  //DUT inputs
  reg clk_tb = 0;
  reg [7:0] byte_tb = 8'h88;
  reg serial_data_tb = 1;

  //Internals
  reg [3:0] state_tb = INIT;
  integer clock_count = 0;
  integer count_finish_tb = 0;
  integer bit_count = 0;

  //States
  parameter INIT = 0,
            SEND = 1,
            FINISH = 2;

  parameter FREQ_HZ = 33330000; //Change for other clk resource.
  parameter BAUD_RATE_TB = 115200;
  parameter SEND_BYTE_CLOCKS = 10 * FREQ_HZ/BAUD_RATE_TB;
  parameter PAYLOAD_BYTE = 8'h61;

  UART_top
    dut(
      .clk(clk_tb), //Input
      .serial_rx(serial_data_tb), //Input
      .led(), //Output
      .serial_debug_pin()//Output
    );



  always@(posedge clk_tb)
  begin
    clock_count <= clock_count + 1;
    case(state_tb)

      INIT:
      begin
        clock_count <= 0;
        serial_data_tb <= 0;
        state_tb <= SEND;
      end

      SEND:
      begin
        if( 287 <= clock_count && 2600 >= clock_count)
        begin
          if( 0 == clock_count % 289 )
          begin
            bit_count <= bit_count + 8'd1;
            serial_data_tb <= PAYLOAD_BYTE[bit_count];
          end
        end
        else
          if(2600 < clock_count)
          begin
            serial_data_tb <= 1;
            state_tb <= FINISH;
          end
      end

      FINISH:
      begin
        if(3500 <= clock_count)
          state_tb <= INIT;
      end

    endcase
  end

  //Clock
  always
  begin
    #15
     clk_tb = ~clk_tb;
    count_finish_tb = count_finish_tb + 1;
    if (count_finish_tb == 15'h4800)
    begin
      //#20 $fclose(logFile);

      $finish;
    end
  end

  //Dumpfile
  initial
  begin
    $dumpfile("UART_top.vcd");
    $dumpvars(0, UART_top_tb);
    $dumpvars(0, dut);
  end


endmodule
