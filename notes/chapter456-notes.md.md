I decided to group chapters 4,5 and 6 into a single for because of their size which is relatively short. 
# Chapter 4 - Object-Oriented Programming
This chapter is quite short. The big takeway here, for me, is that OOP is the best way for memory management. Every time we are creating a new object and passing into other objects we are sharing memory locations to different threads in the simulation. Apparently, this is smooth in SV/UVM.

# Chapter 5 - Classes and Extensions
Classes and it's extensions are all about classifying similar objects, and breaking them into more specific objects. 

Let's imagine the analogy by using structs:

```
typedef struct{
	int length;
	int width;
} square_struct;
```

Structs are interesting ways to gather related data. However, one major donwside about it that the simulator allocates space in memory as soon as the struct is declared.

When we convert the gathered data in the form of a class:

```
class rectangle;
	int length;
	int width;

	function new(int l, int w);
		length = l;
		width = w;
	endfunction

	function int area();
		return length*width;
	endfunction
endclass
```

We have a special function `new` which interacts with the simulator in a different manner. The memory is allocated only when we explicitly call the function `new()`. This is interesting because, we can declare several types of rectangles and use the same 'memory space'.

When we use this class, let's say in a top module, we need to declare a **handler**. Handlers are 'variables' which store the memory address, just like pointers in C/C++, but you cannot perform memory arithmetic, i.e. navigate through the memory by adding values. 

```
module top();

	rectangle rec_h;

	inital begin
		rec_h = new(.l(10),.w(30));
		$display("Area: %0d",rec_h.area());
	end
endmodule
```

We we just did is to "declare a handler for the class rectangle" and "Instantiated an object of the class rectangle and **stored** in the handler".

Extending classes is just like in C++. Let's say we need a new type rectangle. A more specific one like a square. Just define a new class by referring to the parent class.

```
class square extends rectangle;

	function new(int side);
		super.new(.l(side),.w(side));
	endfunction
endclass
```

# Chapter 6 - Polymorphism
The next big step is to treat a `square` as a `rectangle`. This is achieved by the concept of polymorhism. 

The author starts to shift the examples to use animal related.

```
class animal;

	int age=1;

	function new(int a);
		age = a;
	endfunction

	function void make_sound();
		$fatal(1,"Generic Animals don't have any sound");
	endfunction
endclass
```

```
class lions extends animal;

	int age=1;

	function new(int a);
		super.new(.a(a));
	endfunction

	function void make_sound();
		$display("Lion makes ROAAAH");
	endfunction
endclass

class chicken extends animal;

	int age=1;

	function new(int a);
		super.new(.a(a));
	endfunction

	function void make_sound();
		$display("Chicken makes BECAAAW");
	endfunction
endclass
```

If we create a simple top module to test them we could perform the following tests:

```
module top;

 lion lion_h;
 chicker chicken_h;
 animal  animal_h;

 initial begin
	lion_h = new(15);
	lion_h.make_sound();
	
	
	chicken_h = new(3);
	chicker_h.make_sound();
  end
endmodule
```

This should run with no problem at all. The trick here starts when e start to try to handle `chicken_h` and `lion_h` via a handler for its parent class `animal_h`

```
...
animal_h = chicken_h;
animal_h.make_sound(); // This is a fatal error - No virtual method
...
```

One would normally think that `animal_h` would be treated as a `chicken_h` , after all the whole point of OOP is a super-class handle act as a child-class handle.

The reality is that to have such behavior we have to start using special keywords to tell the simulator we want the function to be resolved to a definition based on the object stored in the variable. Otherwise, the default mechanism is the function be resolved by the handler type; hence `animal_h.make_sound()`-> function definition inside `animal`.

In computer science literature, this is referred as **dynamic dispatch** . [Wikipedia page for Dynamic Dispatch](https://en.wikipedia.org/wiki/Dynamic_dispatch), says that languages such as C++, 
the programmer must use the keyword `virtual` in the function declaration. This happens to be the same behavior as SystemVerilog.

## Virtual Methods
The `virtual` keyword is one of those examples that used to scary me whenever I encountered in a piece of code. But is reality it isn't that hard. Depending on where it is placed, a method or a class definition it can either mean 'something will be provided later' or 'it is available somewhere else in the code'.

### Placing prior to method declaration
If we declare the `make_sound()` function inside `animal class` as follows:

```
class animal;

	int age=1;

	function new(int a);
		age = a;
	endfunction

	virtual function void make_sound();
		$fatal(1,"Generic Animals don't have any sound");
	endfunction
endclass
```

We ask the simulator to look for the method definition in the object type stored in variable. So the calling `animal_h.make_sound()` would call either `make_sound()` from `lion` or `chicken`. Depending on who is stored in the variable. Like in the next example:

```
... 
animal_h = chicken_h;
animal_h.make_sound(); 

animal_h = lion_h;
animal_h.make_sound();
```

Now `animal_h` truly acts as either a `chicken` or a `lion`.  Note that `virtual` was only declared in the parent class, `animal`.

### Placing prior to class declaration
Notice that in order to check if calling `animal_h.make_sound()`  was being called by handler-type or stored-object-type we added a `$fatal` to break the simulation. 

The reality is that to build such templates, i.e. classes we want to guarantee that will be fully implemented, there is the concept of **abstract class**. Abstract classes are usually associated with Java, but the same concept applies in SV. 

If a class is defined as abstract, i.e. with a `virtual` prior to its definitions, it prohibits objects of this class being instantiated. So the alternative is to create a class that derives from this class, extending from it. 

The ultimate restriction would be to include `virtual` keyword prior to methods definition within an abstract class. However this construction is performed with the addition of another keyword `pure`. These are the **pure virtual methods**.

```
virtual class;
	int age=1;

	function new(int a);
		age = a;
	endfunction

	pure virtual function void make_sound();


endclass
```

This structure ensures that in order to derive this class, one must to extend-it and implement the functions, otherwise simulation is crashed. 

One might ask what is the use of having a class that is pretty much a "shell" with empty content. [This question in Verification Academy](https://verificationacademy.com/forums/ovm/difference-between-virtual-and-pure-virtual) addresses this question. It turns-out that this is a key feature for implementing **the infrastructure of a reusable testbench**, but is not applied directly to the DUT verification stimuli.

### Additional References
* [Wikipedia page for Dynamic Dispatch](https://en.wikipedia.org/wiki/Dynamic_dispatch)
* [Abstract Classes in SV](https://www.chipverify.com/systemverilog/systemverilog-abstract-class)
* [Verification Academy Question about pure virtual classes](https://verificationacademy.com/forums/ovm/difference-between-virtual-and-pure-virtual)