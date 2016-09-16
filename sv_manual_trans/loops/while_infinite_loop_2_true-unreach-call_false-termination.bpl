// c/loops/while_infinite_loop_2_true-unreach-call_false-termination.c

procedure main()
{
  var x: int;
  x := 0;
  while (true) {
    assert (x == 0);
  }
  assert(x ==0);
}

