class result_monitor extends uvm_component;
  `uvm_component_utils(result_monitor)

    virtual tinyalu_bfm bfm;

    uvm_analysis_port #(shortint) ap;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual tinyalu_bfm)::get(null, "*","bfm", bfm))
    $fatal("Failed to get BFM");

    bfm.result_monitor_h = this;
    ap = new("ap",this);
  endfunction

  virtual function void write_to_monitor(shortint result);
      ap.write(result);
  endfunction : write_to_monitor

endclass : result_monitor
