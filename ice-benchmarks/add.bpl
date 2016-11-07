procedure ADD(i: int, j: int) returns (ret: int)
requires i >= 0;
{
  var b, c: int;

  if (i <= 0)
  {
    ret := j;
  }
  else
  {
    b := i - 1;
    c := j + 1;
    call ret := ADD(b, c);
  }
}

procedure main()
{
  var x, y, result: int;
  assume x >= 0;
  call result := ADD(x, y);
  assert (result == x + y);
}