class env extends uvm_env;
  `uvm_component_utils(env);
  
  tester_base tester_h;
  scoreboard scoreboard_h;
  command_monitor command_monitor_h;
  result_monitor result_monitor_h;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);  
  endfunction :new
  
  function void build_phase(uvm_phase phase);
    tester_h = tester_base::type_id::create("tester_h", this);
    scoreboard_h = scoreboard::type_id::create("scoreboard_h", this);
    command_monitor_h = command_monitor::type_id::create("command_monitor_h", this);
    result_monitor_h = result_monitor::type_id::create("result_monitor_h", this);
  endfunction 

  function void connect_phase(uvm_phase phase);
   command_monitor_h.ap.connect(scoreboard_h.cmd_f.analysis_export);
   result_monitor_h.ap.connect(scoreboard_h.analysis_export);
  endfunction


endclass
