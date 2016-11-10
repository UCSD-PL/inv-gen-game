// c/loop-new/count_by_nondet_true-unreach-call.c

procedure main() {
  var i,j,k,LARGE_INT: int;
  assume (LARGE_INT >= 0);
  i := 0;
  k := 0;
  while(i < LARGE_INT)
  // invariant k <= i && k <= LARGE_INT;
  {
    havoc j;
    assume(1 <= j && j < LARGE_INT);
    i := i + j;
    k := k + 1;
  }
  assert(k <= LARGE_INT);
}

