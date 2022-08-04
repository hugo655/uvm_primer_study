# Chapter 7 - Static Methods and Variables
The codes from this text may be viewed in [My github page](https://github.com/hugo655/uvm_primer_study/tree/main/ex_animal_kingdon). They are based on the examples provided in the book. 

## Declaring Static Variables
There is another keyword that should be studied in case one wants to read SV code fluently: `static`.  Again, for someone landing in OOP, this word might scary, but we should see that is just a matter of asking simulator/compiler to treat default behaviors. 

As a default behavior, simulator only reserves space in memory when the special function (*aka constructor*) `new()` is called; this is called dynamic allocation.

It turns-out that if the word `static` is placed right before the data-member (*a variable declared in a class*), we ask the compiler to reserve this space in memory regardless an object is created; hence this variable is declared "statically", as in oppose to "dynamically".

As consequence, the code has one single variable(memory space) shared across all objects of a given type of class. This effectively acts as a global variable, since multiple parts of the code can write into the same variable. 

To access these variables in parts of the code, one must use another scary sequence of characters that in reality should be simple to understand: Scope Resolution Operator (`::`). 

By using `<class_name>::<static_variable>` we are reading the value of `<static_variable>`  defined under `<class>`.  I often use the mnemonic `::` <=>"from", e.g. "Variable X **from** class Y".

In the book, the example given is to create a new class, a `lion_cage`, that stores objects of type `lion`.  This example is particularly interesting because he makes the use of a non-trivial data structure: [SystemVerilog Queue](https://www.chipverify.com/systemverilog/systemverilog-queues).

*Additional Info: Queues in SystemVerilog are implemented as "linked list" data structure, ideal for scenarios which the data in the head or tail are accessed more often than the one in the middle* 

```
class lion_cage;
  static lion cage[$];
endclass
```

Just by creating this new class, we can access the `cage` from `lion_cage` in the top module:

```
...
//__ Calling static varibles within this scope
  $display("## Calling Static Variables");
  lion_cage::cage.push_back(lion_h);

  lion_h = new(30,"Kanna");
  lion_cage::cage.push_back(lion_h);

  lion_h = new(45,"Trevo");
  lion_cage::cage.push_back(lion_h);

  foreach (lion_cage::cage[i]) begin
    $display("%s: %0d",lion_cage::cage[i].get_name()
            ,lion_cage::cage[i].get_age());
   end
```

Note in the piece of code above, we are creating new lions using the same handler, and storing them in a queue object. The way we are accessing them is via the operator `::`.

## Declaring Static Methods
In order to fully encapsulate the `cage` from the class `lion_cage`. We could include in the class methods that can access them. However in order to to so, one has to explicitly tell the compiler that the function has special privileges. 

When we add `static` prior to the method definition, we allow users to use this method/function in another scope. Just as we created global variables, we create global functions.

It makes sense that global functions processes global variables. Hence, these two constructions are used simultaneously. Furthermore, it makes even more sense to "protect" static variables by using the keyword `protected`. 

If the variable is marked as `protected` and another part of code tries to access it, it would return some error indicating violation. 

The final cage class would be:

```
class lion_cage;
  static lion cage[$]; // Queue: an "array" which you don't know the length yet

  static function void cage_lion(lion l);
    cage.push_back(l);
  endfunction

  static function void list_lions();
    foreach (cage[i]) begin
      $display("%s: %0d",cage[i].get_name()
              ,cage[i].get_age());
    end
  endfunction

endclass
```

Thus, the only way one can access `cage` which is global, but protected is via a function defined as `static` in the same class. So the function 'sees' the variable, and the rest of the code 'sees' the function.

And can be accessed in top module as follows:

```
  $display("## Calling Static Methods");

  lion_h = new(30,"Marry");
  lion_cage::cage_lion(lion_h);

  lion_h = new(45,"Simba");
  lion_cage::cage_lion(lion_h);

  lion_cage::list_lions();
```


#### Additional References
* [SystemVerilog Queue](https://www.chipverify.com/systemverilog/systemverilog-queues)
* [Verification Academy: Queue vs Dynamically Array]([why need dynamic array | Verification Academy](https://verificationacademy.com/forums/systemverilog/why-need-dynamic-array#reply-56627))