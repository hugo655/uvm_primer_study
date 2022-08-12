# Chapter 12 - UVM Components

This code aims to convert a generic class `tester` into a `uvm_component`.

To do so it was required extend the class from `uvm_component`, include a constructor, add the
registration macros, and replace the contents from the old `execute` method into a `run_phase`, i.e. include phasing.

Additionally, in the `test_base` it was required to change the construction mechanism of the old
`tester`. By using `tester_h = tester::type_id::create("tester", this);` we are asking UVM to create
the class with an id labelled "tester". Because we only have one type of test, we don't need to set
any [overriding mechanism](https://www.chipverify.com/uvm/uvm-factory-override#:~:text=UVM%20factory%20is%20a%20mechanism,its%20inherited%20child%20class%20objects.)




