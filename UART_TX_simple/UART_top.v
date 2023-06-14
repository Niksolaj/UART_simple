module UART_top(
    input wire clk,
    output wire serial_tx,
    output wire serial_tx_tp //DEBUG

  );
  //uart in/outs
  reg [7:0] byte_to_send = 8'h00;
  reg send = 0;
  wire uart_sending_byte;


  //Internals
  reg [3:0] state = INIT;
  reg [3:0] char_cnt = 0;
  reg [11:0] clock_count = 0;

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
                 uart(
                   .clk(clk),
                   .tx_byte(byte_to_send),
                   .send_byte(send),
                   .serial_tx(serial_tx),
                   .sending_byte(uart_sending_byte)
                 );

  assign serial_tx_tp = serial_tx ; //DEBUG

  always@(posedge clk)
  begin

    case(state)

      INIT:
      begin
        byte_to_send <= byte_to_send + 1;
        send <= 0;
        state <= SEND;
      end

      SEND:
      begin
        send <= 1;
        if( uart_sending_byte )
        begin
          send <= 0;
          state <= FINISH;
        end
      end

      FINISH:
      begin
        if( !uart_sending_byte )
        begin
          state <= INIT;
        end
      end

    endcase


  end



endmodule
