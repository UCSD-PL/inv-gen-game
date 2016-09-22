implementation main()
{
  var len: int;
  var i: int;
  var j: int;
  var bufsize: int;
  var limit: int;
  var flag: int;


  anon0:
    goto anon12_Then, anon12_Else;

  anon12_Else:
    assume {:partition} 0 <= bufsize;
    limit := bufsize - 4;
    i := 0;
    goto anon13_LoopHead;

  anon13_LoopHead:
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} i < len;
    j := 0;
    goto anon14_LoopHead;

  anon14_LoopHead:
    goto anon14_LoopDone, anon14_LoopBody;

  anon14_LoopBody:
    assume {:partition} i < len && j < limit;
    goto anon15_Then, anon15_Else;

  anon15_Else:
    assume {:partition} len <= i + 1;
    goto anon6;

  anon6:
    goto anon16_Then, anon16_Else;

  anon16_Else:
    flag := 1;
    goto anon9;

  anon9:
    goto anon17_Then, anon17_Else;

  anon17_Else:
    assume {:partition} !(i + 1 < len && flag == 1);
    assert i < len;
    assert 0 <= i;
    assert j < bufsize;
    assert 0 <= j;
    j := j + 1;
    i := i + 1;
    goto anon14_LoopHead;

  anon17_Then:
    assume {:partition} i + 1 < len && flag == 1;
    assert i < len;
    assert 0 <= i;
    assert j < bufsize;
    assert 0 <= j;
    j := j + 1;
    i := i + 1;
    assert i < len;
    assert 0 <= i;
    assert j < bufsize;
    assert 0 <= j;
    j := j + 1;
    i := i + 1;
    assert j < bufsize;
    assert 0 <= j;
    j := j + 1;
    goto anon14_LoopHead;

  anon16_Then:
    flag := 0;
    goto anon9;

  anon15_Then:
    assume {:partition} i + 1 < len;
    assert i + 1 < len;
    assert 0 <= i;
    goto anon6;

  anon14_LoopDone:
    assume {:partition} !(i < len && j < limit);
    goto anon13_LoopHead;

  anon13_LoopDone:
    assume {:partition} len <= i;
    return;

  anon12_Then:
    assume {:partition} bufsize < 0;
    return;
}

