module tiny_alu(
  input clk,
  input reset_n,
  input start,
  input [2:0] op,
  input [7:0] A,
  input [7:0] B,
  output reg [15:0] result,
  output reg done
); 

localparam [2:0]  no_op = 3'b000,
add_op = 3'b001,
and_op = 3'b010,
xor_op = 3'b011,
mul_op = 3'b100;

reg        start_sc;
reg        start_tc;
reg [15:0] result_sc;
reg [15:0] result_tc;
reg        done_sc;
reg        done_tc;


// Inner instances 
single_cycle_add_and_xor single_cycle(.A(A),
.B(B),
.op_code(op),
.clk(clk),
.reset_n(reset_n),
.start(start_sc),
.done(done_sc),
.result(result_sc));

three_cycle_mult three_cycle(.A(A),
.B(B),
.clk(clk),
.reset_n(reset_n),
.start(start_tc),
.done_mult(done_tc),
.result_mult(result_tc));

// Start Demux
always @(*) begin
  case(op)
    add_op: begin
      start_sc = start;
      start_tc = 1'b0;
    end

    and_op: begin
      start_sc = start;
      start_tc = 1'b0;
    end

    xor_op: begin
      start_sc = start;
      start_tc = 1'b0;
    end

    mul_op: begin
      start_sc = 1'b0;
      start_tc = start;
    end
    default: begin
      start_sc = 1'b0;
      start_tc = 1'b0;
    end
  endcase
end

// Result mux
always @(*) begin
  case(op)
    add_op: begin
      done = done_sc;
      result = result_sc;
    end

    and_op: begin
      done = done_sc;
      result = result_sc;
    end

    xor_op: begin
      done = done_sc;
      result = result_sc;
    end

    mul_op: begin
      done = done_tc;
      result = result_tc;
    end

    default: begin
      done = 1'b0;
      result = 1'b0;
    end
  endcase
end  
endmodule
