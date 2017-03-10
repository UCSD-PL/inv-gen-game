function {:existential true} b0(i:int, LARGE_INT:int, k:int): bool;
// c/loop-new/count_by_k_true-unreach-call.c

procedure main() {
  var i,k,LARGE_INT: int;
  assume (LARGE_INT > 0);
  assume (0 <= k && k <= 10);
  i := 0;
  while (i < LARGE_INT * k)
invariant b0(i, LARGE_INT, k);
  // invariant i <= LARGE_INT*k && (k>0 ==> i mod k == 0);
  {
    i := i + k;
  }
  assert(i == LARGE_INT * k);
}
