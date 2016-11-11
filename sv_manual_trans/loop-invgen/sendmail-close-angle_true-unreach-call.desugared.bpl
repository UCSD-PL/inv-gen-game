implementation main()
{
  var in: int;
  var inlen: int;
  var bufferlen: int;
  var buf: int;
  var buflim: int;


  anon0:
    assume bufferlen > 1;
    assume inlen > 0;
    assume bufferlen < inlen;
    buf := 0;
    in := 0;
    buflim := bufferlen - 2;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume true;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume {:partition} buf == buflim;
    goto anon3;

  anon3:
    in := in + 1;
    assert 0 <= in;
    assert in < inlen;
    goto anon8_Then, anon8_Else;

  anon8_Else:
    assume {:partition} buf != buflim;
    goto anon6_LoopHead;

  anon8_Then:
    assume {:partition} buf == buflim;
    goto anon5;

  anon5:
    assert 0 <= buf;
    assert buf < bufferlen;
    buf := buf + 1;
    assert 0 <= buf;
    assert buf < bufferlen;
    buf := buf + 1;
    return;

  anon7_Then:
    assume {:partition} !(buf == buflim);
    assert 0 <= buf;
    assert buf < bufferlen;
    buf := buf + 1;
    goto anon3;

  anon6_LoopDone:
    assume true;
    goto anon5;
}

