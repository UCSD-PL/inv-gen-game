function {:existential true} b0(i:int, sn:int, SIZE:int): bool;
procedure main() { 
  var i, sn, SIZE : int;
  
  sn := 0;
  i := 1;
  
  while(i <= SIZE)
invariant b0(i, sn, SIZE);
  // invariant sn == i - 1 && (SIZE <= 0 ==> sn == 0) && (SIZE > 0 ==> sn <= SIZE);
  {
    sn := sn + 1;
    i := i + 1;
  }
  assert(sn==SIZE || sn == 0);
}
