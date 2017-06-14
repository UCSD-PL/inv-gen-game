function {:existential true} b0(x:int, y:int, k:int): bool;

procedure main()returns ()
{
  var x,y,k: int;
  x := y mod k;
  while (x<k && k > 1)
  invariant b0(x, y, k);
  //invariant (x == y mod k);
  {
    y := y + 2;
    k := k - 1;
    x := y mod k;
  }
  assert(x == y mod k);
}
