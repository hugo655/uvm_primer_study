# Chapter 13 - UVM Envs

This code aims to implement 2 tests each containing one uvm_env. 

To do so it was required create individual tests: random_test and add_test. Each test instantiates the same environment, built upon a
base `tester class`. In order to specialize the `tester_base` into either `random_tester` or `add_tester`, a UVM factory override mechanism
was implemented. 

```
// file `add_test.svh`
function void build_phase(uvm_phase phase);
 tester_base::type_id::set_type_override(add_tester::get_type());
 env_h = env::type_id::create("env_h", this);
endfunction

// file `random_test.svh`
function void build_phase(uvm_phase phase);
 tester_base::type_id::set_type_override(random::get_type());
 env_h = env::type_id::create("env_h", this);
endfunction
```

Inside `env.svh` there is only one type of tester (`tester_base`) from which `add_tester` and `random_tester` extend from. This means
that `env` is generic and treats a single type of tester. This is so true that during `build_phase` of `env` we ask the uvm factory to 
create an object for `tester_base` and store it in a handle `tester_h`.

```
class env extends uvm_env;
 `uvm_component_utils(env);
   
 tester_base tester_h;
 scoreboard scoreboard_h;
        
 function new(string name, uvm_component parent);
   super.new(name,parent);  
 endfunction :new
                    
 function void build_phase(uvm_phase phase);
   tester_h = tester_base::type_id::create("tester_h", this);
   scoreboard_h = scoreboard::type_id::create("scoreboard_h", this);
 endfunction 
endclass
```

However, depending on what is the type of test, i.e. whats type_id is overriding `tester_base`, `tester_h` stores either an object
`add_tester` or `random_tester`. 

