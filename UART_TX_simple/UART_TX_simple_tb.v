`timescale 1 ns/1ps
module UART_TX_simple_tb;
  //DUT inputs
  reg clk_tb = 0;
  reg [7:0] byte_tb = 8'h88;
  reg send_tb = 0;

  //Internals
  reg [3:0] state_tb = INIT;
  reg [3:0] char_cnt = 0;
  reg [11:0] clock_count = 0;
  integer count_finish_tb = 0;
  //States
  parameter INIT = 0,
            SEND = 1,
            FINISH = 2;

  parameter FREQ_HZ = 33330000; //Change for other clk resource.
  parameter BAUD_RATE_TB = 115200;
  parameter SEND_BYTE_CLOCKS = 10 * FREQ_HZ/BAUD_RATE_TB;

  UART_TX_simple #(.BAUD_RATE(BAUD_RATE_TB),
                   .PARITY(0),
                   .STOP(1),
                   .CLK_FREQ_HZ( FREQ_HZ ))
                 dut(
                   .clk(clk_tb),
                   .tx_byte(byte_tb),
                   .send_byte(send_tb),
                   .serial_tx(),
                   .byte_sent()
                 );



  always@(posedge clk_tb)
  begin

    case(state_tb)
      INIT:
      begin
        send_tb <= 0;
        state_tb <= SEND;
      end

      SEND:
      begin
        send_tb <= 1;
        state_tb <= FINISH;
      end

      FINISH:
      begin
        clock_count <= clock_count + 1;
        if( SEND_BYTE_CLOCKS <= clock_count )
        begin
          clock_count <= 0;
          state_tb <= INIT;
        end
      end

    endcase


  end

  //Clock
  always
  begin
    #30
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
    $dumpfile("UART_TX_simple.vcd");
    $dumpvars(0, UART_TX_simple_tb);
    $dumpvars(0, dut);
  end


endmodule
