class scoreboard extends uvm_subscriber#(shortint);
`uvm_component_utils(scoreboard);

uvm_tlm_analysis_fifo #(command_s) cmd_f;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction :new

virtual function void build_phase(uvm_phase phase);
  cmd_f = new("cmd_f",this);
endfunction

virtual function void write(shortint t);
  command_s cmd;
  shortint predicted_result;

  do 
   if(!cmd_f.try_get(cmd)) $display("Empty request fifo!");
  while ((cmd.op == no_op || cmd.op == rst_op));

 
    case (cmd.op)
        add_op: predicted_result = cmd.A + cmd.B;
        and_op: predicted_result = cmd.A & cmd.B;
        xor_op: predicted_result = cmd.A ^ cmd.B;
        mul_op: predicted_result = cmd.A * cmd.B;
    endcase
    if (predicted_result != t) begin
      $display("FAILED: A: %0h  B: %0h  op: %s result: %0h expected: %0h",
          cmd.A, cmd.B, cmd.op.name(), t, predicted_result);
    end // if (predicted_result != bfm.result) 
    else begin
    //   $display("PASSED: A: %0h  B: %0h  op: %s result: %0h expected: %0h",
    //        cmd.A, cmd.B, cmd.op.name(), t, predicted_result);
    end // else !(predicted_result != bfm.result)
   
endfunction

endclass : scoreboard
