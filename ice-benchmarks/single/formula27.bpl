function {:existential true} b0(x1:int, x2:int, x3:int, x4: int, x5: int): bool;

procedure main()
{

  var x1, x2, x3, x4, x5, x6, x7, x8: int;
  var x1', x2', x3', x4', x5', x6', x7', x8': int;

  x1 := 0;
  x2 := 0;
  x3 := 0;
  x4 := 0;
  x5 := 0;
  x6 := 0;
  x7 := 0;
  x8 := 0;

  while(*)
  invariant b0(x1, x2, x3, x4, x5);
  {
    havoc x1';
    havoc x2';
    havoc x3';
    havoc x4';
    havoc x5';
    havoc x6';
    havoc x7';
    havoc x8';

    if(0 <= x1' && x1' <= x4' + 1 && x2' == x3' && (x2' <= -1 || x4' <= x2' + 2) && x5' == 0)
    {
      x1 := x1';
      x2 := x2';
      x3 := x3';
      x4 := x4';
      x5 := x5';
      x6 := x6';
      x7 := x7';
      x8 := x8';
    }
  }
  assert(0 <= x1 && x1 <= x4 + 1 && x2 == x3 && (x2 <= -1 || x4 <= x2 + 2) && x5 == 0);
}

