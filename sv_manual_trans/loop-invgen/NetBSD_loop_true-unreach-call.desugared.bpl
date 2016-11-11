implementation main()
{
  var MAXPATHLEN: int;
  var pathbuf_off: int;
  var bound_off: int;
  var glob2_p_off: int;
  var glob2_pathbuf_off: int;
  var glob2_pathlim_off: int;


  anon0:
    assume MAXPATHLEN > 0 && MAXPATHLEN < 2147483647;
    pathbuf_off := 0;
    bound_off := pathbuf_off + MAXPATHLEN + 1 - 1;
    glob2_pathbuf_off := pathbuf_off;
    glob2_pathlim_off := bound_off;
    glob2_p_off := glob2_pathbuf_off;
    goto anon2_LoopHead;

  anon2_LoopHead:
    goto anon2_LoopDone, anon2_LoopBody;

  anon2_LoopBody:
    assume {:partition} glob2_p_off <= glob2_pathlim_off;
    assert 0 <= glob2_p_off;
    assert glob2_p_off < MAXPATHLEN + 1;
    glob2_p_off := glob2_p_off + 1;
    goto anon2_LoopHead;

  anon2_LoopDone:
    assume {:partition} glob2_pathlim_off < glob2_p_off;
    return;
}

