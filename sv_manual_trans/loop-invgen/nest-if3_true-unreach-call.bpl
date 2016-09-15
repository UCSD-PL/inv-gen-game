// c/loop-invgen/nest-if3_true-unreach-call.c

procedure main() {
  var i,k,n,l,LARGE_INT: int;
  assume(LARGE_INT > 1000);
  //n = __VERIFIER_nondet_int();
  //l = __VERIFIER_nondet_int();
  assume(l>0);
  assume(l < LARGE_INT);
  assume(n < LARGE_INT);
  k := 1;
  while (k<n){
    i := 1;
    while (i < n) {
      assert(1<=i);
      i := i + 1;
    }
    k := k + 1;
    
    if(*) {
      l := l + 1;
    }
  }   
}
