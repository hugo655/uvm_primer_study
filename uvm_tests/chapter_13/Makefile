help:
	@echo "run:" 
	@echo "	-> make add_test to run add_test" 
	@echo "	-> make random_test to run random"

add_test:
	xrun -64 -access +rw -sysv tiny_alu_pkg.sv tinyalu_bfm.sv -uvm design.sv top.sv +UVM_TESTNAME=add_test

random_test:
	xrun -64 -access +rw -sysv tiny_alu_pkg.sv tinyalu_bfm.sv -uvm design.sv top.sv +UVM_TESTNAME=random_test

clean:
	rm -rf xrun.history xrun.log xcelium.d dump.vcd
