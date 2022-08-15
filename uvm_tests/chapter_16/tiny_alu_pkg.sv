package tiny_alu_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Typedefs
  typedef enum bit[2:0] {no_op  = 3'b000,
  add_op = 3'b001, 
  and_op = 3'b010,
  xor_op = 3'b011,
  mul_op = 3'b100,
  rst_op = 3'b111} operation_t;


  typedef struct packed {
    byte unsigned        A;
    byte unsigned        B;
    operation_t op;
  } command_s;

  `include "tester_base.svh"
  `include "command_monitor.svh"
  `include "result_monitor.svh"
  `include "random_tester.svh"
  `include "add_tester.svh"
  `include "scoreboard.svh"

  //envs
  `include "env.svh"

  // Tests
  `include "add_test.svh"
  `include "random_test.svh"

endpackage
