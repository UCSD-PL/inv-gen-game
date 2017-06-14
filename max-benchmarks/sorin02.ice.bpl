function {:existential true} b0(a:int, su:int, t:int): bool;

// Adaptation of sqrt, which we can't solve (well, now we just had one person solve it)
// I just moved the increment of "a" at the end of loop, so that now 
// the invariant is su = a*a instead of su = (a+1)*(a+1)
procedure main() {
  var n, a, su, t : int;

  a := 1;
  su := 1;
  t := 1;
  // Final assert doesn't make sense when n is negative
  assume(n>0);

  while (su <= n)
  invariant b0(a, su, t);
  //invariant su == a*a && t == 2*a-1;
  {
    t := t + 2;
    su := su + t;
    a := a + 1;
  }

  assert((a*a == su));
}
