module top_module;

lion lion_h;
chicken chicken_h;
animal  animal_h;

initial begin
  $display("\n ### START OF SIMULATION ###\n");
  lion_h = new(15,"jones");
  lion_h.make_sound();


  chicken_h = new(3,"Marry");
  chicken_h.make_sound();

  animal_h = chicken_h;
  animal_h.make_sound();
  $display("%s: %0d",animal_h.get_name()
  ,animal_h.get_age());

  animal_h = lion_h;
  animal_h.make_sound();
  $display("%s: %0d",animal_h.get_name()
  ,animal_h.get_age());

   $finish();

end
endmodule
