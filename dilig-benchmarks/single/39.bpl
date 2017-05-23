// dilig-benchmarks/single/39.c
/*
 * "NetBSD_loop_int" from InvGen benchmark suite
 */

procedure main()
{
  var buf_off, pattern_off, bound_off, glob3_pathbuf_off, glob3_pathend_off, glob3_pathlim_off, glob3_pattern_off, glob3_dc, MAXPATHLEN : int;

  assume (MAXPATHLEN > 0);

  /*
  buf = A;
  pattern = B;
  */
  buf_off := 0;
  pattern_off := 0;

  /* bound = A + sizeof(A)/sizeof(*A) - 1; */
  bound_off := 0 + (MAXPATHLEN + 1) - 1;

  glob3_pathbuf_off := buf_off;
  glob3_pathend_off := buf_off;
  glob3_pathlim_off := bound_off;
  glob3_pattern_off := pattern_off;

  glob3_dc := 0;
  while (true)
  // invariant true 
  {
    if (glob3_pathend_off + glob3_dc >= glob3_pathlim_off) {
      break;
    } else {
      //      A[glob3_dc] = 1;
      glob3_dc := glob3_dc + 1;
      /* OK */
      assert(0 <= glob3_dc);
      assert (glob3_dc < MAXPATHLEN + 1);
      if (*) {
        break;
      }
    }
  }
}

