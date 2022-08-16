interface tinyalu_bfm;
  import tiny_alu_pkg::*;

  byte         unsigned        A;
  byte         unsigned        B;
  bit          clk;
  bit          reset_n;
  wire [2:0]   op;
  bit          start;
  wire         done;
  wire [15:0]  result;
  operation_t  op_set;

  command_monitor command_monitor_h;
  result_monitor result_monitor_h;

  assign op = op_set;


  task reset_alu();
    reset_n = 1'b0;
    @(negedge clk);
    @(negedge clk);
    reset_n = 1'b1;
    start = 1'b0;
  endtask : reset_alu



  task send_op(input byte iA, input byte iB, input operation_t iop);
    if (iop == rst_op) begin
      @(negedge clk);
      op_set = iop;
      @(posedge clk);
      reset_n = 1'b0;
      start = 1'b0;
      @(posedge clk);
      #1;
      reset_n = 1'b1;
    end else begin
      @(negedge clk);
      op_set = iop;
      A = iA;
      B = iB;
      start = 1'b1;
      if (iop == no_op) begin
        @(posedge clk);
        #1;
        start = 1'b0;           
      end else begin
        @(posedge done);
        @(negedge done);
        start = 1'b0;
      end
    end // else: !if(iop == rst_op)

  endtask : send_op

  initial begin
    clk = 0;
    forever begin
      #10;
      clk = ~clk;
    end
  end

  // Command Monitor
  always @(posedge clk) begin
    bit state;
    if(!start) state = 0;
    case(state)
      1'b0: begin
        if(start && op != 0) begin
          command_monitor_h.write_to_monitor(A,B,op);
          state = 1'b1;
        end 
      end

      1'b1: state = (done)? 1'b0: 1'b1;
    endcase   
  end

  // Result Monitor
  always @(posedge clk iff done) begin
      result_monitor_h.write_to_monitor(result);
  end
endinterface : tinyalu_bfm
