// c/loop-acceleration/phases_true-unreach-call1.c

procedure main() {
  var x: int;
  x := 0;
  
  while (x < 268435455)  //0x0fffffff
  // invariant x >= 65520 ==> (x mod 2 == 0) ;
  {
    if (x < 65520) { // 0xfff0
      x := x + 1; 
    } else {
      x := x + 2;
    }
  }
  
  assert(0 == (x mod 2));
}
