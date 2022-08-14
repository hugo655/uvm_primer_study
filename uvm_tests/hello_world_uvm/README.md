# UVM Hello World

This code aims to build the very basic boiler plait to run a simulation in SystemVerilog using uvm library.

To use this as a foundation, one must populate all the classes within `my_pkg.sv` file. The entry point for this simulation
is the method `run_test()` inside `top.sv`. When calling the program, make sure to add `+UVM_TESTNAME=<uvm_test_file>` in the command
line argument. For example:

* `xrun -64 xrun -64 -access +rw -sysv my_pkg.sv -uvm  top.sv +UVM_TESTNAME=main_test`


In this case, it is expected to have one class called `main_test` included in `my_pkg`. 
