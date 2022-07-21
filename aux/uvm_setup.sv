// Module to test UVM setup
module uvm_setup;

import uvm_pkg::*;

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
