module top_module;

lion lion_h;
chicken chicken_h;
animal  animal_h;

initial begin
  $display("\n ### START OF SIMULATION ###\n");

  lion_h = new(0,"l0");
  chicken_h = new(0,"c0");

  $display("## Calling Virtual Methods");

  animal_h = chicken_h;
  animal_h.make_sound();
  $display("%s: %0d",animal_h.get_name()
  ,animal_h.get_age());

  animal_h = lion_h;
  animal_h.make_sound();
  $display("%s: %0d",animal_h.get_name()
  ,animal_h.get_age());

  $display("########################\n");

  $display("# Caging Lions #");

  lion_h = new(2,"l2");
  cage#(lion)::cage_animal(lion_h);

  lion_h = new(3,"l3");
  cage#(lion)::cage_animal(lion_h);

  cage#(lion)::list_animals();

  $display("########################\n");

  $display("# Caging Chickens #");
  cage#(chicken)::cage_animal(chicken_h);
  chicken_h = new(1,"c1");
  cage#(chicken)::cage_animal(chicken_h);
  cage#(chicken)::list_animals();
   $finish();

end
endmodule
