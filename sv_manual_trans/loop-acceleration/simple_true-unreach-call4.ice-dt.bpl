function {:existential true} b0(x:int): bool;
// c/loop-acceleration/simple_true-unreach-call4.c

procedure main() {
  var x: int;
 
  x := 268435440; // 0x0ffffff0
  while(x > 0)
invariant b0(x);
  // invariant x mod 2 == 0;
  {
    x := x - 2;
  }
  assert(x mod 2 == 0);
}
