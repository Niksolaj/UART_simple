module UART_TX_simple#(parameter BAUD_RATE = 115200,
                         parameter PARITY = 0,
                         parameter STOP = 1,
                         parameter CLK_FREQ_HZ = 33330000)(
                           input wire clk,
                           input wire [7:0] tx_byte,
                           input wire send_byte,
                           output reg serial_tx = 0,
                           output reg sending_byte
                         );

  reg [7:0] byte_reg;
  reg [3:0] state = IDLE;
  reg [9:0] uart_clk_divider = 0;
  reg uart_clk = 0;
  reg [2:0] bit_cnt = 3'd0;

  //States
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
    if( BAUD_RATE_HALV_PERIOD_IN_CLKS <= uart_clk_divider )
    begin
      uart_clk <= ~uart_clk;
      uart_clk_divider <= 0;
    end
  end

  //UART
  always@(posedge uart_clk)
  begin
    case(state)

      IDLE:
      begin
        serial_tx <= 1;
        if( send_byte )
        begin
          byte_reg <= tx_byte;
          serial_tx <= 0;
          sending_byte <= 1;
          state <= START_BIT;
        end
      end

      START_BIT:
      begin
        serial_tx <= byte_reg[0];
        state <= DATA_BITS;
      end

      DATA_BITS:
      begin
        bit_cnt <= bit_cnt + 3'd1;

        if(7 > bit_cnt)
        serial_tx <= byte_reg[bit_cnt+1];
        else if( 7 == bit_cnt )
        begin
          bit_cnt <= 3'd0;
          if ( 1 == PARITY )
            state <= PARITY_BIT;
          else
            begin
              serial_tx <= 1;
            state <= STOP_BIT;
            end
        end
      end

      PARITY_BIT:
      begin
        state<= STOP_BIT;
      end

      STOP_BIT:
      begin
        state <= IDLE;
        sending_byte <= 0;
      end
    endcase
  end



endmodule
