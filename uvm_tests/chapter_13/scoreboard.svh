class scoreboard extends uvm_component;
`uvm_component_utils(scoreboard);

virtual tinyalu_bfm bfm;
shortint predicted_result;

function new (string name, uvm_component parent);
  super.new(name,parent);
  if(!uvm_config_db #(virtual tinyalu_bfm)::get(null, "*","bfm", bfm))
  $fatal("Failed to get BFM");
endfunction :new


task run_phase(uvm_phase phase);
  forever begin
    @(posedge bfm.done) 
    case (bfm.op_set)
      add_op: predicted_result = bfm.A + bfm.B;
      and_op: predicted_result = bfm.A & bfm.B;
      xor_op: predicted_result = bfm.A ^ bfm.B;
      mul_op: predicted_result = bfm.A * bfm.B;
    endcase // case (op_set)

    if ((bfm.op_set != no_op) && (bfm.op_set != rst_op)) begin
      if (predicted_result != bfm.result) begin
        $display("FAILED: A: %0h  B: %0h  op: %s result: %0h expected: %0h",
            bfm.A, bfm.B, bfm.op_set.name(), bfm.result, predicted_result);
      end // if (predicted_result != bfm.result) 
      else begin
//          $display("PASSED: A: %0h  B: %0h  op: %s result: %0h expected: %0h",
//              bfm.A, bfm.B, bfm.op_set.name(), bfm.result, predicted_result);
      end // else !(predicted_result != bfm.result)
    end // if ((bfm.op_set != no_op) && (bfm.op_set != rst_op))
  end  // forever

endtask : run_phase

endclass : scoreboard
