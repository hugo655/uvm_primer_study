module top_module;

lion lion_h;
chicken chicken_h;
animal  animal_h;

initial begin
  $display("\n ### START OF SIMULATION ###\n");

  lion_h = new(15,"jones");
  chicken_h = new(3,"Marry");

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

//__ Calling static varibles within this scope
// if cage is not `protected` it can be accessed from top module
 // $display("## Calling Static Variables");
 // lion_cage::cage.push_back(lion_h);

 // lion_h = new(30,"Kanna");
 // lion_cage::cage.push_back(lion_h);

 // lion_h = new(45,"Trevo");
 // lion_cage::cage.push_back(lion_h);

 // foreach (lion_cage::cage[i]) begin
 //   $display("%s: %0d",lion_cage::cage[i].get_name()
 //           ,lion_cage::cage[i].get_age());
 //  end
 // $display("########################\n");

  $display("## Calling Static Methods");

  lion_h = new(30,"Marry");
  lion_cage::cage_lion(lion_h);

  lion_h = new(45,"Simba");
  lion_cage::cage_lion(lion_h);

  lion_cage::list_lions();

  $display("########################\n");
   $finish();

end
endmodule
