DUT_module = UART_TX_simple.v
testbench = UART_TX_simple_tb.v
top_module = UART_TX_simple_tb
GTKW_savefile = testbench_save.gtkw
VCD_dumpfile = UART_TX_simple.vcd
tb_log = UART_TX_simple_tb_log.txt


rtlsim:
	iverilog $(DUT_module) $(testbench) -s $(top_module) -o $(top_module)

run: rtlsim
	./$(top_module)

gtkwave: run
	gtkwave $(VCD_dumpfile) $(GTKW_savefile)

clean:
	rm $(top_module)
	rm $(VCD_dumpfile)

