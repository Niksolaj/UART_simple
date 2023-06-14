`timescale 1 ns/1ps
module UART_RX_simple_tb;
  //DUT inputs
  reg clk_tb = 0;
  reg [7:0] byte_tb = 8'h88;
  reg serial_data_tb = 1;

  //Internals
  reg [3:0] state_tb = INIT;
  integer clock_count = 0;
  integer count_finish_tb = 0;
  //States
  parameter INIT = 0,
            SEND = 1,
            FINISH = 2;

  parameter FREQ_HZ = 33330000; //Change for other clk resource.
  parameter BAUD_RATE_TB = 115200;
  parameter SEND_BYTE_CLOCKS = 10 * FREQ_HZ/BAUD_RATE_TB;

  UART_RX_simple #(.BAUD_RATE(BAUD_RATE_TB),
                   .PARITY(0),
                   .STOP(1),
                   .CLK_FREQ_HZ( FREQ_HZ ))
                 dut(
                   .clk(clk_tb), //Input
                   .serial_rx(serial_data_tb), //Input
                   .rx_byte(), //Output
                   .uart_data_redy()//Output
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
        if( 290 <= clock_count && 2600 >= clock_count)
        begin
          if( 0 == clock_count % 289 )
            serial_data_tb <= ~serial_data_tb;
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
    $dumpfile("UART_RX_simple.vcd");
    $dumpvars(0, UART_RX_simple_tb);
    $dumpvars(0, dut);
  end


endmodule
