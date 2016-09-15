// c/loop-new/count_by_2_true-unreach-call.c

procedure main() {
  var i,LARGE_INT: int;
  assume (LARGE_INT > 0 && LARGE_INT mod 2 == 0);
  i := 0;
  while (i < LARGE_INT)
  invariant i <= LARGE_INT && i mod 2 == 0;
  {
    i := i + 2;
  }
  assert(i == LARGE_INT);
}

