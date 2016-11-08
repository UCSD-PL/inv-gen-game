implementation main()
{
  var buf_off: int;
  var pattern_off: int;
  var bound_off: int;
  var glob3_pathbuf_off: int;
  var glob3_pathend_off: int;
  var glob3_pathlim_off: int;
  var glob3_pattern_off: int;
  var glob3_dc: int;
  var MAXPATHLEN: int;


  anon0:
    assume MAXPATHLEN > 0;
    buf_off := 0;
    pattern_off := 0;
    bound_off := 0 + MAXPATHLEN + 1 - 1;
    glob3_pathbuf_off := buf_off;
    glob3_pathend_off := buf_off;
    glob3_pathlim_off := bound_off;
    glob3_pattern_off := pattern_off;
    glob3_dc := 0;
    goto anon5_LoopHead;

  anon5_LoopHead:
    goto anon5_LoopDone, anon5_LoopBody;

  anon5_LoopBody:
    assume {:partition} true;
    goto anon6_Then, anon6_Else;

  anon6_Else:
    assume {:partition} glob3_pathlim_off > glob3_pathend_off + glob3_dc;
    glob3_dc := glob3_dc + 1;
    assert 0 <= glob3_dc;
    assert glob3_dc < MAXPATHLEN + 1;
    goto anon7_Then, anon7_Else;

  anon7_Else:
    assume true;
    goto anon5_LoopHead;

  anon7_Then:
    assume true;
    return;

  anon6_Then:
    assume {:partition} glob3_pathend_off + glob3_dc >= glob3_pathlim_off;
    return;

  anon5_LoopDone:
    assume {:partition} !true;
    return;
}

