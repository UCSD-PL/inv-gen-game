function {:existential true} b0(lo:int, hi:int, mid:int): bool;
// c/loop-lit/cggmp2005_variant_true-unreach-call.c

procedure main()
{
  var LARGE_INT : int;
  var lo, mid, hi: int;
  
  LARGE_INT := 1000;
  lo := 0;
  // mid = __VERIFIER_nondet_int();
  assume(mid > 0 && mid <= LARGE_INT);
  hi := 2*mid;

  while (mid > 0)
invariant b0(lo, hi, mid);
  // invariant hi - lo == 2 * mid && mid >= 0;
  {
    lo := lo + 1;
    hi := hi - 1;
    mid := mid - 1;
  }
  assert(lo == hi);
}
