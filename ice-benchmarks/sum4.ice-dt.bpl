function {:existential true} b0(i:int, sn:int): bool;
procedure main() { 
  var i, sn, a, SIZE : int;
  
  sn := 0;
  i := 1;
  
  while(i <= 8)
invariant b0(i, sn);
  // invariant sn == i - 1 && i <= 9;
  {
    sn := sn + 1;
    i := i + 1;
  }
  assert(sn==8 || sn == 0);
}
