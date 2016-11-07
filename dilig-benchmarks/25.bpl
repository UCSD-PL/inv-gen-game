function unknown1() returns (bool);
function unknown2() returns (bool);
function unknown3() returns (bool);
function unknown4() returns (bool);

procedure main()
{
  var x,y,i,j: int;
  x := 0;
  y := 0;
  i := 0;
  j := 0;

  while(unknown1())
    invariant x == y && i >= j;
  {
    while(unknown2())
    invariant x == y && i >= j;
    {
      if(x==y) {
        i := i+1;
      } else {
        j := j+1;
      }
    }
    if(i>=j)
    {
      x := x+1;
      y := y+1;
    }
    else {
      y := y+1;
    }
  }
  assert(i>=j);
}