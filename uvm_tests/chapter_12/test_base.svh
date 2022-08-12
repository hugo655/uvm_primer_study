class test_base extends uvm_test;
  `uvm_component_utils(test_base)

    tester tester_h;
    scoreboard scoreboard_h;

   function new (string name, uvm_component parent);
    super.new(name,parent);
   endfunction :new

  function void build_phase(uvm_phase phase);
    tester_h = tester::type_id::create("tester", this);
    scoreboard_h = scoreboard::type_id::create("scoreboard", this);
  endfunction
endclass : test_base
