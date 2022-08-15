# Chapter 16 - Using Analysis Port in a Testbench

This code aims to implement a monitor mechanism in the interface. The data on the interface is
sampled and passed to other `uvm_components` via a `uvm_analysis_port`.

## Sampling mechanism
In the interface, the there is a command monitor that analyses the DUT interface. It operates
as a two-state machine [state0: idle; state1: operating] and sends data to a `uvm_component` 
during the transition 

```
  always @(posedge clk) begin
    bit state;
    if(!start) state = 0;
    case(state)
      1'b0: begin
        if(start && op != 0) begin
          command_monitor_h.write_to_monitor(A,B,op);
          state = 1'b1;
        end 
      end

      1'b1: state = (done)? 1'b0: 1'b1;
    endcase   
  end
```

```
  // Result Monitor
  always @(posedge clk iff done) begin
      result_monitor_h.write_to_monitor(result);
  end
```

Each of these classes `write_to_monitor` calls a `write()` that implements the `analysis_port` from
both `result_monitor` and `command_monitor`.

Inside `scoreboard` two port inputs, one via the `analysis_export` object provided by the `uvm_subscriber` [See Definition](https://verificationacademy.com/verification-methodology-reference/uvm/src/comps/uvm_subscriber.svh)
class that we are extending. The other is declared inside the `uvm_tlm_analysis_fifo` [See Definition](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.1d/html/src/tlm1/uvm_tlm_fifos.svh).

In our env, these `analysis_export` are connected to their respective `analysis_port` from either
`command_monitor` or `result_monitor`.





