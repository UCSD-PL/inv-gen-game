procedure main()
{
  var x,y:int;
  x := -50;
  
  while (x<0) {
    x := x + y;
    y := y + 1;
  }

  assert y > 0;
}

