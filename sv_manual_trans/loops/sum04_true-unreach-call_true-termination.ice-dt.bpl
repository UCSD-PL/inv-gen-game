function {:existential true} b0(a:int, i:int, sn:int, SIZE:int): bool;
// c/loops/sum04_true-unreach-call_true-termination.c

procedure main()
{
  var i, sn, SIZE, a: int;
  
  assume(SIZE >= 0);
  sn:= 0;
  i := 1;
  a := 2; // #defined to 2 in C code
  
  while (i <= SIZE)
invariant b0(a, i, sn, SIZE);
  // invariant sn == a * (i-1) && i <= SIZE+1;
  {
    sn := sn + a;
    i := i + 1;
  }
 
 assert(sn==SIZE*a || sn == 0);
}
