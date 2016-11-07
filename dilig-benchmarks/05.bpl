procedure run(flag: bool)
requires flag == true || flag == false;
{
  var x, y, i, j: int;
  x := 0;
  y := 0;
  j := 0;
  i := 0;
  
  while(*)
  // invariant x == y && (flag ==> j == x + i) && (!flag ==> j == i);
  {
    x := x + 1;
    y := y + 1;
    i := i + x;
    j := j + y;
  
    if(flag) {
      j := j + 1;
    }
  }
  assert(j>=i);
}
