# Chapter 18 Adding Put and Get Ports into the testbench 

In this part of the book, we split the tester into two classes connected by a fifo:
`tester_base` and `driver`.

Tester base is responsible for generating data only. Once it creates, it writes the values into 
a struct handler and places this structure in a special method call `put`. This method is implemented
in a `uvm_tlm_fifo` instantiated in the `env` class. 

On the other side of the fifo, there is a `get_port` instantiated inside the new class `driver`. 
There is a interthread communication mechanism in which the tester "puts" data, and driver gets it.

It is important to highlight that the `tester` is the class responsible for raising the objection
and dropping it during the `run-phase`. The driver class is entirely passive, when it comes to 
simulation time. It just "gets" whatever has been putted by someone else -- in this case,
the `tester_base`.


