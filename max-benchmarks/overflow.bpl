// Motivation: Verify with 32 bit int
procedure main() {
  var i: int;
  var j: int;
  i := 0;
  j := 0;
  while (i>=0)
  //invariant j > 0;
  {
    i := i + 1;
    j := j + 1;
  }
  assert(i > 0);
  assert(j > 0);
}