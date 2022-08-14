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

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);


    repeat (500) begin
      roll_value = dr.roll(2);
      `uvm_info("INFO", $sformatf("roll_value: %0d from class %s",roll_value, this.get_type_name()), UVM_LOW);
      av.write(roll_value);
      hist.write(roll_value);
    end

    phase.drop_objection(this);
   endtask : run_phase

endclass : main_test
