implementation main() returns (__RET: int)
{
  var a: [int]int;
  var marker: int;
  var pos: int;
  var i: int;


  anon0:
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} !(pos >= 0 && pos < 100000);
    goto anon4;

  anon4:
    __RET := 0;
    return;

  anon5_Then:
    assume {:partition} pos >= 0 && pos < 100000;
    a[pos] := marker;
    i := 0;
    goto anon6_LoopHead;

  anon6_LoopHead:
    goto anon6_LoopDone, anon6_LoopBody;

  anon6_LoopBody:
    assume {:partition} a[i] != marker;
    i := i + 1;
    goto anon6_LoopHead;

  anon6_LoopDone:
    assume {:partition} a[i] == marker;
    assert i <= pos;
    goto anon4;
}

