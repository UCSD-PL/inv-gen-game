method run(n: int, m: int)
{
  assume n>=0;
  assume m>=0;
  assume m<n;
  var x: int := 0; 
  var y: int := m;
  while x<n
    invariant (x <= n) && (x <= m ==> y == m) && (x > m ==> x == y)  
  {
    x := x+1;
    if(x>m) {
      y := y+1;
    }
  }
  assert y==n;
}
