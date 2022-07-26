class histogram extends uvm_component;
  `uvm_component_utils(histogram);

  // Associative Array indexed by integer
  int rolls[int];

  function new(string name, uvm_component parent);
    super.new(name,parent);
    for (int ii = 2; ii <= 12; ii++) rolls[ii] = 0;
  endfunction : new

  function void write(int t);
    rolls[t]++;
  endfunction : write


  function void report_phase(uvm_phase phase);
    string bar;
    string message;

    message = "\n";
    foreach (rolls[ii]) begin
    string roll_msg;
    bar = "";
    repeat (rolls[ii]) bar = {bar,"#"};
  // Creates a line and concatenates to the main message
      roll_msg = $sformatf( "%2d: %s\n", ii, bar);
      message = {message,roll_msg}; 
    end
    $display(message);
  endfunction : report_phase
endclass : histogram
