// c/loop-lit/jm2006_true-unreach-call.c 

procedure main()
{
  var i,j: int;
  var x,y: int;
  
  assume (i >= 0 && j >= 0);
  x := i;
  y := j;
  
  while (x != 0)
  invariant i == j ==> x == y ;
  {
    x := x - 1;
    y := y - 1;
  }
  
  if (i == j) {
    assert (y == 0);
  }
}
