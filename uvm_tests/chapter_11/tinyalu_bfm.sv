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

  assign op = op_set;


  task reset_alu();
    reset_n = 1'b0;
    @(negedge clk);
    @(negedge clk);
    reset_n = 1'b1;
    start = 1'b0;
  endtask : reset_alu



  task send_op(input byte iA, input byte iB, input operation_t iop, shortint alu_result);
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


endinterface : tinyalu_bfm
