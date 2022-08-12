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

`include "tester.svh"
`include "scoreboard.svh"


// Tests
`include "test_base.svh"


endpackage
