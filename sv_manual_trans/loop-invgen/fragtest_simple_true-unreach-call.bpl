// c/loop-invgen/fragtest_simple_true-unreach-call.c

procedure main()
{
  var i,j,pvlen,tmp___1, k, n, LARGE_INT :int;
  k := 0;
  i := 0;
  //pvlen = __VERIFIER_nondet_int();
  assume(LARGE_INT > 1000);

  //  pkt = pktq->tqh_first;
  while ( * ) {
    if (!(i <= LARGE_INT)) {
      break;
    }
    i := i + 1;
  }

  if (i > pvlen) {
    pvlen := i;
  }
  i := 0;

  while ( * ) 
  invariant i == k;
  {
    if (!(i <= LARGE_INT)) {
      break;
    }
    
    tmp___1 := i;
    i := i + 1;
    k := k + 1;
  }

  j := 0;
  n := i;
  while (true)
  invariant k + j == n && j <= n;
  {
    assert(k >= 0);
    k := k -1;
    i := i - 1;
    j := j + 1;
    if (j >= n) {
      break;
    }
  }
}

