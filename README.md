# UART_simple
UART_simple is written in verilog and may be the simplest UART implementation posible. It has two directories UART_TX_simple and UART_RX_simple.
##UART_TX_simple
The module takes three inputs clk (some clobal clock), 8 bit [7:0] tx_byte and a one pin signal send_byte. There are two outputs serial_tx that caries the serial 
signal and a pin sending_byte that can be used to prevent change of tx_byte while sending. The module also takes four parameters; BAUD_RATE, PARITY,STOP and CLK_FREQ_HZ.
The actual baud rate is produced from the clk input so this has to mach CLK_FREQ_HZ.

##UART_RX_simple
Takes two inputs clk and serial_rx. The clk has to be the frequency of parameter CLK_FREQ_HZ. Outputs are 8 bit rx_byte and uart_data_ready. Data on rx_byte are valid while uart_data_ready 
is high. uart_data_ready is high from stopbit to the next start bit.

##Testbenches
There are also committed testbenches for the modules.
