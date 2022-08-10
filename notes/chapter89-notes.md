# Chapter 8 - Parametrized Classes
Parameters in Hardware design are typically used for listing busses width. As we move into deeper uses of SV, we must get acquainted with passing entire classes via parameters.  It should not be scary. It is just a matter of using proper syntax.

```
class cage #(parameter type T=animal);
  protected static T cage[$]; // Queue: an "array" which you don't know the length yet

  static function void cage_animal(T animal);
    cage.push_back(animal);
  endfunction

  static function void list_animals();
    foreach (cage[i]) begin
      $display("%s: %0d",cage[i].get_name()
              ,cage[i].get_age());
    end
  endfunction

endclass
```

When using the parametrized class, each time we define a new-class with a new parameter, we are accessing a different classes that happen to share the same code. Hence `cage#(lion)::`  is a different namespace than `cage#(chicken)::`. 

Parametrized classes works as templates for writing generic pieces of code. Each new class usage with a specific parameter is defined as 'class specialization'. They are crucial for build the so called design patterns. 

### A quick look in some design patterns in SV
#### Singleton
A way to ensure the constructor of a class is called only once in the code. To do so, the keyword `local` have to be added prior to the constructor definition. `local` enforces that none of the child classes can 'see' the method, thus, the member can only be accessed inside the class. 

```
class Root extends Component;
local static Root  m_root;
local function new();
   super.new("Root",null);
endfunction

static function Root get();
  if(Root!=null) m_root = new();
  return m_root;
endfunction

endclass
```
The above example illustrates how can a singleton be implemented in SV. The `local` `static`  acts as a dead-lock. The method `Root:get()`  is the only way in to create this root object. 


# Chapter 9 - Factory Pattern
Design Patterns are clever solutions that previous engineers came-up with and are some-sort of industry standard techniques. UVM relies a lot on the "Factory Pattern" which addresses the problem of having to 'hardcode' each and every time one wants to create objects dynamically during simulation. There are loads of references on the internet about its implementation in all sorts of programming languages. 

The author chooses to illustrate the concept of factory by passing a `string`data type as an argument of the constructor. He himself admits UVM has a much more 'clever approach' to how the factory is implemented in the framework. 

I decided to highlight the key concepts from his analogy of 'Animal Factory', yet I decided to actually look for references on how the famous factory is implemented/used in a real UVM environment. 

### The author's Analogy
Straight to the point: A `static`  function called `make_animal` receives as one the parameters a `string` which is the data type. The core of the function is a `case` statement which triggers either `new()` functions from all the classes we wish this factory to create. The case acts as a look-up table.


Finally, the author relies on the polymorphism to get a generic data type. One last thing, he makes sure to `$cast` the output of the factory so that the generic handler is replaced by a proper data type.

This example is extremely illustrative, and it really worked for me the very first time I read this book. Yet, I couldn't help but to notice the footnote indicating a cleverer approach. Given that I had seen UVM environments before, I was (sort of) ready to peek how this factory concept is implemented in real world. 

## UVM Factory Concept and Override Policies
Is not as trivial as I thought. Simply put. I am not rewriting the entire code, but I think is important highlighting the key elements of the factory. This type of knowledge is a bit more advanced than I expected. 

[This page]([How UVM Factory Works..?? | Universal Verification Methodology (learnuvmverification.com)](https://learnuvmverification.com/index.php/2015/08/19/how-uvm-factory-works/)) and [this page](https://www.chipverify.com/uvm/uvm-factory-override)saves hours of code reading. In summary, one can create **base components** (base driver, base agent, base sequence) and structure the environment using only this generic class types (a base class). **On the test level**, *special pieces of code* that tell the simulator how to 'override' the base types, scattered all over the environment by the types/names specifically for that test condition. 

Hence, when building the skeleton of the environment we don't need to know what the classes are going to be, we only need generic base classes and later one can specify what child classes this base classes should behave. This mechanism is called overriding. We trick the simulator to create an object of type B instead of its base-class A, thus 'overriding' the class type. 

There are two different approaches to override the data type, either by type or Instance.  Choosing one over another is beyond the scope of this study. 

`<original_type>::type_id::set_type_override(<substitute_type>::get_type(), replace);`
`<original_type>::type_id::set_inst_override(<substitute_type>::get_type(), <path_string>);`

* Every testbench component must include some code to 'register' the new data type into the factory. This code usually is in form of UVM_Macros. These components can be broken into base and cildren (derived form base);
* Every uvm component/object must follow the pattern `new(.name(<base_class_name>)`. The string name is crucial for the factory look-up table mechanism. 
* The creation takes place when one uses the piece of code `<type>::type_id::create("<name>",<parent>)`. At this moment, the skeleton of the environment is created with only base types.
* On the 'test level', one that encapsulates all the other UVM components, the override type policy is selected either by type or by name. These policies are set by using the above code snippets.



#### Additional References
* [OOP Design Pattern Examples Session | SystemVerilog OOP for UVM Verification Course | Verification Academy](https://verificationacademy.com/sessions/oop-design-pattern-examples)
* [Learn UVM Verification How the factory Works](https://learnuvmverification.com/index.php/2015/08/19/how-uvm-factory-works/)
* [Chip Verify - UVM Factory](https://www.chipverify.com/uvm/uvm-factory-override)