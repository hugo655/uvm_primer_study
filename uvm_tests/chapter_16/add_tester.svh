class add_tester extends random_tester;
  `uvm_component_utils(add_tester)
   virtual tinyalu_bfm bfm;

   function new (string name, uvm_component parent);
     super.new(name, parent);
   endfunction : new

  protected virtual function operation_t get_op();
    return add_op;
  endfunction : get_op
endclass : add_tester
