class env extends uvm_env;
  `uvm_component_utils(env);
  
  tester_base tester_h;
  scoreboard scoreboard_h;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);  
  endfunction :new
  
  function void build_phase(uvm_phase phase);
    tester_h = tester_base::type_id::create("tester_h", this);
    scoreboard_h = scoreboard::type_id::create("scoreboard_h", this);
  endfunction 
endclass
