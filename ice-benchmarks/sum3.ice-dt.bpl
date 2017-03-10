function {:existential true} b0(x:int, sn:int): bool;
procedure main()
{
  var sn, loop1, n1, x : int;
  assume loop1 >= 0 && n1 >= 0; 
  sn := 0;  
  x := 0;

  while(true)
invariant b0(x, sn);
  // invariant sn == x;
  {
    sn := sn + 1;
    x := x + 1;
    assert(sn==x*1 || sn == 0);
  }
}
