class add_test extends uvm_test;
    `uvm_component_utils(add_test)

    env env_h;

    function new (string name, uvm_component parent);
      super.new(name,parent);
    endfunction :new

    function void build_phase(uvm_phase phase);
      tester_base::type_id::set_type_override(add_tester::get_type());
      env_h = env::type_id::create("env_h", this);
    endfunction
endclass : add_test
