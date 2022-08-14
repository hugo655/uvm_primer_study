class main_test extends uvm_test;
`uvm_component_utils(main_test)

  dice_roller dr;
  averager av;
  histogram hist;
  int roll_value;

  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction :new

  function void build_phase (uvm_phase phase);
    dr = dice_roller::type_id::create("dr", this);
    av = averager::type_id::create("av", this);
    hist = histogram::type_id::create("hist", this);
  endfunction 

  function void connect_phase (uvm_phase phase);
    dr.ap.connect(av.analysis_export);
    dr.ap.connect(hist.analysis_export);
  endfunction 

endclass : main_test
