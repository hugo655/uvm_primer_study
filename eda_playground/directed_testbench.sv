module directed_testbench;

typedef enum bit[2:0] {no_op  = 3'b000,
add_op = 3'b001, 
and_op = 3'b010,
xor_op = 3'b011,
mul_op = 3'b100,
rst_op = 3'b111} operation_t;
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

tiny_alu DUT (.A, .B, .clk, .op, .reset_n, .start, .done, .result);

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #10000
  $finish;
end
// Clock
initial begin
  clk = 0;
  forever begin
    #10;
    clk = ~clk;
  end
end


function operation_t get_op();
  bit [2:0] op_choice;
  op_choice = $random;
  case (op_choice)
    3'b000 : return add_op;
    3'b001 : return add_op;
    3'b010 : return and_op;
    3'b011 : return xor_op;
    3'b100 : return mul_op;
    3'b101 : return and_op;
    3'b110 : return mul_op;
    3'b111 : return xor_op;
  endcase // case (op_choice)
endfunction : get_op

function byte get_data();
  bit [1:0] zero_ones;
  zero_ones = $random;
  if (zero_ones == 2'b00)
    return 8'h00;
    else if (zero_ones == 2'b11)
      return 8'hFF;
      else
        return $random;
      endfunction : get_data



      always @(posedge done) begin : scoreboard
        shortint predicted_result;
        case (op_set)
          add_op: predicted_result = A + B;
          and_op: predicted_result = A & B;
          xor_op: predicted_result = A ^ B;
          mul_op: predicted_result = A * B;
        endcase // case (op_set)

        if ((op_set != no_op) && (op_set != rst_op)) begin
          if (predicted_result != result) begin
            $display("FAILED: A: %0h  B: %0h  op: %s result: %0h expected: %0h",
            A, B, op_set.name(), result, predicted_result);
          end else
          begin
            $display("PASSED: A: %0h  B: %0h  op: %s result: %0h expected: %0h",
            A, B, op_set.name(), result, predicted_result);
          end
        end  

      end : scoreboard

      initial begin : tester
        reset_n = 1'b0;
        @(negedge clk);
        @(negedge clk);
        reset_n = 1'b1;
        start = 1'b0;
        repeat(1000) begin
          @(negedge clk);
          op_set = get_op();
          A = get_data();
          B = get_data();
          start = 1'b1;
          @(negedge done);
          start = 1'b0;
        end
      end : tester
      endmodule : top
