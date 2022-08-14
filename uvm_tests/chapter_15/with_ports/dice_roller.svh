class dice_roller extends uvm_component;
`uvm_component_utils(dice_roller);

  uvm_analysis_port #(int) ap;
  rand shortint dice;
  int roll_value ;
  constraint dice_faces {dice >= 1; 
                         dice <= 6;}

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    ap = new("ap",this);
  endfunction

  function int roll(int roll_number);
    int counter = 0;

    repeat(roll_number) begin
      this.randomize();
      counter += dice;
    end

    return counter;
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);


    repeat (100) begin
      roll_value = this.roll(2);
      `uvm_info("INFO", $sformatf("roll_value: %0d from class %s",roll_value,this.get_type_name()), UVM_LOW);
      ap.write(roll_value);
    end
    phase.drop_objection(this);
  endtask

endclass
