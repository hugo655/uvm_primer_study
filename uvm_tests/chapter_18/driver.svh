class driver extends uvm_component;
  `uvm_component_utils(driver)

  virtual tinyalu_bfm bfm;
  command_s cmd;

  uvm_get_port #(command_s) get_port;

   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction :new

  virtual function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(virtual tinyalu_bfm)::get(null, "*","bfm", bfm))
      $fatal("Failed to get BFM");
      get_port = new("get_port",this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      get_port.get(cmd);
      bfm.send_op(cmd.A, cmd.B, cmd.op);
    end
  endtask

endclass
