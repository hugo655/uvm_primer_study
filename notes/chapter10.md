# Chapter 10 - UVM Tests
As the author suggests, when building a testbench infrastructure using UVM, compiling code is performed only once. After that, different tests can be called by using the special argument `+UVM_TESTNAME=<name_of_the_test>`.

## Running UVM Simulation 
This might start to get tricky in terms of tools. So I decided to take the author's source code and run with a different simulator just to get acquainted with UVM regardless of the simulator. I was not sure if the argument `+UVM_TESTNAME` was a UVM feature or the Simulator. 

To do so, I put-up a short Makefile script tailored for the tool I have available Xcelium. This is the end result:

```
UVM_TESTNAME=add_test

run:
        xrun -f xrun.f +UVM_TESTNAME=$(UVM_TESTNAME)

clean:
        rm xrun.log xrun.history

clean_hard:
        rm -rf cov_work celium.d
```

The file `xrun.f` is a compilation of command line arguments that I wrote [based on this link](https://eda-playground.readthedocs.io/en/latest/compile_run_options.html). I tend to think that learning tools and framework is a bit intimidating, but for these demoing purposes, it shouldn't really be hard.

```
-64
-v200x

-coverage all -covoverwrite
+incdir+tb_classes
-uvm

tinyalu_dut/single_cycle_add_and_xor.vhd
tinyalu_dut/three_cycle_mult.vhd
tinyalu_dut/tinyalu.vhd

tinyalu_bfm.sv
tinyalu_pkg.sv

top.sv
```

As a result, I can simply call `make run UVM_TESTNAME=<name>` and Xcelium takes care of the rest. The cool thing about having a single command is that now I can benchmark how much time it takes to compile&run vs just compiling. I ran `time make run` to output the total amount of time it took-me to run each command
```
Compiling and Running 
real    0m3.871s
user    0m2.393s
sys     0m0.301s


Running Only - Either tests run under 1s
real    0m0.490s
user    0m0.295s
sys     0m0.075s
```


## Taking a look at the Author's Code

### Top Module
At this point we start to have contact with new code structures. As we read the code, keep in mind that most of these pieces of code are generated automatically by code generators. What we want achieve here is to **highlight some of the core concepts present in most (if not all) UVM-Based testbenches.**

```
   Copyright 2013 Ray Salemi

module top;
   import uvm_pkg::*;
`include "uvm_macros.svh"

   import   tinyalu_pkg::*;
`include "tinyalu_macros.svh"

   tinyalu_bfm       bfm();
   tinyalu DUT (.A(bfm.A), .B(bfm.B), .op(bfm.op),
                .clk(bfm.clk), .reset_n(bfm.reset_n),
                .start(bfm.start), .done(bfm.done), .result(bfm.result));

initial begin
  uvm_config_db #(virtual tinyalu_bfm)::set(null, "*", "bfm", bfm);
  run_test();
end

endmodule : top
```

This first structure `import ... include` is a common practice when using uvm packages. As a matter if fact, [pre-compiler directives (macros) are not stored inside packages](https://verificationacademy.com/forums/uvm/necessity-writing-include-uvmmacros.svh). It turns-out that when we are working with UVM we usually place this boiler plate in a lot of places. 

Another interesting piece of code is `uvm_config_db #(virtual tinyalu_bfm)::set(null, "*", "bfm", bfm);`. UVM developers defined this `static` classes and methods to create global variables that can be visible within a certain scope of the testbench. Essentially, it works by storing an element in a database and associating an id to it.  

The `*` represents the scope of visibility, in this case, the wildcard represents all hierarchies. `bfm` and `"bfm"` are the handler and string id associated with this memory address. It is common practice, to adopt the label name the same as the handler.

One last thing to note is that we now call the simulation by running a simple command `run_test()`. [In some other tutorials](https://sistenix.com/basic_uvm.html), there is an argument to this method, specifying the name of the test. Ideally, one leave this argument empty and define via the command-line-argument we have seen before `UVM_TESTNAME`. 

### Test Classes