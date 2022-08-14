class dice_roller extends uvm_component;
`uvm_component_utils(dice_roller);

  rand shortint dice;

  constraint dice_faces {dice >= 1; 
                         dice <= 6;}

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function int roll(int roll_number);
    int counter = 0;
    repeat(roll_number) begin
      this.randomize();
      counter += dice;
    end
    return counter;
  endfunction

endclass
