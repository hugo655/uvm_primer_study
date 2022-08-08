virtual class animal;

  int age=1;
  string name;
  
  function new(int a, string name);
    this.age = a;
    this.name = name;
  endfunction
  
  pure virtual function void make_sound();
  
  virtual function string get_name();
    return name;
  endfunction
  
  virtual function int get_age();
    return age;
  endfunction
endclass
