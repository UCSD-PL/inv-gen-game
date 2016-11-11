implementation main()
{
  var scheme: int;
  var urilen: int;
  var tokenlen: int;
  var cp: int;
  var c: int;
  var LARGE_INT: int;


  anon0:
    assume LARGE_INT > 1000;
    assume urilen <= LARGE_INT && urilen >= -LARGE_INT;
    assume tokenlen <= LARGE_INT && tokenlen >= -LARGE_INT;
    assume scheme <= LARGE_INT && scheme >= -LARGE_INT;
    assume urilen > 0;
    assume tokenlen > 0;
    assume scheme >= 0;
    assume !(scheme == 0 || urilen - 1 < scheme);
    cp := scheme;
    assert cp - 1 < urilen;
    assert 0 <= cp - 1;
    goto anon12_Then, anon12_Else;

  anon12_Else:
    return;

  anon12_Then:
    assert cp < urilen;
    assert 0 <= cp;
    goto anon13_LoopHead;

  anon13_LoopHead:
    goto anon13_LoopDone, anon13_LoopBody;

  anon13_LoopBody:
    assume {:partition} cp != urilen - 1;
    goto anon14_Then, anon14_Else;

  anon14_Else:
    assert cp < urilen;
    assert 0 <= cp;
    cp := cp + 1;
    goto anon13_LoopHead;

  anon14_Then:
    goto anon5;

  anon5:
    assert cp < urilen;
    assert 0 <= cp;
    goto anon15_Then, anon15_Else;

  anon15_Else:
    assume {:partition} cp == urilen - 1;
    return;

  anon15_Then:
    assume {:partition} cp != urilen - 1;
    assert cp + 1 < urilen;
    assert 0 <= cp + 1;
    goto anon16_Then, anon16_Else;

  anon16_Else:
    assume {:partition} cp + 1 == urilen - 1;
    return;

  anon16_Then:
    assume {:partition} cp + 1 != urilen - 1;
    cp := cp + 1;
    scheme := cp;
    goto anon17_Then, anon17_Else;

  anon17_Else:
    return;

  anon17_Then:
    c := 0;
    assert cp < urilen;
    assert 0 <= cp;
    goto anon18_LoopHead;

  anon18_LoopHead:
    goto anon18_LoopDone, anon18_LoopBody;

  anon18_LoopBody:
    assume {:partition} cp != urilen - 1 && c < tokenlen - 1;
    assert cp < urilen;
    assert 0 <= cp;
    goto anon19_Then, anon19_Else;

  anon19_Else:
    goto anon11;

  anon11:
    cp := cp + 1;
    goto anon18_LoopHead;

  anon19_Then:
    c := c + 1;
    assert c < tokenlen;
    assert 0 <= c;
    assert cp < urilen;
    assert 0 <= cp;
    goto anon11;

  anon18_LoopDone:
    assume {:partition} !(cp != urilen - 1 && c < tokenlen - 1);
    return;

  anon13_LoopDone:
    assume {:partition} cp == urilen - 1;
    goto anon5;
}

