# Setting-up UVM

To set up UVM for this study program, one must set the linux env variable `$UVMHOME` to the path of the UVM directory of the UVM library provided with Cadence tools. 

```
setenv XCELIUM_ROOT "<path_to_XCELIUM>"
setenv PATH "${PATH}:${XCELIUM_ROOT}/tools/bin"
setenv UVMHOME "${XCELIUM_ROOT}/tools/methodology/UVM/CDNS-1.1d"
```

Typically the path to UVM is something like: `<XCELIUM_PATH>/tools/methodology/UVM/CDNS-1.1d/`

One the variable is set, one can access the UVM documentation in `$UVMHOME/sv/docs/html/index.html` or a `.pdf` version of it in the same directory.

The following piece of code can be used to test if UVM has been setup correctly:

```
module test;

import uvm::pkg::*;

`include "uvm_macros.svh"

class mytest extends uvm_test;
 `uvm_component_utils(mytest)

 function new(string name, uvm_component parent);
 super.new(name, parent);
 endfunction

task run();
 `uvm_info("UVM TEST", "Hello World!", UVM_NONE)
endtask
endclass

initial begin
run_test("mytest");
end

endmodule 
```