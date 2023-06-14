DUT_module = UART_RX_simple.v
testbench = UART_RX_simple_tb.v
top_module = UART_RX_simple_tb
GTKW_savefile = testbench_save.gtkw
VCD_dumpfile = UART_RX_simple.vcd
tb_log = UART_RX_simple_tb_log.txt


rtlsim:
	iverilog $(DUT_module) $(testbench) -s $(top_module) -o $(top_module)

run: rtlsim
	./$(top_module)

gtkwave: run
	gtkwave $(VCD_dumpfile) $(GTKW_savefile)

clean:
	rm $(top_module)
	rm $(VCD_dumpfile)


DUT_module = UART_top.v
testbench = UART_top_tb.v
top_module = UART_top_tb
DUT_submodule = UART_RX_simple.v
GTKW_savefile = top_testbench_save.gtkw
VCD_dumpfile = UART_top.vcd
tb_log = UART_top_tb_log.txt


rtlsim_top:
	iverilog $(DUT_module) $(testbench) $(DUT_submodule) -s $(top_module) -o $(top_module)

run_top: rtlsim_top
	./$(top_module)

gtkwave_top: run_top
	gtkwave $(VCD_dumpfile) $(GTKW_savefile)

clean_top:
	rm $(top_module)
	rm $(VCD_dumpfile)
