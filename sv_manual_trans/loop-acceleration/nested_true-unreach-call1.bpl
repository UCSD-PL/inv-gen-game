// c/loop-acceleration/nested_true-unreach-call1.c

procedure main() {
  var x, y: int;
  x := 0;
  y := 0;
  
  while (x < 268435455) //0x0fffffff
  invariant x <= 268435455;
  {
    y := 0; 
    
    while (y < 10) {
      y := y + 1;
    }
    
    x := x + 1;
  } 
    
  assert(x mod 2 == 1);
}
