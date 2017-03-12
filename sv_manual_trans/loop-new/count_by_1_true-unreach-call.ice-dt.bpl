function {:existential true} b0(i:int, LARGE_INT:int): bool;
// c/loop-new/count_by_1_true-unreach-call.c

procedure main() {
  var i,LARGE_INT: int;
  i := 0;
  assume(0 <= LARGE_INT );
  while (i < LARGE_INT)
invariant b0(i, LARGE_INT);
  // invariant i <= LARGE_INT;
  {
    i := i + 1;
  }
  assert(i == LARGE_INT);
}
