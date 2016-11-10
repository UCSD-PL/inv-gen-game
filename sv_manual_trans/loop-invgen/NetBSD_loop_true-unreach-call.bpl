// c/loop-invgen/NetBSD_loop_true-unreach-call.c

procedure main()
{
  var MAXPATHLEN,pathbuf_off,bound_off,glob2_p_off,glob2_pathbuf_off,glob2_pathlim_off  : int;
  
  //MAXPATHLEN = __VERIFIER_nondet_int();
  assume(MAXPATHLEN > 0 && MAXPATHLEN < 2147483647);
  
  pathbuf_off := 0;
  bound_off := pathbuf_off + (MAXPATHLEN + 1) - 1;
  
  glob2_pathbuf_off := pathbuf_off;
  glob2_pathlim_off := bound_off;

  glob2_p_off := glob2_pathbuf_off;
  while (glob2_p_off <= glob2_pathlim_off)
  invariant true;
  {
    /* OK */
    assert (0 <= glob2_p_off );
    assert (glob2_p_off < MAXPATHLEN + 1);

    glob2_p_off := glob2_p_off + 1;
  }
}

