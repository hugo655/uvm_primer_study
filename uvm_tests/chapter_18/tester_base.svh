virtual class tester_base extends uvm_component;
  `uvm_component_utils(tester_base)

   uvm_put_port #(command_s) put_port;
   
  command_s cmd;

 function new (string name, uvm_component parent);
    super.new(name,parent);
 endfunction :new

 virtual function void build_phase(uvm_phase phase);
    put_port = new("put_port",this);
 endfunction

 pure virtual function operation_t get_op();
 pure virtual function byte get_data();

 task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    cmd.op = rst_op;
    put_port.put(cmd);
    
    `uvm_info("DEBUG", $sformatf("tester type: %s", this.get_type_name()), UVM_LOW);
    repeat(100) begin
      cmd.op = get_op();
      cmd.A = get_data();
      cmd.B = get_data();
      put_port.put(cmd);
    end

    #500;
    phase.drop_objection(this);
 endtask : run_phase

endclass : tester_base
