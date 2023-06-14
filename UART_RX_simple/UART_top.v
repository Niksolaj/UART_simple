module UART_top(
    input wire clk,
    input wire serial_rx,
    output reg led1 = 0,
    output reg led2 = 0,
    output reg led3 = 0,
    output reg led4 = 1,
    output wire serial_debug_pin
  );
  //uart in/outs
  wire [7:0] rx_byte;
  wire data_ready;


  //Internals
  reg [11:0] clock_count = 0;
  reg [7:0] command_byte = 0;

  //States
  parameter NOP = 8'h00,
            TOGLE_LED1 = 8'h61;

  parameter FREQ_HZ = 33330000; //Change for other clk resource.
  parameter BAUD_RATE_TB = 115200;
  parameter SEND_BYTE_CLOCKS = 10 * FREQ_HZ/BAUD_RATE_TB;

  UART_RX_simple #(.BAUD_RATE(BAUD_RATE_TB),
                   .PARITY(0),
                   .STOP(1),
                   .CLK_FREQ_HZ( FREQ_HZ ))
                 uart(
                   .clk(clk),
                   .serial_rx(serial_rx),
                   .rx_byte(rx_byte),
                   .uart_data_redy(data_ready)
                 );


  always@(posedge data_ready)
  begin

    command_byte = rx_byte;

    case(command_byte)

      NOP:
      begin
      end

      TOGLE_LED1:
        led1 <= ~led1; 

    endcase
  end

assign serial_debug_pin = serial_rx;

endmodule
