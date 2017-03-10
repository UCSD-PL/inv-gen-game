function {:existential true} b0(bufferlen:int, inlen:int, buf:int, buflim:int, in:int): bool;
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
invariant b0(bufferlen, inlen, buf, buflim, in);
  // invariant 0<=in && in < inlen && 0 <= buf && buf <= buflim && buflim == bufferlen - 2 && bufferlen < inlen && ((buf <= buflim) ==> buf == in);
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
