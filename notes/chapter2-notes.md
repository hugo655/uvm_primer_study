# Chapter 2 - Traditional Testbench

A traditional testbench for the author, follows the coverage methodology. He creates coverage groups that satisfies the following sentences:
* Test all operations; 
* All 0's for input in all operations
* All 1's for input in all operations; 
* Run single operation after a multiply operation;
* Run a multiply operation after a single cycle operation;
* Execute all operations after reset;
* Simulate all operations twice in a roll;

With these coverage group, the author satisfies the conditions that **all Tiny ALU functionality is covered and all RTL lines are executed**. Defining coverage is beyond the scope of this book. Hence, we will assume the coverage is ready. 

## Breaking down the structure of the Traditional Testbench
I am using as reference, the code available at the [this link](https://github.com/raysalemi/uvmprimer/blob/master/02_Conventional_Testbench/tinyalu_tb.sv).

Everything is packet into a single file: Coverage, stimulus, Model, Selfchecking mechanism ... It makes a large file, but is it ideal for an someone starting to plan testbenches. At least he/she knows what to include. 

```
module top

<enum definitions to name operations>
  typedef enum bit[2:0] { no_op       = 3'b000;
						  add_op      = 3'b000;
						  reserved_op = 3'b111;} operation_t;
						  
<wires to connect the output; bits/bytes to connect inputs>

<DUT instantiation with direct(dot)>

<cover groups description> 

<clk generation logic>
  initial clk=0; forever clk=~clk

<covergroups instantiation and initialization>
  covergroup_name my_cover;
  initial begin : coverage
   my_cover = new()
   forever begin 
     @(negedge clk); // samples at nededge clock
	 my_cover.sample();
   end
  end : coverage

<functions to generate data randomly>
  function operation_t get_op();
    bit [2:0] op_choice;
    op_choice = $random; // Randomizes the options
    case(op_choice)
     3'b000 : return no_op;
     3'b001 : return add_op;
      ...
     default : return reserved_op;

<scoreboard mechanism>
  always @(posedge done) begin //evaluates when the DUT spits numbers
    int expect_result;
    #1;
    case (op_set) // This represents 'the model'
     add_op: predicted_result = A + B; 
     and_op: predicted_result = A & B;
     xor_op: predicted_result = A ^ B;
     mul_op: predicted_result = A * B;
    endcase

   if ((op_set != no_op) && (op_set != rst_op))
    if (predicted_result != result)
      $error ("FAILED: A: %0h B: %0h op: %s result: %0h", 
                A, B, op_set.name(), result);

<tester mechanism>
  initial begin : tester
   reset_n = 1'b0;
   @(negedge clk);  
   @(negedge clk);
   reset_n = 1'b1; // Note how he makes sure that data is driven far from posedges
   start = 1'b0;
   repeat (1000) begin // guess number of tests, and expect coverage 100%
    @(negedge clk); 
    op_set = get_op(); 
    A = get_data();
    B = get_data(); 
    start = 1'b1;
    case (op_set) // handle the start signal
   	no_op: begin
      @(posedge clk);
      start = 1'b0;
    end
    
    rst_op: begin
     reset_n = 1'b0;
     start = 1'b0; 
     @(negedge clk);
     reset_n = 1'b1;
    end

    default: begin
     wait(done);
     start = 1'b0;
    end
   endcase // case (op_set)
  end // repeat()
  $stop; // Tester stops the simulation
 end : tester
 
```

As I was reading the code, one part of me was glad that I could understand what was being aimed to; yet, I knew that this file was not reusable what so-ever. At most, It helps copy-pasting to another testbench. 

Funny enough, the author promises that the fundamentals of this book should address this non-reusability and jumbled all-in-one file. 