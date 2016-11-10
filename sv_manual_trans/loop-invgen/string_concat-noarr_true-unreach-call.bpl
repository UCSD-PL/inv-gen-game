// c/loop-invgen/string_concat-noarr_true-unreach-call.c

procedure main()
{
  var i,j, LARGE_INT : int;
  assume(LARGE_INT > 1000);
  i := 0;
 
  while(*) {
    if (i >= LARGE_INT) {
      break;
    }
    i := i + 1;
  }
  assume(i < 100);
  j := 0;

  while(*)
  // invariant i < j + 100;
  {
    if (i >= LARGE_INT ) {
      break;
    }
    i := i + 1;
    j := j + 1;
  }
  assume( j < 100 );
  assert( i < 200 ); /* prove we don't overflow z */
}
