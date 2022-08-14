
help:
	@echo "type \`make run\` to simulate" 
run:
	xrun -64 -access +rw -sysv my_pkg.sv -uvm  top.sv +UVM_TESTNAME=main_test

clean:
	rm -rf xrun.history xrun.log xcelium.d dump.vcd
