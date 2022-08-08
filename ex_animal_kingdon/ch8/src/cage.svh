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
