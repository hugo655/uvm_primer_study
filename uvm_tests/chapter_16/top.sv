module top;

import uvm_pkg::*;
`include "uvm_macros.svh"

import tiny_alu_pkg::*;

tinyalu_bfm bfm();

tiny_alu DUT (.A(bfm.A), .B(bfm.B), .op(bfm.op), 
.clk(bfm.clk), .reset_n(bfm.reset_n), 
.start(bfm.start), .done(bfm.done), .result(bfm.result));

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;    
  uvm_config_db #(virtual tinyalu_bfm)::set(null, "*", "bfm", bfm);
  run_test();
end
endmodule : top
