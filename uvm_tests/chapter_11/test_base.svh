class test_base extends uvm_test;
`uvm_component_utils(test_base)

  virtual tinyalu_bfm bfm;
  tester tester_h;

  function new (string name, uvm_component parent);
  super.new(name,parent);
  if(!uvm_config_db #(virtual tinyalu_bfm)::get(null, "*","bfm", bfm))
  $fatal("Failed to get BFM");
endfunction :new

function void build_phase(uvm_phase phase);
  tester_h = new(bfm);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);

  tester_h.execute();

  phase.drop_objection(this);
endtask : run_phase

endclass : test_base
