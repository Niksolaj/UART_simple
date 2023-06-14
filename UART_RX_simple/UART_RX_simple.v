module UART_RX_simple#(parameter BAUD_RATE = 115200,
                         parameter PARITY = 0,
                         parameter STOP = 1,
                         parameter CLK_FREQ_HZ = 33330000
                        )(
                          input wire clk, //CLK_FREQ_HZ is this frequency
                          input wire serial_rx,
                          output reg [7:0] rx_byte = 0,
                          output reg uart_data_redy
                        );

  reg [3:0] bit_state = IDLE;
  reg [3:0] bit_count = 0;
  reg [9:0] uart_clk_divider = 0;
  reg uart_clk = 0;

  //Bit states
  parameter IDLE = 0,
            START_BIT = 1,
            DATA_BITS = 2,
            PARITY_BIT = 3,
            STOP_BIT = 4;


  parameter BAUD_RATE_HALV_PERIOD_IN_CLKS = CLK_FREQ_HZ/(BAUD_RATE*2);

  //UART clk
  always@(posedge clk)
  begin
    uart_clk_divider <= uart_clk_divider + 1;

    if( IDLE != bit_state )
    begin
      if( BAUD_RATE_HALV_PERIOD_IN_CLKS <= uart_clk_divider )
      begin
        uart_clk <= ~uart_clk;
        uart_clk_divider <= 0;
      end
    end
    else if( (IDLE == bit_state) && (0 == serial_rx) )
    begin
      uart_clk <= 1;
      uart_clk_divider <= 0;
    end
    else
    begin
      uart_clk <= 0;
      uart_clk_divider <= 0;
    end
  end

  //UART statemachine
  always@(posedge uart_clk)
  begin
    bit_count <= bit_count + 3'd1;
    case(bit_state)

      IDLE:
     begin
        uart_data_redy <= 0;
        bit_state <= START_BIT;
      end

      START_BIT:
      begin
        bit_state <= DATA_BITS;
      end

      DATA_BITS:
      begin
        if( 9 <= bit_count )
        begin
          if(PARITY)
            bit_state <= PARITY_BIT;
          else
          begin
            uart_data_redy <= 1;
            bit_state <= STOP_BIT;
          end

        end
      end

      PARITY_BIT:
      begin
        bit_state <= STOP_BIT;
      end

      STOP_BIT:
      begin
        bit_count <= 0;
        bit_state <= IDLE;
      end
    endcase
  end

  //Make the received byte
  always@(negedge uart_clk)
  begin
    if(DATA_BITS == bit_state )
    begin
        rx_byte <= { serial_rx, rx_byte[7:1] };
    end
  end

endmodule
