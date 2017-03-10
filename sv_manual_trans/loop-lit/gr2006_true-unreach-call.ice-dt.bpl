function {:existential true} b0(y:int, x:int): bool;
// c/loop-lit/gr2006_true-unreach-call.c

procedure main()
{
  var x,y: int;
  x := 0;
  y := 0;
  
  while (true)
invariant b0(y, x);
  // invariant (x < 50 ==> x == y) && (x >= 50 ==> x-50 == 50-y) && y >= 0;
  {
    if (x < 50) {
      y := y + 1;
    } else {
      y := y - 1;
    }
    
    if (y < 0) {
      break;
    }
    x := x + 1;
  }
  
  assert (x == 100);
}
