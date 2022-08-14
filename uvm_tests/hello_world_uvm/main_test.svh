class main_test extends uvm_test;
`uvm_component_utils(main_test)


  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction :new


  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("INFO", $sformatf("\n\n#### Hello World from test: %s ####\n\n", this.get_type_name()), UVM_LOW);

    phase.drop_objection(this);
   endtask : run_phase

endclass : main_test
