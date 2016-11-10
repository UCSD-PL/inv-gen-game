// c/loops/sum04_true-unreach-call_true-termination.c

procedure main()
{
  var i, sn, SIZE, a: int;
  
  assume(SIZE >= 0);
  sn:= 0;
  i := 1;
  
  while (i <= SIZE)
  // invariant sn == a * (i-1) && i <= SIZE+1;
  {
    sn := sn + a;
    i := i + 1;
  }
 
 assert(sn==SIZE*a || sn == 0);
}
