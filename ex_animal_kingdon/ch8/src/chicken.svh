class chicken extends animal;
   
   function new(int a,string s);
     super.new(.a(a),.name(s));
   endfunction
   
   function void make_sound();
     $display("Chicken makes BECAAAW");
   endfunction
endclass
