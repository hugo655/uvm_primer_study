class averager extends uvm_component;
`uvm_component_utils(averager);

  protected real sum;
  protected real item_counter;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    reset();
  endfunction

  function void reset();
    this.sum = 0;
    this.item_counter = 0;
  endfunction

  function real get_average();
    real average;
    average = (item_counter == 0 ) ? 0 : sum/item_counter;
     return average;
  endfunction

  function void write(int roll);
    item_counter++;
    sum += roll;
  endfunction

  function void report_phase(uvm_phase phase);
    $display ("DICE AVERAGE: %2.1f",this.get_average());
  endfunction : report_phase

endclass
