class tester extends uvm_component;
`uvm_component_utils(tester)
  virtual tinyalu_bfm bfm;

  shortint result;
  byte unsigned iA;
  byte unsigned iB;
  operation_t op_set;

  function new (string name, uvm_component parent);
  super.new(name,parent);
  if(!uvm_config_db #(virtual tinyalu_bfm)::get(null, "*","bfm", bfm))
  $fatal("Failed to get BFM");
endfunction :new

protected virtual function operation_t get_op();
  bit [2:0] op_choice;
  op_choice = $random;
  case (op_choice)
    3'b000 : return add_op;
    3'b001 : return add_op;
    3'b010 : return and_op;
    3'b011 : return xor_op;
    3'b100 : return mul_op;
    3'b101 : return mul_op;
    3'b110 : return xor_op;
    3'b111 : return and_op;
    endcase // case (op_choice)
endfunction : get_op

protected virtual function byte get_data();
  bit [1:0] zero_ones;
  zero_ones = $random;
  if (zero_ones == 2'b00)
  return 8'h00;
  else if (zero_ones == 2'b11)
  return 8'hFF;
  else
  return $random;
endfunction : get_data

task run_phase(uvm_phase phase);
  phase.raise_objection(this);

  bfm.reset_alu();

  repeat(10) begin
  op_set = get_op();
  iA = get_data();
  iB = get_data();
  bfm.send_op(iA, iB, op_set, result);
  end

  repeat(10) @(posedge bfm.clk);
  phase.drop_objection(this);
endtask : run_phase

endclass : tester
