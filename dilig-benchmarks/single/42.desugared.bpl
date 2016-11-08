implementation main()
{
  var flag: int;
  var x: int;
  var y: int;
  var a: int;


  anon0:
    x := 1;
    y := 1;
    assume flag != 0 ==> a == 0;
    assume flag == 0 ==> a == 1;
    goto anon8_LoopHead;

  anon8_LoopHead:
    goto anon8_LoopDone, anon8_LoopBody;

  anon8_LoopBody:
    assume true;
    goto anon9_Then, anon9_Else;

  anon9_Else:
    assume {:partition} flag == 0;
    a := x + y + 1;
    y := y + 1;
    goto anon4;

  anon4:
    goto anon10_Then, anon10_Else;

  anon10_Else:
    assume {:partition} a mod 2 != 1;
    x := x + 1;
    goto anon8_LoopHead;

  anon10_Then:
    assume {:partition} a mod 2 == 1;
    y := y + 1;
    goto anon8_LoopHead;

  anon9_Then:
    assume {:partition} flag != 0;
    a := x + y;
    x := x + 1;
    goto anon4;

  anon8_LoopDone:
    assume true;
    assert flag == 0 ==> a mod 2 == 1;
    assert flag != 0 ==> (a + 1) mod 2 == 1;
    return;
}

