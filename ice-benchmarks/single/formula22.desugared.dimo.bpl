implementation main()
{
  var x1: int;
  var x2: int;
  var x3: int;
  var x4: int;
  var x5: int;
  var x6: int;
  var x7: int;
  var x8: int;
  var x1': int;
  var x2': int;
  var x3': int;
  var x4': int;
  var x5': int;
  var x6': int;
  var x7': int;
  var x8': int;


  anon0:
    x1 := 0;
    x2 := 0;
    x3 := 0;
    x4 := 0;
    x5 := 0;
    x6 := 0;
    x7 := 0;
    x8 := 0;
    goto anon4_LoopHead;

  anon4_LoopHead:
    goto anon4_LoopDone, anon4_LoopBody;

  anon4_LoopBody:
    havoc x1';
    havoc x2';
    havoc x3';
    havoc x4';
    havoc x5';
    havoc x6';
    havoc x7';
    havoc x8';
    goto anon5_Then, anon5_Else;

  anon5_Else:
    assume {:partition} !(x1' <= x2' && (x2' >= 0 || x2' - x3' <= 2));
    goto anon4_LoopHead;

  anon5_Then:
    assume {:partition} x1' <= x2' && (x2' >= 0 || x2' - x3' <= 2);
    x1 := x1';
    x2 := x2';
    x3 := x3';
    x4 := x4';
    x5 := x5';
    x6 := x6';
    x7 := x7';
    x8 := x8';
    goto anon4_LoopHead;

  anon4_LoopDone:
    assert x1 <= x2 && (x2 >= 0 || x2 - x3 <= 2);
    return;
}

