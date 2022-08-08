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
