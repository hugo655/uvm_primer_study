# Chapter 3 - SystemVerilog Interfaces and BFM

Lack of modularity, that is the best description to the previous testbench created. Don't get me wrong. It suits the needs for a very simple design, but it will blow as more and more elements are included in it. 

According to wikipedia: "A _Bus Functional Model_ or BFM is a non-synthesizable software _model_ of an integrated circuit component having one or more external buses.". One way to implement such would be my using SystemVerilog Interfaces which is perfect way to encapsulate signals and perform processing with the data extracted from the signals. 

All code snippets from this texts belongs to Ray Salemi and are taken from [This Github Page]([uvmprimer/03_Interfaces_and_BFMs at master · raysalemi/uvmprimer (github.com)](https://github.com/raysalemi/uvmprimer/tree/master/03_Interfaces_and_BFMs))

## A simpler top testbench
The top file is much more readable:
```
/*
Copyright 2013 Ray Salemi
*/

module top;

 tinyalu_bfm bfm();
 tester tester_i (bfm);
 coverage coverage_i (bfm);
 scoreboard scoreboard_i(bfm);

 tinyalu DUT (.A(bfm.A), .B(bfm.B), .op(bfm.op),
              .clk(bfm.clk), .reset_n(bfm.reset_n),
              .start(bfm.start), .done(bfm.done),
             .result(bfm.result));

endmodule : top
```

Notice how `bfm`  is a handle (some may call this equivalent to a pointer in C/C++), and we are passing it to `tester` `coverage` `scoreboard` which still happen to be modules. Personally at this stage I would think they would be classes, but at this point in the book, classes haven't being mentioned yet. 

In the following sections, I'll peek some of the code from these new files. `scoreboard` definition is left in this post since is pretty much the same as the code snippets for the `tester` and `scoreboard`.

### Peeking at the BFM
It is a systemverilog interface with tasks, but it very first line may scary some. `import tinyalu_pkg::*;` . There is not a lot to get scary here, the author just chose to "pack" the
type defs into a single "packet"! Clever eh?!. No better place to encapsulate them. 

```
/*
Copyright 2013 Ray Salemi
*/

package tinyalu_pkg;
 typedef enum bit[2:0] {no_op = 3'b000,
                        add_op = 3'b001,
                        ...
                        rst_op = 3'b111} operation_t;

endpackage : tinyalu_pkg
```

Back to the interface, I'll capture the nuts-and-bolts of the file in the same compact format I did in the [chapter 2 notes](chapter2_notes.md).

```
/*
Copyright 2013 Ray Salemi
*/

interface 
<import packages with typedefs>

<bytes/bits/wires declarations>

<inital task for generating clk> // note the BFM is responsable for providing clk

<dedicated task for reset>
  task reset_alu();
   reset_n = 1'b0;
   @(negedge clk);
   @(negedge clk);
   reset_n = 1'b1;
   start = 1'b0;
  endtask : reset_alu

<dedicated task for sending an operation> // Encapsulation of a protocol
 task send_op(input byte iA, input byte iB, input operation_t iop, output shortint alu_result);
  op_set = iop;
  if (iop == rst_op) begin
   @(posedge clk);
   reset_n = 1'b0;
   start = 1'b0;
   @(posedge clk);
   #1;
   reset_n = 1'b1;
  end else begin // else
    @(negedge clk);
    A = iA;
    B = iB;
    start = 1'b1;
    if (iop == no_op) begin
     @(posedge clk);
     #1;
     start = 1'b0;
    end else begin // else_2
     do
      @(negedge clk);
      while (done == 0);
      start = 1'b0;
    end // else_2
  end // else
endtask : send_op
```

The BFM does not care about the generation of the data. It only drives it. It **receives data and synchronizes it according to the protocol**. In this case a simple 'start-done' protocol created by the author. 

### Peeking at the Tester
Same as the bfm. Packages are imported so that in the scope, the variables can be understood.

```
/*
Copyright 2013 Ray Salemi
*/

<import pkg>

<Function declarations for random constained data>

<Test procedural statement making uses of tasks from the BFM>
initial begin
  byte unsigned iA;
  byte unsigned iB;
  operation_t op_set;
  shortint result;
  bfm.reset_alu();
  repeat (1000) begin : random_loop
    op_set = get_op();
    iA = get_data();
    iB = get_data();
    bfm.send_op(iA, iB, op_set, result);
   end : random_loop
  $stop;
end // initial begin

```

### Peeking at the Scoreboard
Note how he starts to refer to the variables in the procedural blocks as 'members of the bfm'.
```
/*
Copyright 2013 Ray Salemi
*/
module scoreboard(tinyalu_bfm bfm);
 import tinyalu_pkg::*;
 always @(posedge bfm.done) begin
 shortint predicted_result;
 #1;
 case (bfm.op_set)
   add_op: predicted_result = bfm.A + bfm.B;
   and_op: predicted_result = bfm.A & bfm.B;
   xor_op: predicted_result = bfm.A ^ bfm.B;
   mul_op: predicted_result = bfm.A * bfm.B;
 endcase // case (op_set)
 if ((bfm.op_set != no_op) && (bfm.op_set != rst_op))
   if (predicted_result != bfm.result)
     $error ("FAILED: A: %0h B: %0h op: %s result: %0h",
      bfm.A, bfm.B, bfm.op_set.name(), bfm.result);
end
```


## Final Comments on Compilation
At this stage, we have gone from a single-file testbench to a 5-file testbench. Furthermore, we are dealing with a 3-file design. For starters, compiling everything into "one simulation" may be a dauting task. So It is probably worth recognizing that multi-file projects is a milestone. 

For the most part, dealing with more than one file and sending them into one tool (it can be either Cadence's XCelium, Mentor's Questa or Icarus Verilog ) is a bit daunting, but as long as one understand the core concepts behind, he/she realizes that most tools are pretty much doing the same job. It is more a matter of learning the syntax.

This is specially true for these simple projects we do at home. We it comes to industrial applications, then the nuances of the algorithms from each of these tools plays a important role. Nevertheless, here is a quick explanation on how the files `run.do` and `dut.f` work.

To run the simulation one perform `vsim -c -d run.do`  . `-c` stands for console. The the `-d` I don't know what stands for, but one may find by looking for in "User Manuals" [such as this one]([ModelSim Command Reference Manual (microsemi.com)](https://www.microsemi.com/document-portal/doc_view/136364-modelsim-me-10-4c-command-reference-manual-for-libero-soc-v11-7)) or [quick guides like this](https://cseweb.ucsd.edu/~hadi/teaching/cs3220/01-2014fa/doc/modelsim/modelsim_quick_guide.pdf) . I won't bother to find what it stands for, you are more than welcome to consult it :) .

Anyways, It tells us that it starts by reading the file `run.do` 

```
if [file exists "work"] {vdel -all}
 vlib work # Creates a directory call 'WORK'

 vcom -f dut.f # vcom is a command to compile a design in VHDL

 vlog -f tb.f #vlog is a command to compile a design in Verilog/SV

 vopt top -o top_optimized +acc +cover=sbfec+tinyalu(rtl). 
 vsim top_optimized -coverage 
 set NoQuitOnFinish 1
 onbreak {resume}
 log /* -r

 run -all
 coverage exclude -src ../../tinyalu_dut/single_cycle_add_and_xor.vhd -line 49 -code s
 coverage exclude -src ../../tinyalu_dut/single_cycle_add_and_xor.vhd -scope /top/DUT/add_and_xor -line 49 -code b
 coverage save tinyalu.ucdb
 vcover report tinyalu.ucdb
 vcover report tinyalu.ucdb -cvg -details
quit
```

The nuts and bolts of this script is using `vcom` to compile a VHDL design `vlog` to compile a SystemVerilog testbench. Each of them are calling files such as `dut.f` and `tb.f` which tell the group of files that have to be read in the correct order of precedence.

Everything else except for `run -all` refers to setting the simulator. A lot of the configurations refer to coverage. 

The main point here is that, to launch a simulation, one must look for the tool documentation specifically:
* How to read and compile design files (include both design and testbench)
* How to load any additional dependencies for UVM
* How to run a simulation 
* If coverage is desired, how to set-up coverage

For example, for Cadence XCelium, one can perform such task by setting-up a `run.f` as the example:

```
# to run: xrun -f run.f
-64
-v200x # enable VHDL support for syntax 2008

-coverage all -covoverwrite


-incdir tinyalu_dut

# Design files in correct order of precedence
tinyalu_dut/single_cycle_add_and_xor.vhd
tinyalu_dut/three_cycle_mult.vhd
tinyalu_dut/tinyalu.vhd

# Tb files in the correct order of precedence
tinyalu_pkg.sv
tinyalu_bfm.sv
tester.sv
coverage.sv
scoreboard.sv
top.sv

```

It can be frustrating not knowing how to run a simulation because you don't know the tool, but believe-me, this tools are not trivial. **No one knows everything about a tool** and most scripts are taken from somewhere else. 

So don't waste energy trying to "learn a tool". It is more effective search for a script somewhere in the internet. [EDA Playgroud]([Compile and Run Options — EDA Playground documentation (eda-playground.readthedocs.io)](https://www.edaplayground.com/)) has a good cheatsheet in [this link](https://eda-playground.readthedocs.io/en/latest/compile_run_options.html)) . 


### Additional References
* [BFM WIkipedia](https://en.wikipedia.org/wiki/Bus_functional_model)
* [SystemVerilog Interface - ChipVerify](https://www.chipverify.com/systemverilog/systemverilog-interface)


