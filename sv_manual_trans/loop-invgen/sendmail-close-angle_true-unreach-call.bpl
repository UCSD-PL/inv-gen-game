// c/loop-invgen/sendmail-close-angle_true-unreach-call.c

procedure main()
{
  var in, inlen, bufferlen, buf, buflim, LARGE_INT :int;
  //int inlen = __VERIFIER_nondet_int();
  //int bufferlen = __VERIFIER_nondet_int();;

  assume(bufferlen >1);
  assume(inlen > 0);
  assume(bufferlen < inlen);

  buf := 0;
  in := 0;
  buflim := bufferlen - 2;

  while (*)
  invariant buf <= buflim && in <= buf + 1;
  {
    if (!(buf == buflim)) {
      assert(0<=buf);
      assert(buf<bufferlen);
      buf := buf + 1;
    }
    in := in + 1;
    assert(0<=in);
    assert(in<inlen);
    
    if (buf == buflim) {
      break;
    }
  }

  assert(0<=buf);
  assert(buf<bufferlen);
  buf := buf + 1;

  /* OK */
  assert(0<=buf);//6
  assert(buf<bufferlen);

  buf := buf + 1;
}
