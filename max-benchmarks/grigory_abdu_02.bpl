procedure main() {
  var x,y,LEN: int;
  x := 0;
  y := 0;
  assume( LEN >= 0 );
  while ( x < LEN )
  //invariant y == 2*x && x<=LEN;
  {
	x := x+1;
	y := y+2;
  }
  assert(y == 2*x);
  assert(x == LEN);
}
