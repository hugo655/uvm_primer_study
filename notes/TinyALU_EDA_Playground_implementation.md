# Implementing TinyALU in EDA Playground
I decided to implement the whole book exercise in a public platform. The main reason behind is self-learning. I do have some access to Cadence Licenses at my workplace but I figure I could learn more about UVM if I implemented myself. 

Since EDA Playground is opensource, I figured is the best place to practice it. [link for EDA Playground](https://www.edaplayground.com/x/KSgh). This project is also available at [my git hub page](https://github.com/hugo655/uvm_primer_study/tree/main/eda_playground)

## The DUT
The DUT used by the book is the so-called **Tiny-ALU** . Design specifications are as follows:

```
## Tiny ALU Spec ##
I/O:
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

Behavior:
-> reset_n is synchronous and active low;
-> Rising edge of the clock, when start is active, DUT reads 'A', 'B' and 'op';
-> After a given number of clock cycles, the reusult is delivered in 'result' and raises 'done' for one clock cycle;
-> A,B, start and op must remain static while operartion occurs;
-> done signal is high for 1 clock cycle;
-> On 'no_op'(see OP-Codes Bellow) requester lowers start signal one cycle after raising it;
-> reserved operations are not supported.

OP-Codes:
no_op:  000
add_op: 001
and_op: 010
xor_op: 011
mul_op: 100
reserved: 101-111

```
## Tinyalu conversion
The books uses a dut named tinyALU written in VHDL. Personally, I don't feel comfortable in copying somebody else's code. Since is a very simple design. I decided to write an equivalent code in Verilog. 

To make it modular, I codded each part of the design into its own file. I grouped them in the correct order of precedence in `design.sv`

```
// design.sv
`include "one_cycle_add_and_xor.sv"
`include "three_cycle_mult.sv"
`include "tiny_alu.sv"
```

I changed a bit of the original design in order to suit my needs. For instance, I decided to add one stage of pipeline for the single-cycle operations:

```
// Input register pipeline
always@(posedge clk, negedge reset_n) begin
  if(!reset_n) begin
    A_reg <= 'b0;
    B_reg <= 'b0;
    start_reg <= 'b0;
  end 
  else begin
    A_reg <= A;
    B_reg <= B;
    start_reg <= start & !done_aux;
  end
end
```

## Directed Testbench
As I codded, I felt the need to validated if the operations were ok. I felt the need to built a simple testbench for validating each component operation. Specially timing. To do so, I adapted part of the code from [the chapter 01 testbench](https://github.com/raysalemi/uvmprimer/blob/master/02_Conventional_Testbench/tinyalu_tb.sv). And ran a couple of tests for each operation manually.

I chose to randomize only valid operations. So that my 'tester' procedural block does not have to handle reserved operations. This makes a lot easier to validated if the functional logic is correct.

```
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
```

To validate the the design, the scoreboard from the original project was used:

```
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
```

I feel the need to highlight how clever is to treat the 16-bit result as a shortint datatype. This way one can perform the operations and model the 