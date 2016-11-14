procedure main()
{
  var n,m,x,y:int;

  assume n>=0;
  assume m >= 0;
  assume m < n;
  x := 0;
  y := m;
  
  while (x<n) {
    x := x + 1;
    if (x>m) {
      y := y + 1;
    }
  }  
  
  assert y == n;
}
