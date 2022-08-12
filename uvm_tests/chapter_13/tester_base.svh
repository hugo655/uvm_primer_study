virtual class tester_base extends uvm_component;
  `uvm_component_utils(tester_base)
   virtual tinyalu_bfm bfm;

   shortint result;
   byte unsigned iA;
   byte unsigned iB;
   operation_t op_set;

   function new (string name, uvm_component parent);
      super.new(name,parent);
      if(!uvm_config_db #(virtual tinyalu_bfm)::get(null, "*","bfm", bfm))
      $fatal("Failed to get BFM");
   endfunction :new

  pure virtual function operation_t get_op();
  pure virtual function byte get_data();

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    bfm.reset_alu();

    `uvm_info("DEBUG", $sformatf("tester type: %s", this.get_type_name()), UVM_LOW);
    repeat(100) begin
      op_set = get_op();
      iA = get_data();
      iB = get_data();
      bfm.send_op(iA, iB, op_set, result);
    end

    repeat(10) @(posedge bfm.clk);
    phase.drop_objection(this);
    
  endtask : run_phase
endclass : tester_base
