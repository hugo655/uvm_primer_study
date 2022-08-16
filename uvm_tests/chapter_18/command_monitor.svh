class command_monitor extends uvm_component;
  `uvm_component_utils(command_monitor)

    virtual tinyalu_bfm bfm;

    uvm_analysis_port #(command_s) ap;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual tinyalu_bfm)::get(null, "*","bfm", bfm))
    $fatal("Failed to get BFM");

    bfm.command_monitor_h = this;
    ap = new("ap",this);
  endfunction

  virtual function void write_to_monitor(byte A,
                                         byte B,
                                         bit[2:0] op);
      command_s cmd;

      cmd.A = A;
      cmd.B = B;
      cmd.op = op2enum(op);
      ap.write(cmd);
  endfunction : write_to_monitor

      virtual function operation_t op2enum(bit[2:0] op);
        case(op)
          3'b000 : return no_op;
          3'b001 : return add_op;
          3'b010 : return and_op;
          3'b011 : return xor_op;
          3'b100 : return mul_op;
          3'b111 : return rst_op;
          default : $display("Illegal Operation %b",op);
        endcase // case (op)
      endfunction : op2enum

endclass : command_monitor
