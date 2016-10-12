function {:existential true} init_preference_lists_b0(i: int, j: int): bool;
function {:existential true} init_preference_lists_b1(i: int, j: int, c: int, s: int): bool;
function {:existential true} init_local_stores_b0(i: int, j: int): bool;
function {:existential true} init_local_stores_b1(i: int, j: int): bool;


axiom $arch_ptr_size == 8;

axiom $arch_spec_ptr_start == $max.u8;

const unique ^$##thread_id: $ctype;

axiom $def_math_type(^$##thread_id);

type $##thread_id;

const unique ^$##club: $ctype;

axiom $def_math_type(^$##club);

type $##club;

const unique ^LiveNodes: $ctype;

axiom $is_span_sequential(^LiveNodes);

axiom $def_struct_type(^LiveNodes, 40000, false, false);

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2(#s1, #s2, #p, ^LiveNodes) } $inv2(#s1, #s2, #p, ^LiveNodes) == $set_eq($owns(#s2, #p), $set_empty()));

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2_without_lemmas(#s1, #s2, #p, ^LiveNodes) } $inv2_without_lemmas(#s1, #s2, #p, ^LiveNodes) == $set_eq($owns(#s2, #p), $set_empty()));

axiom (forall p: $ptr, q: $ptr, s: $state :: { $in(q, $composite_extent(s, p, ^LiveNodes)) } $in(q, $composite_extent(s, p, ^LiveNodes)) == (q == p));

const unique LiveNodes.live_nodes: $field;

axiom $def_phys_arr_field(^LiveNodes, LiveNodes.live_nodes, ^^i4, false, 0, 10000);

const unique ^PreferenceLists: $ctype;

axiom $is_span_sequential(^PreferenceLists);

axiom $def_struct_type(^PreferenceLists, 128000000, false, false);

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2(#s1, #s2, #p, ^PreferenceLists) } $inv2(#s1, #s2, #p, ^PreferenceLists) == ($set_eq($owns(#s2, #p), $set_empty()) && (forall Q#i$1^74.14#tc1#1408: int :: {:weight 10} { $idx($dot(#p, PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408) } $in_range_i4(Q#i$1^74.14#tc1#1408) ==> Q#i$1^74.14#tc1#1408 >= 0 && Q#i$1^74.14#tc1#1408 < 32000000 ==> $rd_inv(#s2, $field($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408)), $prim_emb($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408))) >= 0 && $rd_inv(#s2, $field($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408)), $prim_emb($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408))) < 10000) && (forall Q#i$1^78.14#tc1#1409: int :: {:weight 10} { $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv(#s2, PreferenceLists.vals, #p)), Q#i$1^78.14#tc1#1409) } $in_range_i4(Q#i$1^78.14#tc1#1409) ==> Q#i$1^78.14#tc1#1409 >= 0 && Q#i$1^78.14#tc1#1409 < 32000000 ==> $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv(#s2, PreferenceLists.vals, #p)), Q#i$1^78.14#tc1#1409) == $rd_inv(#s2, $field($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^78.14#tc1#1409)), $prim_emb($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^78.14#tc1#1409))))));

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2_without_lemmas(#s1, #s2, #p, ^PreferenceLists) } $inv2_without_lemmas(#s1, #s2, #p, ^PreferenceLists) == ($set_eq($owns(#s2, #p), $set_empty()) && (forall Q#i$1^74.14#tc1#1408: int :: {:weight 10} { $idx($dot(#p, PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408) } $in_range_i4(Q#i$1^74.14#tc1#1408) ==> Q#i$1^74.14#tc1#1408 >= 0 && Q#i$1^74.14#tc1#1408 < 32000000 ==> $rd_inv(#s2, $field($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408)), $prim_emb($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408))) >= 0 && $rd_inv(#s2, $field($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408)), $prim_emb($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408))) < 10000) && (forall Q#i$1^78.14#tc1#1409: int :: {:weight 10} { $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv(#s2, PreferenceLists.vals, #p)), Q#i$1^78.14#tc1#1409) } $in_range_i4(Q#i$1^78.14#tc1#1409) ==> Q#i$1^78.14#tc1#1409 >= 0 && Q#i$1^78.14#tc1#1409 < 32000000 ==> $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv(#s2, PreferenceLists.vals, #p)), Q#i$1^78.14#tc1#1409) == $rd_inv(#s2, $field($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^78.14#tc1#1409)), $prim_emb($idx($dot(#p, PreferenceLists.preference_list), Q#i$1^78.14#tc1#1409))))));

axiom (forall p: $ptr, q: $ptr, s: $state :: { $in(q, $composite_extent(s, p, ^PreferenceLists)) } $in(q, $composite_extent(s, p, ^PreferenceLists)) == (q == p));

const unique PreferenceLists.preference_list: $field;

axiom $def_phys_arr_field(^PreferenceLists, PreferenceLists.preference_list, ^^i4, false, 0, 32000000);

const unique PreferenceLists.vals: $field;

axiom $def_ghost_field(^PreferenceLists, PreferenceLists.vals, $map_t(^^i4, ^^i4), false);

procedure PreferenceLists#adm(P#_this_: $ptr);
  modifies $s, $cev_pc;
  ensures $is_admissibility_check() ==> $set_eq($owns($s, $phys_ptr_cast(P#_this_, ^PreferenceLists)), $set_empty());
  ensures $is_admissibility_check() ==> (forall Q#i$1^74.14#tc1#1408: int :: {:weight 10} { $idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408) } $in_range_i4(Q#i$1^74.14#tc1#1408) ==> Q#i$1^74.14#tc1#1408 >= 0 && Q#i$1^74.14#tc1#1408 < 32000000 ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408))) >= 0 && $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408))) < 10000);
  ensures $is_admissibility_check() ==> (forall Q#i$1^78.14#tc1#1409: int :: {:weight 10} { $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $phys_ptr_cast(P#_this_, ^PreferenceLists))), Q#i$1^78.14#tc1#1409) } $in_range_i4(Q#i$1^78.14#tc1#1409) ==> Q#i$1^78.14#tc1#1409 >= 0 && Q#i$1^78.14#tc1#1409 < 32000000 ==> $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $phys_ptr_cast(P#_this_, ^PreferenceLists))), Q#i$1^78.14#tc1#1409) == $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^78.14#tc1#1409)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^78.14#tc1#1409))));
  ensures $is_unwrap_check() ==> $set_eq($owns($s, $phys_ptr_cast(P#_this_, ^PreferenceLists)), $set_empty());
  ensures $is_unwrap_check() ==> (forall Q#i$1^74.14#tc1#1408: int :: {:weight 10} { $idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408) } $in_range_i4(Q#i$1^74.14#tc1#1408) ==> Q#i$1^74.14#tc1#1408 >= 0 && Q#i$1^74.14#tc1#1408 < 32000000 ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408))) >= 0 && $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408))) < 10000);
  ensures $is_unwrap_check() ==> (forall Q#i$1^78.14#tc1#1409: int :: {:weight 10} { $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $phys_ptr_cast(P#_this_, ^PreferenceLists))), Q#i$1^78.14#tc1#1409) } $in_range_i4(Q#i$1^78.14#tc1#1409) ==> Q#i$1^78.14#tc1#1409 >= 0 && Q#i$1^78.14#tc1#1409 < 32000000 ==> $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $phys_ptr_cast(P#_this_, ^PreferenceLists))), Q#i$1^78.14#tc1#1409) == $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^78.14#tc1#1409)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^78.14#tc1#1409))));
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



implementation PreferenceLists#adm(P#_this_: $ptr)
{
  var #wrTime$1^69.9: int;
  var #stackframe: int;

  anon6:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^69.9, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^69.9 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^69.9, (lambda #p: $ptr :: false));
    // assume @decreases_level_is(0); 
    assume 0 == $decreases_level;
    // assume @_vcc_admissibility_start(_this_); 
    assume $admissibility_start($phys_ptr_cast(P#_this_, ^PreferenceLists), ^PreferenceLists);
    assume true;
    // if (@_vcc_is_unwrap_check) ...
    if ($is_unwrap_check())
    {
      anon1:
        // assume !(@_vcc_is_stuttering_check); 
        assume !$is_stuttering_check();
        // assume @_vcc_unwrap_check_pre(@state, _this_); 
        assume $unwrap_check_pre($s, $phys_ptr_cast(P#_this_, ^PreferenceLists));
        // @_vcc_unwrap_check(_this_)
        call $unwrap_check($phys_ptr_cast(P#_this_, ^PreferenceLists));
        assume $good_state_ext(#tok$1^69.9, $s);
        // assert true
    }
    else
    {
      anon4:
        assume true;
        // if (@_vcc_is_admissibility_check) ...
        if ($is_admissibility_check())
        {
          anon2:
            // assume @_vcc_admissibility_pre(@state, _this_); 
            assume $admissibility_pre($s, $phys_ptr_cast(P#_this_, ^PreferenceLists));
        }
        else
        {
          anon3:
            // assume @_vcc_stuttering_pre(@state, _this_); 
            assume $stuttering_pre($s, $phys_ptr_cast(P#_this_, ^PreferenceLists));
        }

      anon5:
        // @_vcc_havoc_others(_this_, @_vcc_typeof((struct PreferenceLists*)@null))
        call $havoc_others($phys_ptr_cast(P#_this_, ^PreferenceLists), ^PreferenceLists);
        assume $good_state_ext(#tok$1^69.9, $s);
        // assert true
        // assume ==>(@_vcc_is_stuttering_check, @_vcc_inv2(old(@prestate, @state), @state, _this_)); 
        assume $is_stuttering_check() ==> $inv2(old($s), $s, $phys_ptr_cast(P#_this_, ^PreferenceLists), ^PreferenceLists);
    }

  #exit:
}



const unique ^LocalStores: $ctype;

axiom $is_span_sequential(^LocalStores);

axiom $def_struct_type(^LocalStores, 400000008, false, false);

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2(#s1, #s2, #p, ^LocalStores) } $inv2(#s1, #s2, #p, ^LocalStores) == ($set_eq($owns(#s2, #p), $set_empty()) && $rd_inv(#s2, LocalStores.len, #p) <= 100000000 && ($rd_inv(#s2, LocalStores.tainted_key, #p) == -1 || ($rd_inv(#s2, LocalStores.tainted_key, #p) >= 0 && $rd_inv(#s2, LocalStores.tainted_key, #p) < 10000))));

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2_without_lemmas(#s1, #s2, #p, ^LocalStores) } $inv2_without_lemmas(#s1, #s2, #p, ^LocalStores) == ($set_eq($owns(#s2, #p), $set_empty()) && $rd_inv(#s2, LocalStores.len, #p) <= 100000000 && ($rd_inv(#s2, LocalStores.tainted_key, #p) == -1 || ($rd_inv(#s2, LocalStores.tainted_key, #p) >= 0 && $rd_inv(#s2, LocalStores.tainted_key, #p) < 10000))));

axiom (forall p: $ptr, q: $ptr, s: $state :: { $in(q, $composite_extent(s, p, ^LocalStores)) } $in(q, $composite_extent(s, p, ^LocalStores)) == (q == p));

const unique LocalStores.local_store: $field;

axiom $def_phys_arr_field(^LocalStores, LocalStores.local_store, ^^i4, false, 0, 100000000);

const unique LocalStores.len: $field;

axiom $def_phys_field(^LocalStores, LocalStores.len, ^^u8, false, 400000000);

const unique LocalStores.tainted_nodes: $field;

axiom $def_ghost_field(^LocalStores, LocalStores.tainted_nodes, $map_t(^^i4, ^^bool), false);

const unique LocalStores.tainted_key: $field;

axiom $def_ghost_field(^LocalStores, LocalStores.tainted_key, ^^i4, false);

const unique LocalStores.size: $field;

axiom $def_ghost_field(^LocalStores, LocalStores.size, ^^nat, false);

procedure LocalStores#adm(P#_this_: $ptr);
  modifies $s, $cev_pc;
  ensures $is_admissibility_check() ==> $set_eq($owns($s, $phys_ptr_cast(P#_this_, ^LocalStores)), $set_empty());
  ensures $is_admissibility_check() ==> $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#_this_, ^LocalStores)) <= 100000000;
  ensures $is_admissibility_check() ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#_this_, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#_this_, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#_this_, ^LocalStores)) < 10000);
  ensures $is_unwrap_check() ==> $set_eq($owns($s, $phys_ptr_cast(P#_this_, ^LocalStores)), $set_empty());
  ensures $is_unwrap_check() ==> $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#_this_, ^LocalStores)) <= 100000000;
  ensures $is_unwrap_check() ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#_this_, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#_this_, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#_this_, ^LocalStores)) < 10000);
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



implementation LocalStores#adm(P#_this_: $ptr)
{
  var #wrTime$1^83.9: int;
  var #stackframe: int;

  anon12:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^83.9, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^83.9 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^83.9, (lambda #p: $ptr :: false));
    // assume @decreases_level_is(0); 
    assume 0 == $decreases_level;
    // assume @_vcc_admissibility_start(_this_); 
    assume $admissibility_start($phys_ptr_cast(P#_this_, ^LocalStores), ^LocalStores);
    assume true;
    // if (@_vcc_is_unwrap_check) ...
    if ($is_unwrap_check())
    {
      anon7:
        // assume !(@_vcc_is_stuttering_check); 
        assume !$is_stuttering_check();
        // assume @_vcc_unwrap_check_pre(@state, _this_); 
        assume $unwrap_check_pre($s, $phys_ptr_cast(P#_this_, ^LocalStores));
        // @_vcc_unwrap_check(_this_)
        call $unwrap_check($phys_ptr_cast(P#_this_, ^LocalStores));
        assume $good_state_ext(#tok$1^83.9, $s);
        // assert true
    }
    else
    {
      anon10:
        assume true;
        // if (@_vcc_is_admissibility_check) ...
        if ($is_admissibility_check())
        {
          anon8:
            // assume @_vcc_admissibility_pre(@state, _this_); 
            assume $admissibility_pre($s, $phys_ptr_cast(P#_this_, ^LocalStores));
        }
        else
        {
          anon9:
            // assume @_vcc_stuttering_pre(@state, _this_); 
            assume $stuttering_pre($s, $phys_ptr_cast(P#_this_, ^LocalStores));
        }

      anon11:
        // @_vcc_havoc_others(_this_, @_vcc_typeof((struct LocalStores*)@null))
        call $havoc_others($phys_ptr_cast(P#_this_, ^LocalStores), ^LocalStores);
        assume $good_state_ext(#tok$1^83.9, $s);
        // assert true
        // assume ==>(@_vcc_is_stuttering_check, @_vcc_inv2(old(@prestate, @state), @state, _this_)); 
        assume $is_stuttering_check() ==> $inv2(old($s), $s, $phys_ptr_cast(P#_this_, ^LocalStores), ^LocalStores);
    }

  #exit:
}



const unique ^$#AbsHint: $ctype;

axiom $def_record_type(^$#AbsHint);

type RT#AbsHint;

function RC#AbsHint(AbsHint.src: int, AbsHint.dst: int, AbsHint.key: int) : RT#AbsHint;

function RSZ#AbsHint(a: RT#AbsHint) : int;

function REQ#AbsHint(a: RT#AbsHint, b: RT#AbsHint) : bool;

const RZ#AbsHint: RT#AbsHint;

axiom (forall AbsHint.src: int, AbsHint.dst: int, AbsHint.key: int :: { RC#AbsHint(AbsHint.src, AbsHint.dst, AbsHint.key) } RSZ#AbsHint(RC#AbsHint(AbsHint.src, AbsHint.dst, AbsHint.key)) == $abs($unchecked(^^nat, AbsHint.src)) + $abs($unchecked(^^nat, AbsHint.dst)) + $abs($unchecked(^^nat, AbsHint.key)) + 1 && RF#AbsHint.src(RC#AbsHint(AbsHint.src, AbsHint.dst, AbsHint.key)) == $unchecked(^^nat, AbsHint.src) && RF#AbsHint.dst(RC#AbsHint(AbsHint.src, AbsHint.dst, AbsHint.key)) == $unchecked(^^nat, AbsHint.dst) && RF#AbsHint.key(RC#AbsHint(AbsHint.src, AbsHint.dst, AbsHint.key)) == $unchecked(^^nat, AbsHint.key));

axiom (forall r: RT#AbsHint :: r == RC#AbsHint(RF#AbsHint.src(r), RF#AbsHint.dst(r), RF#AbsHint.key(r)));

axiom (forall r: RT#AbsHint :: 0 < RSZ#AbsHint(r));

axiom (forall a: RT#AbsHint, b: RT#AbsHint :: { REQ#AbsHint(a, b) } RF#AbsHint.src(a) == RF#AbsHint.src(b) && RF#AbsHint.dst(a) == RF#AbsHint.dst(b) && RF#AbsHint.key(a) == RF#AbsHint.key(b) ==> REQ#AbsHint(a, b));

axiom (forall a: RT#AbsHint, b: RT#AbsHint :: { REQ#AbsHint(a, b) } REQ#AbsHint(a, b) == (a == b));

function RF#AbsHint.src(r: RT#AbsHint) : int;

function RF#AbsHint.dst(r: RT#AbsHint) : int;

function RF#AbsHint.key(r: RT#AbsHint) : int;

const unique ^HintedHandoffStores: $ctype;

axiom $is_span_sequential(^HintedHandoffStores);

axiom $def_struct_type(^HintedHandoffStores, 134217728, false, false);

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2(#s1, #s2, #p, ^HintedHandoffStores) } $inv2(#s1, #s2, #p, ^HintedHandoffStores) == ($set_eq($owns(#s2, #p), $set_empty()) && $rd_inv(#s2, HintedHandoffStores.size, #p) <= 16777215 && (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), $rd_inv(#s2, $field($idx($dot(#p, HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot(#p, HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv(#s2, HintedHandoffStores.size, #p) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), $rd_inv(#s2, $field($idx($dot(#p, HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot(#p, HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410))))) && (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, HintedHandoffStores.idx, #p)), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, HintedHandoffStores.idx, #p)), Q#h$1^185.14#tc2#1411) < $rd_inv(#s2, HintedHandoffStores.size, #p)) && (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, HintedHandoffStores.idx, #p)), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), Q#h$1^186.14#tc2#1412) ==> $rd_inv(#s2, $field($idx($dot(#p, HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, HintedHandoffStores.idx, #p)), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot(#p, HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, HintedHandoffStores.idx, #p)), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412) && ($rd_inv(#s2, HintedHandoffStores.tkey, #p) >= 0 && $rd_inv(#s2, HintedHandoffStores.tkey, #p) < 10000 ==> $rd_inv(#s2, HintedHandoffStores.tcoord, #p) == F#get_coord_for_key($rd_inv(#s2, HintedHandoffStores.tkey, #p)))));

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2_without_lemmas(#s1, #s2, #p, ^HintedHandoffStores) } $inv2_without_lemmas(#s1, #s2, #p, ^HintedHandoffStores) == ($set_eq($owns(#s2, #p), $set_empty()) && $rd_inv(#s2, HintedHandoffStores.size, #p) <= 16777215 && (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), $rd_inv(#s2, $field($idx($dot(#p, HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot(#p, HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv(#s2, HintedHandoffStores.size, #p) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), $rd_inv(#s2, $field($idx($dot(#p, HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot(#p, HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410))))) && (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, HintedHandoffStores.idx, #p)), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, HintedHandoffStores.idx, #p)), Q#h$1^185.14#tc2#1411) < $rd_inv(#s2, HintedHandoffStores.size, #p)) && (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, HintedHandoffStores.idx, #p)), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, HintedHandoffStores.hset, #p)), Q#h$1^186.14#tc2#1412) ==> $rd_inv(#s2, $field($idx($dot(#p, HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, HintedHandoffStores.idx, #p)), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot(#p, HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, HintedHandoffStores.idx, #p)), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412) && ($rd_inv(#s2, HintedHandoffStores.tkey, #p) >= 0 && $rd_inv(#s2, HintedHandoffStores.tkey, #p) < 10000 ==> $rd_inv(#s2, HintedHandoffStores.tcoord, #p) == F#get_coord_for_key($rd_inv(#s2, HintedHandoffStores.tkey, #p)))));

axiom (forall p: $ptr, q: $ptr, s: $state :: { $in(q, $composite_extent(s, p, ^HintedHandoffStores)) } $in(q, $composite_extent(s, p, ^HintedHandoffStores)) == (q == p));

const unique HintedHandoffStores.hint_store: $field;

axiom $def_phys_arr_field(^HintedHandoffStores, HintedHandoffStores.hint_store, ^^u8, false, 0, 16777215);

const unique HintedHandoffStores.size: $field;

axiom $def_phys_field(^HintedHandoffStores, HintedHandoffStores.size, ^^u8, false, 134217720);

const unique HintedHandoffStores.hset: $field;

axiom $def_ghost_field(^HintedHandoffStores, HintedHandoffStores.hset, $map_t(^^u8, ^^bool), false);

const unique HintedHandoffStores.idx: $field;

axiom $def_ghost_field(^HintedHandoffStores, HintedHandoffStores.idx, $map_t(^^u8, ^^u8), false);

const unique HintedHandoffStores.tainted_nodes: $field;

axiom $def_ghost_field(^HintedHandoffStores, HintedHandoffStores.tainted_nodes, $map_t(^^i4, ^^bool), false);

const unique HintedHandoffStores.tkey: $field;

axiom $def_ghost_field(^HintedHandoffStores, HintedHandoffStores.tkey, ^^i4, false);

const unique HintedHandoffStores.tcoord: $field;

axiom $def_ghost_field(^HintedHandoffStores, HintedHandoffStores.tcoord, ^^i4, false);

procedure HintedHandoffStores#adm(P#_this_: $ptr);
  modifies $s, $cev_pc;
  ensures $is_admissibility_check() ==> $set_eq($owns($s, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)), $set_empty());
  ensures $is_admissibility_check() ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)) <= 16777215;
  ensures $is_admissibility_check() ==> (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))));
  ensures $is_admissibility_check() ==> (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)));
  ensures $is_admissibility_check() ==> (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412);
  ensures $is_admissibility_check() ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)) < 10000 ==> $rd_inv($s, HintedHandoffStores.tcoord, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)) == F#get_coord_for_key($rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)));
  ensures $is_unwrap_check() ==> $set_eq($owns($s, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)), $set_empty());
  ensures $is_unwrap_check() ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)) <= 16777215;
  ensures $is_unwrap_check() ==> (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))));
  ensures $is_unwrap_check() ==> (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)));
  ensures $is_unwrap_check() ==> (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#_this_, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412);
  ensures $is_unwrap_check() ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)) < 10000 ==> $rd_inv($s, HintedHandoffStores.tcoord, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)) == F#get_coord_for_key($rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#_this_, ^HintedHandoffStores)));
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



implementation HintedHandoffStores#adm(P#_this_: $ptr)
{
  var #wrTime$1^169.9: int;
  var #stackframe: int;

  anon18:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^169.9, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^169.9 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^169.9, (lambda #p: $ptr :: false));
    // assume @decreases_level_is(0); 
    assume 0 == $decreases_level;
    // assume @_vcc_admissibility_start(_this_); 
    assume $admissibility_start($phys_ptr_cast(P#_this_, ^HintedHandoffStores), ^HintedHandoffStores);
    assume true;
    // if (@_vcc_is_unwrap_check) ...
    if ($is_unwrap_check())
    {
      anon13:
        // assume !(@_vcc_is_stuttering_check); 
        assume !$is_stuttering_check();
        // assume @_vcc_unwrap_check_pre(@state, _this_); 
        assume $unwrap_check_pre($s, $phys_ptr_cast(P#_this_, ^HintedHandoffStores));
        // @_vcc_unwrap_check(_this_)
        call $unwrap_check($phys_ptr_cast(P#_this_, ^HintedHandoffStores));
        assume $good_state_ext(#tok$1^169.9, $s);
        // assert true
    }
    else
    {
      anon16:
        assume true;
        // if (@_vcc_is_admissibility_check) ...
        if ($is_admissibility_check())
        {
          anon14:
            // assume @_vcc_admissibility_pre(@state, _this_); 
            assume $admissibility_pre($s, $phys_ptr_cast(P#_this_, ^HintedHandoffStores));
        }
        else
        {
          anon15:
            // assume @_vcc_stuttering_pre(@state, _this_); 
            assume $stuttering_pre($s, $phys_ptr_cast(P#_this_, ^HintedHandoffStores));
        }

      anon17:
        // @_vcc_havoc_others(_this_, @_vcc_typeof((struct HintedHandoffStores*)@null))
        call $havoc_others($phys_ptr_cast(P#_this_, ^HintedHandoffStores), ^HintedHandoffStores);
        assume $good_state_ext(#tok$1^169.9, $s);
        // assert true
        // assume ==>(@_vcc_is_stuttering_check, @_vcc_inv2(old(@prestate, @state), @state, _this_)); 
        assume $is_stuttering_check() ==> $inv2(old($s), $s, $phys_ptr_cast(P#_this_, ^HintedHandoffStores), ^HintedHandoffStores);
    }

  #exit:
}



const unique ^PendingSet: $ctype;

axiom $is_span_sequential(^PendingSet);

axiom $def_struct_type(^PendingSet, 134217728, false, false);

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2(#s1, #s2, #p, ^PendingSet) } $inv2(#s1, #s2, #p, ^PendingSet) == ($set_eq($owns(#s2, #p), $set_empty()) && $rd_inv(#s2, PendingSet.size, #p) <= 16777215 && (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), $rd_inv(#s2, $field($idx($dot(#p, PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot(#p, PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv(#s2, PendingSet.size, #p) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), $rd_inv(#s2, $field($idx($dot(#p, PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot(#p, PendingSet.pending), Q#i$1^208.14#tc2#1413))))) && (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, PendingSet.idx, #p)), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, PendingSet.idx, #p)), Q#h$1^209.14#tc2#1414) < $rd_inv(#s2, PendingSet.size, #p)) && (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, PendingSet.idx, #p)), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), Q#h$1^210.14#tc2#1415) ==> $rd_inv(#s2, $field($idx($dot(#p, PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, PendingSet.idx, #p)), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot(#p, PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, PendingSet.idx, #p)), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415) && ($rd_inv(#s2, PendingSet.tkey, #p) >= 0 && $rd_inv(#s2, PendingSet.tkey, #p) < 10000 ==> $rd_inv(#s2, PendingSet.tcoord, #p) == F#get_coord_for_key($rd_inv(#s2, PendingSet.tkey, #p)))));

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2_without_lemmas(#s1, #s2, #p, ^PendingSet) } $inv2_without_lemmas(#s1, #s2, #p, ^PendingSet) == ($set_eq($owns(#s2, #p), $set_empty()) && $rd_inv(#s2, PendingSet.size, #p) <= 16777215 && (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), $rd_inv(#s2, $field($idx($dot(#p, PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot(#p, PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv(#s2, PendingSet.size, #p) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), $rd_inv(#s2, $field($idx($dot(#p, PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot(#p, PendingSet.pending), Q#i$1^208.14#tc2#1413))))) && (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, PendingSet.idx, #p)), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, PendingSet.idx, #p)), Q#h$1^209.14#tc2#1414) < $rd_inv(#s2, PendingSet.size, #p)) && (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, PendingSet.idx, #p)), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(#s2, PendingSet.pset, #p)), Q#h$1^210.14#tc2#1415) ==> $rd_inv(#s2, $field($idx($dot(#p, PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, PendingSet.idx, #p)), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot(#p, PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv(#s2, PendingSet.idx, #p)), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415) && ($rd_inv(#s2, PendingSet.tkey, #p) >= 0 && $rd_inv(#s2, PendingSet.tkey, #p) < 10000 ==> $rd_inv(#s2, PendingSet.tcoord, #p) == F#get_coord_for_key($rd_inv(#s2, PendingSet.tkey, #p)))));

axiom (forall p: $ptr, q: $ptr, s: $state :: { $in(q, $composite_extent(s, p, ^PendingSet)) } $in(q, $composite_extent(s, p, ^PendingSet)) == (q == p));

const unique PendingSet.pending: $field;

axiom $def_phys_arr_field(^PendingSet, PendingSet.pending, ^^u8, false, 0, 16777215);

const unique PendingSet.size: $field;

axiom $def_phys_field(^PendingSet, PendingSet.size, ^^u8, false, 134217720);

const unique PendingSet.pset: $field;

axiom $def_ghost_field(^PendingSet, PendingSet.pset, $map_t(^^u8, ^^bool), false);

const unique PendingSet.idx: $field;

axiom $def_ghost_field(^PendingSet, PendingSet.idx, $map_t(^^u8, ^^u8), false);

const unique PendingSet.tainted_nodes: $field;

axiom $def_ghost_field(^PendingSet, PendingSet.tainted_nodes, $map_t(^^i4, ^^bool), false);

const unique PendingSet.tkey: $field;

axiom $def_ghost_field(^PendingSet, PendingSet.tkey, ^^i4, false);

const unique PendingSet.tcoord: $field;

axiom $def_ghost_field(^PendingSet, PendingSet.tcoord, ^^i4, false);

procedure PendingSet#adm(P#_this_: $ptr);
  modifies $s, $cev_pc;
  ensures $is_admissibility_check() ==> $set_eq($owns($s, $phys_ptr_cast(P#_this_, ^PendingSet)), $set_empty());
  ensures $is_admissibility_check() ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#_this_, ^PendingSet)) <= 16777215;
  ensures $is_admissibility_check() ==> (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#_this_, ^PendingSet)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))));
  ensures $is_admissibility_check() ==> (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^209.14#tc2#1414) < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#_this_, ^PendingSet)));
  ensures $is_admissibility_check() ==> (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^210.14#tc2#1415) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415);
  ensures $is_admissibility_check() ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#_this_, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#_this_, ^PendingSet)) < 10000 ==> $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#_this_, ^PendingSet)) == F#get_coord_for_key($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#_this_, ^PendingSet)));
  ensures $is_unwrap_check() ==> $set_eq($owns($s, $phys_ptr_cast(P#_this_, ^PendingSet)), $set_empty());
  ensures $is_unwrap_check() ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#_this_, ^PendingSet)) <= 16777215;
  ensures $is_unwrap_check() ==> (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#_this_, ^PendingSet)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))));
  ensures $is_unwrap_check() ==> (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^209.14#tc2#1414) < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#_this_, ^PendingSet)));
  ensures $is_unwrap_check() ==> (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^210.14#tc2#1415) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot($phys_ptr_cast(P#_this_, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#_this_, ^PendingSet))), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415);
  ensures $is_unwrap_check() ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#_this_, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#_this_, ^PendingSet)) < 10000 ==> $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#_this_, ^PendingSet)) == F#get_coord_for_key($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#_this_, ^PendingSet)));
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



implementation PendingSet#adm(P#_this_: $ptr)
{
  var #wrTime$1^192.9: int;
  var #stackframe: int;

  anon24:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^192.9, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^192.9 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^192.9, (lambda #p: $ptr :: false));
    // assume @decreases_level_is(0); 
    assume 0 == $decreases_level;
    // assume @_vcc_admissibility_start(_this_); 
    assume $admissibility_start($phys_ptr_cast(P#_this_, ^PendingSet), ^PendingSet);
    assume true;
    // if (@_vcc_is_unwrap_check) ...
    if ($is_unwrap_check())
    {
      anon19:
        // assume !(@_vcc_is_stuttering_check); 
        assume !$is_stuttering_check();
        // assume @_vcc_unwrap_check_pre(@state, _this_); 
        assume $unwrap_check_pre($s, $phys_ptr_cast(P#_this_, ^PendingSet));
        // @_vcc_unwrap_check(_this_)
        call $unwrap_check($phys_ptr_cast(P#_this_, ^PendingSet));
        assume $good_state_ext(#tok$1^192.9, $s);
        // assert true
    }
    else
    {
      anon22:
        assume true;
        // if (@_vcc_is_admissibility_check) ...
        if ($is_admissibility_check())
        {
          anon20:
            // assume @_vcc_admissibility_pre(@state, _this_); 
            assume $admissibility_pre($s, $phys_ptr_cast(P#_this_, ^PendingSet));
        }
        else
        {
          anon21:
            // assume @_vcc_stuttering_pre(@state, _this_); 
            assume $stuttering_pre($s, $phys_ptr_cast(P#_this_, ^PendingSet));
        }

      anon23:
        // @_vcc_havoc_others(_this_, @_vcc_typeof((struct PendingSet*)@null))
        call $havoc_others($phys_ptr_cast(P#_this_, ^PendingSet), ^PendingSet);
        assume $good_state_ext(#tok$1^192.9, $s);
        // assert true
        // assume ==>(@_vcc_is_stuttering_check, @_vcc_inv2(old(@prestate, @state), @state, _this_)); 
        assume $is_stuttering_check() ==> $inv2(old($s), $s, $phys_ptr_cast(P#_this_, ^PendingSet), ^PendingSet);
    }

  #exit:
}



const unique ^Env: $ctype;

axiom $is_span_sequential(^Env);

axiom $def_struct_type(^Env, 32, false, false);

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2(#s1, #s2, #p, ^Env) } $inv2(#s1, #s2, #p, ^Env) == ($rd_phys_ptr(#s1, Env.pl, #p, ^PreferenceLists) == $rd_phys_ptr(#s2, Env.pl, #p, ^PreferenceLists) && $keeps(#s2, #p, $rd_phys_ptr(#s2, Env.pl, #p, ^PreferenceLists)) && $rd_phys_ptr(#s1, Env.ls, #p, ^LocalStores) == $rd_phys_ptr(#s2, Env.ls, #p, ^LocalStores) && $keeps(#s2, #p, $rd_phys_ptr(#s2, Env.ls, #p, ^LocalStores)) && $rd_phys_ptr(#s1, Env.hhs, #p, ^HintedHandoffStores) == $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores) && $keeps(#s2, #p, $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores)) && $rd_phys_ptr(#s1, Env.ps, #p, ^PendingSet) == $rd_phys_ptr(#s2, Env.ps, #p, ^PendingSet) && $keeps(#s2, #p, $rd_phys_ptr(#s2, Env.ps, #p, ^PendingSet)) && $rd_inv(#s2, LocalStores.tainted_key, $rd_phys_ptr(#s2, Env.ls, #p, ^LocalStores)) == $rd_inv(#s2, HintedHandoffStores.tkey, $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores)) && $bool_to_int($bool_to_int($rd_inv(#s2, Env.tainted_key, #p) == $rd_inv(#s2, LocalStores.tainted_key, $rd_phys_ptr(#s2, Env.ls, #p, ^LocalStores))) == $rd_inv(#s2, HintedHandoffStores.tkey, $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores))) == $rd_inv(#s2, PendingSet.tkey, $rd_phys_ptr(#s2, Env.ps, #p, ^PendingSet)) && $bool_to_int($rd_inv(#s2, Env.tainted_coord, #p) == $rd_inv(#s2, HintedHandoffStores.tcoord, $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores))) == $rd_inv(#s2, PendingSet.tcoord, $rd_phys_ptr(#s2, Env.ps, #p, ^PendingSet)) && ($rd_inv(#s2, Env.tainted_key, #p) >= 0 && $rd_inv(#s2, Env.tainted_key, #p) < 10000 ==> $rd_inv(#s2, Env.tainted_coord, #p) == F#get_coord_for_key($rd_inv(#s2, Env.tainted_key, #p))) && ($rd_inv(#s2, Env.tainted_key, #p) != -1 && $rd_inv(#s2, Env.tainted_coord, #p) == F#get_coord_for_key($rd_inv(#s2, Env.tainted_key, #p)) ==> (forall Q#j$1^234.4#tc1#1416: int :: {:weight 10} { $op_mul($rd_inv(#s2, Env.tainted_coord, #p), 3200) + Q#j$1^234.4#tc1#1416 } $in_range_i4(Q#j$1^234.4#tc1#1416) ==> Q#j$1^234.4#tc1#1416 >= 0 && Q#j$1^234.4#tc1#1416 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(#s2, LocalStores.tainted_nodes, $rd_phys_ptr(#s2, Env.ls, #p, ^LocalStores))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv(#s2, PreferenceLists.vals, $rd_phys_ptr(#s2, Env.pl, #p, ^PreferenceLists))), $op_mul($rd_inv(#s2, Env.tainted_coord, #p), 3200) + Q#j$1^234.4#tc1#1416)) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(#s2, HintedHandoffStores.tainted_nodes, $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv(#s2, PreferenceLists.vals, $rd_phys_ptr(#s2, Env.pl, #p, ^PreferenceLists))), $op_mul($rd_inv(#s2, Env.tainted_coord, #p), 3200) + Q#j$1^234.4#tc1#1416)) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(#s2, PendingSet.tainted_nodes, $rd_phys_ptr(#s2, Env.ps, #p, ^PendingSet))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv(#s2, PreferenceLists.vals, $rd_phys_ptr(#s2, Env.pl, #p, ^PreferenceLists))), $op_mul($rd_inv(#s2, Env.tainted_coord, #p), 3200) + Q#j$1^234.4#tc1#1416))))));

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2_without_lemmas(#s1, #s2, #p, ^Env) } $inv2_without_lemmas(#s1, #s2, #p, ^Env) == ($rd_phys_ptr(#s1, Env.pl, #p, ^PreferenceLists) == $rd_phys_ptr(#s2, Env.pl, #p, ^PreferenceLists) && $keeps(#s2, #p, $rd_phys_ptr(#s2, Env.pl, #p, ^PreferenceLists)) && $rd_phys_ptr(#s1, Env.ls, #p, ^LocalStores) == $rd_phys_ptr(#s2, Env.ls, #p, ^LocalStores) && $keeps(#s2, #p, $rd_phys_ptr(#s2, Env.ls, #p, ^LocalStores)) && $rd_phys_ptr(#s1, Env.hhs, #p, ^HintedHandoffStores) == $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores) && $keeps(#s2, #p, $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores)) && $rd_phys_ptr(#s1, Env.ps, #p, ^PendingSet) == $rd_phys_ptr(#s2, Env.ps, #p, ^PendingSet) && $keeps(#s2, #p, $rd_phys_ptr(#s2, Env.ps, #p, ^PendingSet)) && $rd_inv(#s2, LocalStores.tainted_key, $rd_phys_ptr(#s2, Env.ls, #p, ^LocalStores)) == $rd_inv(#s2, HintedHandoffStores.tkey, $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores)) && $bool_to_int($bool_to_int($rd_inv(#s2, Env.tainted_key, #p) == $rd_inv(#s2, LocalStores.tainted_key, $rd_phys_ptr(#s2, Env.ls, #p, ^LocalStores))) == $rd_inv(#s2, HintedHandoffStores.tkey, $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores))) == $rd_inv(#s2, PendingSet.tkey, $rd_phys_ptr(#s2, Env.ps, #p, ^PendingSet)) && $bool_to_int($rd_inv(#s2, Env.tainted_coord, #p) == $rd_inv(#s2, HintedHandoffStores.tcoord, $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores))) == $rd_inv(#s2, PendingSet.tcoord, $rd_phys_ptr(#s2, Env.ps, #p, ^PendingSet)) && ($rd_inv(#s2, Env.tainted_key, #p) >= 0 && $rd_inv(#s2, Env.tainted_key, #p) < 10000 ==> $rd_inv(#s2, Env.tainted_coord, #p) == F#get_coord_for_key($rd_inv(#s2, Env.tainted_key, #p))) && ($rd_inv(#s2, Env.tainted_key, #p) != -1 && $rd_inv(#s2, Env.tainted_coord, #p) == F#get_coord_for_key($rd_inv(#s2, Env.tainted_key, #p)) ==> (forall Q#j$1^234.4#tc1#1416: int :: {:weight 10} { $op_mul($rd_inv(#s2, Env.tainted_coord, #p), 3200) + Q#j$1^234.4#tc1#1416 } $in_range_i4(Q#j$1^234.4#tc1#1416) ==> Q#j$1^234.4#tc1#1416 >= 0 && Q#j$1^234.4#tc1#1416 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(#s2, LocalStores.tainted_nodes, $rd_phys_ptr(#s2, Env.ls, #p, ^LocalStores))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv(#s2, PreferenceLists.vals, $rd_phys_ptr(#s2, Env.pl, #p, ^PreferenceLists))), $op_mul($rd_inv(#s2, Env.tainted_coord, #p), 3200) + Q#j$1^234.4#tc1#1416)) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(#s2, HintedHandoffStores.tainted_nodes, $rd_phys_ptr(#s2, Env.hhs, #p, ^HintedHandoffStores))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv(#s2, PreferenceLists.vals, $rd_phys_ptr(#s2, Env.pl, #p, ^PreferenceLists))), $op_mul($rd_inv(#s2, Env.tainted_coord, #p), 3200) + Q#j$1^234.4#tc1#1416)) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(#s2, PendingSet.tainted_nodes, $rd_phys_ptr(#s2, Env.ps, #p, ^PendingSet))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv(#s2, PreferenceLists.vals, $rd_phys_ptr(#s2, Env.pl, #p, ^PreferenceLists))), $op_mul($rd_inv(#s2, Env.tainted_coord, #p), 3200) + Q#j$1^234.4#tc1#1416))))));

axiom (forall p: $ptr, q: $ptr, s: $state :: { $in(q, $composite_extent(s, p, ^Env)) } $in(q, $composite_extent(s, p, ^Env)) == (q == p));

const unique Env.pl: $field;

axiom $def_phys_field(^Env, Env.pl, $ptr_to(^PreferenceLists), false, 0);

const unique Env.ls: $field;

axiom $def_phys_field(^Env, Env.ls, $ptr_to(^LocalStores), false, 8);

const unique Env.hhs: $field;

axiom $def_phys_field(^Env, Env.hhs, $ptr_to(^HintedHandoffStores), false, 16);

const unique Env.ps: $field;

axiom $def_phys_field(^Env, Env.ps, $ptr_to(^PendingSet), false, 24);

const unique Env.tainted_key: $field;

axiom $def_ghost_field(^Env, Env.tainted_key, ^^i4, false);

const unique Env.tainted_coord: $field;

axiom $def_ghost_field(^Env, Env.tainted_coord, ^^i4, false);

procedure Env#adm(P#_this_: $ptr);
  modifies $s, $cev_pc;
  ensures $is_admissibility_check() ==> $rd_phys_ptr(old($s), Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists) == $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists);
  ensures $is_admissibility_check() ==> $keeps($s, $phys_ptr_cast(P#_this_, ^Env), $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists));
  ensures $is_admissibility_check() ==> $rd_phys_ptr(old($s), Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores) == $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores);
  ensures $is_admissibility_check() ==> $keeps($s, $phys_ptr_cast(P#_this_, ^Env), $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores));
  ensures $is_admissibility_check() ==> $rd_phys_ptr(old($s), Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores) == $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores);
  ensures $is_admissibility_check() ==> $keeps($s, $phys_ptr_cast(P#_this_, ^Env), $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores));
  ensures $is_admissibility_check() ==> $rd_phys_ptr(old($s), Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet) == $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet);
  ensures $is_admissibility_check() ==> $keeps($s, $phys_ptr_cast(P#_this_, ^Env), $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet));
  ensures $is_admissibility_check() ==> $rd_inv($s, LocalStores.tainted_key, $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores)) == $rd_inv($s, HintedHandoffStores.tkey, $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores));
  ensures $is_admissibility_check() ==> $bool_to_int($bool_to_int($rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env)) == $rd_inv($s, LocalStores.tainted_key, $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores))) == $rd_inv($s, HintedHandoffStores.tkey, $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores))) == $rd_inv($s, PendingSet.tkey, $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet));
  ensures $is_admissibility_check() ==> $bool_to_int($rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)) == $rd_inv($s, HintedHandoffStores.tcoord, $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores))) == $rd_inv($s, PendingSet.tcoord, $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet));
  ensures $is_admissibility_check() ==> $rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env)) >= 0 && $rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env)) < 10000 ==> $rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)) == F#get_coord_for_key($rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env)));
  ensures $is_admissibility_check() ==> $rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env)) != -1 && $rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)) == F#get_coord_for_key($rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env))) ==> (forall Q#j$1^234.4#tc1#1416: int :: {:weight 10} { $op_mul($rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)), 3200) + Q#j$1^234.4#tc1#1416 } $in_range_i4(Q#j$1^234.4#tc1#1416) ==> Q#j$1^234.4#tc1#1416 >= 0 && Q#j$1^234.4#tc1#1416 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists))), $op_mul($rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)), 3200) + Q#j$1^234.4#tc1#1416)) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists))), $op_mul($rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)), 3200) + Q#j$1^234.4#tc1#1416)) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists))), $op_mul($rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)), 3200) + Q#j$1^234.4#tc1#1416)));
  ensures $is_stuttering_check() ==> $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists) == $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists);
  ensures $is_stuttering_check() ==> $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores) == $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores);
  ensures $is_stuttering_check() ==> $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores) == $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores);
  ensures $is_stuttering_check() ==> $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet) == $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet);
  ensures $is_unwrap_check() ==> $rd_phys_ptr(old($s), Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists) == $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists);
  ensures $is_unwrap_check() ==> $keeps($s, $phys_ptr_cast(P#_this_, ^Env), $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists));
  ensures $is_unwrap_check() ==> $rd_phys_ptr(old($s), Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores) == $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores);
  ensures $is_unwrap_check() ==> $keeps($s, $phys_ptr_cast(P#_this_, ^Env), $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores));
  ensures $is_unwrap_check() ==> $rd_phys_ptr(old($s), Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores) == $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores);
  ensures $is_unwrap_check() ==> $keeps($s, $phys_ptr_cast(P#_this_, ^Env), $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores));
  ensures $is_unwrap_check() ==> $rd_phys_ptr(old($s), Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet) == $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet);
  ensures $is_unwrap_check() ==> $keeps($s, $phys_ptr_cast(P#_this_, ^Env), $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet));
  ensures $is_unwrap_check() ==> $rd_inv($s, LocalStores.tainted_key, $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores)) == $rd_inv($s, HintedHandoffStores.tkey, $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores));
  ensures $is_unwrap_check() ==> $bool_to_int($bool_to_int($rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env)) == $rd_inv($s, LocalStores.tainted_key, $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores))) == $rd_inv($s, HintedHandoffStores.tkey, $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores))) == $rd_inv($s, PendingSet.tkey, $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet));
  ensures $is_unwrap_check() ==> $bool_to_int($rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)) == $rd_inv($s, HintedHandoffStores.tcoord, $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores))) == $rd_inv($s, PendingSet.tcoord, $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet));
  ensures $is_unwrap_check() ==> $rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env)) >= 0 && $rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env)) < 10000 ==> $rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)) == F#get_coord_for_key($rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env)));
  ensures $is_unwrap_check() ==> $rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env)) != -1 && $rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)) == F#get_coord_for_key($rd_inv($s, Env.tainted_key, $phys_ptr_cast(P#_this_, ^Env))) ==> (forall Q#j$1^234.4#tc1#1416: int :: {:weight 10} { $op_mul($rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)), 3200) + Q#j$1^234.4#tc1#1416 } $in_range_i4(Q#j$1^234.4#tc1#1416) ==> Q#j$1^234.4#tc1#1416 >= 0 && Q#j$1^234.4#tc1#1416 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $rd_phys_ptr($s, Env.ls, $phys_ptr_cast(P#_this_, ^Env), ^LocalStores))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists))), $op_mul($rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)), 3200) + Q#j$1^234.4#tc1#1416)) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $rd_phys_ptr($s, Env.hhs, $phys_ptr_cast(P#_this_, ^Env), ^HintedHandoffStores))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists))), $op_mul($rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)), 3200) + Q#j$1^234.4#tc1#1416)) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $rd_phys_ptr($s, Env.ps, $phys_ptr_cast(P#_this_, ^Env), ^PendingSet))), $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $rd_phys_ptr($s, Env.pl, $phys_ptr_cast(P#_this_, ^Env), ^PreferenceLists))), $op_mul($rd_inv($s, Env.tainted_coord, $phys_ptr_cast(P#_this_, ^Env)), 3200) + Q#j$1^234.4#tc1#1416)));
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



implementation Env#adm(P#_this_: $ptr)
{
  var #wrTime$1^216.9: int;
  var #stackframe: int;

  anon30:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^216.9, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^216.9 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^216.9, (lambda #p: $ptr :: false));
    // assume @decreases_level_is(0); 
    assume 0 == $decreases_level;
    // assume @_vcc_admissibility_start(_this_); 
    assume $admissibility_start($phys_ptr_cast(P#_this_, ^Env), ^Env);
    assume true;
    // if (@_vcc_is_unwrap_check) ...
    if ($is_unwrap_check())
    {
      anon25:
        // assume !(@_vcc_is_stuttering_check); 
        assume !$is_stuttering_check();
        // assume @_vcc_unwrap_check_pre(@state, _this_); 
        assume $unwrap_check_pre($s, $phys_ptr_cast(P#_this_, ^Env));
        // @_vcc_unwrap_check(_this_)
        call $unwrap_check($phys_ptr_cast(P#_this_, ^Env));
        assume $good_state_ext(#tok$1^216.9, $s);
        // assert true
    }
    else
    {
      anon28:
        assume true;
        // if (@_vcc_is_admissibility_check) ...
        if ($is_admissibility_check())
        {
          anon26:
            // assume @_vcc_admissibility_pre(@state, _this_); 
            assume $admissibility_pre($s, $phys_ptr_cast(P#_this_, ^Env));
        }
        else
        {
          anon27:
            // assume @_vcc_stuttering_pre(@state, _this_); 
            assume $stuttering_pre($s, $phys_ptr_cast(P#_this_, ^Env));
        }

      anon29:
        // @_vcc_havoc_others(_this_, @_vcc_typeof((struct Env*)@null))
        call $havoc_others($phys_ptr_cast(P#_this_, ^Env), ^Env);
        assume $good_state_ext(#tok$1^216.9, $s);
        // assert true
        // assume ==>(@_vcc_is_stuttering_check, @_vcc_inv2(old(@prestate, @state), @state, _this_)); 
        assume $is_stuttering_check() ==> $inv2(old($s), $s, $phys_ptr_cast(P#_this_, ^Env), ^Env);
    }

  #exit:
}



const unique ^$#_purecall_handler#1: $ctype;

axiom $def_fnptr_type(^$#_purecall_handler#1);

type $#_purecall_handler#1;

const unique ^$#_invalid_parameter_handler#2: $ctype;

axiom $def_fnptr_type(^$#_invalid_parameter_handler#2);

type $#_invalid_parameter_handler#2;

const unique ^$#verified_model_cl.c..31682#3: $ctype;

axiom $def_fnptr_type(^$#verified_model_cl.c..31682#3);

type $#verified_model_cl.c..31682#3;

const unique ^$#_PtFuncCompare#4: $ctype;

axiom $def_fnptr_type(^$#_PtFuncCompare#4);

type $#_PtFuncCompare#4;

const unique ^$#_PtFuncCompare#5: $ctype;

axiom $def_fnptr_type(^$#_PtFuncCompare#5);

type $#_PtFuncCompare#5;

const unique ^$#_PtFuncCompare#6: $ctype;

axiom $def_fnptr_type(^$#_PtFuncCompare#6);

type $#_PtFuncCompare#6;

const unique ^$#_PtFuncCompare#7: $ctype;

axiom $def_fnptr_type(^$#_PtFuncCompare#7);

type $#_PtFuncCompare#7;

const unique ^$#_onexit_t#8: $ctype;

axiom $def_fnptr_type(^$#_onexit_t#8);

type $#_onexit_t#8;

const unique ^swrap#RDT: $ctype;

axiom $is_span_sequential(^swrap#RDT);

axiom $def_struct_type(^swrap#RDT, 4, false, false);

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2(#s1, #s2, #p, ^swrap#RDT) } $inv2(#s1, #s2, #p, ^swrap#RDT) == $set_eq($owns(#s2, #p), $set_empty()));

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2_without_lemmas(#s1, #s2, #p, ^swrap#RDT) } $inv2_without_lemmas(#s1, #s2, #p, ^swrap#RDT) == $set_eq($owns(#s2, #p), $set_empty()));

axiom (forall p: $ptr, q: $ptr, s: $state :: { $in(q, $composite_extent(s, p, ^swrap#RDT)) } $in(q, $composite_extent(s, p, ^swrap#RDT)) == (q == p));

const unique swrap#RDT.data: $field;

axiom $def_phys_field(^swrap#RDT, swrap#RDT.data, ^^i4, false, 0);

const unique G#wrap#RDT#dt9: $ptr;

axiom $def_global(G#wrap#RDT#dt9, ^swrap#RDT);

axiom $is_global($phys_ptr_cast(G#wrap#RDT#dt9, ^swrap#RDT), ^swrap#RDT);

const unique ^swrap#WDT: $ctype;

axiom $is_span_sequential(^swrap#WDT);

axiom $def_struct_type(^swrap#WDT, 4, false, false);

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2(#s1, #s2, #p, ^swrap#WDT) } $inv2(#s1, #s2, #p, ^swrap#WDT) == $set_eq($owns(#s2, #p), $set_empty()));

axiom (forall #s1: $state, #s2: $state, #p: $ptr :: { $inv2_without_lemmas(#s1, #s2, #p, ^swrap#WDT) } $inv2_without_lemmas(#s1, #s2, #p, ^swrap#WDT) == $set_eq($owns(#s2, #p), $set_empty()));

axiom (forall p: $ptr, q: $ptr, s: $state :: { $in(q, $composite_extent(s, p, ^swrap#WDT)) } $in(q, $composite_extent(s, p, ^swrap#WDT)) == (q == p));

const unique swrap#WDT.data: $field;

axiom $def_phys_field(^swrap#WDT, swrap#WDT.data, ^^i4, false, 0);

const unique G#wrap#WDT#dt10: $ptr;

axiom $def_global(G#wrap#WDT#dt10, ^swrap#WDT);

axiom $is_global($phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT), ^swrap#WDT);

function F#card_iset(SP#s: $map_t..^^i4.^^bool) : int;

const unique cf#card_iset: $pure_function;

axiom $function_arg_type(cf#card_iset, 0, ^^mathint);

axiom $function_arg_type(cf#card_iset, 1, $map_t(^^i4, ^^bool));

procedure card_iset(SP#s: $map_t..^^i4.^^bool) returns ($result: int);
  free ensures $result == F#card_iset(SP#s);
  free ensures $call_transition(old($s), $s);



function F#empty_iset() : $map_t..^^i4.^^bool;

const unique cf#empty_iset: $pure_function;

axiom $eq.$map_t..^^i4.^^bool(F#empty_iset(), F#lambda#45());

axiom $function_arg_type(cf#empty_iset, 0, $map_t(^^i4, ^^bool));

procedure empty_iset() returns ($result: $map_t..^^i4.^^bool);
  ensures $eq.$map_t..^^i4.^^bool($result, F#lambda#45());
  free ensures $result == F#empty_iset();
  free ensures $call_transition(old($s), $s);



function F#addone_iset(SP#s: $map_t..^^i4.^^bool, SP#i: int) : $map_t..^^i4.^^bool;

const unique cf#addone_iset: $pure_function;

axiom (forall SP#s: $map_t..^^i4.^^bool, SP#i: int :: { F#addone_iset(SP#s, SP#i) } $in_range_i4(SP#i) ==> $eq.$map_t..^^i4.^^bool(F#addone_iset(SP#s, SP#i), F#lambda#46(SP#s, SP#i)));

axiom $function_arg_type(cf#addone_iset, 0, $map_t(^^i4, ^^bool));

axiom $function_arg_type(cf#addone_iset, 1, $map_t(^^i4, ^^bool));

axiom $function_arg_type(cf#addone_iset, 2, ^^i4);

procedure addone_iset(SP#s: $map_t..^^i4.^^bool, SP#i: int) returns ($result: $map_t..^^i4.^^bool);
  ensures $eq.$map_t..^^i4.^^bool($result, F#lambda#46(SP#s, SP#i));
  free ensures $result == F#addone_iset(SP#s, SP#i);
  free ensures $call_transition(old($s), $s);



function F#delone_iset(SP#s: $map_t..^^i4.^^bool, SP#i: int) : $map_t..^^i4.^^bool;

const unique cf#delone_iset: $pure_function;

axiom (forall SP#s: $map_t..^^i4.^^bool, SP#i: int :: { F#delone_iset(SP#s, SP#i) } $in_range_i4(SP#i) ==> $eq.$map_t..^^i4.^^bool(F#delone_iset(SP#s, SP#i), F#lambda#47(SP#s, SP#i)));

axiom $function_arg_type(cf#delone_iset, 0, $map_t(^^i4, ^^bool));

axiom $function_arg_type(cf#delone_iset, 1, $map_t(^^i4, ^^bool));

axiom $function_arg_type(cf#delone_iset, 2, ^^i4);

procedure delone_iset(SP#s: $map_t..^^i4.^^bool, SP#i: int) returns ($result: $map_t..^^i4.^^bool);
  ensures $eq.$map_t..^^i4.^^bool($result, F#lambda#47(SP#s, SP#i));
  free ensures $result == F#delone_iset(SP#s, SP#i);
  free ensures $call_transition(old($s), $s);



function F#get_coord_for_key(P#key: int) : int;

const unique cf#get_coord_for_key: $pure_function;

axiom (forall P#key: int :: { F#get_coord_for_key(P#key) } $in_range_i4(P#key) && P#key >= 0 && P#key < 10000 ==> $in_range_i4(F#get_coord_for_key(P#key)) && F#get_coord_for_key(P#key) >= 0 && F#get_coord_for_key(P#key) < 10000);

axiom $function_arg_type(cf#get_coord_for_key, 0, ^^i4);

axiom $function_arg_type(cf#get_coord_for_key, 1, ^^i4);

procedure get_coord_for_key(P#key: int) returns ($result: int);
  requires P#key >= 0;
  requires P#key < 10000;
  free ensures $in_range_i4($result);
  ensures $result >= 0;
  ensures $result < 10000;
  free ensures $result == F#get_coord_for_key(P#key);
  free ensures $call_transition(old($s), $s);



function F#card_hset(SP#s: $map_t..^^u8.^^bool) : int;

const unique cf#card_hset: $pure_function;

axiom $function_arg_type(cf#card_hset, 0, ^^mathint);

axiom $function_arg_type(cf#card_hset, 1, $map_t(^^u8, ^^bool));

procedure card_hset(SP#s: $map_t..^^u8.^^bool) returns ($result: int);
  free ensures $result == F#card_hset(SP#s);
  free ensures $call_transition(old($s), $s);



function F#empty_hset() : $map_t..^^u8.^^bool;

const unique cf#empty_hset: $pure_function;

axiom $eq.$map_t..^^u8.^^bool(F#empty_hset(), F#lambda#48());

axiom $function_arg_type(cf#empty_hset, 0, $map_t(^^u8, ^^bool));

procedure empty_hset() returns ($result: $map_t..^^u8.^^bool);
  ensures $eq.$map_t..^^u8.^^bool($result, F#lambda#48());
  free ensures $result == F#empty_hset();
  free ensures $call_transition(old($s), $s);



function F#addone_hset(SP#s: $map_t..^^u8.^^bool, SP#h: int) : $map_t..^^u8.^^bool;

const unique cf#addone_hset: $pure_function;

axiom (forall SP#s: $map_t..^^u8.^^bool, SP#h: int :: { F#addone_hset(SP#s, SP#h) } $in_range_u8(SP#h) ==> $eq.$map_t..^^u8.^^bool(F#addone_hset(SP#s, SP#h), F#lambda#49(SP#s, SP#h)));

axiom $function_arg_type(cf#addone_hset, 0, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#addone_hset, 1, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#addone_hset, 2, ^^u8);

procedure addone_hset(SP#s: $map_t..^^u8.^^bool, SP#h: int) returns ($result: $map_t..^^u8.^^bool);
  ensures $eq.$map_t..^^u8.^^bool($result, F#lambda#49(SP#s, SP#h));
  free ensures $result == F#addone_hset(SP#s, SP#h);
  free ensures $call_transition(old($s), $s);



function F#delone_hset(SP#s: $map_t..^^u8.^^bool, SP#h: int) : $map_t..^^u8.^^bool;

const unique cf#delone_hset: $pure_function;

axiom (forall SP#s: $map_t..^^u8.^^bool, SP#h: int :: { F#delone_hset(SP#s, SP#h) } $in_range_u8(SP#h) ==> $eq.$map_t..^^u8.^^bool(F#delone_hset(SP#s, SP#h), F#lambda#50(SP#s, SP#h)));

axiom $function_arg_type(cf#delone_hset, 0, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#delone_hset, 1, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#delone_hset, 2, ^^u8);

procedure delone_hset(SP#s: $map_t..^^u8.^^bool, SP#h: int) returns ($result: $map_t..^^u8.^^bool);
  ensures $eq.$map_t..^^u8.^^bool($result, F#lambda#50(SP#s, SP#h));
  free ensures $result == F#delone_hset(SP#s, SP#h);
  free ensures $call_transition(old($s), $s);



function F#create_hint(P#src: int, P#dst: int, P#key: int) : int;

function F#create_hint#OP#ah(P#src: int, P#dst: int, P#key: int) : RT#AbsHint;

const unique cf#create_hint: $pure_function;

axiom (forall P#src: int, P#dst: int, P#key: int :: { F#create_hint(P#src, P#dst, P#key) } { F#create_hint#OP#ah(P#src, P#dst, P#key) } $in_range_i4(P#src) && $in_range_i4(P#dst) && $in_range_i4(P#key) && P#src >= 0 && P#src < 10000 && P#dst >= 0 && P#dst < 10000 && P#key >= 0 && P#key < 10000 ==> $in_range_u8(F#create_hint(P#src, P#dst, P#key)) && RF#AbsHint.src(F#create_hint#OP#ah(P#src, P#dst, P#key)) == P#src && RF#AbsHint.dst(F#create_hint#OP#ah(P#src, P#dst, P#key)) == P#dst && RF#AbsHint.key(F#create_hint#OP#ah(P#src, P#dst, P#key)) == P#key);

axiom $function_arg_type(cf#create_hint, 0, ^^u8);

axiom $function_arg_type(cf#create_hint, 1, ^^i4);

axiom $function_arg_type(cf#create_hint, 2, ^^i4);

axiom $function_arg_type(cf#create_hint, 3, ^^i4);

axiom $function_arg_type(cf#create_hint, 4, ^$#AbsHint);

procedure create_hint(P#src: int, P#dst: int, P#key: int) returns ($result: int, OP#ah: RT#AbsHint);
  requires P#src >= 0;
  requires P#src < 10000;
  requires P#dst >= 0;
  requires P#dst < 10000;
  requires P#key >= 0;
  requires P#key < 10000;
  free ensures $in_range_u8($result);
  ensures RF#AbsHint.src(OP#ah) == P#src;
  ensures RF#AbsHint.dst(OP#ah) == P#dst;
  ensures RF#AbsHint.key(OP#ah) == P#key;
  free ensures $result == F#create_hint(P#src, P#dst, P#key);
  free ensures $call_transition(old($s), $s);



implementation create_hint(P#src: int, P#dst: int, P#key: int) returns ($result: int, OP#ah: RT#AbsHint)
{
  var L#src_result: int where $in_range_u8(L#src_result);
  var L#dst_result: int where $in_range_u8(L#dst_result);
  var L#key_result: int where $in_range_u8(L#key_result);
  var L#result: int where $in_range_u8(L#result);
  var #wrTime$1^125.3: int;
  var #stackframe: int;

  anon31:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^125.3, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^125.3 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^125.3, (lambda #p: $ptr :: false));
    // assume @in_range_i4(src); 
    assume $in_range_i4(P#src);
    // assume @in_range_i4(dst); 
    assume $in_range_i4(P#dst);
    // assume @in_range_i4(key); 
    assume $in_range_i4(P#key);
    // assume @decreases_level_is(1); 
    assume 1 == $decreases_level;
    // assume true
    // assume true
    // uint64_t result; 
    // uint64_t key_result; 
    // uint64_t dst_result; 
    // uint64_t src_result; 
    // assert @in_range_u8((uint64_t)src); 
    assert $in_range_u8(P#src);
    // src_result := (uint64_t)src; 
    L#src_result := P#src;
    // assert @in_range_u8((uint64_t)dst); 
    assert $in_range_u8(P#dst);
    // dst_result := (uint64_t)dst; 
    L#dst_result := P#dst;
    // dst_result := dst_result; 
    L#dst_result := L#dst_result;
    // assert &&(<=(0, 16), <(16, 64)); 
    assert 0 <= 16 && 16 < 64;
    // dst_result := unchecked<<(dst_result, 16); 
    L#dst_result := $_shl(^^u8, L#dst_result, 16);
    // assert @in_range_u8((uint64_t)key); 
    assert $in_range_u8(P#key);
    // key_result := (uint64_t)key; 
    L#key_result := P#key;
    // assert &&(<=(0, 32), <(32, 64)); 
    assert 0 <= 32 && 32 < 64;
    // key_result := unchecked<<(key_result, 32); 
    L#key_result := $_shl(^^u8, L#key_result, 32);
    // assert @in_range_u8(+(+(key_result, dst_result), src_result)); 
    assert $in_range_u8(L#key_result + L#dst_result + L#src_result);
    // assert @in_range_u8(+(key_result, dst_result)); 
    assert $in_range_u8(L#key_result + L#dst_result);
    // result := +(+(key_result, dst_result), src_result); 
    L#result := L#key_result + L#dst_result + L#src_result;
    // assert @in_range_nat((\natural)src); 
    assert $in_range_nat(P#src);
    // ah := @rec_update(ah, userdata(__spec \natural src /* @0 */) : Field, (\natural)src); 
    OP#ah := RC#AbsHint(P#src, RF#AbsHint.dst(OP#ah), RF#AbsHint.key(OP#ah));
    // assert @in_range_nat((\natural)dst); 
    assert $in_range_nat(P#dst);
    // ah := @rec_update(ah, userdata(__spec \natural dst /* @0 */) : Field, (\natural)dst); 
    OP#ah := RC#AbsHint(RF#AbsHint.src(OP#ah), P#dst, RF#AbsHint.key(OP#ah));
    // assert @in_range_nat((\natural)key); 
    assert $in_range_nat(P#key);
    // ah := @rec_update(ah, userdata(__spec \natural key /* @0 */) : Field, (\natural)key); 
    OP#ah := RC#AbsHint(RF#AbsHint.src(OP#ah), RF#AbsHint.dst(OP#ah), P#key);
    // return result; 
    $result := L#result;
    assume true;
    assert $position_marker();
    goto #exit;

  anon32:
    // skip

  #exit:
}



function F#get_dst(P#h: int) : int;

const unique cf#get_dst: $pure_function;

axiom (forall P#h: int :: { F#get_dst(P#h) } $in_range_u8(P#h) ==> $in_range_i4(F#get_dst(P#h)) && F#get_dst(P#h) >= 0 && F#get_dst(P#h) < 10000);

axiom $function_arg_type(cf#get_dst, 0, ^^i4);

axiom $function_arg_type(cf#get_dst, 1, ^^u8);

procedure get_dst(P#h: int) returns ($result: int);
  free ensures $in_range_i4($result);
  ensures $result >= 0;
  ensures $result < 10000;
  free ensures $result == F#get_dst(P#h);
  free ensures $call_transition(old($s), $s);



implementation get_dst(P#h: int) returns ($result: int)
{
  var #wrTime$1^149.3: int;
  var #stackframe: int;

  anon33:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^149.3, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^149.3 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^149.3, (lambda #p: $ptr :: false));
    // assume @in_range_u8(h); 
    assume $in_range_u8(P#h);
    // assume @decreases_level_is(1); 
    assume 1 == $decreases_level;
    // assume ==(9999, @unchecked_u8((uint64_t)unchecked-(10000, 1))); 
    assume 9999 == $unchecked(^^u8, $unchk_sub(^^i4, 10000, 1));
    // assume true
    // assert @in_range_i4((int32_t)unchecked&(unchecked>>(h, 16), 9999)); 
    assert $in_range_i4($_and(^^u8, $_shr(P#h, 16), 9999));
    // assert &&(<=(0, 16), <(16, 64)); 
    assert 0 <= 16 && 16 < 64;
    // return (int32_t)unchecked&(unchecked>>(h, 16), 9999); 
    $result := $_and(^^u8, $_shr(P#h, 16), 9999);
    assume true;
    assert $position_marker();
    goto #exit;

  anon34:
    // skip

  #exit:
}



function F#get_key(P#h: int) : int;

const unique cf#get_key: $pure_function;

axiom (forall P#h: int :: { F#get_key(P#h) } $in_range_u8(P#h) ==> $in_range_i4(F#get_key(P#h)) && F#get_key(P#h) >= 0 && F#get_key(P#h) < 10000);

axiom $function_arg_type(cf#get_key, 0, ^^i4);

axiom $function_arg_type(cf#get_key, 1, ^^u8);

procedure get_key(P#h: int) returns ($result: int);
  free ensures $in_range_i4($result);
  ensures $result >= 0;
  ensures $result < 10000;
  free ensures $result == F#get_key(P#h);
  free ensures $call_transition(old($s), $s);



implementation get_key(P#h: int) returns ($result: int)
{
  var #wrTime$1^158.3: int;
  var #stackframe: int;

  anon35:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^158.3, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^158.3 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^158.3, (lambda #p: $ptr :: false));
    // assume @in_range_u8(h); 
    assume $in_range_u8(P#h);
    // assume @decreases_level_is(1); 
    assume 1 == $decreases_level;
    // assume ==(9999, @unchecked_u8((uint64_t)unchecked-(10000, 1))); 
    assume 9999 == $unchecked(^^u8, $unchk_sub(^^i4, 10000, 1));
    // assume true
    // assert @in_range_i4((int32_t)unchecked&(unchecked>>(h, 32), 9999)); 
    assert $in_range_i4($_and(^^u8, $_shr(P#h, 32), 9999));
    // assert &&(<=(0, 32), <(32, 64)); 
    assert 0 <= 32 && 32 < 64;
    // return (int32_t)unchecked&(unchecked>>(h, 32), 9999); 
    $result := $_and(^^u8, $_shr(P#h, 32), 9999);
    assume true;
    assert $position_marker();
    goto #exit;

  anon36:
    // skip

  #exit:
}



procedure init_live_nodes(P#ln: $ptr);
  requires $non_null($phys_ptr_cast(P#ln, ^LiveNodes));
  modifies $s, $cev_pc;
  ensures $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: $set_in(#p, $extent(old($s), $phys_ptr_cast(P#ln, ^LiveNodes)))));
  free ensures $call_transition(old($s), $s);



implementation init_live_nodes(P#ln: $ptr)
{
  var owns#112: $ptrset;
  var staticWrapState#110: $state;
  var prestate#109: $state;
  var #wrTime$1^250.1: int;
  var #stackframe: int;

  anon37:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^250.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^250.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^250.1, (lambda #p: $ptr :: $set_in(#p, $extent($s, $phys_ptr_cast(P#ln, ^LiveNodes)))));
    assume $extent_mutable($s, $phys_ptr_cast(P#ln, ^LiveNodes));
    // assume true
    // assume @decreases_level_is(1); 
    assume 1 == $decreases_level;
    // _math \state prestate#109; 
    // prestate#109 := @_vcc_current_state(@state); 
    prestate#109 := $current_state($s);
    // _math \state staticWrapState#110; 
    // staticWrapState#110 := @_vcc_current_state(@state); 
    staticWrapState#110 := $current_state($s);
    // _math \objset owns#112; 
    // owns#112 := @_vcc_set_empty; 
    owns#112 := $set_empty();
    // assert @writes_check(ln); 
    assert $top_writable($s, #wrTime$1^250.1, $phys_ptr_cast(P#ln, ^LiveNodes));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ln), staticWrapState#110, owns#112)
    call $static_wrap($phys_ptr_cast(P#ln, ^LiveNodes), staticWrapState#110, owns#112);
    assume $good_state_ext(#tok$1^256.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ln), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ln, ^LiveNodes)), $set_empty());
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure init_preference_lists(P#pl: $ptr);
  requires $non_null($phys_ptr_cast(P#pl, ^PreferenceLists));
  modifies $s, $cev_pc;
  ensures $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: $set_in(#p, $extent(old($s), $phys_ptr_cast(P#pl, ^PreferenceLists)))));
  free ensures $call_transition(old($s), $s);



implementation init_preference_lists(P#pl: $ptr)
{
  var owns#116: $ptrset;
  var staticWrapState#114: $state;
  var prestate#113: $state;
  var loopDecrEnd#304: int;
  var loopDecrEnd#302: int;
  var L#__temp63795: int where $in_range_i4(L#__temp63795);
  var loopDecrBeg#301: int;
  var #wrTime$1^277.3: int;
  var loopState#1: $state;
  var L#count: int where $in_range_i4(L#count);
  var L#value: int where $in_range_i4(L#value);
  var loopDecrBeg#303: int;
  var #wrTime$1^267.2: int;
  var loopState#0: $state;
  var L#i: int where $in_range_i4(L#i);
  var L#j: int where $in_range_i4(L#j);
  var #wrTime$1^260.1: int;
  var #stackframe: int;

  anon45:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^260.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^260.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^260.1, (lambda #p: $ptr :: $set_in(#p, $extent($s, $phys_ptr_cast(P#pl, ^PreferenceLists)))));
    assume $extent_mutable($s, $phys_ptr_cast(P#pl, ^PreferenceLists));
    // assume true
    // assume @decreases_level_is(1); 
    assume 1 == $decreases_level;
    // assume true
    // int32_t j; 
    // int32_t i; 
    // i := 0; 
    L#i := 0;
    // j := 0; 
    L#j := 0;
    call $bump_timestamp();
    assume $full_stop_ext(#tok$1^267.2, $s);
    loopState#0 := $s;
    assume #wrTime$1^267.2 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^267.2, (lambda #p: $ptr :: $set_in(#p, $extent($s, $phys_ptr_cast(P#pl, ^PreferenceLists)))));
    assert (forall #loopWrites^$1^267.2: $ptr :: { $dont_instantiate(#loopWrites^$1^267.2) } $listed_in_writes($s, #wrTime$1^267.2, #loopWrites^$1^267.2) ==> $top_writable($s, #wrTime$1^260.1, #loopWrites^$1^267.2));
    assume true;
    while (true)
      invariant L#i >= 0;
      invariant L#i <= 10000;
      invariant L#j == 0;
      invariant (forall Q#k$1^270.15#tc1#1177: int :: {:weight 10} { $idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^270.15#tc1#1177) } $in_range_i4(Q#k$1^270.15#tc1#1177) ==> Q#k$1^270.15#tc1#1177 >= 0 && Q#k$1^270.15#tc1#1177 < $op_mul(L#i, 3200) + L#j ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^270.15#tc1#1177)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^270.15#tc1#1177))) >= 0 && $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^270.15#tc1#1177)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^270.15#tc1#1177))) < 10000);
      invariant (forall Q#k$1^271.15#tc1#1178: int :: {:weight 10} { $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $phys_ptr_cast(P#pl, ^PreferenceLists))), Q#k$1^271.15#tc1#1178) } $in_range_i4(Q#k$1^271.15#tc1#1178) ==> Q#k$1^271.15#tc1#1178 >= 0 && Q#k$1^271.15#tc1#1178 < $op_mul(L#i, 3200) + L#j ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^271.15#tc1#1178)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^271.15#tc1#1178))) == $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $phys_ptr_cast(P#pl, ^PreferenceLists))), Q#k$1^271.15#tc1#1178));
    {
      anon44:
        assume $modifies(loopState#0, $s, (lambda #p: $ptr :: $set_in(#p, $extent(loopState#0, $phys_ptr_cast(P#pl, ^PreferenceLists)))));
        assume $timestamp_post(loopState#0, $s);
        assume $full_stop_ext(#tok$1^267.2, $s);
        // \integer loopDecrBeg#303; 
        // loopDecrBeg#303 := @prelude_int_distance(i, 10000); 
        loopDecrBeg#303 := $int_distance(L#i, 10000);
        // assume @_vcc_meta_eq(old(@prestate, @state), @state); 
        assume $meta_eq(loopState#0, $s);
        assume true;
        // if (<(i, 10000)) ...
        if (L#i < 10000)
        {
          anon41:
            // int32_t value; 
            // int32_t count; 
            // assert >=(i, 0); 
            assert L#i >= 0;
            // assert <(i, 10000); 
            assert L#i < 10000;
            // assume &&(>=(i, 0), <(i, 10000)); 
            assume L#i >= 0 && L#i < 10000;
            // count := i; 
            L#count := L#i;
            // value := 0; 
            L#value := 0;
            call $bump_timestamp();
            assume $full_stop_ext(#tok$1^277.3, $s);
            loopState#1 := $s;
            assume #wrTime$1^277.3 == $current_timestamp($s);
            assume $def_writes($s, #wrTime$1^277.3, (lambda #p: $ptr :: $set_in(#p, $extent($s, $phys_ptr_cast(P#pl, ^PreferenceLists)))));
            assert (forall #loopWrites^$1^277.3: $ptr :: { $dont_instantiate(#loopWrites^$1^277.3) } $listed_in_writes($s, #wrTime$1^277.3, #loopWrites^$1^277.3) ==> $top_writable($s, #wrTime$1^267.2, #loopWrites^$1^277.3));
            assume true;
            while (true)
	      invariant init_preference_lists_b1(L#i, L#j, L#count, L#i + L#j);
              /*
              invariant L#count == L#i + L#j;
	      invariant L#i >= 0;
              invariant L#i < 10000;
              invariant $int_to_bool($_and(^^i4, $bool_to_int(L#j >= 0), $bool_to_int(L#j <= 3200)));
              invariant true;
	      invariant L#value >= 0;
              invariant L#value < 10000;
	      */
              invariant (forall Q#k$1^282.16#tc1#1175: int :: {:weight 10} { $idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^282.16#tc1#1175) } $in_range_i4(Q#k$1^282.16#tc1#1175) ==> Q#k$1^282.16#tc1#1175 >= 0 && Q#k$1^282.16#tc1#1175 < $op_mul(L#i, 3200) + L#j ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^282.16#tc1#1175)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^282.16#tc1#1175))) >= 0 && $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^282.16#tc1#1175)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^282.16#tc1#1175))) < 10000);
              invariant (forall Q#k$1^283.16#tc1#1176: int :: {:weight 10} { $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $phys_ptr_cast(P#pl, ^PreferenceLists))), Q#k$1^283.16#tc1#1176) } $in_range_i4(Q#k$1^283.16#tc1#1176) ==> Q#k$1^283.16#tc1#1176 >= 0 && Q#k$1^283.16#tc1#1176 < $op_mul(L#i, 3200) + L#j ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^283.16#tc1#1176)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#k$1^283.16#tc1#1176))) == $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $phys_ptr_cast(P#pl, ^PreferenceLists))), Q#k$1^283.16#tc1#1176));
            {
              anon40:
                assume $modifies(loopState#1, $s, (lambda #p: $ptr :: $set_in(#p, $extent(loopState#1, $phys_ptr_cast(P#pl, ^PreferenceLists)))));
                assume $timestamp_post(loopState#1, $s);
                assume $full_stop_ext(#tok$1^277.3, $s);
                // \integer loopDecrBeg#301; 
                // loopDecrBeg#301 := @prelude_int_distance(j, 3200); 
                loopDecrBeg#301 := $int_distance(L#j, 3200);
                // assume @_vcc_meta_eq(old(@prestate, @state), @state); 
                assume $meta_eq(loopState#1, $s);
                assume true;
                // if (<(j, 3200)) ...
                if (L#j < 3200)
                {
                  anon38:
                    // int32_t __temp63795; 
                    // __temp63795 := count; 
                    L#__temp63795 := L#count;
                    // assert @in_range_i4(+(__temp63795, 1)); 
                    assert $in_range_i4(L#__temp63795 + 1);
                    // count := +(__temp63795, 1); 
                    L#count := L#__temp63795 + 1;
                    // assert !=(10000, 0); 
                    assert 10000 != 0;
                    // value := unchecked%(__temp63795, 10000); 
                    L#value := $unchk_mod(^^i4, L#__temp63795, 10000);
                    // assert @prim_writes_check((pl->preference_list)[+(*(i, 3200), j)]); 
                    assert $writable_prim($s, #wrTime$1^277.3, $idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#i, 3200) + L#j));
                    // assert @in_range_i4(+(*(i, 3200), j)); 
                    assert $in_range_i4($op_mul(L#i, 3200) + L#j);
                    // assert @in_range_i4(*(i, 3200)); 
                    assert $in_range_i4($op_mul(L#i, 3200));
                    // *(pl->preference_list)[+(*(i, 3200), j)] := value; 
                    call $write_int($field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#i, 3200) + L#j)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#i, 3200) + L#j)), L#value);
                    assume $full_stop_ext(#tok$1^286.4, $s);
                    // assert @prim_writes_check((pl->vals)); 
                    assert $writable_prim($s, #wrTime$1^277.3, $dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.vals));
                    // assert @in_range_i4(+(*(i, 3200), j)); 
                    assert $in_range_i4($op_mul(L#i, 3200) + L#j);
                    // assert @in_range_i4(*(i, 3200)); 
                    assert $in_range_i4($op_mul(L#i, 3200));
                    // *(pl->vals) := @map_updated(*((pl->vals)), +(*(i, 3200), j), value); 
                    call $write_int(PreferenceLists.vals, $phys_ptr_cast(P#pl, ^PreferenceLists), $map_t..^^i4.^^i4_to_int($store.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $phys_ptr_cast(P#pl, ^PreferenceLists))), $op_mul(L#i, 3200) + L#j, L#value)));
                    assume $full_stop_ext(#tok$1^287.12, $s);
                    // assert @in_range_i4(+(j, 1)); 
                    assert $in_range_i4(L#j + 1);
                    // j := +(j, 1); 
                    L#j := L#j + 1;
                }
                else
                {
                  anon39:
                    // assert @_vcc_possibly_unreachable; 
                    assert {:PossiblyUnreachable true} true;
                    // goto #break_57; 
                    goto #break_57;
                }

              #continue_57:
                // \integer loopDecrEnd#302; 
                // loopDecrEnd#302 := @prelude_int_distance(j, 3200); 
                loopDecrEnd#302 := $int_distance(L#j, 3200);
                // assert @prelude_int_lt_or(loopDecrEnd#302, loopDecrBeg#301, false); 
                assert $int_lt_or(loopDecrEnd#302, loopDecrBeg#301, false);
                assume true;
            }

          anon42:
            assume $full_stop_ext(#tok$1^277.3, $s);

          #break_57:
            // j := 0; 
            L#j := 0;
            // assert @in_range_i4(+(i, 1)); 
            assert $in_range_i4(L#i + 1);
            // i := +(i, 1); 
            L#i := L#i + 1;
        }
        else
        {
          anon43:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
            // goto #break_56; 
            goto #break_56;
        }

      #continue_56:
        // \integer loopDecrEnd#304; 
        // loopDecrEnd#304 := @prelude_int_distance(i, 10000); 
        loopDecrEnd#304 := $int_distance(L#i, 10000);
        // assert @prelude_int_lt_or(loopDecrEnd#304, loopDecrBeg#303, false); 
        assert $int_lt_or(loopDecrEnd#304, loopDecrBeg#303, false);
        assume true;
    }

  anon46:
    assume $full_stop_ext(#tok$1^267.2, $s);

  #break_56:
    // assert ==(i, 10000); 
    assert L#i == 10000;
    // assume ==(i, 10000); 
    assume L#i == 10000;
    // _math \state prestate#113; 
    // prestate#113 := @_vcc_current_state(@state); 
    prestate#113 := $current_state($s);
    // _math \state staticWrapState#114; 
    // staticWrapState#114 := @_vcc_current_state(@state); 
    staticWrapState#114 := $current_state($s);
    // _math \objset owns#116; 
    // owns#116 := @_vcc_set_empty; 
    owns#116 := $set_empty();
    // assert @writes_check(pl); 
    assert $top_writable($s, #wrTime$1^260.1, $phys_ptr_cast(P#pl, ^PreferenceLists));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(pl), staticWrapState#114, owns#116)
    call $static_wrap($phys_ptr_cast(P#pl, ^PreferenceLists), staticWrapState#114, owns#116);
    assume $good_state_ext(#tok$1^294.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, pl), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#pl, ^PreferenceLists)), $set_empty());
    // assert @inv_check(forall(int32_t i; @in_range_i4(i); ==>(&&(>=(i, 0), <(i, 32000000)), &&(>=(*((pl->preference_list)[i]), 0), <(*((pl->preference_list)[i]), 10000))))); 
    assert (forall Q#i$1^74.14#tc1#1408: int :: {:weight 10} { $idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408) } $in_range_i4(Q#i$1^74.14#tc1#1408) ==> Q#i$1^74.14#tc1#1408 >= 0 && Q#i$1^74.14#tc1#1408 < 32000000 ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408))) >= 0 && $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^74.14#tc1#1408))) < 10000);
    // assert @inv_check(forall(int32_t i; @in_range_i4(i); ==>(&&(>=(i, 0), <(i, 32000000)), ==(@map_get(*((pl->vals)), i), *((pl->preference_list)[i]))))); 
    assert (forall Q#i$1^78.14#tc1#1409: int :: {:weight 10} { $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $phys_ptr_cast(P#pl, ^PreferenceLists))), Q#i$1^78.14#tc1#1409) } $in_range_i4(Q#i$1^78.14#tc1#1409) ==> Q#i$1^78.14#tc1#1409 >= 0 && Q#i$1^78.14#tc1#1409 < 32000000 ==> $select.$map_t..^^i4.^^i4($int_to_map_t..^^i4.^^i4($rd_inv($s, PreferenceLists.vals, $phys_ptr_cast(P#pl, ^PreferenceLists))), Q#i$1^78.14#tc1#1409) == $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^78.14#tc1#1409)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), Q#i$1^78.14#tc1#1409))));
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure init_local_stores(P#ls: $ptr);
  requires $non_null($phys_ptr_cast(P#ls, ^LocalStores));
  free requires -1 == $unchk_sub(^^i4, 0, 1);
  modifies $s, $cev_pc;
  ensures $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  ensures $rd_inv($s, LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores)) == 0;
  ensures $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1;
  free ensures -1 == $unchk_sub(^^i4, 0, 1);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: $set_in(#p, $extent(old($s), $phys_ptr_cast(P#ls, ^LocalStores)))));
  free ensures $call_transition(old($s), $s);



implementation init_local_stores(P#ls: $ptr)
{
  var owns#120: $ptrset;
  var staticWrapState#118: $state;
  var prestate#117: $state;
  var res_empty_iset#69: $map_t..^^i4.^^bool;
  var loopDecrEnd#308: int;
  var loopDecrEnd#306: int;
  var loopDecrBeg#305: int;
  var #wrTime$1^312.3: int;
  var loopState#3: $state;
  var loopDecrBeg#307: int;
  var #wrTime$1^307.2: int;
  var loopState#2: $state;
  var L#i: int where $in_range_i4(L#i);
  var L#j: int where $in_range_i4(L#j);
  var #wrTime$1^298.1: int;
  var #stackframe: int;

  anon54:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^298.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^298.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^298.1, (lambda #p: $ptr :: $set_in(#p, $extent($s, $phys_ptr_cast(P#ls, ^LocalStores)))));
    assume $extent_mutable($s, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume true
    // assume @decreases_level_is(2); 
    assume 2 == $decreases_level;
    // assume ==(-1, unchecked-(0, 1)); 
    assume -1 == $unchk_sub(^^i4, 0, 1);
    // assume true
    // int32_t j; 
    // int32_t i; 
    // i := 0; 
    L#i := 0;
    // j := 0; 
    L#j := 0;
    call $bump_timestamp();
    assume $full_stop_ext(#tok$1^307.2, $s);
    loopState#2 := $s;
    assume #wrTime$1^307.2 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^307.2, (lambda #p: $ptr :: $set_in(#p, $extent($s, $phys_ptr_cast(P#ls, ^LocalStores)))));
    assert (forall #loopWrites^$1^307.2: $ptr :: { $dont_instantiate(#loopWrites^$1^307.2) } $listed_in_writes($s, #wrTime$1^307.2, #loopWrites^$1^307.2) ==> $top_writable($s, #wrTime$1^298.1, #loopWrites^$1^307.2));
    assume true;
    while (true)
      invariant init_local_stores_b0(L#i, L#j);
      /*
      invariant L#i <= 10000;
      invariant L#j == 0;
      */
      invariant (forall Q#k$1^310.15#tc1#1184: int :: {:weight 10} { $idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), Q#k$1^310.15#tc1#1184) } $in_range_i4(Q#k$1^310.15#tc1#1184) ==> Q#k$1^310.15#tc1#1184 >= 0 && Q#k$1^310.15#tc1#1184 < $op_mul(L#i, 10000) + L#j ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), Q#k$1^310.15#tc1#1184)), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), Q#k$1^310.15#tc1#1184))) == -1);
    {
      anon53:
        assume $modifies(loopState#2, $s, (lambda #p: $ptr :: $set_in(#p, $extent(loopState#2, $phys_ptr_cast(P#ls, ^LocalStores)))));
        assume $timestamp_post(loopState#2, $s);
        assume $full_stop_ext(#tok$1^307.2, $s);
        // \integer loopDecrBeg#307; 
        // loopDecrBeg#307 := @prelude_int_distance(i, 10000); 
        loopDecrBeg#307 := $int_distance(L#i, 10000);
        // assume @_vcc_meta_eq(old(@prestate, @state), @state); 
        assume $meta_eq(loopState#2, $s);
        assume true;
        // if (<(i, 10000)) ...
        if (L#i < 10000)
        {
          anon50:
            call $bump_timestamp();
            assume $full_stop_ext(#tok$1^312.3, $s);
            loopState#3 := $s;
            assume #wrTime$1^312.3 == $current_timestamp($s);
            assume $def_writes($s, #wrTime$1^312.3, (lambda #p: $ptr :: $set_in(#p, $extent($s, $phys_ptr_cast(P#ls, ^LocalStores)))));
            assert (forall #loopWrites^$1^312.3: $ptr :: { $dont_instantiate(#loopWrites^$1^312.3) } $listed_in_writes($s, #wrTime$1^312.3, #loopWrites^$1^312.3) ==> $top_writable($s, #wrTime$1^307.2, #loopWrites^$1^312.3));
            assume true;
            while (true)
	      invariant init_local_stores_b1(L#i, L#j);
              /*
	      invariant L#i <= 10000;
              invariant L#j <= 10000;
	      */
              invariant (forall Q#k$1^314.16#tc1#1183: int :: {:weight 10} { $idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), Q#k$1^314.16#tc1#1183) } $in_range_i4(Q#k$1^314.16#tc1#1183) ==> Q#k$1^314.16#tc1#1183 >= 0 && Q#k$1^314.16#tc1#1183 < $op_mul(L#i, 10000) + L#j ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), Q#k$1^314.16#tc1#1183)), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), Q#k$1^314.16#tc1#1183))) == -1);
            {
              anon49:
                assume $modifies(loopState#3, $s, (lambda #p: $ptr :: $set_in(#p, $extent(loopState#3, $phys_ptr_cast(P#ls, ^LocalStores)))));
                assume $timestamp_post(loopState#3, $s);
                assume $full_stop_ext(#tok$1^312.3, $s);
                // \integer loopDecrBeg#305; 
                // loopDecrBeg#305 := @prelude_int_distance(j, 10000); 
                loopDecrBeg#305 := $int_distance(L#j, 10000);
                // assume @_vcc_meta_eq(old(@prestate, @state), @state); 
                assume $meta_eq(loopState#3, $s);
                assume true;
                // if (<(j, 10000)) ...
                if (L#j < 10000)
                {
                  anon47:
                    // assert @prim_writes_check((ls->local_store)[+(*(i, 10000), j)]); 
                    assert $writable_prim($s, #wrTime$1^312.3, $idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#i, 10000) + L#j));
                    // assert @in_range_i4(+(*(i, 10000), j)); 
                    assert $in_range_i4($op_mul(L#i, 10000) + L#j);
                    // assert @in_range_i4(*(i, 10000)); 
                    assert $in_range_i4($op_mul(L#i, 10000));
                    // *(ls->local_store)[+(*(i, 10000), j)] := -1; 
                    call $write_int($field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#i, 10000) + L#j)), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#i, 10000) + L#j)), -1);
                    assume $full_stop_ext(#tok$1^316.4, $s);
                    // assert @in_range_i4(+(j, 1)); 
                    assert $in_range_i4(L#j + 1);
                    // j := +(j, 1); 
                    L#j := L#j + 1;
                }
                else
                {
                  anon48:
                    // assert @_vcc_possibly_unreachable; 
                    assert {:PossiblyUnreachable true} true;
                    // goto #break_59; 
                    goto #break_59;
                }

              #continue_59:
                // \integer loopDecrEnd#306; 
                // loopDecrEnd#306 := @prelude_int_distance(j, 10000); 
                loopDecrEnd#306 := $int_distance(L#j, 10000);
                // assert @prelude_int_lt_or(loopDecrEnd#306, loopDecrBeg#305, false); 
                assert $int_lt_or(loopDecrEnd#306, loopDecrBeg#305, false);
                assume true;
            }

          anon51:
            assume $full_stop_ext(#tok$1^312.3, $s);

          #break_59:
            // j := 0; 
            L#j := 0;
            // assert @in_range_i4(+(i, 1)); 
            assert $in_range_i4(L#i + 1);
            // i := +(i, 1); 
            L#i := L#i + 1;
        }
        else
        {
          anon52:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
            // goto #break_58; 
            goto #break_58;
        }

      #continue_58:
        // \integer loopDecrEnd#308; 
        // loopDecrEnd#308 := @prelude_int_distance(i, 10000); 
        loopDecrEnd#308 := $int_distance(L#i, 10000);
        // assert @prelude_int_lt_or(loopDecrEnd#308, loopDecrBeg#307, false); 
        assert $int_lt_or(loopDecrEnd#308, loopDecrBeg#307, false);
        assume true;
    }

  anon55:
    assume $full_stop_ext(#tok$1^307.2, $s);

  #break_58:
    // (int32_t -> _Bool) res_empty_iset#69; 
    // res_empty_iset#69 := empty_iset(); 
    call res_empty_iset#69 := empty_iset();
    assume $full_stop_ext(#tok$1^322.30, $s);
    // assert @prim_writes_check((ls->tainted_nodes)); 
    assert $writable_prim($s, #wrTime$1^298.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.tainted_nodes));
    // *(ls->tainted_nodes) := res_empty_iset#69; 
    call $write_int(LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores), $map_t..^^i4.^^bool_to_int(res_empty_iset#69));
    assume $full_stop_ext(#tok$1^322.10, $s);
    // assert @prim_writes_check((ls->tainted_key)); 
    assert $writable_prim($s, #wrTime$1^298.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.tainted_key));
    // *(ls->tainted_key) := -1; 
    call $write_int(LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores), -1);
    assume $full_stop_ext(#tok$1^323.10, $s);
    // assert @prim_writes_check((ls->len)); 
    assert $writable_prim($s, #wrTime$1^298.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.len));
    // *(ls->len) := 0; 
    call $write_int(LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores), 0);
    assume $full_stop_ext(#tok$1^324.2, $s);
    // assert @prim_writes_check((ls->size)); 
    assert $writable_prim($s, #wrTime$1^298.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.size));
    // *(ls->size) := 0; 
    call $write_int(LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores), 0);
    assume $full_stop_ext(#tok$1^325.10, $s);
    // _math \state prestate#117; 
    // prestate#117 := @_vcc_current_state(@state); 
    prestate#117 := $current_state($s);
    // _math \state staticWrapState#118; 
    // staticWrapState#118 := @_vcc_current_state(@state); 
    staticWrapState#118 := $current_state($s);
    // _math \objset owns#120; 
    // owns#120 := @_vcc_set_empty; 
    owns#120 := $set_empty();
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^298.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ls), staticWrapState#118, owns#120)
    call $static_wrap($phys_ptr_cast(P#ls, ^LocalStores), staticWrapState#118, owns#120);
    assume $good_state_ext(#tok$1^326.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ls), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ls, ^LocalStores)), $set_empty());
    // assert @inv_check(<=(*((ls->len)), 100000000)); 
    assert $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores)) <= 100000000;
    // assert @inv_check(||(==(*((ls->tainted_key)), -1), &&(>=(*((ls->tainted_key)), 0), <(*((ls->tainted_key)), 10000)))); 
    assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) < 10000);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure init_hinted_handoff_stores(P#hhs: $ptr);
  requires $non_null($phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  requires $extent_mutable($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  modifies $s, $cev_pc;
  ensures $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  ensures $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == 0;
  ensures $eq.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), F#empty_hset());
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: $set_in(#p, $extent(old($s), $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))));
  free ensures $call_transition(old($s), $s);



implementation init_hinted_handoff_stores(P#hhs: $ptr)
{
  var owns#124: $ptrset;
  var staticWrapState#122: $state;
  var prestate#121: $state;
  var res_empty_hset#71: $map_t..^^u8.^^bool;
  var res_empty_iset#70: $map_t..^^i4.^^bool;
  var #wrTime$1^330.1: int;
  var #stackframe: int;

  anon56:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^330.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^330.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^330.1, (lambda #p: $ptr :: $set_in(#p, $extent($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))));
    assume $extent_mutable($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume true
    // assume @decreases_level_is(2); 
    assume 2 == $decreases_level;
    // assume ==(-1, unchecked-(0, 1)); 
    assume -1 == $unchk_sub(^^i4, 0, 1);
    // (int32_t -> _Bool) res_empty_iset#70; 
    // res_empty_iset#70 := empty_iset(); 
    call res_empty_iset#70 := empty_iset();
    assume $full_stop_ext(#tok$1^339.31, $s);
    // assert @prim_writes_check((hhs->tainted_nodes)); 
    assert $writable_prim($s, #wrTime$1^330.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.tainted_nodes));
    // *(hhs->tainted_nodes) := res_empty_iset#70; 
    call $write_int(HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^i4.^^bool_to_int(res_empty_iset#70));
    assume $full_stop_ext(#tok$1^339.10, $s);
    // assert @prim_writes_check((hhs->tkey)); 
    assert $writable_prim($s, #wrTime$1^330.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.tkey));
    // *(hhs->tkey) := -1; 
    call $write_int(HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), -1);
    assume $full_stop_ext(#tok$1^340.10, $s);
    // assert @prim_writes_check((hhs->tcoord)); 
    assert $writable_prim($s, #wrTime$1^330.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.tcoord));
    // *(hhs->tcoord) := -1; 
    call $write_int(HintedHandoffStores.tcoord, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), -1);
    assume $full_stop_ext(#tok$1^341.10, $s);
    // (uint64_t -> _Bool) res_empty_hset#71; 
    // res_empty_hset#71 := empty_hset(); 
    call res_empty_hset#71 := empty_hset();
    assume $full_stop_ext(#tok$1^342.22, $s);
    // assert @prim_writes_check((hhs->hset)); 
    assert $writable_prim($s, #wrTime$1^330.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hset));
    // *(hhs->hset) := res_empty_hset#71; 
    call $write_int(HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^u8.^^bool_to_int(res_empty_hset#71));
    assume $full_stop_ext(#tok$1^342.10, $s);
    // assert @prim_writes_check((hhs->size)); 
    assert $writable_prim($s, #wrTime$1^330.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.size));
    // *(hhs->size) := 0; 
    call $write_int(HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), 0);
    assume $full_stop_ext(#tok$1^343.2, $s);
    // _math \state prestate#121; 
    // prestate#121 := @_vcc_current_state(@state); 
    prestate#121 := $current_state($s);
    // _math \state staticWrapState#122; 
    // staticWrapState#122 := @_vcc_current_state(@state); 
    staticWrapState#122 := $current_state($s);
    // _math \objset owns#124; 
    // owns#124 := @_vcc_set_empty; 
    owns#124 := $set_empty();
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^330.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(hhs), staticWrapState#122, owns#124)
    call $static_wrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), staticWrapState#122, owns#124);
    assume $good_state_ext(#tok$1^344.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, hhs), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)), $set_empty());
    // assert @inv_check(<=(*((hhs->size)), 16777215)); 
    assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
    // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((hhs->size))), @map_get(*((hhs->hset)), *((hhs->hint_store)[i]))))); 
    assert (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), <(@map_get(*((hhs->idx)), h), *((hhs->size)))))); 
    assert (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), ==(*((hhs->hint_store)[@map_get(*((hhs->idx)), h)]), h)))); 
    assert (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412);
    // assert @inv_check(==>(&&(>=(*((hhs->tkey)), 0), <(*((hhs->tkey)), 10000)), ==(*((hhs->tcoord)), get_coord_for_key(*((hhs->tkey)))))); 
    assert $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 10000 ==> $rd_inv($s, HintedHandoffStores.tcoord, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == F#get_coord_for_key($rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure init_pending(P#ps: $ptr);
  requires $non_null($phys_ptr_cast(P#ps, ^PendingSet));
  requires $extent_mutable($s, $phys_ptr_cast(P#ps, ^PendingSet));
  modifies $s, $cev_pc;
  ensures $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  ensures $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == 0;
  ensures $eq.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), F#empty_hset());
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: $set_in(#p, $extent(old($s), $phys_ptr_cast(P#ps, ^PendingSet)))));
  free ensures $call_transition(old($s), $s);



implementation init_pending(P#ps: $ptr)
{
  var owns#128: $ptrset;
  var staticWrapState#126: $state;
  var prestate#125: $state;
  var res_empty_hset#73: $map_t..^^u8.^^bool;
  var res_empty_iset#72: $map_t..^^i4.^^bool;
  var #wrTime$1^347.1: int;
  var #stackframe: int;

  anon57:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^347.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^347.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^347.1, (lambda #p: $ptr :: $set_in(#p, $extent($s, $phys_ptr_cast(P#ps, ^PendingSet)))));
    assume $extent_mutable($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume true
    // assume @decreases_level_is(2); 
    assume 2 == $decreases_level;
    // assume ==(-1, unchecked-(0, 1)); 
    assume -1 == $unchk_sub(^^i4, 0, 1);
    // (int32_t -> _Bool) res_empty_iset#72; 
    // res_empty_iset#72 := empty_iset(); 
    call res_empty_iset#72 := empty_iset();
    assume $full_stop_ext(#tok$1^356.30, $s);
    // assert @prim_writes_check((ps->tainted_nodes)); 
    assert $writable_prim($s, #wrTime$1^347.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.tainted_nodes));
    // *(ps->tainted_nodes) := res_empty_iset#72; 
    call $write_int(PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^i4.^^bool_to_int(res_empty_iset#72));
    assume $full_stop_ext(#tok$1^356.10, $s);
    // assert @prim_writes_check((ps->tkey)); 
    assert $writable_prim($s, #wrTime$1^347.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.tkey));
    // *(ps->tkey) := -1; 
    call $write_int(PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet), -1);
    assume $full_stop_ext(#tok$1^357.10, $s);
    // assert @prim_writes_check((ps->tcoord)); 
    assert $writable_prim($s, #wrTime$1^347.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.tcoord));
    // *(ps->tcoord) := -1; 
    call $write_int(PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet), -1);
    assume $full_stop_ext(#tok$1^358.10, $s);
    // (uint64_t -> _Bool) res_empty_hset#73; 
    // res_empty_hset#73 := empty_hset(); 
    call res_empty_hset#73 := empty_hset();
    assume $full_stop_ext(#tok$1^359.21, $s);
    // assert @prim_writes_check((ps->pset)); 
    assert $writable_prim($s, #wrTime$1^347.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pset));
    // *(ps->pset) := res_empty_hset#73; 
    call $write_int(PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^u8.^^bool_to_int(res_empty_hset#73));
    assume $full_stop_ext(#tok$1^359.10, $s);
    // assert @prim_writes_check((ps->size)); 
    assert $writable_prim($s, #wrTime$1^347.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.size));
    // *(ps->size) := 0; 
    call $write_int(PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet), 0);
    assume $full_stop_ext(#tok$1^360.2, $s);
    // _math \state prestate#125; 
    // prestate#125 := @_vcc_current_state(@state); 
    prestate#125 := $current_state($s);
    // _math \state staticWrapState#126; 
    // staticWrapState#126 := @_vcc_current_state(@state); 
    staticWrapState#126 := $current_state($s);
    // _math \objset owns#128; 
    // owns#128 := @_vcc_set_empty; 
    owns#128 := $set_empty();
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^347.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ps), staticWrapState#126, owns#128)
    call $static_wrap($phys_ptr_cast(P#ps, ^PendingSet), staticWrapState#126, owns#128);
    assume $good_state_ext(#tok$1^361.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ps), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ps, ^PendingSet)), $set_empty());
    // assert @inv_check(<=(*((ps->size)), 16777215)); 
    assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
    // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((ps->size))), @map_get(*((ps->pset)), *((ps->pending)[i]))))); 
    assert (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), <(@map_get(*((ps->idx)), h), *((ps->size)))))); 
    assert (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), ==(*((ps->pending)[@map_get(*((ps->idx)), h)]), h)))); 
    assert (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415);
    // assert @inv_check(==>(&&(>=(*((ps->tkey)), 0), <(*((ps->tkey)), 10000)), ==(*((ps->tcoord)), get_coord_for_key(*((ps->tkey)))))); 
    assert $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) < 10000 ==> $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet)) == F#get_coord_for_key($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)));
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure get(P#key: int, P#coord: int, P#is_tainted: int, P#ln: $ptr, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr) returns ($result: int);
  requires $thread_local2($s, $dot($phys_ptr_cast(G#wrap#RDT#dt9, ^swrap#RDT), swrap#RDT.data), ^^i4);
  requires P#coord == F#get_coord_for_key(P#key);
  requires P#key >= 0;
  requires P#key < 10000;
  requires $non_null($phys_ptr_cast(P#ln, ^LiveNodes));
  requires $non_null($phys_ptr_cast(P#pl, ^PreferenceLists));
  requires $non_null($phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  requires $non_null($phys_ptr_cast(P#ls, ^LocalStores));
  requires $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), F#get_coord_for_key(P#key))), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), F#get_coord_for_key(P#key)))) == 1;
  requires $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  requires $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  requires $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  requires $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  requires $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  modifies $s, $cev_pc;
  free ensures $in_range_i4($result);
  ensures $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  ensures $int_to_bool(P#is_tainted) ==> (forall Q#j$1^378.28#tc1#1205: int :: {:weight 10} { $op_mul(P#coord, 3200) + Q#j$1^378.28#tc1#1205 } $in_range_i4(Q#j$1^378.28#tc1#1205) ==> Q#j$1^378.28#tc1#1205 >= 0 && Q#j$1^378.28#tc1#1205 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^378.28#tc1#1205)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^378.28#tc1#1205)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^378.28#tc1#1205)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^378.28#tc1#1205)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^378.28#tc1#1205)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^378.28#tc1#1205)))));
  ensures $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  ensures $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  ensures $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  ensures $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
  free ensures $call_transition(old($s), $s);



implementation get(P#key: int, P#coord: int, P#is_tainted: int, P#ln: $ptr, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr) returns ($result: int)
{
  var owns#135: $ptrset;
  var staticWrapState#133: $state;
  var prestate#132: $state;
  var res_addone_iset#74: $map_t..^^i4.^^bool;
  var ite#2: bool;
  var prestate#131: $state;
  var prestate#129: $state;
  var owns#130: $ptrset;
  var ite#1: bool;
  var SL#s0: $state;
  var #wrTime$1^396.12: int;
  var loopState#4: $state;
  var L#cnt_succ: int where $in_range_i4(L#cnt_succ);
  var L#cur_node: int where $in_range_i4(L#cur_node);
  var L#i: int where $in_range_i4(L#i);
  var #wrTime$1^364.1: int;
  var #stackframe: int;

  anon69:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^364.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^364.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^364.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
    assume $thread_owned($s, $phys_ptr_cast(P#ln, ^LiveNodes));
    assume $thread_owned($s, $phys_ptr_cast(P#ls, ^LocalStores));
    assume $thread_owned($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    assume $thread_owned($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @in_range_i4(key); 
    assume $in_range_i4(P#key);
    // assume @in_range_i4(coord); 
    assume $in_range_i4(P#coord);
    // assume @in_range_i4(is_tainted); 
    assume $in_range_i4(P#is_tainted);
    // assume true
    // assume true
    // assume true
    // assume true
    // assume true
    // assume @decreases_level_is(2147483647); 
    assume 2147483647 == $decreases_level;
    // assert @_vcc_in_domain(@state, ps, ps); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ps, ^PendingSet), $phys_ptr_cast(P#ps, ^PendingSet), l#public);
    // assert @_vcc_in_domain(@state, ls, ls); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ls, ^LocalStores), l#public);
    // assert @_vcc_in_domain(@state, hhs, hhs); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), l#public);
    // assert @_vcc_in_domain(@state, ln, ln); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ln, ^LiveNodes), l#public);
    // assert @_vcc_in_domain(@state, pl, pl); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#pl, ^PreferenceLists), l#public);
    // assume true
    // assume ==(-1, unchecked-(0, 1)); 
    assume -1 == $unchk_sub(^^i4, 0, 1);
    // int32_t i; 
    // int32_t cur_node; 
    // int32_t cnt_succ; 
    // cnt_succ := 0; 
    L#cnt_succ := 0;
    // cur_node := -1; 
    L#cur_node := -1;
    // i := 0; 
    L#i := 0;
    call $bump_timestamp();
    assume $full_stop_ext(#tok$1^396.12, $s);
    loopState#4 := $s;
    assume #wrTime$1^396.12 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^396.12, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    assert (forall #loopWrites^$1^396.12: $ptr :: { $dont_instantiate(#loopWrites^$1^396.12) } $listed_in_writes($s, #wrTime$1^396.12, #loopWrites^$1^396.12) ==> $top_writable($s, #wrTime$1^364.1, #loopWrites^$1^396.12));
    assume true;
    while (true)
      invariant L#cnt_succ <= L#i;
      invariant $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
      invariant $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
      invariant $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
      invariant $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
      invariant $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
      invariant $thread_local2($s, $dot($phys_ptr_cast(G#wrap#RDT#dt9, ^swrap#RDT), swrap#RDT.data), ^^i4);
      invariant L#i > 0 ==> L#cur_node >= 0;
      invariant L#i > 0 ==> L#cur_node < 10000;
      invariant L#i > 0 && $int_to_bool(P#is_tainted) && $int_to_bool($rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)))) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#cur_node) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#cur_node) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), L#cur_node);
      invariant L#i > 0 && $int_to_bool(P#is_tainted) ==> (forall Q#j$1^399.40#tc1#1204: int :: {:weight 10} { $op_mul(P#coord, 3200) + Q#j$1^399.40#tc1#1204 } $in_range_i4(Q#j$1^399.40#tc1#1204) ==> Q#j$1^399.40#tc1#1204 >= 0 && Q#j$1^399.40#tc1#1204 < L#i ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^399.40#tc1#1204)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^399.40#tc1#1204)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^399.40#tc1#1204)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^399.40#tc1#1204)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^399.40#tc1#1204)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^399.40#tc1#1204)))));
    {
      anon66:
        assume $modifies(loopState#4, $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
        assume $timestamp_post(loopState#4, $s);
        assume $full_stop_ext(#tok$1^387.2, $s);
        assume true;
        // if (<(i, 3200)) ...
        if (L#i < 3200)
        {
          anon62:
            // _math \state s0; 
            // assert ==>(>(i, 0), >=(cur_node, 0)); 
            assert L#i > 0 ==> L#cur_node >= 0;
            // assert ==>(>(i, 0), <(cur_node, 10000)); 
            assert L#i > 0 ==> L#cur_node < 10000;
            // assume ==>(>(i, 0), &&(>=(cur_node, 0), <(cur_node, 10000))); 
            assume L#i > 0 ==> L#cur_node >= 0 && L#cur_node < 10000;
            // assert @reads_check_normal((pl->preference_list)[+(*(coord, 3200), i)]); 
            assert $thread_local($s, $idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i));
            // assert @in_range_i4(+(*(coord, 3200), i)); 
            assert $in_range_i4($op_mul(P#coord, 3200) + L#i);
            // assert @in_range_i4(*(coord, 3200)); 
            assert $in_range_i4($op_mul(P#coord, 3200));
            // cur_node := *((pl->preference_list)[+(*(coord, 3200), i)]); 
            L#cur_node := $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i)));
            // _Bool ite#1; 
            // assert @reads_check_normal((ln->live_nodes)[cur_node]); 
            assert $thread_local($s, $idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node));
            // ite#1 := (_Bool)*((ln->live_nodes)[cur_node]); 
            ite#1 := $int_to_bool($rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node))));
            assume true;
            // if (ite#1) ...
            if (ite#1)
            {
              anon58:
                // assert @in_range_i4(+(cnt_succ, 1)); 
                assert $in_range_i4(L#cnt_succ + 1);
                // cnt_succ := +(cnt_succ, 1); 
                L#cnt_succ := L#cnt_succ + 1;
            }
            else
            {
              anon59:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
            }

          anon63:
            // assert @in_range_i4(+(i, 1)); 
            assert $in_range_i4(L#i + 1);
            // i := +(i, 1); 
            L#i := L#i + 1;
            // assert @writes_check(ln); 
            assert $top_writable($s, #wrTime$1^396.12, $phys_ptr_cast(P#ln, ^LiveNodes));
            // assert @writes_check(ls); 
            assert $top_writable($s, #wrTime$1^396.12, $phys_ptr_cast(P#ls, ^LocalStores));
            // assert @writes_check(hhs); 
            assert $top_writable($s, #wrTime$1^396.12, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
            // assert @writes_check(ps); 
            assert $top_writable($s, #wrTime$1^396.12, $phys_ptr_cast(P#ps, ^PendingSet));
            // stmt havoc_all(ln, ls, hhs, ps); 
            call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
            assume $full_stop_ext(#tok$1^410.3, $s);
            // s0 := @_vcc_current_state(@state); 
            SL#s0 := $current_state($s);
            // _math \objset owns#130; 
            // owns#130 := @_vcc_set_empty; 
            owns#130 := $set_empty();
            // _math \state prestate#129; 
            // prestate#129 := @_vcc_current_state(@state); 
            prestate#129 := $current_state($s);
            // _math \state prestate#131; 
            // prestate#131 := @_vcc_current_state(@state); 
            prestate#131 := $current_state($s);
            // assert @_vcc_wrapped(@state, ls); 
            assert $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
            // assert @writes_check(ls); 
            assert $top_writable($s, #wrTime$1^396.12, $phys_ptr_cast(P#ls, ^LocalStores));
            // prestate#131 := pure(@_vcc_start_release(prestate#131, prestate#131)); 
            prestate#131 := $start_release(prestate#131, prestate#131);
            // assume @_vcc_inv(@state, ls); 
            assume $inv($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
            // assume ==(owns#130, @_vcc_owns(@state, ls)); 
            assume owns#130 == $owns($s, $phys_ptr_cast(P#ls, ^LocalStores));
            // assume @_vcc_pre_static_unwrap(@state); 
            assume $pre_static_unwrap($s);
            // @_vcc_static_unwrap(pure(ls), prestate#131)
            call $static_unwrap($phys_ptr_cast(P#ls, ^LocalStores), prestate#131);
            assume $good_state_ext(#tok$1^412.5, $s);
            // assume @_vcc_full_stop(@state); 
            assume $full_stop($s);
            // _Bool ite#2; 
            // ite#2 := (_Bool)is_tainted; 
            ite#2 := $int_to_bool(P#is_tainted);
            assume true;
            // if (ite#2) ...
            if (ite#2)
            {
              anon60:
                // assert @prim_writes_check((ls->tainted_key)); 
                assert $writable_prim($s, #wrTime$1^396.12, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.tainted_key));
                // *(ls->tainted_key) := key; 
                call $write_int(LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores), P#key);
                assume $full_stop_ext(#tok$1^415.4, $s);
                // (int32_t -> _Bool) res_addone_iset#74; 
                // res_addone_iset#74 := addone_iset(*((ls->tainted_nodes)), cur_node); 
                call res_addone_iset#74 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#cur_node);
                assume $full_stop_ext(#tok$1^416.25, $s);
                // assert @prim_writes_check((ls->tainted_nodes)); 
                assert $writable_prim($s, #wrTime$1^396.12, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.tainted_nodes));
                // *(ls->tainted_nodes) := res_addone_iset#74; 
                call $write_int(LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores), $map_t..^^i4.^^bool_to_int(res_addone_iset#74));
                assume $full_stop_ext(#tok$1^416.4, $s);
            }
            else
            {
              anon61:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
            }

          anon64:
            // _math \state prestate#132; 
            // prestate#132 := @_vcc_current_state(@state); 
            prestate#132 := $current_state($s);
            // _math \state staticWrapState#133; 
            // staticWrapState#133 := @_vcc_current_state(@state); 
            staticWrapState#133 := $current_state($s);
            // _math \objset owns#135; 
            // owns#135 := @_vcc_set_empty; 
            owns#135 := $set_empty();
            // assert @writes_check(ls); 
            assert $top_writable($s, #wrTime$1^396.12, $phys_ptr_cast(P#ls, ^LocalStores));
            // assume @_vcc_pre_static_wrap(@state); 
            assume $pre_static_wrap($s);
            // @_vcc_static_wrap(pure(ls), staticWrapState#133, owns#135)
            call $static_wrap($phys_ptr_cast(P#ls, ^LocalStores), staticWrapState#133, owns#135);
            assume $good_state_ext(#tok$1^418.5, $s);
            // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ls), @_vcc_set_empty)); 
            assert $set_eq($owns($s, $phys_ptr_cast(P#ls, ^LocalStores)), $set_empty());
            // assert @inv_check(<=(*((ls->len)), 100000000)); 
            assert $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores)) <= 100000000;
            // assert @inv_check(||(==(*((ls->tainted_key)), -1), &&(>=(*((ls->tainted_key)), 0), <(*((ls->tainted_key)), 10000)))); 
            assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) < 10000);
            // assume @_vcc_full_stop(@state); 
            assume $full_stop($s);
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^419.12#tc1#1439: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^419.12#tc1#1439) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^419.12#tc1#1439) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^419.12#tc1#1439) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^419.12#tc1#1439) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^419.12#tc1#1439) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^419.12#tc1#1439) } $in_range_i4(Q#i$1^419.12#tc1#1439) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^419.12#tc1#1439) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^419.12#tc1#1439) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^419.12#tc1#1439) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^419.12#tc1#1439) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^419.12#tc1#1439) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^419.12#tc1#1439));
            // assume ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
            assume $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^419.12#tc1#1453: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^419.12#tc1#1453) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^419.12#tc1#1453) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^419.12#tc1#1453) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^419.12#tc1#1453) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^419.12#tc1#1453) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^419.12#tc1#1453) } $in_range_i4(Q#i$1^419.12#tc1#1453) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^419.12#tc1#1453) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^419.12#tc1#1453) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^419.12#tc1#1453) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^419.12#tc1#1453) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^419.12#tc1#1453) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^419.12#tc1#1453));
            // assert @writes_check(ln); 
            assert $top_writable($s, #wrTime$1^396.12, $phys_ptr_cast(P#ln, ^LiveNodes));
            // assert @writes_check(ls); 
            assert $top_writable($s, #wrTime$1^396.12, $phys_ptr_cast(P#ls, ^LocalStores));
            // assert @writes_check(hhs); 
            assert $top_writable($s, #wrTime$1^396.12, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
            // assert @writes_check(ps); 
            assert $top_writable($s, #wrTime$1^396.12, $phys_ptr_cast(P#ps, ^PendingSet));
            // stmt havoc_all(ln, ls, hhs, ps); 
            call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
            assume $full_stop_ext(#tok$1^420.3, $s);
        }
        else
        {
          anon65:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
            // goto #break_60; 
            goto #break_60;
        }

      #continue_60:
        assume true;
    }

  anon70:
    assume $full_stop_ext(#tok$1^387.2, $s);

  #break_60:
    // assert @reads_check_normal((wrap#RDT->data)); 
    assert $thread_local($s, $phys_ptr_cast(G#wrap#RDT#dt9, ^swrap#RDT));
    assume true;
    // if (<(cnt_succ, *((wrap#RDT->data)))) ...
    if (L#cnt_succ < $rd_inv($s, swrap#RDT.data, $phys_ptr_cast(G#wrap#RDT#dt9, ^swrap#RDT)))
    {
      anon67:
        // return -1; 
        $result := -1;
        assume true;
        assert $position_marker();
        goto #exit;
    }
    else
    {
      anon68:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon71:
    // return cnt_succ; 
    $result := L#cnt_succ;
    assume true;
    assert $position_marker();
    goto #exit;

  anon72:
    // skip

  #exit:
}



procedure write_succeeded() returns ($result: int);
  modifies $s, $cev_pc;
  free ensures $in_range_i4($result);
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



procedure put(P#key: int, P#coord: int, P#is_tainted: int, P#first_tainted_write: int, P#ln: $ptr, P#pl: $ptr, P#ls: $ptr, P#hhs: $ptr, P#ps: $ptr) returns ($result: int);
  requires $thread_local2($s, $dot($phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT), swrap#WDT.data), ^^i4);
  requires P#key >= 0;
  requires P#key < 10000;
  requires $non_null($phys_ptr_cast(P#ps, ^PendingSet));
  requires P#coord == F#get_coord_for_key(P#key);
  requires $non_null($phys_ptr_cast(P#pl, ^PreferenceLists));
  requires $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), P#coord)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), P#coord))) == 1;
  requires $non_null($phys_ptr_cast(P#ls, ^LocalStores));
  requires $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < 4294967295;
  requires !$int_to_bool(P#first_tainted_write) ==> (forall Q#j$1^440.39#tc1#1227: int :: {:weight 10} { $op_mul(P#coord, 3200) + Q#j$1^440.39#tc1#1227 } $in_range_i4(Q#j$1^440.39#tc1#1227) ==> Q#j$1^440.39#tc1#1227 >= 0 && Q#j$1^440.39#tc1#1227 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^440.39#tc1#1227)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^440.39#tc1#1227)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^440.39#tc1#1227)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^440.39#tc1#1227)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^440.39#tc1#1227)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^440.39#tc1#1227)))));
  free requires -2 == $unchk_sub(^^i4, 0, 2);
  requires $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  requires $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  requires $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  requires $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  requires $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  modifies $s, $cev_pc;
  free ensures $in_range_i4($result);
  ensures P#coord == F#get_coord_for_key(P#key);
  ensures $result > -2 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
  ensures $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
  ensures $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
  ensures $int_to_bool(P#is_tainted) && $result > -2 ==> P#key != -1 && P#coord == F#get_coord_for_key(P#key) ==> (forall Q#j$1^455.43#tc1#1446: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))))) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))))) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))))) } $in_range_i4(Q#j$1^455.43#tc1#1446) ==> Q#j$1^455.43#tc1#1446 >= 0 && Q#j$1^455.43#tc1#1446 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^455.43#tc1#1446))))));
  ensures $int_to_bool(P#is_tainted) && $result > -2 ==> (forall Q#j$1^459.10#tc1#1228: int :: {:weight 10} { $op_mul(P#coord, 3200) + Q#j$1^459.10#tc1#1228 } $in_range_i4(Q#j$1^459.10#tc1#1228) ==> Q#j$1^459.10#tc1#1228 >= 0 && Q#j$1^459.10#tc1#1228 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^459.10#tc1#1228)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^459.10#tc1#1228)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^459.10#tc1#1228)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^459.10#tc1#1228)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^459.10#tc1#1228)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^459.10#tc1#1228)))));
  free ensures -2 == $unchk_sub(^^i4, 0, 2);
  ensures $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes) && $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists) && $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores) && $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores) && $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
  free ensures $call_transition(old($s), $s);



implementation put(P#key: int, P#coord: int, P#is_tainted: int, P#first_tainted_write: int, P#ln: $ptr, P#pl: $ptr, P#ls: $ptr, P#hhs: $ptr, P#ps: $ptr) returns ($result: int)
{
  var loopDecrEnd#310: int;
  var owns#164: $ptrset;
  var staticWrapState#162: $state;
  var prestate#161: $state;
  var res_addone_hset#80: $map_t..^^u8.^^bool;
  var res_addone_iset#79: $map_t..^^i4.^^bool;
  var ite#8: bool;
  var owns#160: $ptrset;
  var staticWrapState#158: $state;
  var prestate#157: $state;
  var prestate#156: $state;
  var prestate#154: $state;
  var owns#155: $ptrset;
  var s0#2: $state;
  var h#1: int where $in_range_u8(h#1);
  var owns#153: $ptrset;
  var staticWrapState#151: $state;
  var prestate#150: $state;
  var res_addone_iset#78: $map_t..^^i4.^^bool;
  var ite#7: bool;
  var res_addone_hset#77: $map_t..^^u8.^^bool;
  var owns#149: $ptrset;
  var staticWrapState#147: $state;
  var prestate#146: $state;
  var prestate#145: $state;
  var prestate#143: $state;
  var owns#144: $ptrset;
  var s0#0: $state;
  var L#h: int where $in_range_u8(L#h);
  var owns#142: $ptrset;
  var staticWrapState#140: $state;
  var prestate#139: $state;
  var res_addone_iset#76: $map_t..^^i4.^^bool;
  var ite#6: bool;
  var prestate#138: $state;
  var prestate#136: $state;
  var owns#137: $ptrset;
  var SL#s0: $state;
  var res_write_succeeded#75: int where $in_range_i4(res_write_succeeded#75);
  var ite#5: bool;
  var ite#4: bool;
  var ite#3: bool;
  var loopDecrBeg#309: int;
  var #wrTime$1^475.12: int;
  var loopState#5: $state;
  var SL#abs_hint: RT#AbsHint;
  var L#cnt_succ: int where $in_range_i4(L#cnt_succ);
  var L#cur_node: int where $in_range_i4(L#cur_node);
  var L#i: int where $in_range_i4(L#i);
  var #wrTime$1^431.1: int;
  var #stackframe: int;

  anon110:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^431.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^431.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^431.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
    assume $thread_owned($s, $phys_ptr_cast(P#ln, ^LiveNodes));
    assume $thread_owned($s, $phys_ptr_cast(P#ls, ^LocalStores));
    assume $thread_owned($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    assume $thread_owned($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @in_range_i4(key); 
    assume $in_range_i4(P#key);
    // assume @in_range_i4(coord); 
    assume $in_range_i4(P#coord);
    // assume @in_range_i4(is_tainted); 
    assume $in_range_i4(P#is_tainted);
    // assume @in_range_i4(first_tainted_write); 
    assume $in_range_i4(P#first_tainted_write);
    // assume true
    // assume true
    // assume true
    // assume true
    // assume true
    // assume @decreases_level_is(2); 
    assume 2 == $decreases_level;
    // assert @_vcc_in_domain(@state, ps, ps); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ps, ^PendingSet), $phys_ptr_cast(P#ps, ^PendingSet), l#public);
    // assert @_vcc_in_domain(@state, hhs, hhs); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), l#public);
    // assert @_vcc_in_domain(@state, ls, ls); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ls, ^LocalStores), l#public);
    // assert @_vcc_in_domain(@state, pl, pl); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#pl, ^PreferenceLists), l#public);
    // assert @_vcc_in_domain(@state, ln, ln); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ln, ^LiveNodes), l#public);
    // assume ==(-2, unchecked-(0, 2)); 
    assume -2 == $unchk_sub(^^i4, 0, 2);
    // assume true
    // assume ==(-1, unchecked-(0, 1)); 
    assume -1 == $unchk_sub(^^i4, 0, 1);
    // int32_t i; 
    // int32_t cur_node; 
    // int32_t cnt_succ; 
    // record AbsHint abs_hint; 
    // var spec struct AbsHint abs_hint
    // cnt_succ := 0; 
    L#cnt_succ := 0;
    // cur_node := -1; 
    L#cur_node := -1;
    // i := 0; 
    L#i := 0;
    call $bump_timestamp();
    assume $full_stop_ext(#tok$1^475.12, $s);
    loopState#5 := $s;
    assume #wrTime$1^475.12 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^475.12, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
    assert (forall #loopWrites^$1^475.12: $ptr :: { $dont_instantiate(#loopWrites^$1^475.12) } $listed_in_writes($s, #wrTime$1^475.12, #loopWrites^$1^475.12) ==> $top_writable($s, #wrTime$1^431.1, #loopWrites^$1^475.12));
    assume true;
    while (true)
      invariant L#cnt_succ <= L#i;
      invariant $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
      invariant $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
      invariant $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
      invariant $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
      invariant $thread_local2($s, $dot($phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT), swrap#WDT.data), ^^i4);
      invariant $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
      invariant $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
      invariant L#i > 0 && $int_to_bool(P#is_tainted) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#cur_node) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), L#cur_node) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#cur_node);
      invariant $int_to_bool(P#is_tainted) ==> P#key != -1 && P#coord == F#get_coord_for_key(P#key) ==> (forall Q#j$1^480.31#tc1#1440: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))))) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))))) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))))) } $in_range_i4(Q#j$1^480.31#tc1#1440) ==> Q#j$1^480.31#tc1#1440 >= 0 && Q#j$1^480.31#tc1#1440 < L#i ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $unchk_add(^^i4, $unchk_mul(^^i4, P#coord, 3200), Q#j$1^480.31#tc1#1440))))));
      invariant L#i > 0 && $int_to_bool(P#is_tainted) && $int_to_bool($rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)))) && L#cnt_succ <= $rd_inv($s, swrap#WDT.data, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT)) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#cur_node) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), L#cur_node) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#cur_node);
      invariant $int_to_bool(P#is_tainted) ==> (forall Q#j$1^485.11#tc1#1226: int :: {:weight 10} { $op_mul(P#coord, 3200) + Q#j$1^485.11#tc1#1226 } $in_range_i4(Q#j$1^485.11#tc1#1226) ==> Q#j$1^485.11#tc1#1226 >= 0 && Q#j$1^485.11#tc1#1226 < L#i ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^485.11#tc1#1226)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^485.11#tc1#1226)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^485.11#tc1#1226)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^485.11#tc1#1226)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^485.11#tc1#1226)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^485.11#tc1#1226)))));
    {
      anon107:
        assume $modifies(loopState#5, $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
        assume $timestamp_post(loopState#5, $s);
        assume $full_stop_ext(#tok$1^471.2, $s);
        // \integer loopDecrBeg#309; 
        // loopDecrBeg#309 := @prelude_int_distance(i, 3200); 
        loopDecrBeg#309 := $int_distance(L#i, 3200);
        assume true;
        // if (<(i, 3200)) ...
        if (L#i < 3200)
        {
          anon103:
            // assert @reads_check_normal((pl->preference_list)[+(*(coord, 3200), i)]); 
            assert $thread_local($s, $idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i));
            // assert @in_range_i4(+(*(coord, 3200), i)); 
            assert $in_range_i4($op_mul(P#coord, 3200) + L#i);
            // assert @in_range_i4(*(coord, 3200)); 
            assert $in_range_i4($op_mul(P#coord, 3200));
            // cur_node := *((pl->preference_list)[+(*(coord, 3200), i)]); 
            L#cur_node := $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i)));
            // _Bool ite#3; 
            // _Bool ite#4; 
            // assert @reads_check_normal((ln->live_nodes)[cur_node]); 
            assert $thread_local($s, $idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node));
            // ite#4 := (_Bool)*((ln->live_nodes)[cur_node]); 
            ite#4 := $int_to_bool($rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node))));
            assume true;
            // if (ite#4) ...
            if (ite#4)
            {
              anon73:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
                // assert @reads_check_normal((wrap#WDT->data)); 
                assert $thread_local($s, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT));
                // ite#3 := <(cnt_succ, *((wrap#WDT->data))); 
                ite#3 := L#cnt_succ < $rd_inv($s, swrap#WDT.data, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT));
            }
            else
            {
              anon74:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
                // ite#3 := false; 
                ite#3 := false;
            }

          anon104:
            assume true;
            // if (ite#3) ...
            if (ite#3)
            {
              anon92:
                // assert ==>(&&(&&(&&(>(i, 0), (_Bool)is_tainted), ||(unchecked!((_Bool)*((ln->live_nodes)[cur_node])), >=(cnt_succ, *((wrap#WDT->data))))), <(*((ps->size)), 16777215)), @map_get(*((ps->tainted_nodes)), cur_node)); 
                assert L#i > 0 && $int_to_bool(P#is_tainted) && (!$int_to_bool($rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)))) || L#cnt_succ >= $rd_inv($s, swrap#WDT.data, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT))) && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < 16777215 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), L#cur_node);
                // assume ==>(&&(&&(&&(>(i, 0), (_Bool)is_tainted), ||(unchecked!((_Bool)*((ln->live_nodes)[cur_node])), >=(cnt_succ, *((wrap#WDT->data))))), <(*((ps->size)), 16777215)), @map_get(*((ps->tainted_nodes)), cur_node)); 
                assume L#i > 0 && $int_to_bool(P#is_tainted) && (!$int_to_bool($rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)))) || L#cnt_succ >= $rd_inv($s, swrap#WDT.data, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT))) && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < 16777215 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), L#cur_node);
                // _Bool ite#5; 
                // int32_t res_write_succeeded#75; 
                // res_write_succeeded#75 := write_succeeded(); 
                call res_write_succeeded#75 := write_succeeded();
                assume $full_stop_ext(#tok$1^493.8, $s);
                // ite#5 := (_Bool)res_write_succeeded#75; 
                ite#5 := $int_to_bool(res_write_succeeded#75);
                assume true;
                // if (ite#5) ...
                if (ite#5)
                {
                  anon77:
                    // _math \state s0; 
                    // assert @writes_check(ln); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ln, ^LiveNodes));
                    // assert @writes_check(ls); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ls, ^LocalStores));
                    // assert @writes_check(hhs); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                    // assert @writes_check(ps); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                    // stmt havoc_all(ln, ls, hhs, ps); 
                    call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
                    assume $full_stop_ext(#tok$1^494.5, $s);
                    // s0 := @_vcc_current_state(@state); 
                    SL#s0 := $current_state($s);
                    // _math \objset owns#137; 
                    // owns#137 := @_vcc_set_empty; 
                    owns#137 := $set_empty();
                    // _math \state prestate#136; 
                    // prestate#136 := @_vcc_current_state(@state); 
                    prestate#136 := $current_state($s);
                    // _math \state prestate#138; 
                    // prestate#138 := @_vcc_current_state(@state); 
                    prestate#138 := $current_state($s);
                    // assert @_vcc_wrapped(@state, ls); 
                    assert $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
                    // assert @writes_check(ls); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ls, ^LocalStores));
                    // prestate#138 := pure(@_vcc_start_release(prestate#138, prestate#138)); 
                    prestate#138 := $start_release(prestate#138, prestate#138);
                    // assume @_vcc_inv(@state, ls); 
                    assume $inv($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
                    // assume ==(owns#137, @_vcc_owns(@state, ls)); 
                    assume owns#137 == $owns($s, $phys_ptr_cast(P#ls, ^LocalStores));
                    // assume @_vcc_pre_static_unwrap(@state); 
                    assume $pre_static_unwrap($s);
                    // @_vcc_static_unwrap(pure(ls), prestate#138)
                    call $static_unwrap($phys_ptr_cast(P#ls, ^LocalStores), prestate#138);
                    assume $good_state_ext(#tok$1^496.7, $s);
                    // assume @_vcc_full_stop(@state); 
                    assume $full_stop($s);
                    // assert @prim_writes_check((ls->local_store)[+(*(cur_node, 10000), key)]); 
                    assert $writable_prim($s, #wrTime$1^475.12, $idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#cur_node, 10000) + P#key));
                    // assert @in_range_i4(+(*(cur_node, 10000), key)); 
                    assert $in_range_i4($op_mul(L#cur_node, 10000) + P#key);
                    // assert @in_range_i4(*(cur_node, 10000)); 
                    assert $in_range_i4($op_mul(L#cur_node, 10000));
                    // *(ls->local_store)[+(*(cur_node, 10000), key)] := key; 
                    call $write_int($field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#cur_node, 10000) + P#key)), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#cur_node, 10000) + P#key)), P#key);
                    assume $full_stop_ext(#tok$1^497.5, $s);
                    // _Bool ite#6; 
                    // ite#6 := (_Bool)is_tainted; 
                    ite#6 := $int_to_bool(P#is_tainted);
                    assume true;
                    // if (ite#6) ...
                    if (ite#6)
                    {
                      anon75:
                        // assert @prim_writes_check((ls->tainted_key)); 
                        assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.tainted_key));
                        // *(ls->tainted_key) := key; 
                        call $write_int(LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores), P#key);
                        assume $full_stop_ext(#tok$1^500.7, $s);
                        // (int32_t -> _Bool) res_addone_iset#76; 
                        // res_addone_iset#76 := addone_iset(*((ls->tainted_nodes)), cur_node); 
                        call res_addone_iset#76 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#cur_node);
                        assume $full_stop_ext(#tok$1^501.28, $s);
                        // assert @prim_writes_check((ls->tainted_nodes)); 
                        assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.tainted_nodes));
                        // *(ls->tainted_nodes) := res_addone_iset#76; 
                        call $write_int(LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores), $map_t..^^i4.^^bool_to_int(res_addone_iset#76));
                        assume $full_stop_ext(#tok$1^501.7, $s);
                        // assert @prim_writes_check((ls->size)); 
                        assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.size));
                        // *(ls->size) := unchecked+(*((ls->size)), 1); 
                        call $write_int(LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores), $unchk_add(^^nat, $rd_inv($s, LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores)), 1));
                        assume $full_stop_ext(#tok$1^502.7, $s);
                    }
                    else
                    {
                      anon76:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                    }

                  anon78:
                    // _math \state prestate#139; 
                    // prestate#139 := @_vcc_current_state(@state); 
                    prestate#139 := $current_state($s);
                    // _math \state staticWrapState#140; 
                    // staticWrapState#140 := @_vcc_current_state(@state); 
                    staticWrapState#140 := $current_state($s);
                    // _math \objset owns#142; 
                    // owns#142 := @_vcc_set_empty; 
                    owns#142 := $set_empty();
                    // assert @writes_check(ls); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ls, ^LocalStores));
                    // assume @_vcc_pre_static_wrap(@state); 
                    assume $pre_static_wrap($s);
                    // @_vcc_static_wrap(pure(ls), staticWrapState#140, owns#142)
                    call $static_wrap($phys_ptr_cast(P#ls, ^LocalStores), staticWrapState#140, owns#142);
                    assume $good_state_ext(#tok$1^504.7, $s);
                    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ls), @_vcc_set_empty)); 
                    assert $set_eq($owns($s, $phys_ptr_cast(P#ls, ^LocalStores)), $set_empty());
                    // assert @inv_check(<=(*((ls->len)), 100000000)); 
                    assert $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores)) <= 100000000;
                    // assert @inv_check(||(==(*((ls->tainted_key)), -1), &&(>=(*((ls->tainted_key)), 0), <(*((ls->tainted_key)), 10000)))); 
                    assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) < 10000);
                    // assume @_vcc_full_stop(@state); 
                    assume $full_stop($s);
                    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
                    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
                    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
                    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
                    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
                    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
                    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
                    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
                    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
                    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
                    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
                    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^505.14#tc1#1441: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^505.14#tc1#1441) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^505.14#tc1#1441) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^505.14#tc1#1441) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^505.14#tc1#1441) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^505.14#tc1#1441) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^505.14#tc1#1441) } $in_range_i4(Q#i$1^505.14#tc1#1441) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^505.14#tc1#1441) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^505.14#tc1#1441) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^505.14#tc1#1441) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^505.14#tc1#1441) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^505.14#tc1#1441) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^505.14#tc1#1441));
                    // assume ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
                    assume $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^505.14#tc1#1454: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^505.14#tc1#1454) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^505.14#tc1#1454) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^505.14#tc1#1454) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^505.14#tc1#1454) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^505.14#tc1#1454) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^505.14#tc1#1454) } $in_range_i4(Q#i$1^505.14#tc1#1454) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^505.14#tc1#1454) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^505.14#tc1#1454) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^505.14#tc1#1454) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^505.14#tc1#1454) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^505.14#tc1#1454) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^505.14#tc1#1454));
                    // assert @writes_check(ln); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ln, ^LiveNodes));
                    // assert @writes_check(ls); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ls, ^LocalStores));
                    // assert @writes_check(hhs); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                    // assert @writes_check(ps); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                    // stmt havoc_all(ln, ls, hhs, ps); 
                    call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
                    assume $full_stop_ext(#tok$1^506.5, $s);
                    // assert @in_range_i4(+(cnt_succ, 1)); 
                    assert $in_range_i4(L#cnt_succ + 1);
                    // cnt_succ := +(cnt_succ, 1); 
                    L#cnt_succ := L#cnt_succ + 1;
                }
                else
                {
                  anon88:
                    // uint64_t h; 
                    // _math \state s0#0; 
                    // assert @reads_check_normal((ps->size)); 
                    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                    assume true;
                    // if (==(*((ps->size)), 16777215)) ...
                    if ($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == 16777215)
                    {
                      anon79:
                        // return -2; 
                        $result := -2;
                        assume true;
                        assert $position_marker();
                        goto #exit;
                    }
                    else
                    {
                      anon80:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                    }

                  anon89:
                    // assert @writes_check(ln); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ln, ^LiveNodes));
                    // assert @writes_check(ls); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ls, ^LocalStores));
                    // assert @writes_check(hhs); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                    // assert @writes_check(ps); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                    // stmt havoc_all(ln, ls, hhs, ps); 
                    call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
                    assume $full_stop_ext(#tok$1^512.5, $s);
                    // s0#0 := @_vcc_current_state(@state); 
                    s0#0 := $current_state($s);
                    // _math \objset owns#144; 
                    // owns#144 := @_vcc_set_empty; 
                    owns#144 := $set_empty();
                    // _math \state prestate#143; 
                    // prestate#143 := @_vcc_current_state(@state); 
                    prestate#143 := $current_state($s);
                    // _math \state prestate#145; 
                    // prestate#145 := @_vcc_current_state(@state); 
                    prestate#145 := $current_state($s);
                    // assert @_vcc_wrapped(@state, ps); 
                    assert $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
                    // assert @writes_check(ps); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                    // prestate#145 := pure(@_vcc_start_release(prestate#145, prestate#145)); 
                    prestate#145 := $start_release(prestate#145, prestate#145);
                    // assume @_vcc_inv(@state, ps); 
                    assume $inv($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
                    // assume ==(owns#144, @_vcc_owns(@state, ps)); 
                    assume owns#144 == $owns($s, $phys_ptr_cast(P#ps, ^PendingSet));
                    // assume @_vcc_pre_static_unwrap(@state); 
                    assume $pre_static_unwrap($s);
                    // @_vcc_static_unwrap(pure(ps), prestate#145)
                    call $static_unwrap($phys_ptr_cast(P#ps, ^PendingSet), prestate#145);
                    assume $good_state_ext(#tok$1^514.7, $s);
                    // assume @_vcc_full_stop(@state); 
                    assume $full_stop($s);
                    // (h, abs_hint) = create_hint(coord, cur_node, key); 
                    call L#h, SL#abs_hint := create_hint(P#coord, L#cur_node, P#key);
                    assume $full_stop_ext(#tok$1^515.15, $s);
                    // assert @reads_check_normal((ps->size)); 
                    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                    assume true;
                    // if (==(*((ps->size)), 16777215)) ...
                    if ($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == 16777215)
                    {
                      anon81:
                        // _math \state prestate#146; 
                        // prestate#146 := @_vcc_current_state(@state); 
                        prestate#146 := $current_state($s);
                        // _math \state staticWrapState#147; 
                        // staticWrapState#147 := @_vcc_current_state(@state); 
                        staticWrapState#147 := $current_state($s);
                        // _math \objset owns#149; 
                        // owns#149 := @_vcc_set_empty; 
                        owns#149 := $set_empty();
                        // assert @writes_check(ps); 
                        assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                        // assume @_vcc_pre_static_wrap(@state); 
                        assume $pre_static_wrap($s);
                        // @_vcc_static_wrap(pure(ps), staticWrapState#147, owns#149)
                        call $static_wrap($phys_ptr_cast(P#ps, ^PendingSet), staticWrapState#147, owns#149);
                        assume $good_state_ext(#tok$1^517.9, $s);
                        // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ps), @_vcc_set_empty)); 
                        assert $set_eq($owns($s, $phys_ptr_cast(P#ps, ^PendingSet)), $set_empty());
                        // assert @inv_check(<=(*((ps->size)), 16777215)); 
                        assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
                        // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((ps->size))), @map_get(*((ps->pset)), *((ps->pending)[i]))))); 
                        assert (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))));
                        // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), <(@map_get(*((ps->idx)), h), *((ps->size)))))); 
                        assert (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)));
                        // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), ==(*((ps->pending)[@map_get(*((ps->idx)), h)]), h)))); 
                        assert (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415);
                        // assert @inv_check(==>(&&(>=(*((ps->tkey)), 0), <(*((ps->tkey)), 10000)), ==(*((ps->tcoord)), get_coord_for_key(*((ps->tkey)))))); 
                        assert $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) < 10000 ==> $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet)) == F#get_coord_for_key($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)));
                        // assume @_vcc_full_stop(@state); 
                        assume $full_stop($s);
                        // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
                        assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
                        // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
                        assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
                        // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
                        assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
                        // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
                        assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
                        // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
                        assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
                        // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0#0, @map_get(*((ls->tainted_nodes)), i)), old(s0#0, @map_get(*((hhs->tainted_nodes)), i))), old(s0#0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
                        assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^518.16#tc1#1442: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^518.16#tc1#1442) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^518.16#tc1#1442) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^518.16#tc1#1442) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^518.16#tc1#1442) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^518.16#tc1#1442) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^518.16#tc1#1442) } $in_range_i4(Q#i$1^518.16#tc1#1442) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^518.16#tc1#1442) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^518.16#tc1#1442) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^518.16#tc1#1442) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^518.16#tc1#1442) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^518.16#tc1#1442) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^518.16#tc1#1442));
                        // assume ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0#0, @map_get(*((ls->tainted_nodes)), i)), old(s0#0, @map_get(*((hhs->tainted_nodes)), i))), old(s0#0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
                        assume $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^518.16#tc1#1455: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^518.16#tc1#1455) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^518.16#tc1#1455) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^518.16#tc1#1455) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^518.16#tc1#1455) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^518.16#tc1#1455) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^518.16#tc1#1455) } $in_range_i4(Q#i$1^518.16#tc1#1455) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^518.16#tc1#1455) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^518.16#tc1#1455) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^518.16#tc1#1455) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^518.16#tc1#1455) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^518.16#tc1#1455) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^518.16#tc1#1455));
                        // assert @writes_check(ln); 
                        assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ln, ^LiveNodes));
                        // assert @writes_check(ls); 
                        assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ls, ^LocalStores));
                        // assert @writes_check(hhs); 
                        assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                        // assert @writes_check(ps); 
                        assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                        // stmt havoc_all(ln, ls, hhs, ps); 
                        call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
                        assume $full_stop_ext(#tok$1^519.7, $s);
                        // return -2; 
                        $result := -2;
                        assume true;
                        assert $position_marker();
                        goto #exit;
                    }
                    else
                    {
                      anon82:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                    }

                  anon90:
                    // assert @prim_writes_check((ps->pending)[*((ps->size))]); 
                    assert $writable_prim($s, #wrTime$1^475.12, $idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet))));
                    // assert @reads_check_normal((ps->size)); 
                    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                    // *(ps->pending)[*((ps->size))] := h; 
                    call $write_int($field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)))), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)))), L#h);
                    assume $full_stop_ext(#tok$1^523.6, $s);
                    // (uint64_t -> _Bool) res_addone_hset#77; 
                    // res_addone_hset#77 := addone_hset(*((ps->pset)), h); 
                    call res_addone_hset#77 := addone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), L#h);
                    assume $full_stop_ext(#tok$1^524.25, $s);
                    // assert @prim_writes_check((ps->pset)); 
                    assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pset));
                    // *(ps->pset) := res_addone_hset#77; 
                    call $write_int(PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^u8.^^bool_to_int(res_addone_hset#77));
                    assume $full_stop_ext(#tok$1^524.14, $s);
                    // assert @prim_writes_check((ps->idx)); 
                    assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.idx));
                    // *(ps->idx) := @map_updated(*((ps->idx)), h, *((ps->size))); 
                    call $write_int(PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^u8.^^u8_to_int($store.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), L#h, $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)))));
                    assume $full_stop_ext(#tok$1^525.14, $s);
                    // assert @prim_writes_check((ps->size)); 
                    assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.size));
                    // assert @in_range_u8(+(*((ps->size)), 1)); 
                    assert $in_range_u8($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) + 1);
                    // assert @reads_check_normal((ps->size)); 
                    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                    // *(ps->size) := +(*((ps->size)), 1); 
                    call $write_int(PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) + 1);
                    assume $full_stop_ext(#tok$1^527.6, $s);
                    // _Bool ite#7; 
                    // ite#7 := (_Bool)is_tainted; 
                    ite#7 := $int_to_bool(P#is_tainted);
                    assume true;
                    // if (ite#7) ...
                    if (ite#7)
                    {
                      anon85:
                        assume true;
                        // if (==(*((ps->tkey)), -1)) ...
                        if ($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) == -1)
                        {
                          anon83:
                            // assert @prim_writes_check((ps->tkey)); 
                            assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.tkey));
                            // *(ps->tkey) := key; 
                            call $write_int(PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet), P#key);
                            assume $full_stop_ext(#tok$1^534.9, $s);
                            // assert @prim_writes_check((ps->tcoord)); 
                            assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.tcoord));
                            // *(ps->tcoord) := coord; 
                            call $write_int(PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet), P#coord);
                            assume $full_stop_ext(#tok$1^535.9, $s);
                        }
                        else
                        {
                          anon84:
                            // assert @_vcc_possibly_unreachable; 
                            assert {:PossiblyUnreachable true} true;
                        }

                      anon86:
                        // (int32_t -> _Bool) res_addone_iset#78; 
                        // res_addone_iset#78 := addone_iset(*((ps->tainted_nodes)), cur_node); 
                        call res_addone_iset#78 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), L#cur_node);
                        assume $full_stop_ext(#tok$1^537.28, $s);
                        // assert @prim_writes_check((ps->tainted_nodes)); 
                        assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.tainted_nodes));
                        // *(ps->tainted_nodes) := res_addone_iset#78; 
                        call $write_int(PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^i4.^^bool_to_int(res_addone_iset#78));
                        assume $full_stop_ext(#tok$1^537.8, $s);
                    }
                    else
                    {
                      anon87:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                    }

                  anon91:
                    // _math \state prestate#150; 
                    // prestate#150 := @_vcc_current_state(@state); 
                    prestate#150 := $current_state($s);
                    // _math \state staticWrapState#151; 
                    // staticWrapState#151 := @_vcc_current_state(@state); 
                    staticWrapState#151 := $current_state($s);
                    // _math \objset owns#153; 
                    // owns#153 := @_vcc_set_empty; 
                    owns#153 := $set_empty();
                    // assert @writes_check(ps); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                    // assume @_vcc_pre_static_wrap(@state); 
                    assume $pre_static_wrap($s);
                    // @_vcc_static_wrap(pure(ps), staticWrapState#151, owns#153)
                    call $static_wrap($phys_ptr_cast(P#ps, ^PendingSet), staticWrapState#151, owns#153);
                    assume $good_state_ext(#tok$1^541.7, $s);
                    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ps), @_vcc_set_empty)); 
                    assert $set_eq($owns($s, $phys_ptr_cast(P#ps, ^PendingSet)), $set_empty());
                    // assert @inv_check(<=(*((ps->size)), 16777215)); 
                    assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
                    // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((ps->size))), @map_get(*((ps->pset)), *((ps->pending)[i]))))); 
                    assert (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))));
                    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), <(@map_get(*((ps->idx)), h), *((ps->size)))))); 
                    assert (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)));
                    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), ==(*((ps->pending)[@map_get(*((ps->idx)), h)]), h)))); 
                    assert (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415);
                    // assert @inv_check(==>(&&(>=(*((ps->tkey)), 0), <(*((ps->tkey)), 10000)), ==(*((ps->tcoord)), get_coord_for_key(*((ps->tkey)))))); 
                    assert $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) < 10000 ==> $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet)) == F#get_coord_for_key($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)));
                    // assume @_vcc_full_stop(@state); 
                    assume $full_stop($s);
                    // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
                    assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
                    // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
                    assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
                    // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
                    assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
                    // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
                    assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
                    // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
                    assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
                    // assert ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0#0, @map_get(*((ls->tainted_nodes)), i)), old(s0#0, @map_get(*((hhs->tainted_nodes)), i))), old(s0#0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
                    assert $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^542.14#tc1#1443: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^542.14#tc1#1443) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^542.14#tc1#1443) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^542.14#tc1#1443) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^542.14#tc1#1443) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^542.14#tc1#1443) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^542.14#tc1#1443) } $in_range_i4(Q#i$1^542.14#tc1#1443) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^542.14#tc1#1443) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^542.14#tc1#1443) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^542.14#tc1#1443) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^542.14#tc1#1443) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^542.14#tc1#1443) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^542.14#tc1#1443));
                    // assume ==>(!=(old(s0#0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#0, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0#0, @map_get(*((ls->tainted_nodes)), i)), old(s0#0, @map_get(*((hhs->tainted_nodes)), i))), old(s0#0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
                    assume $rd_inv(s0#0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^542.14#tc1#1456: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^542.14#tc1#1456) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^542.14#tc1#1456) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^542.14#tc1#1456) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^542.14#tc1#1456) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^542.14#tc1#1456) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^542.14#tc1#1456) } $in_range_i4(Q#i$1^542.14#tc1#1456) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^542.14#tc1#1456) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^542.14#tc1#1456) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^542.14#tc1#1456) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^542.14#tc1#1456) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^542.14#tc1#1456) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^542.14#tc1#1456));
                    // assert @writes_check(ln); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ln, ^LiveNodes));
                    // assert @writes_check(ls); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ls, ^LocalStores));
                    // assert @writes_check(hhs); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                    // assert @writes_check(ps); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                    // stmt havoc_all(ln, ls, hhs, ps); 
                    call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
                    assume $full_stop_ext(#tok$1^543.5, $s);
                }
            }
            else
            {
              anon99:
                // uint64_t h#1; 
                // _math \state s0#2; 
                // assert ||(unchecked!((_Bool)*((ln->live_nodes)[cur_node])), >=(cnt_succ, *((wrap#WDT->data)))); 
                assert !$int_to_bool($rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)))) || L#cnt_succ >= $rd_inv($s, swrap#WDT.data, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT));
                // assume ||(unchecked!((_Bool)*((ln->live_nodes)[cur_node])), >=(cnt_succ, *((wrap#WDT->data)))); 
                assume !$int_to_bool($rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)))) || L#cnt_succ >= $rd_inv($s, swrap#WDT.data, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT));
                // assert @reads_check_normal((ps->size)); 
                assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                assume true;
                // if (==(*((ps->size)), 16777215)) ...
                if ($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == 16777215)
                {
                  anon93:
                    // return -2; 
                    $result := -2;
                    assume true;
                    assert $position_marker();
                    goto #exit;
                }
                else
                {
                  anon94:
                    // assert @_vcc_possibly_unreachable; 
                    assert {:PossiblyUnreachable true} true;
                }

              anon100:
                // assert ||(unchecked!((_Bool)*((ln->live_nodes)[cur_node])), >=(cnt_succ, *((wrap#WDT->data)))); 
                assert !$int_to_bool($rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)))) || L#cnt_succ >= $rd_inv($s, swrap#WDT.data, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT));
                // assert <(*((ps->size)), 16777215); 
                assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < 16777215;
                // assume &&(||(unchecked!((_Bool)*((ln->live_nodes)[cur_node])), >=(cnt_succ, *((wrap#WDT->data)))), <(*((ps->size)), 16777215)); 
                assume (!$int_to_bool($rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#cur_node)))) || L#cnt_succ >= $rd_inv($s, swrap#WDT.data, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT))) && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < 16777215;
                // assert @writes_check(ln); 
                assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ln, ^LiveNodes));
                // assert @writes_check(ls); 
                assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ls, ^LocalStores));
                // assert @writes_check(hhs); 
                assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                // assert @writes_check(ps); 
                assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                // stmt havoc_all(ln, ls, hhs, ps); 
                call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
                assume $full_stop_ext(#tok$1^552.4, $s);
                // s0#2 := @_vcc_current_state(@state); 
                s0#2 := $current_state($s);
                // _math \objset owns#155; 
                // owns#155 := @_vcc_set_empty; 
                owns#155 := $set_empty();
                // _math \state prestate#154; 
                // prestate#154 := @_vcc_current_state(@state); 
                prestate#154 := $current_state($s);
                // _math \state prestate#156; 
                // prestate#156 := @_vcc_current_state(@state); 
                prestate#156 := $current_state($s);
                // assert @_vcc_wrapped(@state, ps); 
                assert $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
                // assert @writes_check(ps); 
                assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                // prestate#156 := pure(@_vcc_start_release(prestate#156, prestate#156)); 
                prestate#156 := $start_release(prestate#156, prestate#156);
                // assume @_vcc_inv(@state, ps); 
                assume $inv($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
                // assume ==(owns#155, @_vcc_owns(@state, ps)); 
                assume owns#155 == $owns($s, $phys_ptr_cast(P#ps, ^PendingSet));
                // assume @_vcc_pre_static_unwrap(@state); 
                assume $pre_static_unwrap($s);
                // @_vcc_static_unwrap(pure(ps), prestate#156)
                call $static_unwrap($phys_ptr_cast(P#ps, ^PendingSet), prestate#156);
                assume $good_state_ext(#tok$1^554.6, $s);
                // assume @_vcc_full_stop(@state); 
                assume $full_stop($s);
                // assert @reads_check_normal((ps->size)); 
                assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                assume true;
                // if (==(*((ps->size)), 16777215)) ...
                if ($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == 16777215)
                {
                  anon95:
                    // _math \state prestate#157; 
                    // prestate#157 := @_vcc_current_state(@state); 
                    prestate#157 := $current_state($s);
                    // _math \state staticWrapState#158; 
                    // staticWrapState#158 := @_vcc_current_state(@state); 
                    staticWrapState#158 := $current_state($s);
                    // _math \objset owns#160; 
                    // owns#160 := @_vcc_set_empty; 
                    owns#160 := $set_empty();
                    // assert @writes_check(ps); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                    // assume @_vcc_pre_static_wrap(@state); 
                    assume $pre_static_wrap($s);
                    // @_vcc_static_wrap(pure(ps), staticWrapState#158, owns#160)
                    call $static_wrap($phys_ptr_cast(P#ps, ^PendingSet), staticWrapState#158, owns#160);
                    assume $good_state_ext(#tok$1^556.7, $s);
                    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ps), @_vcc_set_empty)); 
                    assert $set_eq($owns($s, $phys_ptr_cast(P#ps, ^PendingSet)), $set_empty());
                    // assert @inv_check(<=(*((ps->size)), 16777215)); 
                    assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
                    // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((ps->size))), @map_get(*((ps->pset)), *((ps->pending)[i]))))); 
                    assert (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))));
                    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), <(@map_get(*((ps->idx)), h), *((ps->size)))))); 
                    assert (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)));
                    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), ==(*((ps->pending)[@map_get(*((ps->idx)), h)]), h)))); 
                    assert (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415);
                    // assert @inv_check(==>(&&(>=(*((ps->tkey)), 0), <(*((ps->tkey)), 10000)), ==(*((ps->tcoord)), get_coord_for_key(*((ps->tkey)))))); 
                    assert $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) < 10000 ==> $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet)) == F#get_coord_for_key($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)));
                    // assume @_vcc_full_stop(@state); 
                    assume $full_stop($s);
                    // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
                    assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
                    // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
                    assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
                    // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
                    assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
                    // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
                    assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
                    // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
                    assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
                    // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0#2, @map_get(*((ls->tainted_nodes)), i)), old(s0#2, @map_get(*((hhs->tainted_nodes)), i))), old(s0#2, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
                    assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^557.14#tc1#1444: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^557.14#tc1#1444) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^557.14#tc1#1444) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^557.14#tc1#1444) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^557.14#tc1#1444) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^557.14#tc1#1444) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^557.14#tc1#1444) } $in_range_i4(Q#i$1^557.14#tc1#1444) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^557.14#tc1#1444) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^557.14#tc1#1444) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^557.14#tc1#1444) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^557.14#tc1#1444) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^557.14#tc1#1444) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^557.14#tc1#1444));
                    // assume ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0#2, @map_get(*((ls->tainted_nodes)), i)), old(s0#2, @map_get(*((hhs->tainted_nodes)), i))), old(s0#2, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
                    assume $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^557.14#tc1#1457: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^557.14#tc1#1457) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^557.14#tc1#1457) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^557.14#tc1#1457) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^557.14#tc1#1457) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^557.14#tc1#1457) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^557.14#tc1#1457) } $in_range_i4(Q#i$1^557.14#tc1#1457) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^557.14#tc1#1457) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^557.14#tc1#1457) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^557.14#tc1#1457) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^557.14#tc1#1457) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^557.14#tc1#1457) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^557.14#tc1#1457));
                    // assert @writes_check(ln); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ln, ^LiveNodes));
                    // assert @writes_check(ls); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ls, ^LocalStores));
                    // assert @writes_check(hhs); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                    // assert @writes_check(ps); 
                    assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                    // stmt havoc_all(ln, ls, hhs, ps); 
                    call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
                    assume $full_stop_ext(#tok$1^558.5, $s);
                    // return -2; 
                    $result := -2;
                    assume true;
                    assert $position_marker();
                    goto #exit;
                }
                else
                {
                  anon96:
                    // assert @_vcc_possibly_unreachable; 
                    assert {:PossiblyUnreachable true} true;
                }

              anon101:
                // _Bool ite#8; 
                // ite#8 := (_Bool)is_tainted; 
                ite#8 := $int_to_bool(P#is_tainted);
                assume true;
                // if (ite#8) ...
                if (ite#8)
                {
                  anon97:
                    // assert @prim_writes_check((ps->tkey)); 
                    assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.tkey));
                    // *(ps->tkey) := key; 
                    call $write_int(PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet), P#key);
                    assume $full_stop_ext(#tok$1^564.6, $s);
                    // assert @prim_writes_check((ps->tcoord)); 
                    assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.tcoord));
                    // *(ps->tcoord) := coord; 
                    call $write_int(PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet), P#coord);
                    assume $full_stop_ext(#tok$1^565.6, $s);
                    // (int32_t -> _Bool) res_addone_iset#79; 
                    // res_addone_iset#79 := addone_iset(*((ps->tainted_nodes)), cur_node); 
                    call res_addone_iset#79 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), L#cur_node);
                    assume $full_stop_ext(#tok$1^566.26, $s);
                    // assert @prim_writes_check((ps->tainted_nodes)); 
                    assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.tainted_nodes));
                    // *(ps->tainted_nodes) := res_addone_iset#79; 
                    call $write_int(PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^i4.^^bool_to_int(res_addone_iset#79));
                    assume $full_stop_ext(#tok$1^566.6, $s);
                    // assert @map_get(*((ps->tainted_nodes)), cur_node); 
                    assert $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), L#cur_node);
                    // assume @map_get(*((ps->tainted_nodes)), cur_node); 
                    assume $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), L#cur_node);
                }
                else
                {
                  anon98:
                    // assert @_vcc_possibly_unreachable; 
                    assert {:PossiblyUnreachable true} true;
                }

              anon102:
                // (h#1, abs_hint) = create_hint(coord, i, key); 
                call h#1, SL#abs_hint := create_hint(P#coord, L#i, P#key);
                assume $full_stop_ext(#tok$1^570.14, $s);
                // assert @prim_writes_check((ps->pending)[*((ps->size))]); 
                assert $writable_prim($s, #wrTime$1^475.12, $idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet))));
                // assert @reads_check_normal((ps->size)); 
                assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                // *(ps->pending)[*((ps->size))] := h#1; 
                call $write_int($field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)))), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)))), h#1);
                assume $full_stop_ext(#tok$1^571.5, $s);
                // (uint64_t -> _Bool) res_addone_hset#80; 
                // res_addone_hset#80 := addone_hset(*((ps->pset)), h#1); 
                call res_addone_hset#80 := addone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), h#1);
                assume $full_stop_ext(#tok$1^572.24, $s);
                // assert @prim_writes_check((ps->pset)); 
                assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pset));
                // *(ps->pset) := res_addone_hset#80; 
                call $write_int(PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^u8.^^bool_to_int(res_addone_hset#80));
                assume $full_stop_ext(#tok$1^572.13, $s);
                // assert @prim_writes_check((ps->idx)); 
                assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.idx));
                // *(ps->idx) := @map_updated(*((ps->idx)), h#1, *((ps->size))); 
                call $write_int(PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^u8.^^u8_to_int($store.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), h#1, $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)))));
                assume $full_stop_ext(#tok$1^573.13, $s);
                // assert @prim_writes_check((ps->size)); 
                assert $writable_prim($s, #wrTime$1^475.12, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.size));
                // assert @in_range_u8(+(*((ps->size)), 1)); 
                assert $in_range_u8($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) + 1);
                // assert @reads_check_normal((ps->size)); 
                assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                // *(ps->size) := +(*((ps->size)), 1); 
                call $write_int(PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) + 1);
                assume $full_stop_ext(#tok$1^574.5, $s);
                // _math \state prestate#161; 
                // prestate#161 := @_vcc_current_state(@state); 
                prestate#161 := $current_state($s);
                // _math \state staticWrapState#162; 
                // staticWrapState#162 := @_vcc_current_state(@state); 
                staticWrapState#162 := $current_state($s);
                // _math \objset owns#164; 
                // owns#164 := @_vcc_set_empty; 
                owns#164 := $set_empty();
                // assert @writes_check(ps); 
                assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                // assume @_vcc_pre_static_wrap(@state); 
                assume $pre_static_wrap($s);
                // @_vcc_static_wrap(pure(ps), staticWrapState#162, owns#164)
                call $static_wrap($phys_ptr_cast(P#ps, ^PendingSet), staticWrapState#162, owns#164);
                assume $good_state_ext(#tok$1^575.6, $s);
                // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ps), @_vcc_set_empty)); 
                assert $set_eq($owns($s, $phys_ptr_cast(P#ps, ^PendingSet)), $set_empty());
                // assert @inv_check(<=(*((ps->size)), 16777215)); 
                assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
                // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((ps->size))), @map_get(*((ps->pset)), *((ps->pending)[i]))))); 
                assert (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))));
                // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), <(@map_get(*((ps->idx)), h), *((ps->size)))))); 
                assert (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)));
                // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), ==(*((ps->pending)[@map_get(*((ps->idx)), h)]), h)))); 
                assert (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415);
                // assert @inv_check(==>(&&(>=(*((ps->tkey)), 0), <(*((ps->tkey)), 10000)), ==(*((ps->tcoord)), get_coord_for_key(*((ps->tkey)))))); 
                assert $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) < 10000 ==> $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet)) == F#get_coord_for_key($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)));
                // assume @_vcc_full_stop(@state); 
                assume $full_stop($s);
                // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
                assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
                // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
                assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
                // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
                assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
                // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
                assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
                // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
                assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
                // assert ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0#2, @map_get(*((ls->tainted_nodes)), i)), old(s0#2, @map_get(*((hhs->tainted_nodes)), i))), old(s0#2, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
                assert $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^576.13#tc1#1445: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^576.13#tc1#1445) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^576.13#tc1#1445) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^576.13#tc1#1445) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^576.13#tc1#1445) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^576.13#tc1#1445) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^576.13#tc1#1445) } $in_range_i4(Q#i$1^576.13#tc1#1445) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^576.13#tc1#1445) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^576.13#tc1#1445) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^576.13#tc1#1445) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^576.13#tc1#1445) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^576.13#tc1#1445) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^576.13#tc1#1445));
                // assume ==>(!=(old(s0#2, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0#2, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0#2, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0#2, @map_get(*((ls->tainted_nodes)), i)), old(s0#2, @map_get(*((hhs->tainted_nodes)), i))), old(s0#2, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
                assume $rd_inv(s0#2, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(s0#2, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(s0#2, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^576.13#tc1#1458: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^576.13#tc1#1458) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^576.13#tc1#1458) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^576.13#tc1#1458) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^576.13#tc1#1458) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^576.13#tc1#1458) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^576.13#tc1#1458) } $in_range_i4(Q#i$1^576.13#tc1#1458) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^576.13#tc1#1458) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^576.13#tc1#1458) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(s0#2, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^576.13#tc1#1458) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^576.13#tc1#1458) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^576.13#tc1#1458) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^576.13#tc1#1458));
                // assert @writes_check(ln); 
                assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ln, ^LiveNodes));
                // assert @writes_check(ls); 
                assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ls, ^LocalStores));
                // assert @writes_check(hhs); 
                assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                // assert @writes_check(ps); 
                assert $top_writable($s, #wrTime$1^475.12, $phys_ptr_cast(P#ps, ^PendingSet));
                // stmt havoc_all(ln, ls, hhs, ps); 
                call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
                assume $full_stop_ext(#tok$1^577.4, $s);
            }

          anon105:
            // assert @in_range_i4(+(i, 1)); 
            assert $in_range_i4(L#i + 1);
            // i := +(i, 1); 
            L#i := L#i + 1;
        }
        else
        {
          anon106:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
            // goto #break_61; 
            goto #break_61;
        }

      #continue_61:
        // \integer loopDecrEnd#310; 
        // loopDecrEnd#310 := @prelude_int_distance(i, 3200); 
        loopDecrEnd#310 := $int_distance(L#i, 3200);
        // assert @prelude_int_lt_or(loopDecrEnd#310, loopDecrBeg#309, false); 
        assert $int_lt_or(loopDecrEnd#310, loopDecrBeg#309, false);
        assume true;
    }

  anon111:
    assume $full_stop_ext(#tok$1^471.2, $s);

  #break_61:
    // assert @reads_check_normal((wrap#WDT->data)); 
    assert $thread_local($s, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT));
    assume true;
    // if (<(cnt_succ, *((wrap#WDT->data)))) ...
    if (L#cnt_succ < $rd_inv($s, swrap#WDT.data, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT)))
    {
      anon108:
        // return -1; 
        $result := -1;
        assume true;
        assert $position_marker();
        goto #exit;
    }
    else
    {
      anon109:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon112:
    // return cnt_succ; 
    $result := L#cnt_succ;
    assume true;
    assert $position_marker();
    goto #exit;

  anon113:
    // skip

  #exit:
}



procedure write_to_local_store() returns ($result: int);
  modifies $s, $cev_pc;
  free ensures $in_range_i4($result);
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



procedure write_to_slop_store() returns ($result: int);
  modifies $s, $cev_pc;
  free ensures $in_range_i4($result);
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



function F#is_the_last_tainted(#s: $state, P#key: int, P#tainted_key: int, P#tainted_coord: int, P#dst_node: int, P#ps: $ptr) : int;

const unique cf#is_the_last_tainted: $pure_function;

axiom (forall #s: $state, P#key: int, P#tainted_key: int, P#tainted_coord: int, P#dst_node: int, P#ps: $ptr :: { F#is_the_last_tainted(#s, P#key, P#tainted_key, P#tainted_coord, P#dst_node, P#ps) } $in_range_i4(P#key) && $in_range_i4(P#tainted_key) && $in_range_i4(P#tainted_coord) && $in_range_i4(P#dst_node) && P#tainted_coord == F#get_coord_for_key(P#tainted_key) ==> $in_range_i4(F#is_the_last_tainted(#s, P#key, P#tainted_key, P#tainted_coord, P#dst_node, P#ps)));

axiom $function_arg_type(cf#is_the_last_tainted, 0, ^^i4);

axiom $function_arg_type(cf#is_the_last_tainted, 1, ^^i4);

axiom $function_arg_type(cf#is_the_last_tainted, 2, ^^i4);

axiom $function_arg_type(cf#is_the_last_tainted, 3, ^^i4);

axiom $function_arg_type(cf#is_the_last_tainted, 4, ^^i4);

axiom $function_arg_type(cf#is_the_last_tainted, 5, $ptr_to(^PendingSet));

procedure is_the_last_tainted(P#key: int, P#tainted_key: int, P#tainted_coord: int, P#dst_node: int, P#ps: $ptr) returns ($result: int);
  requires P#tainted_coord == F#get_coord_for_key(P#tainted_key);
  free ensures $in_range_i4($result);
  free ensures $result == F#is_the_last_tainted($s, P#key, P#tainted_key, P#tainted_coord, P#dst_node, P#ps);
  free ensures $call_transition(old($s), $s);



procedure rm_pending_seq(P#tainted_key: int, P#tainted_coord: int, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr);
  requires $non_null($phys_ptr_cast(P#pl, ^PreferenceLists));
  requires $non_null($phys_ptr_cast(P#ls, ^LocalStores));
  requires $non_null($phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  requires $non_null($phys_ptr_cast(P#ps, ^PendingSet));
  requires $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) > 0;
  requires P#tainted_key >= 0;
  requires P#tainted_key < 10000;
  requires P#tainted_key != -1 ==> P#tainted_coord == F#get_coord_for_key(P#tainted_key);
  requires $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 16777215;
  free requires -1 == $unchk_sub(^^i4, 0, 1);
  requires (forall Q#j$1^608.5#tc1#1429: int :: {:weight 10} { $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1429 } $in_range_i4(Q#j$1^608.5#tc1#1429) ==> Q#j$1^608.5#tc1#1429 >= 0 && Q#j$1^608.5#tc1#1429 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1429)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1429)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1429)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1429)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1429)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1429)))));
  requires $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  requires $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  requires $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  requires $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  modifies $s, $cev_pc;
  ensures $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == $rd_inv(old($s), PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1;
  ensures $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == $rd_inv(old($s), HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) || $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == $rd_inv(old($s), HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1;
  ensures $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
  free ensures -1 == $unchk_sub(^^i4, 0, 1);
  ensures (forall Q#j$1^608.5#tc1#1430: int :: {:weight 10} { $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1430 } $in_range_i4(Q#j$1^608.5#tc1#1430) ==> Q#j$1^608.5#tc1#1430 >= 0 && Q#j$1^608.5#tc1#1430 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1430)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1430)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1430)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1430)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1430)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^608.5#tc1#1430)))));
  ensures $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  ensures $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  ensures $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  ensures $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
  free ensures $call_transition(old($s), $s);



implementation rm_pending_seq(P#tainted_key: int, P#tainted_coord: int, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr)
{
  var owns#185: $ptrset;
  var staticWrapState#183: $state;
  var prestate#182: $state;
  var owns#181: $ptrset;
  var staticWrapState#179: $state;
  var prestate#178: $state;
  var res_addone_hset#88: $map_t..^^u8.^^bool;
  var res_addone_hset#87: $map_t..^^u8.^^bool;
  var ite#13: bool;
  var ite#12: bool;
  var owns#177: $ptrset;
  var staticWrapState#175: $state;
  var prestate#174: $state;
  var res_lambda#51#86: $map_t..^^u8.^^bool;
  var h#35: int where $in_range_u8(h#35);
  var res_addone_iset#85: $map_t..^^i4.^^bool;
  var res_addone_iset#84: $map_t..^^i4.^^bool;
  var ite#11: bool;
  var res_addone_iset#83: $map_t..^^i4.^^bool;
  var ite#10: bool;
  var res_delone_iset#82: $map_t..^^i4.^^bool;
  var res_is_the_last_tainted#81: int where $in_range_i4(res_is_the_last_tainted#81);
  var ite#9: bool;
  var prestate#173: $state;
  var prestate#171: $state;
  var owns#172: $ptrset;
  var prestate#170: $state;
  var prestate#168: $state;
  var owns#169: $ptrset;
  var prestate#167: $state;
  var prestate#165: $state;
  var owns#166: $ptrset;
  var L#x: int where $in_range_i4(L#x);
  var L#last_hint: int where $in_range_u8(L#last_hint);
  var L#dst_node: int where $in_range_i4(L#dst_node);
  var L#key: int where $in_range_i4(L#key);
  var L#do_local_write: int where $in_range_i4(L#do_local_write);
  var L#do_slop_write: int where $in_range_i4(L#do_slop_write);
  var thisDecr#311: int where $in_range_u8(thisDecr#311);
  var #wrTime$1^600.1: int;
  var #stackframe: int;

  anon129:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^600.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^600.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^600.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
    assume $thread_owned($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    assume $thread_owned($s, $phys_ptr_cast(P#ls, ^LocalStores));
    assume $thread_owned($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @in_range_i4(tainted_key); 
    assume $in_range_i4(P#tainted_key);
    // assume @in_range_i4(tainted_coord); 
    assume $in_range_i4(P#tainted_coord);
    // assume true
    // assume true
    // assume true
    // assume true
    // uint64_t thisDecr#311; 
    // thisDecr#311 := *((ps->size)); 
    thisDecr#311 := $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @decreases_level_is(2); 
    assume 2 == $decreases_level;
    // assert @_vcc_in_domain(@state, ps, ps); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ps, ^PendingSet), $phys_ptr_cast(P#ps, ^PendingSet), l#public);
    // assert @_vcc_in_domain(@state, pl, pl); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#pl, ^PreferenceLists), l#public);
    // assert @_vcc_in_domain(@state, ls, ls); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ls, ^LocalStores), l#public);
    // assert @_vcc_in_domain(@state, hhs, hhs); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), l#public);
    // assume true
    // assume ==(18446744073709551615, @unchecked_u8((uint64_t)unchecked-(0, 1))); 
    assume 18446744073709551615 == $unchecked(^^u8, $unchk_sub(^^i4, 0, 1));
    // int32_t do_slop_write; 
    // int32_t do_local_write; 
    // int32_t key; 
    // int32_t dst_node; 
    // uint64_t last_hint; 
    // int32_t x; 
    // assert ==(tainted_coord, get_coord_for_key(tainted_key)); 
    assert P#tainted_coord == F#get_coord_for_key(P#tainted_key);
    // assume ==(tainted_coord, get_coord_for_key(tainted_key)); 
    assume P#tainted_coord == F#get_coord_for_key(P#tainted_key);
    // assert @in_range_i4(*(tainted_coord, 3200)); 
    assert $in_range_i4($op_mul(P#tainted_coord, 3200));
    // x := *(tainted_coord, 3200); 
    L#x := $op_mul(P#tainted_coord, 3200);
    // assert @reads_check_normal((ps->pending)[-(*((ps->size)), 1)]); 
    assert $thread_local($s, $idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1));
    // assert @in_range_u8(-(*((ps->size)), 1)); 
    assert $in_range_u8($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    // assert @reads_check_normal((ps->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // last_hint := *((ps->pending)[-(*((ps->size)), 1)]); 
    L#last_hint := $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)));
    // dst_node := get_dst(last_hint); 
    call L#dst_node := get_dst(L#last_hint);
    assume $full_stop_ext(#tok$1^634.17, $s);
    // key := get_key(last_hint); 
    call L#key := get_key(L#last_hint);
    assume $full_stop_ext(#tok$1^635.12, $s);
    // non-pure function
    // do_local_write := write_to_local_store(); 
    call L#do_local_write := write_to_local_store();
    assume $full_stop_ext(#tok$1^637.24, $s);
    // non-pure function
    // do_slop_write := write_to_slop_store(); 
    call L#do_slop_write := write_to_slop_store();
    assume $full_stop_ext(#tok$1^638.23, $s);
    // _math \objset owns#166; 
    // owns#166 := @_vcc_set_empty; 
    owns#166 := $set_empty();
    // _math \state prestate#165; 
    // prestate#165 := @_vcc_current_state(@state); 
    prestate#165 := $current_state($s);
    // _math \state prestate#167; 
    // prestate#167 := @_vcc_current_state(@state); 
    prestate#167 := $current_state($s);
    // assert @_vcc_wrapped(@state, ps); 
    assert $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^600.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // prestate#167 := pure(@_vcc_start_release(prestate#167, prestate#167)); 
    prestate#167 := $start_release(prestate#167, prestate#167);
    // assume @_vcc_inv(@state, ps); 
    assume $inv($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
    // assume ==(owns#166, @_vcc_owns(@state, ps)); 
    assume owns#166 == $owns($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(ps), prestate#167)
    call $static_unwrap($phys_ptr_cast(P#ps, ^PendingSet), prestate#167);
    assume $good_state_ext(#tok$1^640.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _math \objset owns#169; 
    // owns#169 := @_vcc_set_empty; 
    owns#169 := $set_empty();
    // _math \state prestate#168; 
    // prestate#168 := @_vcc_current_state(@state); 
    prestate#168 := $current_state($s);
    // _math \state prestate#170; 
    // prestate#170 := @_vcc_current_state(@state); 
    prestate#170 := $current_state($s);
    // assert @_vcc_wrapped(@state, ls); 
    assert $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^600.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // prestate#170 := pure(@_vcc_start_release(prestate#170, prestate#170)); 
    prestate#170 := $start_release(prestate#170, prestate#170);
    // assume @_vcc_inv(@state, ls); 
    assume $inv($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
    // assume ==(owns#169, @_vcc_owns(@state, ls)); 
    assume owns#169 == $owns($s, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(ls), prestate#170)
    call $static_unwrap($phys_ptr_cast(P#ls, ^LocalStores), prestate#170);
    assume $good_state_ext(#tok$1^641.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _math \objset owns#172; 
    // owns#172 := @_vcc_set_empty; 
    owns#172 := $set_empty();
    // _math \state prestate#171; 
    // prestate#171 := @_vcc_current_state(@state); 
    prestate#171 := $current_state($s);
    // _math \state prestate#173; 
    // prestate#173 := @_vcc_current_state(@state); 
    prestate#173 := $current_state($s);
    // assert @_vcc_wrapped(@state, hhs); 
    assert $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^600.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // prestate#173 := pure(@_vcc_start_release(prestate#173, prestate#173)); 
    prestate#173 := $start_release(prestate#173, prestate#173);
    // assume @_vcc_inv(@state, hhs); 
    assume $inv($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
    // assume ==(owns#172, @_vcc_owns(@state, hhs)); 
    assume owns#172 == $owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(hhs), prestate#173)
    call $static_unwrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), prestate#173);
    assume $good_state_ext(#tok$1^642.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _Bool ite#9; 
    // int32_t res_is_the_last_tainted#81; 
    // res_is_the_last_tainted#81 := is_the_last_tainted(key, tainted_key, tainted_coord, dst_node, ps); 
    call res_is_the_last_tainted#81 := is_the_last_tainted(L#key, P#tainted_key, P#tainted_coord, L#dst_node, $phys_ptr_cast(P#ps, ^PendingSet));
    assume $full_stop_ext(#tok$1^644.7, $s);
    // ite#9 := (_Bool)res_is_the_last_tainted#81; 
    ite#9 := $int_to_bool(res_is_the_last_tainted#81);
    assume true;
    // if (ite#9) ...
    if (ite#9)
    {
      anon118:
        // (int32_t -> _Bool) res_delone_iset#82; 
        // res_delone_iset#82 := delone_iset(*((ps->tainted_nodes)), dst_node); 
        call res_delone_iset#82 := delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), L#dst_node);
        assume $full_stop_ext(#tok$1^646.24, $s);
        // assert @prim_writes_check((ps->tainted_nodes)); 
        assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.tainted_nodes));
        // *(ps->tainted_nodes) := res_delone_iset#82; 
        call $write_int(PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^i4.^^bool_to_int(res_delone_iset#82));
        assume $full_stop_ext(#tok$1^646.4, $s);
        // _Bool ite#10; 
        // ite#10 := (_Bool)do_local_write; 
        ite#10 := $int_to_bool(L#do_local_write);
        assume true;
        // if (ite#10) ...
        if (ite#10)
        {
          anon116:
            // (int32_t -> _Bool) res_addone_iset#83; 
            // res_addone_iset#83 := addone_iset(*((ls->tainted_nodes)), dst_node); 
            call res_addone_iset#83 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node);
            assume $full_stop_ext(#tok$1^649.26, $s);
            // assert @prim_writes_check((ls->tainted_nodes)); 
            assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.tainted_nodes));
            // *(ls->tainted_nodes) := res_addone_iset#83; 
            call $write_int(LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores), $map_t..^^i4.^^bool_to_int(res_addone_iset#83));
            assume $full_stop_ext(#tok$1^649.5, $s);
            // _Bool ite#11; 
            // ite#11 := (_Bool)do_slop_write; 
            ite#11 := $int_to_bool(L#do_slop_write);
            assume true;
            // if (ite#11) ...
            if (ite#11)
            {
              anon114:
                // (int32_t -> _Bool) res_addone_iset#84; 
                // res_addone_iset#84 := addone_iset(*((hhs->tainted_nodes)), dst_node); 
                call res_addone_iset#84 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#dst_node);
                assume $full_stop_ext(#tok$1^651.27, $s);
                // assert @prim_writes_check((hhs->tainted_nodes)); 
                assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.tainted_nodes));
                // *(hhs->tainted_nodes) := res_addone_iset#84; 
                call $write_int(HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^i4.^^bool_to_int(res_addone_iset#84));
                assume $full_stop_ext(#tok$1^651.6, $s);
            }
            else
            {
              anon115:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
            }
        }
        else
        {
          anon117:
            // (int32_t -> _Bool) res_addone_iset#85; 
            // res_addone_iset#85 := addone_iset(*((hhs->tainted_nodes)), dst_node); 
            call res_addone_iset#85 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#dst_node);
            assume $full_stop_ext(#tok$1^654.26, $s);
            // assert @prim_writes_check((hhs->tainted_nodes)); 
            assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.tainted_nodes));
            // *(hhs->tainted_nodes) := res_addone_iset#85; 
            call $write_int(HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^i4.^^bool_to_int(res_addone_iset#85));
            assume $full_stop_ext(#tok$1^654.5, $s);
        }
    }
    else
    {
      anon119:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon130:
    assume true;
    // if (@check_termination(36)) ...
    if ($check_termination(36))
    {
      anon122:
        // uint64_t h#35; 
        assume true;
        // if (==(h#35, last_hint)) ...
        if (h#35 == L#last_hint)
        {
          anon120:
            // skip
        }
        else
        {
          anon121:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
        }

      anon123:
        // assume false; 
        assume false;
    }
    else
    {
      anon124:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon131:
    // (uint64_t -> _Bool) res_lambda#51#86; 
    // res_lambda#51#86 := lambda#51(*((ps->pset)), last_hint); 
    call res_lambda#51#86 := lambda#51($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), L#last_hint);
    assume $full_stop_ext(#tok$1^658.21, $s);
    // assert @prim_writes_check((ps->pset)); 
    assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pset));
    // *(ps->pset) := res_lambda#51#86; 
    call $write_int(PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^u8.^^bool_to_int(res_lambda#51#86));
    assume $full_stop_ext(#tok$1^658.10, $s);
    // assert @map_eq(addone_hset(delone_hset(*((ps->pset)), last_hint), last_hint), *((ps->pset))); 
    assert $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))));
    // assume @map_eq(addone_hset(delone_hset(*((ps->pset)), last_hint), last_hint), *((ps->pset))); 
    assume $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))));
    // assert @map_eq(addone_iset(delone_iset(*((ls->tainted_nodes)), dst_node), dst_node), *((ls->tainted_nodes))); 
    assert $eq.$map_t..^^i4.^^bool(F#addone_iset(F#delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node), L#dst_node), $int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))));
    // assume @map_eq(addone_iset(delone_iset(*((ls->tainted_nodes)), dst_node), dst_node), *((ls->tainted_nodes))); 
    assume $eq.$map_t..^^i4.^^bool(F#addone_iset(F#delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node), L#dst_node), $int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))));
    // assert @map_eq(addone_hset(delone_hset(*((hhs->hset)), last_hint), last_hint), *((hhs->hset))); 
    assert $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
    // assume @map_eq(addone_hset(delone_hset(*((hhs->hset)), last_hint), last_hint), *((hhs->hset))); 
    assume $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
    // assert @prim_writes_check((ps->pending)[-(*((ps->size)), 1)]); 
    assert $writable_prim($s, #wrTime$1^600.1, $idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1));
    // assert @in_range_u8(-(*((ps->size)), 1)); 
    assert $in_range_u8($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    // assert @reads_check_normal((ps->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // *(ps->pending)[-(*((ps->size)), 1)] := 18446744073709551615; 
    call $write_int($field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)), 18446744073709551615);
    assume $full_stop_ext(#tok$1^665.2, $s);
    // assert @prim_writes_check((ps->size)); 
    assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.size));
    // assert @in_range_u8(-(*((ps->size)), 1)); 
    assert $in_range_u8($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    // assert @reads_check_normal((ps->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // *(ps->size) := -(*((ps->size)), 1); 
    call $write_int(PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    assume $full_stop_ext(#tok$1^666.2, $s);
    // _math \state prestate#174; 
    // prestate#174 := @_vcc_current_state(@state); 
    prestate#174 := $current_state($s);
    // _math \state staticWrapState#175; 
    // staticWrapState#175 := @_vcc_current_state(@state); 
    staticWrapState#175 := $current_state($s);
    // _math \objset owns#177; 
    // owns#177 := @_vcc_set_empty; 
    owns#177 := $set_empty();
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^600.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ps), staticWrapState#175, owns#177)
    call $static_wrap($phys_ptr_cast(P#ps, ^PendingSet), staticWrapState#175, owns#177);
    assume $good_state_ext(#tok$1^667.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ps), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ps, ^PendingSet)), $set_empty());
    // assert @inv_check(<=(*((ps->size)), 16777215)); 
    assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
    // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((ps->size))), @map_get(*((ps->pset)), *((ps->pending)[i]))))); 
    assert (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), <(@map_get(*((ps->idx)), h), *((ps->size)))))); 
    assert (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), ==(*((ps->pending)[@map_get(*((ps->idx)), h)]), h)))); 
    assert (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415);
    // assert @inv_check(==>(&&(>=(*((ps->tkey)), 0), <(*((ps->tkey)), 10000)), ==(*((ps->tcoord)), get_coord_for_key(*((ps->tkey)))))); 
    assert $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) < 10000 ==> $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet)) == F#get_coord_for_key($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)));
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _Bool ite#12; 
    // ite#12 := (_Bool)do_local_write; 
    ite#12 := $int_to_bool(L#do_local_write);
    assume true;
    // if (ite#12) ...
    if (ite#12)
    {
      anon127:
        // assert @prim_writes_check((ls->local_store)[+(*(dst_node, 10000), key)]); 
        assert $writable_prim($s, #wrTime$1^600.1, $idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key));
        // assert @in_range_i4(+(*(dst_node, 10000), key)); 
        assert $in_range_i4($op_mul(L#dst_node, 10000) + L#key);
        // assert @in_range_i4(*(dst_node, 10000)); 
        assert $in_range_i4($op_mul(L#dst_node, 10000));
        // *(ls->local_store)[+(*(dst_node, 10000), key)] := key; 
        call $write_int($field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key)), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key)), L#key);
        assume $full_stop_ext(#tok$1^670.3, $s);
        // assert @prim_writes_check((ls->size)); 
        assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.size));
        // *(ls->size) := unchecked+(*((ls->size)), 1); 
        call $write_int(LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores), $unchk_add(^^nat, $rd_inv($s, LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores)), 1));
        assume $full_stop_ext(#tok$1^671.11, $s);
        // _Bool ite#13; 
        // ite#13 := (_Bool)do_slop_write; 
        ite#13 := $int_to_bool(L#do_slop_write);
        assume true;
        // if (ite#13) ...
        if (ite#13)
        {
          anon125:
            // assert @prim_writes_check((hhs->hint_store)[*((hhs->size))]); 
            assert $writable_prim($s, #wrTime$1^600.1, $idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
            // assert @reads_check_normal((hhs->size)); 
            assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
            // *(hhs->hint_store)[*((hhs->size))] := last_hint; 
            call $write_int($field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))), L#last_hint);
            assume $full_stop_ext(#tok$1^673.4, $s);
            // (uint64_t -> _Bool) res_addone_hset#87; 
            // res_addone_hset#87 := addone_hset(*((hhs->hset)), last_hint); 
            call res_addone_hset#87 := addone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint);
            assume $full_stop_ext(#tok$1^674.24, $s);
            // assert @prim_writes_check((hhs->hset)); 
            assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hset));
            // *(hhs->hset) := res_addone_hset#87; 
            call $write_int(HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^u8.^^bool_to_int(res_addone_hset#87));
            assume $full_stop_ext(#tok$1^674.12, $s);
            // assert @prim_writes_check((hhs->idx)); 
            assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.idx));
            // *(hhs->idx) := @map_updated(*((hhs->idx)), last_hint, *((hhs->size))); 
            call $write_int(HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^u8.^^u8_to_int($store.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint, $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))));
            assume $full_stop_ext(#tok$1^675.12, $s);
            // assert @prim_writes_check((hhs->size)); 
            assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.size));
            // assert @in_range_u8(+(*((hhs->size)), 1)); 
            assert $in_range_u8($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1);
            // assert @reads_check_normal((hhs->size)); 
            assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
            // *(hhs->size) := +(*((hhs->size)), 1); 
            call $write_int(HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1);
            assume $full_stop_ext(#tok$1^676.4, $s);
        }
        else
        {
          anon126:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
        }
    }
    else
    {
      anon128:
        // assert @prim_writes_check((hhs->hint_store)[*((hhs->size))]); 
        assert $writable_prim($s, #wrTime$1^600.1, $idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
        // assert @reads_check_normal((hhs->size)); 
        assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
        // *(hhs->hint_store)[*((hhs->size))] := last_hint; 
        call $write_int($field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))), L#last_hint);
        assume $full_stop_ext(#tok$1^679.3, $s);
        // (uint64_t -> _Bool) res_addone_hset#88; 
        // res_addone_hset#88 := addone_hset(*((hhs->hset)), last_hint); 
        call res_addone_hset#88 := addone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint);
        assume $full_stop_ext(#tok$1^680.23, $s);
        // assert @prim_writes_check((hhs->hset)); 
        assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hset));
        // *(hhs->hset) := res_addone_hset#88; 
        call $write_int(HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^u8.^^bool_to_int(res_addone_hset#88));
        assume $full_stop_ext(#tok$1^680.11, $s);
        // assert @prim_writes_check((hhs->idx)); 
        assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.idx));
        // *(hhs->idx) := @map_updated(*((hhs->idx)), last_hint, *((hhs->size))); 
        call $write_int(HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^u8.^^u8_to_int($store.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint, $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))));
        assume $full_stop_ext(#tok$1^681.11, $s);
        // assert @prim_writes_check((hhs->size)); 
        assert $writable_prim($s, #wrTime$1^600.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.size));
        // assert @in_range_u8(+(*((hhs->size)), 1)); 
        assert $in_range_u8($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1);
        // assert @reads_check_normal((hhs->size)); 
        assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
        // *(hhs->size) := +(*((hhs->size)), 1); 
        call $write_int(HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1);
        assume $full_stop_ext(#tok$1^682.3, $s);
    }

  anon132:
    // _math \state prestate#178; 
    // prestate#178 := @_vcc_current_state(@state); 
    prestate#178 := $current_state($s);
    // _math \state staticWrapState#179; 
    // staticWrapState#179 := @_vcc_current_state(@state); 
    staticWrapState#179 := $current_state($s);
    // _math \objset owns#181; 
    // owns#181 := @_vcc_set_empty; 
    owns#181 := $set_empty();
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^600.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(hhs), staticWrapState#179, owns#181)
    call $static_wrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), staticWrapState#179, owns#181);
    assume $good_state_ext(#tok$1^685.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, hhs), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)), $set_empty());
    // assert @inv_check(<=(*((hhs->size)), 16777215)); 
    assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
    // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((hhs->size))), @map_get(*((hhs->hset)), *((hhs->hint_store)[i]))))); 
    assert (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), <(@map_get(*((hhs->idx)), h), *((hhs->size)))))); 
    assert (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), ==(*((hhs->hint_store)[@map_get(*((hhs->idx)), h)]), h)))); 
    assert (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412);
    // assert @inv_check(==>(&&(>=(*((hhs->tkey)), 0), <(*((hhs->tkey)), 10000)), ==(*((hhs->tcoord)), get_coord_for_key(*((hhs->tkey)))))); 
    assert $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 10000 ==> $rd_inv($s, HintedHandoffStores.tcoord, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == F#get_coord_for_key($rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _math \state prestate#182; 
    // prestate#182 := @_vcc_current_state(@state); 
    prestate#182 := $current_state($s);
    // _math \state staticWrapState#183; 
    // staticWrapState#183 := @_vcc_current_state(@state); 
    staticWrapState#183 := $current_state($s);
    // _math \objset owns#185; 
    // owns#185 := @_vcc_set_empty; 
    owns#185 := $set_empty();
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^600.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ls), staticWrapState#183, owns#185)
    call $static_wrap($phys_ptr_cast(P#ls, ^LocalStores), staticWrapState#183, owns#185);
    assume $good_state_ext(#tok$1^686.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ls), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ls, ^LocalStores)), $set_empty());
    // assert @inv_check(<=(*((ls->len)), 100000000)); 
    assert $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores)) <= 100000000;
    // assert @inv_check(||(==(*((ls->tainted_key)), -1), &&(>=(*((ls->tainted_key)), 0), <(*((ls->tainted_key)), 10000)))); 
    assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) < 10000);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure rm_pending_rr(P#pl: $ptr, P#ls: $ptr, P#ps: $ptr);
  requires $non_null($phys_ptr_cast(P#pl, ^PreferenceLists));
  requires $non_null($phys_ptr_cast(P#ls, ^LocalStores));
  requires $non_null($phys_ptr_cast(P#ps, ^PendingSet));
  requires $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) > 0;
  requires $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  requires $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  requires $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  modifies $s, $cev_pc;
  ensures $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < $rd_inv(old($s), PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
  ensures $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  ensures $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  ensures $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
  free ensures $call_transition(old($s), $s);



implementation rm_pending_rr(P#pl: $ptr, P#ls: $ptr, P#ps: $ptr)
{
  var owns#199: $ptrset;
  var staticWrapState#197: $state;
  var prestate#196: $state;
  var owns#195: $ptrset;
  var staticWrapState#193: $state;
  var prestate#192: $state;
  var res_lambda#52#89: $map_t..^^u8.^^bool;
  var h#37: int where $in_range_u8(h#37);
  var prestate#191: $state;
  var prestate#189: $state;
  var owns#190: $ptrset;
  var prestate#188: $state;
  var prestate#186: $state;
  var owns#187: $ptrset;
  var L#last_hint: int where $in_range_u8(L#last_hint);
  var L#dst_node: int where $in_range_i4(L#dst_node);
  var L#key: int where $in_range_i4(L#key);
  var thisDecr#312: int where $in_range_u8(thisDecr#312);
  var #wrTime$1^690.1: int;
  var #stackframe: int;

  anon138:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^690.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^690.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^690.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
    assume $thread_owned($s, $phys_ptr_cast(P#ls, ^LocalStores));
    assume $thread_owned($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume true
    // assume true
    // assume true
    // uint64_t thisDecr#312; 
    // thisDecr#312 := *((ps->size)); 
    thisDecr#312 := $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @decreases_level_is(2); 
    assume 2 == $decreases_level;
    // assert @_vcc_in_domain(@state, ps, ps); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ps, ^PendingSet), $phys_ptr_cast(P#ps, ^PendingSet), l#public);
    // assert @_vcc_in_domain(@state, pl, pl); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#pl, ^PreferenceLists), l#public);
    // assert @_vcc_in_domain(@state, ls, ls); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ls, ^LocalStores), l#public);
    // assume true
    // assume ==(18446744073709551615, @unchecked_u8((uint64_t)unchecked-(0, 1))); 
    assume 18446744073709551615 == $unchecked(^^u8, $unchk_sub(^^i4, 0, 1));
    // int32_t key; 
    // int32_t dst_node; 
    // uint64_t last_hint; 
    // assert @reads_check_normal((ps->pending)[-(*((ps->size)), 1)]); 
    assert $thread_local($s, $idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1));
    // assert @in_range_u8(-(*((ps->size)), 1)); 
    assert $in_range_u8($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    // assert @reads_check_normal((ps->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // last_hint := *((ps->pending)[-(*((ps->size)), 1)]); 
    L#last_hint := $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)));
    // dst_node := get_dst(last_hint); 
    call L#dst_node := get_dst(L#last_hint);
    assume $full_stop_ext(#tok$1^707.17, $s);
    // key := get_key(last_hint); 
    call L#key := get_key(L#last_hint);
    assume $full_stop_ext(#tok$1^708.12, $s);
    // _math \objset owns#187; 
    // owns#187 := @_vcc_set_empty; 
    owns#187 := $set_empty();
    // _math \state prestate#186; 
    // prestate#186 := @_vcc_current_state(@state); 
    prestate#186 := $current_state($s);
    // _math \state prestate#188; 
    // prestate#188 := @_vcc_current_state(@state); 
    prestate#188 := $current_state($s);
    // assert @_vcc_wrapped(@state, ps); 
    assert $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^690.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // prestate#188 := pure(@_vcc_start_release(prestate#188, prestate#188)); 
    prestate#188 := $start_release(prestate#188, prestate#188);
    // assume @_vcc_inv(@state, ps); 
    assume $inv($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
    // assume ==(owns#187, @_vcc_owns(@state, ps)); 
    assume owns#187 == $owns($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(ps), prestate#188)
    call $static_unwrap($phys_ptr_cast(P#ps, ^PendingSet), prestate#188);
    assume $good_state_ext(#tok$1^710.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _math \objset owns#190; 
    // owns#190 := @_vcc_set_empty; 
    owns#190 := $set_empty();
    // _math \state prestate#189; 
    // prestate#189 := @_vcc_current_state(@state); 
    prestate#189 := $current_state($s);
    // _math \state prestate#191; 
    // prestate#191 := @_vcc_current_state(@state); 
    prestate#191 := $current_state($s);
    // assert @_vcc_wrapped(@state, ls); 
    assert $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^690.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // prestate#191 := pure(@_vcc_start_release(prestate#191, prestate#191)); 
    prestate#191 := $start_release(prestate#191, prestate#191);
    // assume @_vcc_inv(@state, ls); 
    assume $inv($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
    // assume ==(owns#190, @_vcc_owns(@state, ls)); 
    assume owns#190 == $owns($s, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(ls), prestate#191)
    call $static_unwrap($phys_ptr_cast(P#ls, ^LocalStores), prestate#191);
    assume $good_state_ext(#tok$1^711.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    assume true;
    // if (@check_termination(38)) ...
    if ($check_termination(38))
    {
      anon135:
        // uint64_t h#37; 
        assume true;
        // if (==(h#37, last_hint)) ...
        if (h#37 == L#last_hint)
        {
          anon133:
            // skip
        }
        else
        {
          anon134:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
        }

      anon136:
        // assume false; 
        assume false;
    }
    else
    {
      anon137:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon139:
    // (uint64_t -> _Bool) res_lambda#52#89; 
    // res_lambda#52#89 := lambda#52(*((ps->pset)), last_hint); 
    call res_lambda#52#89 := lambda#52($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), L#last_hint);
    assume $full_stop_ext(#tok$1^712.21, $s);
    // assert @prim_writes_check((ps->pset)); 
    assert $writable_prim($s, #wrTime$1^690.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pset));
    // *(ps->pset) := res_lambda#52#89; 
    call $write_int(PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^u8.^^bool_to_int(res_lambda#52#89));
    assume $full_stop_ext(#tok$1^712.10, $s);
    // assert @map_eq(addone_hset(delone_hset(*((ps->pset)), last_hint), last_hint), *((ps->pset))); 
    assert $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))));
    // assume @map_eq(addone_hset(delone_hset(*((ps->pset)), last_hint), last_hint), *((ps->pset))); 
    assume $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))));
    // assert @prim_writes_check((ps->pending)[-(*((ps->size)), 1)]); 
    assert $writable_prim($s, #wrTime$1^690.1, $idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1));
    // assert @in_range_u8(-(*((ps->size)), 1)); 
    assert $in_range_u8($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    // assert @reads_check_normal((ps->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // *(ps->pending)[-(*((ps->size)), 1)] := 18446744073709551615; 
    call $write_int($field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)), 18446744073709551615);
    assume $full_stop_ext(#tok$1^716.2, $s);
    // assert @prim_writes_check((ps->size)); 
    assert $writable_prim($s, #wrTime$1^690.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.size));
    // assert @in_range_u8(-(*((ps->size)), 1)); 
    assert $in_range_u8($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    // assert @reads_check_normal((ps->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // *(ps->size) := -(*((ps->size)), 1); 
    call $write_int(PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    assume $full_stop_ext(#tok$1^717.2, $s);
    // _math \state prestate#192; 
    // prestate#192 := @_vcc_current_state(@state); 
    prestate#192 := $current_state($s);
    // _math \state staticWrapState#193; 
    // staticWrapState#193 := @_vcc_current_state(@state); 
    staticWrapState#193 := $current_state($s);
    // _math \objset owns#195; 
    // owns#195 := @_vcc_set_empty; 
    owns#195 := $set_empty();
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^690.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ps), staticWrapState#193, owns#195)
    call $static_wrap($phys_ptr_cast(P#ps, ^PendingSet), staticWrapState#193, owns#195);
    assume $good_state_ext(#tok$1^718.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ps), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ps, ^PendingSet)), $set_empty());
    // assert @inv_check(<=(*((ps->size)), 16777215)); 
    assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
    // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((ps->size))), @map_get(*((ps->pset)), *((ps->pending)[i]))))); 
    assert (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), <(@map_get(*((ps->idx)), h), *((ps->size)))))); 
    assert (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), ==(*((ps->pending)[@map_get(*((ps->idx)), h)]), h)))); 
    assert (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415);
    // assert @inv_check(==>(&&(>=(*((ps->tkey)), 0), <(*((ps->tkey)), 10000)), ==(*((ps->tcoord)), get_coord_for_key(*((ps->tkey)))))); 
    assert $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) < 10000 ==> $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet)) == F#get_coord_for_key($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)));
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // assert @prim_writes_check((ls->local_store)[+(*(dst_node, 10000), key)]); 
    assert $writable_prim($s, #wrTime$1^690.1, $idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key));
    // assert @in_range_i4(+(*(dst_node, 10000), key)); 
    assert $in_range_i4($op_mul(L#dst_node, 10000) + L#key);
    // assert @in_range_i4(*(dst_node, 10000)); 
    assert $in_range_i4($op_mul(L#dst_node, 10000));
    // *(ls->local_store)[+(*(dst_node, 10000), key)] := key; 
    call $write_int($field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key)), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key)), L#key);
    assume $full_stop_ext(#tok$1^720.2, $s);
    // _math \state prestate#196; 
    // prestate#196 := @_vcc_current_state(@state); 
    prestate#196 := $current_state($s);
    // _math \state staticWrapState#197; 
    // staticWrapState#197 := @_vcc_current_state(@state); 
    staticWrapState#197 := $current_state($s);
    // _math \objset owns#199; 
    // owns#199 := @_vcc_set_empty; 
    owns#199 := $set_empty();
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^690.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ls), staticWrapState#197, owns#199)
    call $static_wrap($phys_ptr_cast(P#ls, ^LocalStores), staticWrapState#197, owns#199);
    assume $good_state_ext(#tok$1^721.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ls), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ls, ^LocalStores)), $set_empty());
    // assert @inv_check(<=(*((ls->len)), 100000000)); 
    assert $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores)) <= 100000000;
    // assert @inv_check(||(==(*((ls->tainted_key)), -1), &&(>=(*((ls->tainted_key)), 0), <(*((ls->tainted_key)), 10000)))); 
    assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) < 10000);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure havoc_all(P#ln: $ptr, P#ls: $ptr, P#hhs: $ptr, P#ps: $ptr);
  free requires -1 == $unchk_sub(^^i4, 0, 1);
  requires $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  requires $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  requires $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  requires $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  modifies $s, $cev_pc;
  ensures $rd_inv(old($s), LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1;
  ensures $rd_inv(old($s), HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1;
  ensures $rd_inv(old($s), PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv(old($s), PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) == $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet));
  ensures $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
  ensures $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
  ensures (forall Q#i$1^734.12#tc1#1264: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(old($s), LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^734.12#tc1#1264) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(old($s), HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^734.12#tc1#1264) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(old($s), PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^734.12#tc1#1264) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^734.12#tc1#1264) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^734.12#tc1#1264) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^734.12#tc1#1264) } $in_range_i4(Q#i$1^734.12#tc1#1264) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(old($s), LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^734.12#tc1#1264) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(old($s), HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^734.12#tc1#1264) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(old($s), PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^734.12#tc1#1264) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^734.12#tc1#1264) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^734.12#tc1#1264) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^734.12#tc1#1264));
  ensures $thread_local2($s, $dot($phys_ptr_cast(G#wrap#RDT#dt9, ^swrap#RDT), swrap#RDT.data), ^^i4);
  ensures $thread_local2($s, $dot($phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT), swrap#WDT.data), ^^i4);
  free ensures -1 == $unchk_sub(^^i4, 0, 1);
  ensures $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes) && $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores) && $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores) && $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
  free ensures $call_transition(old($s), $s);



procedure rm_pending_conc(P#tainted_key: int, P#tainted_coord: int, P#ln: $ptr, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr);
  requires $non_null($phys_ptr_cast(P#pl, ^PreferenceLists));
  requires $non_null($phys_ptr_cast(P#ls, ^LocalStores));
  requires $non_null($phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  requires $non_null($phys_ptr_cast(P#ps, ^PendingSet));
  requires $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
  requires P#tainted_key >= 0;
  requires P#tainted_key < 10000;
  requires P#tainted_key != -1 ==> P#tainted_coord == F#get_coord_for_key(P#tainted_key);
  requires $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 16777215;
  free requires -1 == $unchk_sub(^^i4, 0, 1);
  requires (forall Q#j$1^759.5#tc1#1431: int :: {:weight 10} { $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1431 } $in_range_i4(Q#j$1^759.5#tc1#1431) ==> Q#j$1^759.5#tc1#1431 >= 0 && Q#j$1^759.5#tc1#1431 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1431)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1431)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1431)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1431)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1431)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1431)))));
  requires $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  requires $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  requires $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  requires $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  requires $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  modifies $s, $cev_pc;
  free ensures -1 == $unchk_sub(^^i4, 0, 1);
  ensures (forall Q#j$1^759.5#tc1#1432: int :: {:weight 10} { $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1432 } $in_range_i4(Q#j$1^759.5#tc1#1432) ==> Q#j$1^759.5#tc1#1432 >= 0 && Q#j$1^759.5#tc1#1432 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1432)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1432)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1432)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1432)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1432)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^759.5#tc1#1432)))));
  ensures $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  ensures $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  ensures $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  ensures $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  ensures $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
  free ensures $call_transition(old($s), $s);



implementation rm_pending_conc(P#tainted_key: int, P#tainted_coord: int, P#ln: $ptr, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr)
{
  var owns#240: $ptrset;
  var staticWrapState#238: $state;
  var prestate#237: $state;
  var owns#236: $ptrset;
  var staticWrapState#234: $state;
  var prestate#233: $state;
  var res_addone_hset#96: $map_t..^^u8.^^bool;
  var owns#232: $ptrset;
  var staticWrapState#230: $state;
  var prestate#229: $state;
  var owns#228: $ptrset;
  var staticWrapState#226: $state;
  var prestate#225: $state;
  var res_addone_hset#95: $map_t..^^u8.^^bool;
  var owns#224: $ptrset;
  var staticWrapState#222: $state;
  var prestate#221: $state;
  var owns#220: $ptrset;
  var staticWrapState#218: $state;
  var prestate#217: $state;
  var ite#18: bool;
  var ite#17: bool;
  var owns#216: $ptrset;
  var staticWrapState#214: $state;
  var prestate#213: $state;
  var res_lambda#53#94: $map_t..^^u8.^^bool;
  var h#39: int where $in_range_u8(h#39);
  var res_addone_iset#93: $map_t..^^i4.^^bool;
  var res_addone_iset#92: $map_t..^^i4.^^bool;
  var ite#16: bool;
  var res_addone_iset#91: $map_t..^^i4.^^bool;
  var ite#15: bool;
  var res_delone_iset#90: $map_t..^^i4.^^bool;
  var ite#14: bool;
  var prestate#212: $state;
  var prestate#210: $state;
  var owns#211: $ptrset;
  var prestate#209: $state;
  var prestate#207: $state;
  var owns#208: $ptrset;
  var owns#206: $ptrset;
  var staticWrapState#204: $state;
  var prestate#203: $state;
  var prestate#202: $state;
  var prestate#200: $state;
  var owns#201: $ptrset;
  var L#x: int where $in_range_i4(L#x);
  var SL#s0: $state;
  var L#last_hint: int where $in_range_u8(L#last_hint);
  var L#dst_node: int where $in_range_i4(L#dst_node);
  var L#key: int where $in_range_i4(L#key);
  var L#do_local_write: int where $in_range_i4(L#do_local_write);
  var L#do_slop_write: int where $in_range_i4(L#do_slop_write);
  var #wrTime$1^751.1: int;
  var #stackframe: int;

  anon165:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^751.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^751.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^751.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
    assume $thread_owned($s, $phys_ptr_cast(P#ln, ^LiveNodes));
    assume $thread_owned($s, $phys_ptr_cast(P#ls, ^LocalStores));
    assume $thread_owned($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    assume $thread_owned($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @in_range_i4(tainted_key); 
    assume $in_range_i4(P#tainted_key);
    // assume @in_range_i4(tainted_coord); 
    assume $in_range_i4(P#tainted_coord);
    // assume true
    // assume true
    // assume true
    // assume true
    // assume true
    // assume @decreases_level_is(2); 
    assume 2 == $decreases_level;
    // assert @_vcc_in_domain(@state, ln, ln); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ln, ^LiveNodes), l#public);
    // assert @_vcc_in_domain(@state, ps, ps); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ps, ^PendingSet), $phys_ptr_cast(P#ps, ^PendingSet), l#public);
    // assert @_vcc_in_domain(@state, pl, pl); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#pl, ^PreferenceLists), l#public);
    // assert @_vcc_in_domain(@state, ls, ls); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ls, ^LocalStores), l#public);
    // assert @_vcc_in_domain(@state, hhs, hhs); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), l#public);
    // assume ==(18446744073709551615, @unchecked_u8((uint64_t)unchecked-(0, 1))); 
    assume 18446744073709551615 == $unchecked(^^u8, $unchk_sub(^^i4, 0, 1));
    // assume ==(3199, unchecked-(3200, 1)); 
    assume 3199 == $unchk_sub(^^i4, 3200, 1);
    // assume true
    // int32_t do_slop_write; 
    // int32_t do_local_write; 
    // int32_t key; 
    // int32_t dst_node; 
    // uint64_t last_hint; 
    // _math \state s0; 
    // int32_t x; 
    // assert ==(tainted_coord, get_coord_for_key(tainted_key)); 
    assert P#tainted_coord == F#get_coord_for_key(P#tainted_key);
    // assume ==(tainted_coord, get_coord_for_key(tainted_key)); 
    assume P#tainted_coord == F#get_coord_for_key(P#tainted_key);
    // assert @in_range_i4(*(tainted_coord, 3200)); 
    assert $in_range_i4($op_mul(P#tainted_coord, 3200));
    // x := *(tainted_coord, 3200); 
    L#x := $op_mul(P#tainted_coord, 3200);
    // assert @writes_check(ln); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ln, ^LiveNodes));
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // stmt havoc_all(ln, ls, hhs, ps); 
    call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
    assume $full_stop_ext(#tok$1^780.2, $s);
    // s0 := @_vcc_current_state(@state); 
    SL#s0 := $current_state($s);
    // _math \objset owns#201; 
    // owns#201 := @_vcc_set_empty; 
    owns#201 := $set_empty();
    // _math \state prestate#200; 
    // prestate#200 := @_vcc_current_state(@state); 
    prestate#200 := $current_state($s);
    // _math \state prestate#202; 
    // prestate#202 := @_vcc_current_state(@state); 
    prestate#202 := $current_state($s);
    // assert @_vcc_wrapped(@state, ps); 
    assert $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // prestate#202 := pure(@_vcc_start_release(prestate#202, prestate#202)); 
    prestate#202 := $start_release(prestate#202, prestate#202);
    // assume @_vcc_inv(@state, ps); 
    assume $inv($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
    // assume ==(owns#201, @_vcc_owns(@state, ps)); 
    assume owns#201 == $owns($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(ps), prestate#202)
    call $static_unwrap($phys_ptr_cast(P#ps, ^PendingSet), prestate#202);
    assume $good_state_ext(#tok$1^782.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // assert @reads_check_normal((ps->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
    assume true;
    // if (==(*((ps->size)), 0)) ...
    if ($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == 0)
    {
      anon140:
        // _math \state prestate#203; 
        // prestate#203 := @_vcc_current_state(@state); 
        prestate#203 := $current_state($s);
        // _math \state staticWrapState#204; 
        // staticWrapState#204 := @_vcc_current_state(@state); 
        staticWrapState#204 := $current_state($s);
        // _math \objset owns#206; 
        // owns#206 := @_vcc_set_empty; 
        owns#206 := $set_empty();
        // assert @writes_check(ps); 
        assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ps, ^PendingSet));
        // assume @_vcc_pre_static_wrap(@state); 
        assume $pre_static_wrap($s);
        // @_vcc_static_wrap(pure(ps), staticWrapState#204, owns#206)
        call $static_wrap($phys_ptr_cast(P#ps, ^PendingSet), staticWrapState#204, owns#206);
        assume $good_state_ext(#tok$1^784.5, $s);
        // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ps), @_vcc_set_empty)); 
        assert $set_eq($owns($s, $phys_ptr_cast(P#ps, ^PendingSet)), $set_empty());
        // assert @inv_check(<=(*((ps->size)), 16777215)); 
        assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
        // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((ps->size))), @map_get(*((ps->pset)), *((ps->pending)[i]))))); 
        assert (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))));
        // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), <(@map_get(*((ps->idx)), h), *((ps->size)))))); 
        assert (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)));
        // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), ==(*((ps->pending)[@map_get(*((ps->idx)), h)]), h)))); 
        assert (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415);
        // assert @inv_check(==>(&&(>=(*((ps->tkey)), 0), <(*((ps->tkey)), 10000)), ==(*((ps->tcoord)), get_coord_for_key(*((ps->tkey)))))); 
        assert $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) < 10000 ==> $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet)) == F#get_coord_for_key($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)));
        // assume @_vcc_full_stop(@state); 
        assume $full_stop($s);
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^785.12#tc1#1447: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^785.12#tc1#1447) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^785.12#tc1#1447) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^785.12#tc1#1447) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^785.12#tc1#1447) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^785.12#tc1#1447) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^785.12#tc1#1447) } $in_range_i4(Q#i$1^785.12#tc1#1447) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^785.12#tc1#1447) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^785.12#tc1#1447) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^785.12#tc1#1447) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^785.12#tc1#1447) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^785.12#tc1#1447) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^785.12#tc1#1447));
        // assume ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
        assume $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^785.12#tc1#1459: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^785.12#tc1#1459) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^785.12#tc1#1459) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^785.12#tc1#1459) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^785.12#tc1#1459) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^785.12#tc1#1459) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^785.12#tc1#1459) } $in_range_i4(Q#i$1^785.12#tc1#1459) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^785.12#tc1#1459) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^785.12#tc1#1459) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^785.12#tc1#1459) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^785.12#tc1#1459) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^785.12#tc1#1459) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^785.12#tc1#1459));
        // assert @writes_check(ln); 
        assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ln, ^LiveNodes));
        // assert @writes_check(ls); 
        assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ls, ^LocalStores));
        // assert @writes_check(hhs); 
        assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
        // assert @writes_check(ps); 
        assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ps, ^PendingSet));
        // stmt havoc_all(ln, ls, hhs, ps); 
        call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
        assume $full_stop_ext(#tok$1^786.3, $s);
        // return; 
        assume true;
        assert $position_marker();
        goto #exit;
    }
    else
    {
      anon141:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon166:
    // _math \objset owns#208; 
    // owns#208 := @_vcc_set_empty; 
    owns#208 := $set_empty();
    // _math \state prestate#207; 
    // prestate#207 := @_vcc_current_state(@state); 
    prestate#207 := $current_state($s);
    // _math \state prestate#209; 
    // prestate#209 := @_vcc_current_state(@state); 
    prestate#209 := $current_state($s);
    // assert @_vcc_wrapped(@state, ls); 
    assert $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // prestate#209 := pure(@_vcc_start_release(prestate#209, prestate#209)); 
    prestate#209 := $start_release(prestate#209, prestate#209);
    // assume @_vcc_inv(@state, ls); 
    assume $inv($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
    // assume ==(owns#208, @_vcc_owns(@state, ls)); 
    assume owns#208 == $owns($s, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(ls), prestate#209)
    call $static_unwrap($phys_ptr_cast(P#ls, ^LocalStores), prestate#209);
    assume $good_state_ext(#tok$1^789.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _math \objset owns#211; 
    // owns#211 := @_vcc_set_empty; 
    owns#211 := $set_empty();
    // _math \state prestate#210; 
    // prestate#210 := @_vcc_current_state(@state); 
    prestate#210 := $current_state($s);
    // _math \state prestate#212; 
    // prestate#212 := @_vcc_current_state(@state); 
    prestate#212 := $current_state($s);
    // assert @_vcc_wrapped(@state, hhs); 
    assert $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // prestate#212 := pure(@_vcc_start_release(prestate#212, prestate#212)); 
    prestate#212 := $start_release(prestate#212, prestate#212);
    // assume @_vcc_inv(@state, hhs); 
    assume $inv($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
    // assume ==(owns#211, @_vcc_owns(@state, hhs)); 
    assume owns#211 == $owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(hhs), prestate#212)
    call $static_unwrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), prestate#212);
    assume $good_state_ext(#tok$1^790.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // assert @reads_check_normal((ps->pending)[-(*((ps->size)), 1)]); 
    assert $thread_local($s, $idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1));
    // assert @in_range_u8(-(*((ps->size)), 1)); 
    assert $in_range_u8($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    // assert @reads_check_normal((ps->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // last_hint := *((ps->pending)[-(*((ps->size)), 1)]); 
    L#last_hint := $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)));
    // dst_node := get_dst(last_hint); 
    call L#dst_node := get_dst(L#last_hint);
    assume $full_stop_ext(#tok$1^793.17, $s);
    // key := get_key(last_hint); 
    call L#key := get_key(L#last_hint);
    assume $full_stop_ext(#tok$1^794.12, $s);
    // non-pure function
    // do_local_write := write_to_local_store(); 
    call L#do_local_write := write_to_local_store();
    assume $full_stop_ext(#tok$1^796.24, $s);
    // non-pure function
    // do_slop_write := write_to_slop_store(); 
    call L#do_slop_write := write_to_slop_store();
    assume $full_stop_ext(#tok$1^797.23, $s);
    // _Bool ite#14; 
    assume true;
    // if (>=(dst_node, *((pl->preference_list)[x]))) ...
    if (L#dst_node >= $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x))))
    {
      anon142:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
        // assert @in_range_i4(+(x, 3199)); 
        assert $in_range_i4(L#x + 3199);
        // ite#14 := <=(dst_node, *((pl->preference_list)[+(x, 3199)])); 
        ite#14 := L#dst_node <= $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x + 3199)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x + 3199)));
    }
    else
    {
      anon143:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
        // ite#14 := false; 
        ite#14 := false;
    }

  anon167:
    assume true;
    // if (ite#14) ...
    if (ite#14)
    {
      anon148:
        // (int32_t -> _Bool) res_delone_iset#90; 
        // res_delone_iset#90 := delone_iset(*((ps->tainted_nodes)), dst_node); 
        call res_delone_iset#90 := delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), L#dst_node);
        assume $full_stop_ext(#tok$1^802.23, $s);
        // assert @prim_writes_check((ps->tainted_nodes)); 
        assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.tainted_nodes));
        // *(ps->tainted_nodes) := res_delone_iset#90; 
        call $write_int(PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^i4.^^bool_to_int(res_delone_iset#90));
        assume $full_stop_ext(#tok$1^802.3, $s);
        // _Bool ite#15; 
        // ite#15 := (_Bool)do_local_write; 
        ite#15 := $int_to_bool(L#do_local_write);
        assume true;
        // if (ite#15) ...
        if (ite#15)
        {
          anon146:
            // (int32_t -> _Bool) res_addone_iset#91; 
            // res_addone_iset#91 := addone_iset(*((ls->tainted_nodes)), dst_node); 
            call res_addone_iset#91 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node);
            assume $full_stop_ext(#tok$1^805.25, $s);
            // assert @prim_writes_check((ls->tainted_nodes)); 
            assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.tainted_nodes));
            // *(ls->tainted_nodes) := res_addone_iset#91; 
            call $write_int(LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores), $map_t..^^i4.^^bool_to_int(res_addone_iset#91));
            assume $full_stop_ext(#tok$1^805.4, $s);
            // _Bool ite#16; 
            // ite#16 := (_Bool)do_slop_write; 
            ite#16 := $int_to_bool(L#do_slop_write);
            assume true;
            // if (ite#16) ...
            if (ite#16)
            {
              anon144:
                // (int32_t -> _Bool) res_addone_iset#92; 
                // res_addone_iset#92 := addone_iset(*((hhs->tainted_nodes)), dst_node); 
                call res_addone_iset#92 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#dst_node);
                assume $full_stop_ext(#tok$1^807.26, $s);
                // assert @prim_writes_check((hhs->tainted_nodes)); 
                assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.tainted_nodes));
                // *(hhs->tainted_nodes) := res_addone_iset#92; 
                call $write_int(HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^i4.^^bool_to_int(res_addone_iset#92));
                assume $full_stop_ext(#tok$1^807.5, $s);
            }
            else
            {
              anon145:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
            }
        }
        else
        {
          anon147:
            // (int32_t -> _Bool) res_addone_iset#93; 
            // res_addone_iset#93 := addone_iset(*((hhs->tainted_nodes)), dst_node); 
            call res_addone_iset#93 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#dst_node);
            assume $full_stop_ext(#tok$1^810.25, $s);
            // assert @prim_writes_check((hhs->tainted_nodes)); 
            assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.tainted_nodes));
            // *(hhs->tainted_nodes) := res_addone_iset#93; 
            call $write_int(HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^i4.^^bool_to_int(res_addone_iset#93));
            assume $full_stop_ext(#tok$1^810.4, $s);
        }
    }
    else
    {
      anon149:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon168:
    assume true;
    // if (@check_termination(40)) ...
    if ($check_termination(40))
    {
      anon152:
        // uint64_t h#39; 
        assume true;
        // if (==(h#39, last_hint)) ...
        if (h#39 == L#last_hint)
        {
          anon150:
            // skip
        }
        else
        {
          anon151:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
        }

      anon153:
        // assume false; 
        assume false;
    }
    else
    {
      anon154:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon169:
    // (uint64_t -> _Bool) res_lambda#53#94; 
    // res_lambda#53#94 := lambda#53(*((ps->pset)), last_hint); 
    call res_lambda#53#94 := lambda#53($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), L#last_hint);
    assume $full_stop_ext(#tok$1^815.21, $s);
    // assert @prim_writes_check((ps->pset)); 
    assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pset));
    // *(ps->pset) := res_lambda#53#94; 
    call $write_int(PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet), $map_t..^^u8.^^bool_to_int(res_lambda#53#94));
    assume $full_stop_ext(#tok$1^815.10, $s);
    // assert @map_eq(addone_hset(delone_hset(*((ps->pset)), last_hint), last_hint), *((ps->pset))); 
    assert $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))));
    // assume @map_eq(addone_hset(delone_hset(*((ps->pset)), last_hint), last_hint), *((ps->pset))); 
    assume $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))));
    // assert @map_eq(addone_iset(delone_iset(*((ls->tainted_nodes)), dst_node), dst_node), *((ls->tainted_nodes))); 
    assert $eq.$map_t..^^i4.^^bool(F#addone_iset(F#delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node), L#dst_node), $int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))));
    // assume @map_eq(addone_iset(delone_iset(*((ls->tainted_nodes)), dst_node), dst_node), *((ls->tainted_nodes))); 
    assume $eq.$map_t..^^i4.^^bool(F#addone_iset(F#delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node), L#dst_node), $int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))));
    // assert @map_eq(addone_hset(delone_hset(*((hhs->hset)), last_hint), last_hint), *((hhs->hset))); 
    assert $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
    // assume @map_eq(addone_hset(delone_hset(*((hhs->hset)), last_hint), last_hint), *((hhs->hset))); 
    assume $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
    // assert @prim_writes_check((ps->pending)[-(*((ps->size)), 1)]); 
    assert $writable_prim($s, #wrTime$1^751.1, $idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1));
    // assert @in_range_u8(-(*((ps->size)), 1)); 
    assert $in_range_u8($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    // assert @reads_check_normal((ps->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // *(ps->pending)[-(*((ps->size)), 1)] := 18446744073709551615; 
    call $write_int($field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1)), 18446744073709551615);
    assume $full_stop_ext(#tok$1^823.2, $s);
    // assert @prim_writes_check((ps->size)); 
    assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.size));
    // assert @in_range_u8(-(*((ps->size)), 1)); 
    assert $in_range_u8($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    // assert @reads_check_normal((ps->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // *(ps->size) := -(*((ps->size)), 1); 
    call $write_int(PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet), $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) - 1);
    assume $full_stop_ext(#tok$1^824.2, $s);
    // _math \state prestate#213; 
    // prestate#213 := @_vcc_current_state(@state); 
    prestate#213 := $current_state($s);
    // _math \state staticWrapState#214; 
    // staticWrapState#214 := @_vcc_current_state(@state); 
    staticWrapState#214 := $current_state($s);
    // _math \objset owns#216; 
    // owns#216 := @_vcc_set_empty; 
    owns#216 := $set_empty();
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ps), staticWrapState#214, owns#216)
    call $static_wrap($phys_ptr_cast(P#ps, ^PendingSet), staticWrapState#214, owns#216);
    assume $good_state_ext(#tok$1^825.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ps), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ps, ^PendingSet)), $set_empty());
    // assert @inv_check(<=(*((ps->size)), 16777215)); 
    assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
    // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((ps->size))), @map_get(*((ps->pset)), *((ps->pending)[i]))))); 
    assert (forall Q#i$1^208.14#tc2#1413: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))) } $in_range_u8(Q#i$1^208.14#tc2#1413) ==> Q#i$1^208.14#tc2#1413 < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), Q#i$1^208.14#tc2#1413)))));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), <(@map_get(*((ps->idx)), h), *((ps->size)))))); 
    assert (forall Q#h$1^209.14#tc2#1414: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) } $in_range_u8(Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^209.14#tc2#1414) < $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((ps->pset)), h), ==(*((ps->pending)[@map_get(*((ps->idx)), h)]), h)))); 
    assert (forall Q#h$1^210.14#tc2#1415: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) } $in_range_u8(Q#h$1^210.14#tc2#1415) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415))), $prim_emb($idx($dot($phys_ptr_cast(P#ps, ^PendingSet), PendingSet.pending), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, PendingSet.idx, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^210.14#tc2#1415)))) == Q#h$1^210.14#tc2#1415);
    // assert @inv_check(==>(&&(>=(*((ps->tkey)), 0), <(*((ps->tkey)), 10000)), ==(*((ps->tcoord)), get_coord_for_key(*((ps->tkey)))))); 
    assert $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) < 10000 ==> $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet)) == F#get_coord_for_key($rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)));
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _Bool ite#17; 
    // ite#17 := (_Bool)do_local_write; 
    ite#17 := $int_to_bool(L#do_local_write);
    assume true;
    // if (ite#17) ...
    if (ite#17)
    {
      anon160:
        // assert @prim_writes_check((ls->local_store)[+(*(dst_node, 10000), key)]); 
        assert $writable_prim($s, #wrTime$1^751.1, $idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key));
        // assert @in_range_i4(+(*(dst_node, 10000), key)); 
        assert $in_range_i4($op_mul(L#dst_node, 10000) + L#key);
        // assert @in_range_i4(*(dst_node, 10000)); 
        assert $in_range_i4($op_mul(L#dst_node, 10000));
        // *(ls->local_store)[+(*(dst_node, 10000), key)] := key; 
        call $write_int($field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key)), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key)), L#key);
        assume $full_stop_ext(#tok$1^828.3, $s);
        // assert @prim_writes_check((ls->size)); 
        assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.size));
        // *(ls->size) := unchecked+(*((ls->size)), 1); 
        call $write_int(LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores), $unchk_add(^^nat, $rd_inv($s, LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores)), 1));
        assume $full_stop_ext(#tok$1^829.11, $s);
        // _Bool ite#18; 
        // ite#18 := (_Bool)do_slop_write; 
        ite#18 := $int_to_bool(L#do_slop_write);
        assume true;
        // if (ite#18) ...
        if (ite#18)
        {
          anon157:
            // assert >=(*((hhs->size)), 0); 
            assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
            // assume >=(*((hhs->size)), 0); 
            assume $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
            // assert @reads_check_normal((hhs->size)); 
            assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
            assume true;
            // if (==(*((hhs->size)), 16777215)) ...
            if ($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == 16777215)
            {
              anon155:
                // _math \state prestate#217; 
                // prestate#217 := @_vcc_current_state(@state); 
                prestate#217 := $current_state($s);
                // _math \state staticWrapState#218; 
                // staticWrapState#218 := @_vcc_current_state(@state); 
                staticWrapState#218 := $current_state($s);
                // _math \objset owns#220; 
                // owns#220 := @_vcc_set_empty; 
                owns#220 := $set_empty();
                // assert @writes_check(hhs); 
                assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                // assume @_vcc_pre_static_wrap(@state); 
                assume $pre_static_wrap($s);
                // @_vcc_static_wrap(pure(hhs), staticWrapState#218, owns#220)
                call $static_wrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), staticWrapState#218, owns#220);
                assume $good_state_ext(#tok$1^833.7, $s);
                // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, hhs), @_vcc_set_empty)); 
                assert $set_eq($owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)), $set_empty());
                // assert @inv_check(<=(*((hhs->size)), 16777215)); 
                assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
                // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((hhs->size))), @map_get(*((hhs->hset)), *((hhs->hint_store)[i]))))); 
                assert (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))));
                // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), <(@map_get(*((hhs->idx)), h), *((hhs->size)))))); 
                assert (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
                // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), ==(*((hhs->hint_store)[@map_get(*((hhs->idx)), h)]), h)))); 
                assert (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412);
                // assert @inv_check(==>(&&(>=(*((hhs->tkey)), 0), <(*((hhs->tkey)), 10000)), ==(*((hhs->tcoord)), get_coord_for_key(*((hhs->tkey)))))); 
                assert $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 10000 ==> $rd_inv($s, HintedHandoffStores.tcoord, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == F#get_coord_for_key($rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
                // assume @_vcc_full_stop(@state); 
                assume $full_stop($s);
                // _math \state prestate#221; 
                // prestate#221 := @_vcc_current_state(@state); 
                prestate#221 := $current_state($s);
                // _math \state staticWrapState#222; 
                // staticWrapState#222 := @_vcc_current_state(@state); 
                staticWrapState#222 := $current_state($s);
                // _math \objset owns#224; 
                // owns#224 := @_vcc_set_empty; 
                owns#224 := $set_empty();
                // assert @writes_check(ls); 
                assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ls, ^LocalStores));
                // assume @_vcc_pre_static_wrap(@state); 
                assume $pre_static_wrap($s);
                // @_vcc_static_wrap(pure(ls), staticWrapState#222, owns#224)
                call $static_wrap($phys_ptr_cast(P#ls, ^LocalStores), staticWrapState#222, owns#224);
                assume $good_state_ext(#tok$1^834.7, $s);
                // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ls), @_vcc_set_empty)); 
                assert $set_eq($owns($s, $phys_ptr_cast(P#ls, ^LocalStores)), $set_empty());
                // assert @inv_check(<=(*((ls->len)), 100000000)); 
                assert $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores)) <= 100000000;
                // assert @inv_check(||(==(*((ls->tainted_key)), -1), &&(>=(*((ls->tainted_key)), 0), <(*((ls->tainted_key)), 10000)))); 
                assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) < 10000);
                // assume @_vcc_full_stop(@state); 
                assume $full_stop($s);
                // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
                assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
                // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
                assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
                // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
                assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
                // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
                assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
                // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
                assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
                // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
                assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^835.14#tc1#1448: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^835.14#tc1#1448) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^835.14#tc1#1448) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^835.14#tc1#1448) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^835.14#tc1#1448) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^835.14#tc1#1448) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^835.14#tc1#1448) } $in_range_i4(Q#i$1^835.14#tc1#1448) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^835.14#tc1#1448) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^835.14#tc1#1448) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^835.14#tc1#1448) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^835.14#tc1#1448) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^835.14#tc1#1448) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^835.14#tc1#1448));
                // assume ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
                assume $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^835.14#tc1#1460: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^835.14#tc1#1460) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^835.14#tc1#1460) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^835.14#tc1#1460) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^835.14#tc1#1460) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^835.14#tc1#1460) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^835.14#tc1#1460) } $in_range_i4(Q#i$1^835.14#tc1#1460) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^835.14#tc1#1460) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^835.14#tc1#1460) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^835.14#tc1#1460) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^835.14#tc1#1460) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^835.14#tc1#1460) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^835.14#tc1#1460));
                // assert @writes_check(ln); 
                assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ln, ^LiveNodes));
                // assert @writes_check(ls); 
                assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ls, ^LocalStores));
                // assert @writes_check(hhs); 
                assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                // assert @writes_check(ps); 
                assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ps, ^PendingSet));
                // stmt havoc_all(ln, ls, hhs, ps); 
                call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
                assume $full_stop_ext(#tok$1^836.5, $s);
                // return; 
                assume true;
                assert $position_marker();
                goto #exit;
            }
            else
            {
              anon156:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
            }

          anon158:
            // assert @prim_writes_check((hhs->hint_store)[*((hhs->size))]); 
            assert $writable_prim($s, #wrTime$1^751.1, $idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
            // assert @reads_check_normal((hhs->size)); 
            assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
            // *(hhs->hint_store)[*((hhs->size))] := last_hint; 
            call $write_int($field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))), L#last_hint);
            assume $full_stop_ext(#tok$1^839.4, $s);
            // (uint64_t -> _Bool) res_addone_hset#95; 
            // res_addone_hset#95 := addone_hset(*((hhs->hset)), last_hint); 
            call res_addone_hset#95 := addone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint);
            assume $full_stop_ext(#tok$1^840.24, $s);
            // assert @prim_writes_check((hhs->hset)); 
            assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hset));
            // *(hhs->hset) := res_addone_hset#95; 
            call $write_int(HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^u8.^^bool_to_int(res_addone_hset#95));
            assume $full_stop_ext(#tok$1^840.12, $s);
            // assert @prim_writes_check((hhs->idx)); 
            assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.idx));
            // *(hhs->idx) := @map_updated(*((hhs->idx)), last_hint, *((hhs->size))); 
            call $write_int(HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^u8.^^u8_to_int($store.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint, $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))));
            assume $full_stop_ext(#tok$1^841.12, $s);
            // assert @prim_writes_check((hhs->size)); 
            assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.size));
            // assert @in_range_u8(+(*((hhs->size)), 1)); 
            assert $in_range_u8($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1);
            // assert @reads_check_normal((hhs->size)); 
            assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
            // *(hhs->size) := +(*((hhs->size)), 1); 
            call $write_int(HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1);
            assume $full_stop_ext(#tok$1^842.4, $s);
        }
        else
        {
          anon159:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
        }
    }
    else
    {
      anon163:
        // assert @reads_check_normal((hhs->size)); 
        assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
        assume true;
        // if (==(*((hhs->size)), 16777215)) ...
        if ($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == 16777215)
        {
          anon161:
            // _math \state prestate#225; 
            // prestate#225 := @_vcc_current_state(@state); 
            prestate#225 := $current_state($s);
            // _math \state staticWrapState#226; 
            // staticWrapState#226 := @_vcc_current_state(@state); 
            staticWrapState#226 := $current_state($s);
            // _math \objset owns#228; 
            // owns#228 := @_vcc_set_empty; 
            owns#228 := $set_empty();
            // assert @writes_check(hhs); 
            assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
            // assume @_vcc_pre_static_wrap(@state); 
            assume $pre_static_wrap($s);
            // @_vcc_static_wrap(pure(hhs), staticWrapState#226, owns#228)
            call $static_wrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), staticWrapState#226, owns#228);
            assume $good_state_ext(#tok$1^846.6, $s);
            // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, hhs), @_vcc_set_empty)); 
            assert $set_eq($owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)), $set_empty());
            // assert @inv_check(<=(*((hhs->size)), 16777215)); 
            assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
            // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((hhs->size))), @map_get(*((hhs->hset)), *((hhs->hint_store)[i]))))); 
            assert (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))));
            // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), <(@map_get(*((hhs->idx)), h), *((hhs->size)))))); 
            assert (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
            // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), ==(*((hhs->hint_store)[@map_get(*((hhs->idx)), h)]), h)))); 
            assert (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412);
            // assert @inv_check(==>(&&(>=(*((hhs->tkey)), 0), <(*((hhs->tkey)), 10000)), ==(*((hhs->tcoord)), get_coord_for_key(*((hhs->tkey)))))); 
            assert $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 10000 ==> $rd_inv($s, HintedHandoffStores.tcoord, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == F#get_coord_for_key($rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
            // assume @_vcc_full_stop(@state); 
            assume $full_stop($s);
            // _math \state prestate#229; 
            // prestate#229 := @_vcc_current_state(@state); 
            prestate#229 := $current_state($s);
            // _math \state staticWrapState#230; 
            // staticWrapState#230 := @_vcc_current_state(@state); 
            staticWrapState#230 := $current_state($s);
            // _math \objset owns#232; 
            // owns#232 := @_vcc_set_empty; 
            owns#232 := $set_empty();
            // assert @writes_check(ls); 
            assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ls, ^LocalStores));
            // assume @_vcc_pre_static_wrap(@state); 
            assume $pre_static_wrap($s);
            // @_vcc_static_wrap(pure(ls), staticWrapState#230, owns#232)
            call $static_wrap($phys_ptr_cast(P#ls, ^LocalStores), staticWrapState#230, owns#232);
            assume $good_state_ext(#tok$1^847.6, $s);
            // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ls), @_vcc_set_empty)); 
            assert $set_eq($owns($s, $phys_ptr_cast(P#ls, ^LocalStores)), $set_empty());
            // assert @inv_check(<=(*((ls->len)), 100000000)); 
            assert $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores)) <= 100000000;
            // assert @inv_check(||(==(*((ls->tainted_key)), -1), &&(>=(*((ls->tainted_key)), 0), <(*((ls->tainted_key)), 10000)))); 
            assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) < 10000);
            // assume @_vcc_full_stop(@state); 
            assume $full_stop($s);
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
            // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
            assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^848.13#tc1#1449: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^848.13#tc1#1449) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^848.13#tc1#1449) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^848.13#tc1#1449) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^848.13#tc1#1449) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^848.13#tc1#1449) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^848.13#tc1#1449) } $in_range_i4(Q#i$1^848.13#tc1#1449) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^848.13#tc1#1449) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^848.13#tc1#1449) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^848.13#tc1#1449) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^848.13#tc1#1449) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^848.13#tc1#1449) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^848.13#tc1#1449));
            // assume ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
            assume $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^848.13#tc1#1461: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^848.13#tc1#1461) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^848.13#tc1#1461) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^848.13#tc1#1461) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^848.13#tc1#1461) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^848.13#tc1#1461) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^848.13#tc1#1461) } $in_range_i4(Q#i$1^848.13#tc1#1461) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^848.13#tc1#1461) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^848.13#tc1#1461) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^848.13#tc1#1461) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^848.13#tc1#1461) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^848.13#tc1#1461) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^848.13#tc1#1461));
            // assert @writes_check(ln); 
            assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ln, ^LiveNodes));
            // assert @writes_check(ls); 
            assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ls, ^LocalStores));
            // assert @writes_check(hhs); 
            assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
            // assert @writes_check(ps); 
            assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ps, ^PendingSet));
            // stmt havoc_all(ln, ls, hhs, ps); 
            call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
            assume $full_stop_ext(#tok$1^849.4, $s);
            // return; 
            assume true;
            assert $position_marker();
            goto #exit;
        }
        else
        {
          anon162:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
        }

      anon164:
        // assert @prim_writes_check((hhs->hint_store)[*((hhs->size))]); 
        assert $writable_prim($s, #wrTime$1^751.1, $idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
        // assert @reads_check_normal((hhs->size)); 
        assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
        // *(hhs->hint_store)[*((hhs->size))] := last_hint; 
        call $write_int($field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))), L#last_hint);
        assume $full_stop_ext(#tok$1^852.3, $s);
        // (uint64_t -> _Bool) res_addone_hset#96; 
        // res_addone_hset#96 := addone_hset(*((hhs->hset)), last_hint); 
        call res_addone_hset#96 := addone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint);
        assume $full_stop_ext(#tok$1^853.23, $s);
        // assert @prim_writes_check((hhs->hset)); 
        assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hset));
        // *(hhs->hset) := res_addone_hset#96; 
        call $write_int(HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^u8.^^bool_to_int(res_addone_hset#96));
        assume $full_stop_ext(#tok$1^853.11, $s);
        // assert @prim_writes_check((hhs->idx)); 
        assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.idx));
        // *(hhs->idx) := @map_updated(*((hhs->idx)), last_hint, *((hhs->size))); 
        call $write_int(HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^u8.^^u8_to_int($store.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint, $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)))));
        assume $full_stop_ext(#tok$1^854.11, $s);
        // assert @prim_writes_check((hhs->size)); 
        assert $writable_prim($s, #wrTime$1^751.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.size));
        // assert @in_range_u8(+(*((hhs->size)), 1)); 
        assert $in_range_u8($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1);
        // assert @reads_check_normal((hhs->size)); 
        assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
        // *(hhs->size) := +(*((hhs->size)), 1); 
        call $write_int(HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1);
        assume $full_stop_ext(#tok$1^855.3, $s);
    }

  anon170:
    // _math \state prestate#233; 
    // prestate#233 := @_vcc_current_state(@state); 
    prestate#233 := $current_state($s);
    // _math \state staticWrapState#234; 
    // staticWrapState#234 := @_vcc_current_state(@state); 
    staticWrapState#234 := $current_state($s);
    // _math \objset owns#236; 
    // owns#236 := @_vcc_set_empty; 
    owns#236 := $set_empty();
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(hhs), staticWrapState#234, owns#236)
    call $static_wrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), staticWrapState#234, owns#236);
    assume $good_state_ext(#tok$1^858.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, hhs), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)), $set_empty());
    // assert @inv_check(<=(*((hhs->size)), 16777215)); 
    assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
    // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((hhs->size))), @map_get(*((hhs->hset)), *((hhs->hint_store)[i]))))); 
    assert (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), <(@map_get(*((hhs->idx)), h), *((hhs->size)))))); 
    assert (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), ==(*((hhs->hint_store)[@map_get(*((hhs->idx)), h)]), h)))); 
    assert (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412);
    // assert @inv_check(==>(&&(>=(*((hhs->tkey)), 0), <(*((hhs->tkey)), 10000)), ==(*((hhs->tcoord)), get_coord_for_key(*((hhs->tkey)))))); 
    assert $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 10000 ==> $rd_inv($s, HintedHandoffStores.tcoord, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == F#get_coord_for_key($rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _math \state prestate#237; 
    // prestate#237 := @_vcc_current_state(@state); 
    prestate#237 := $current_state($s);
    // _math \state staticWrapState#238; 
    // staticWrapState#238 := @_vcc_current_state(@state); 
    staticWrapState#238 := $current_state($s);
    // _math \objset owns#240; 
    // owns#240 := @_vcc_set_empty; 
    owns#240 := $set_empty();
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ls), staticWrapState#238, owns#240)
    call $static_wrap($phys_ptr_cast(P#ls, ^LocalStores), staticWrapState#238, owns#240);
    assume $good_state_ext(#tok$1^859.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ls), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ls, ^LocalStores)), $set_empty());
    // assert @inv_check(<=(*((ls->len)), 100000000)); 
    assert $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores)) <= 100000000;
    // assert @inv_check(||(==(*((ls->tainted_key)), -1), &&(>=(*((ls->tainted_key)), 0), <(*((ls->tainted_key)), 10000)))); 
    assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) < 10000);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^860.11#tc1#1450: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^860.11#tc1#1450) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^860.11#tc1#1450) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^860.11#tc1#1450) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^860.11#tc1#1450) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^860.11#tc1#1450) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^860.11#tc1#1450) } $in_range_i4(Q#i$1^860.11#tc1#1450) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^860.11#tc1#1450) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^860.11#tc1#1450) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^860.11#tc1#1450) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^860.11#tc1#1450) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^860.11#tc1#1450) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^860.11#tc1#1450));
    // assume ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
    assume $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^860.11#tc1#1462: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^860.11#tc1#1462) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^860.11#tc1#1462) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^860.11#tc1#1462) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^860.11#tc1#1462) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^860.11#tc1#1462) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^860.11#tc1#1462) } $in_range_i4(Q#i$1^860.11#tc1#1462) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^860.11#tc1#1462) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^860.11#tc1#1462) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^860.11#tc1#1462) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^860.11#tc1#1462) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^860.11#tc1#1462) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^860.11#tc1#1462));
    // assert @writes_check(ln); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ln, ^LiveNodes));
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^751.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // stmt havoc_all(ln, ls, hhs, ps); 
    call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
    assume $full_stop_ext(#tok$1^861.2, $s);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure handoff_hint_conc(P#tainted_key: int, P#tainted_coord: int, P#ln: $ptr, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr);
  requires $non_null($phys_ptr_cast(P#pl, ^PreferenceLists));
  requires $non_null($phys_ptr_cast(P#ls, ^LocalStores));
  requires $non_null($phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  requires $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
  requires P#tainted_key >= 0;
  requires P#tainted_key < 10000;
  requires P#tainted_key != -1 ==> P#tainted_coord == F#get_coord_for_key(P#tainted_key);
  free requires -1 == $unchk_sub(^^i4, 0, 1);
  requires (forall Q#j$1^871.15#tc1#1433: int :: {:weight 10} { $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1433 } $in_range_i4(Q#j$1^871.15#tc1#1433) ==> Q#j$1^871.15#tc1#1433 >= 0 && Q#j$1^871.15#tc1#1433 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1433)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1433)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1433)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1433)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1433)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1433)))));
  requires $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  requires $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  requires $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  requires $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  requires $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  modifies $s, $cev_pc;
  free ensures -1 == $unchk_sub(^^i4, 0, 1);
  ensures (forall Q#j$1^871.15#tc1#1434: int :: {:weight 10} { $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1434 } $in_range_i4(Q#j$1^871.15#tc1#1434) ==> Q#j$1^871.15#tc1#1434 >= 0 && Q#j$1^871.15#tc1#1434 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1434)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1434)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1434)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1434)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1434)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^871.15#tc1#1434)))));
  ensures $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes) && $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists) && $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores) && $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores) && $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
  free ensures $call_transition(old($s), $s);



implementation handoff_hint_conc(P#tainted_key: int, P#tainted_coord: int, P#ln: $ptr, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr)
{
  var owns#258: $ptrset;
  var staticWrapState#256: $state;
  var prestate#255: $state;
  var owns#254: $ptrset;
  var staticWrapState#252: $state;
  var prestate#251: $state;
  var res_lambda#54#99: $map_t..^^u8.^^bool;
  var h#41: int where $in_range_u8(h#41);
  var res_addone_iset#98: $map_t..^^i4.^^bool;
  var res_delone_iset#97: $map_t..^^i4.^^bool;
  var ite#19: bool;
  var prestate#250: $state;
  var prestate#248: $state;
  var owns#249: $ptrset;
  var owns#247: $ptrset;
  var staticWrapState#245: $state;
  var prestate#244: $state;
  var prestate#243: $state;
  var prestate#241: $state;
  var owns#242: $ptrset;
  var L#x: int where $in_range_i4(L#x);
  var SL#s0: $state;
  var L#last_hint: int where $in_range_u8(L#last_hint);
  var L#dst_node: int where $in_range_i4(L#dst_node);
  var L#key: int where $in_range_i4(L#key);
  var #wrTime$1^866.1: int;
  var #stackframe: int;

  anon182:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^866.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^866.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^866.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
    assume $thread_owned($s, $phys_ptr_cast(P#ln, ^LiveNodes));
    assume $thread_owned($s, $phys_ptr_cast(P#ls, ^LocalStores));
    assume $thread_owned($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    assume $thread_owned($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume @in_range_i4(tainted_key); 
    assume $in_range_i4(P#tainted_key);
    // assume @in_range_i4(tainted_coord); 
    assume $in_range_i4(P#tainted_coord);
    // assume true
    // assume true
    // assume true
    // assume true
    // assume true
    // assume @decreases_level_is(2); 
    assume 2 == $decreases_level;
    // assert @_vcc_in_domain(@state, ps, ps); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ps, ^PendingSet), $phys_ptr_cast(P#ps, ^PendingSet), l#public);
    // assert @_vcc_in_domain(@state, hhs, hhs); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), l#public);
    // assert @_vcc_in_domain(@state, ls, ls); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ls, ^LocalStores), l#public);
    // assert @_vcc_in_domain(@state, pl, pl); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#pl, ^PreferenceLists), l#public);
    // assert @_vcc_in_domain(@state, ln, ln); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ln, ^LiveNodes), l#public);
    // assume ==(18446744073709551615, @unchecked_u8((uint64_t)unchecked-(0, 1))); 
    assume 18446744073709551615 == $unchecked(^^u8, $unchk_sub(^^i4, 0, 1));
    // assume ==(3199, unchecked-(3200, 1)); 
    assume 3199 == $unchk_sub(^^i4, 3200, 1);
    // assume true
    // int32_t key; 
    // int32_t dst_node; 
    // uint64_t last_hint; 
    // _math \state s0; 
    // int32_t x; 
    // assert ==(tainted_coord, get_coord_for_key(tainted_key)); 
    assert P#tainted_coord == F#get_coord_for_key(P#tainted_key);
    // assume ==(tainted_coord, get_coord_for_key(tainted_key)); 
    assume P#tainted_coord == F#get_coord_for_key(P#tainted_key);
    // assert @in_range_i4(*(tainted_coord, 3200)); 
    assert $in_range_i4($op_mul(P#tainted_coord, 3200));
    // x := *(tainted_coord, 3200); 
    L#x := $op_mul(P#tainted_coord, 3200);
    // assert @writes_check(ln); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#ln, ^LiveNodes));
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // stmt havoc_all(ln, ls, hhs, ps); 
    call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
    assume $full_stop_ext(#tok$1^884.2, $s);
    // s0 := @_vcc_current_state(@state); 
    SL#s0 := $current_state($s);
    // _math \objset owns#242; 
    // owns#242 := @_vcc_set_empty; 
    owns#242 := $set_empty();
    // _math \state prestate#241; 
    // prestate#241 := @_vcc_current_state(@state); 
    prestate#241 := $current_state($s);
    // _math \state prestate#243; 
    // prestate#243 := @_vcc_current_state(@state); 
    prestate#243 := $current_state($s);
    // assert @_vcc_wrapped(@state, hhs); 
    assert $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // prestate#243 := pure(@_vcc_start_release(prestate#243, prestate#243)); 
    prestate#243 := $start_release(prestate#243, prestate#243);
    // assume @_vcc_inv(@state, hhs); 
    assume $inv($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
    // assume ==(owns#242, @_vcc_owns(@state, hhs)); 
    assume owns#242 == $owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(hhs), prestate#243)
    call $static_unwrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), prestate#243);
    assume $good_state_ext(#tok$1^886.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // assert @reads_check_normal((hhs->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    assume true;
    // if (==(*((hhs->size)), 0)) ...
    if ($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == 0)
    {
      anon171:
        // _math \state prestate#244; 
        // prestate#244 := @_vcc_current_state(@state); 
        prestate#244 := $current_state($s);
        // _math \state staticWrapState#245; 
        // staticWrapState#245 := @_vcc_current_state(@state); 
        staticWrapState#245 := $current_state($s);
        // _math \objset owns#247; 
        // owns#247 := @_vcc_set_empty; 
        owns#247 := $set_empty();
        // assert @writes_check(hhs); 
        assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
        // assume @_vcc_pre_static_wrap(@state); 
        assume $pre_static_wrap($s);
        // @_vcc_static_wrap(pure(hhs), staticWrapState#245, owns#247)
        call $static_wrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), staticWrapState#245, owns#247);
        assume $good_state_ext(#tok$1^889.5, $s);
        // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, hhs), @_vcc_set_empty)); 
        assert $set_eq($owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)), $set_empty());
        // assert @inv_check(<=(*((hhs->size)), 16777215)); 
        assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
        // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((hhs->size))), @map_get(*((hhs->hset)), *((hhs->hint_store)[i]))))); 
        assert (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))));
        // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), <(@map_get(*((hhs->idx)), h), *((hhs->size)))))); 
        assert (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
        // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), ==(*((hhs->hint_store)[@map_get(*((hhs->idx)), h)]), h)))); 
        assert (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412);
        // assert @inv_check(==>(&&(>=(*((hhs->tkey)), 0), <(*((hhs->tkey)), 10000)), ==(*((hhs->tcoord)), get_coord_for_key(*((hhs->tkey)))))); 
        assert $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 10000 ==> $rd_inv($s, HintedHandoffStores.tcoord, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == F#get_coord_for_key($rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
        // assume @_vcc_full_stop(@state); 
        assume $full_stop($s);
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
        // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
        assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^890.12#tc1#1451: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^890.12#tc1#1451) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^890.12#tc1#1451) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^890.12#tc1#1451) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^890.12#tc1#1451) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^890.12#tc1#1451) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^890.12#tc1#1451) } $in_range_i4(Q#i$1^890.12#tc1#1451) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^890.12#tc1#1451) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^890.12#tc1#1451) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^890.12#tc1#1451) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^890.12#tc1#1451) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^890.12#tc1#1451) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^890.12#tc1#1451));
        // assume ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
        assume $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^890.12#tc1#1463: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^890.12#tc1#1463) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^890.12#tc1#1463) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^890.12#tc1#1463) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^890.12#tc1#1463) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^890.12#tc1#1463) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^890.12#tc1#1463) } $in_range_i4(Q#i$1^890.12#tc1#1463) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^890.12#tc1#1463) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^890.12#tc1#1463) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^890.12#tc1#1463) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^890.12#tc1#1463) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^890.12#tc1#1463) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^890.12#tc1#1463));
        // assert @writes_check(ln); 
        assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#ln, ^LiveNodes));
        // assert @writes_check(ls); 
        assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#ls, ^LocalStores));
        // assert @writes_check(hhs); 
        assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
        // assert @writes_check(ps); 
        assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#ps, ^PendingSet));
        // stmt havoc_all(ln, ls, hhs, ps); 
        call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
        assume $full_stop_ext(#tok$1^891.3, $s);
        // return; 
        assume true;
        assert $position_marker();
        goto #exit;
    }
    else
    {
      anon172:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon183:
    // assert @reads_check_normal((hhs->hint_store)[-(*((hhs->size)), 1)]); 
    assert $thread_local($s, $idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1));
    // assert @in_range_u8(-(*((hhs->size)), 1)); 
    assert $in_range_u8($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1);
    // assert @reads_check_normal((hhs->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // last_hint := *((hhs->hint_store)[-(*((hhs->size)), 1)]); 
    L#last_hint := $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1)));
    // dst_node := get_dst(last_hint); 
    call L#dst_node := get_dst(L#last_hint);
    assume $full_stop_ext(#tok$1^896.17, $s);
    // key := get_key(last_hint); 
    call L#key := get_key(L#last_hint);
    assume $full_stop_ext(#tok$1^897.12, $s);
    // _math \objset owns#249; 
    // owns#249 := @_vcc_set_empty; 
    owns#249 := $set_empty();
    // _math \state prestate#248; 
    // prestate#248 := @_vcc_current_state(@state); 
    prestate#248 := $current_state($s);
    // _math \state prestate#250; 
    // prestate#250 := @_vcc_current_state(@state); 
    prestate#250 := $current_state($s);
    // assert @_vcc_wrapped(@state, ls); 
    assert $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // prestate#250 := pure(@_vcc_start_release(prestate#250, prestate#250)); 
    prestate#250 := $start_release(prestate#250, prestate#250);
    // assume @_vcc_inv(@state, ls); 
    assume $inv($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
    // assume ==(owns#249, @_vcc_owns(@state, ls)); 
    assume owns#249 == $owns($s, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(ls), prestate#250)
    call $static_unwrap($phys_ptr_cast(P#ls, ^LocalStores), prestate#250);
    assume $good_state_ext(#tok$1^899.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _Bool ite#19; 
    assume true;
    // if (>=(dst_node, *((pl->preference_list)[x]))) ...
    if (L#dst_node >= $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x))))
    {
      anon173:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
        // assert @in_range_i4(+(x, 3199)); 
        assert $in_range_i4(L#x + 3199);
        // ite#19 := <=(dst_node, *((pl->preference_list)[+(x, 3199)])); 
        ite#19 := L#dst_node <= $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x + 3199)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x + 3199)));
    }
    else
    {
      anon174:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
        // ite#19 := false; 
        ite#19 := false;
    }

  anon184:
    assume true;
    // if (ite#19) ...
    if (ite#19)
    {
      anon175:
        // (int32_t -> _Bool) res_delone_iset#97; 
        // res_delone_iset#97 := delone_iset(*((hhs->tainted_nodes)), dst_node); 
        call res_delone_iset#97 := delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#dst_node);
        assume $full_stop_ext(#tok$1^903.24, $s);
        // assert @prim_writes_check((hhs->tainted_nodes)); 
        assert $writable_prim($s, #wrTime$1^866.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.tainted_nodes));
        // *(hhs->tainted_nodes) := res_delone_iset#97; 
        call $write_int(HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^i4.^^bool_to_int(res_delone_iset#97));
        assume $full_stop_ext(#tok$1^903.3, $s);
        // (int32_t -> _Bool) res_addone_iset#98; 
        // res_addone_iset#98 := addone_iset(*((ls->tainted_nodes)), dst_node); 
        call res_addone_iset#98 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node);
        assume $full_stop_ext(#tok$1^905.24, $s);
        // assert @prim_writes_check((ls->tainted_nodes)); 
        assert $writable_prim($s, #wrTime$1^866.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.tainted_nodes));
        // *(ls->tainted_nodes) := res_addone_iset#98; 
        call $write_int(LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores), $map_t..^^i4.^^bool_to_int(res_addone_iset#98));
        assume $full_stop_ext(#tok$1^905.3, $s);
    }
    else
    {
      anon176:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon185:
    assume true;
    // if (@check_termination(42)) ...
    if ($check_termination(42))
    {
      anon179:
        // uint64_t h#41; 
        assume true;
        // if (==(h#41, last_hint)) ...
        if (h#41 == L#last_hint)
        {
          anon177:
            // skip
        }
        else
        {
          anon178:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
        }

      anon180:
        // assume false; 
        assume false;
    }
    else
    {
      anon181:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon186:
    // (uint64_t -> _Bool) res_lambda#54#99; 
    // res_lambda#54#99 := lambda#54(*((hhs->hset)), last_hint); 
    call res_lambda#54#99 := lambda#54($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint);
    assume $full_stop_ext(#tok$1^907.22, $s);
    // assert @prim_writes_check((hhs->hset)); 
    assert $writable_prim($s, #wrTime$1^866.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hset));
    // *(hhs->hset) := res_lambda#54#99; 
    call $write_int(HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^u8.^^bool_to_int(res_lambda#54#99));
    assume $full_stop_ext(#tok$1^907.10, $s);
    // assert @map_eq(addone_hset(delone_hset(*((hhs->hset)), last_hint), last_hint), *((hhs->hset))); 
    assert $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
    // assume @map_eq(addone_hset(delone_hset(*((hhs->hset)), last_hint), last_hint), *((hhs->hset))); 
    assume $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
    // assert @map_eq(addone_iset(delone_iset(*((ls->tainted_nodes)), dst_node), dst_node), *((ls->tainted_nodes))); 
    assert $eq.$map_t..^^i4.^^bool(F#addone_iset(F#delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node), L#dst_node), $int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))));
    // assume @map_eq(addone_iset(delone_iset(*((ls->tainted_nodes)), dst_node), dst_node), *((ls->tainted_nodes))); 
    assume $eq.$map_t..^^i4.^^bool(F#addone_iset(F#delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node), L#dst_node), $int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))));
    // assert @prim_writes_check((hhs->hint_store)[-(*((hhs->size)), 1)]); 
    assert $writable_prim($s, #wrTime$1^866.1, $idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1));
    // assert @in_range_u8(-(*((hhs->size)), 1)); 
    assert $in_range_u8($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1);
    // assert @reads_check_normal((hhs->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // *(hhs->hint_store)[-(*((hhs->size)), 1)] := 18446744073709551615; 
    call $write_int($field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1)), 18446744073709551615);
    assume $full_stop_ext(#tok$1^912.2, $s);
    // assert @prim_writes_check((hhs->size)); 
    assert $writable_prim($s, #wrTime$1^866.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.size));
    // assert @in_range_u8(-(*((hhs->size)), 1)); 
    assert $in_range_u8($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1);
    // assert @reads_check_normal((hhs->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // *(hhs->size) := -(*((hhs->size)), 1); 
    call $write_int(HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1);
    assume $full_stop_ext(#tok$1^913.2, $s);
    // assert @prim_writes_check((ls->local_store)[+(*(dst_node, 10000), key)]); 
    assert $writable_prim($s, #wrTime$1^866.1, $idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key));
    // assert @in_range_i4(+(*(dst_node, 10000), key)); 
    assert $in_range_i4($op_mul(L#dst_node, 10000) + L#key);
    // assert @in_range_i4(*(dst_node, 10000)); 
    assert $in_range_i4($op_mul(L#dst_node, 10000));
    // *(ls->local_store)[+(*(dst_node, 10000), key)] := key; 
    call $write_int($field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key)), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key)), L#key);
    assume $full_stop_ext(#tok$1^916.2, $s);
    // assert @prim_writes_check((ls->size)); 
    assert $writable_prim($s, #wrTime$1^866.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.size));
    // *(ls->size) := unchecked+(*((ls->size)), 1); 
    call $write_int(LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores), $unchk_add(^^nat, $rd_inv($s, LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores)), 1));
    assume $full_stop_ext(#tok$1^917.10, $s);
    // _math \state prestate#251; 
    // prestate#251 := @_vcc_current_state(@state); 
    prestate#251 := $current_state($s);
    // _math \state staticWrapState#252; 
    // staticWrapState#252 := @_vcc_current_state(@state); 
    staticWrapState#252 := $current_state($s);
    // _math \objset owns#254; 
    // owns#254 := @_vcc_set_empty; 
    owns#254 := $set_empty();
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(hhs), staticWrapState#252, owns#254)
    call $static_wrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), staticWrapState#252, owns#254);
    assume $good_state_ext(#tok$1^918.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, hhs), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)), $set_empty());
    // assert @inv_check(<=(*((hhs->size)), 16777215)); 
    assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
    // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((hhs->size))), @map_get(*((hhs->hset)), *((hhs->hint_store)[i]))))); 
    assert (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), <(@map_get(*((hhs->idx)), h), *((hhs->size)))))); 
    assert (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), ==(*((hhs->hint_store)[@map_get(*((hhs->idx)), h)]), h)))); 
    assert (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412);
    // assert @inv_check(==>(&&(>=(*((hhs->tkey)), 0), <(*((hhs->tkey)), 10000)), ==(*((hhs->tcoord)), get_coord_for_key(*((hhs->tkey)))))); 
    assert $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 10000 ==> $rd_inv($s, HintedHandoffStores.tcoord, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == F#get_coord_for_key($rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _math \state prestate#255; 
    // prestate#255 := @_vcc_current_state(@state); 
    prestate#255 := $current_state($s);
    // _math \state staticWrapState#256; 
    // staticWrapState#256 := @_vcc_current_state(@state); 
    staticWrapState#256 := $current_state($s);
    // _math \objset owns#258; 
    // owns#258 := @_vcc_set_empty; 
    owns#258 := $set_empty();
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ls), staticWrapState#256, owns#258)
    call $static_wrap($phys_ptr_cast(P#ls, ^LocalStores), staticWrapState#256, owns#258);
    assume $good_state_ext(#tok$1^919.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ls), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ls, ^LocalStores)), $set_empty());
    // assert @inv_check(<=(*((ls->len)), 100000000)); 
    assert $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores)) <= 100000000;
    // assert @inv_check(||(==(*((ls->tainted_key)), -1), &&(>=(*((ls->tainted_key)), 0), <(*((ls->tainted_key)), 10000)))); 
    assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) < 10000);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), !=(*((ps->tkey)), -1)))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1;
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((hhs->size)), 0)))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((hhs->size)), 16777215)))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), >=(*((ps->size)), 0)))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), <=(*((ps->size)), 16777215)))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
    // assert ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i))))))); 
    assert $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> (forall Q#i$1^920.11#tc1#1452: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^920.11#tc1#1452) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^920.11#tc1#1452) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^920.11#tc1#1452) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^920.11#tc1#1452) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^920.11#tc1#1452) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^920.11#tc1#1452) } $in_range_i4(Q#i$1^920.11#tc1#1452) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^920.11#tc1#1452) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^920.11#tc1#1452) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^920.11#tc1#1452) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^920.11#tc1#1452) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^920.11#tc1#1452) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^920.11#tc1#1452));
    // assume ==>(!=(old(s0, *((ls->tainted_key))), -1), ==>(&&(!=(*((ls->tainted_key)), -1), !=(old(s0, *((hhs->tkey))), -1)), ==>(&&(!=(*((hhs->tkey)), -1), !=(old(s0, *((ps->tkey))), -1)), &&(&&(&&(&&(&&(!=(*((ps->tkey)), -1), >=(*((hhs->size)), 0)), <=(*((hhs->size)), 16777215)), >=(*((ps->size)), 0)), <=(*((ps->size)), 16777215)), forall(int32_t i; @in_range_i4(i); ==>(||(||(old(s0, @map_get(*((ls->tainted_nodes)), i)), old(s0, @map_get(*((hhs->tainted_nodes)), i))), old(s0, @map_get(*((ps->tainted_nodes)), i))), ||(||(@map_get(*((ls->tainted_nodes)), i), @map_get(*((hhs->tainted_nodes)), i)), @map_get(*((ps->tainted_nodes)), i)))))))); 
    assume $rd_inv(SL#s0, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 ==> $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) != -1 && $rd_inv(SL#s0, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 ==> $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) != -1 && $rd_inv(SL#s0, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 ==> $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) != -1 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0 && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215 && (forall Q#i$1^920.11#tc1#1464: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^920.11#tc1#1464) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^920.11#tc1#1464) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^920.11#tc1#1464) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^920.11#tc1#1464) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^920.11#tc1#1464) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^920.11#tc1#1464) } $in_range_i4(Q#i$1^920.11#tc1#1464) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^920.11#tc1#1464) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^920.11#tc1#1464) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(SL#s0, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^920.11#tc1#1464) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), Q#i$1^920.11#tc1#1464) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^920.11#tc1#1464) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^920.11#tc1#1464));
    // assert @writes_check(ln); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#ln, ^LiveNodes));
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^866.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // stmt havoc_all(ln, ls, hhs, ps); 
    call havoc_all($phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
    assume $full_stop_ext(#tok$1^921.2, $s);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure handoff_hint_seq(P#tainted_key: int, P#tainted_coord: int, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr);
  requires $non_null($phys_ptr_cast(P#pl, ^PreferenceLists));
  requires $non_null($phys_ptr_cast(P#ls, ^LocalStores));
  requires $non_null($phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  requires $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) > 0;
  requires P#tainted_key >= 0;
  requires P#tainted_key < 10000;
  requires P#tainted_key != -1 ==> P#tainted_coord == F#get_coord_for_key(P#tainted_key);
  free requires -1 == $unchk_sub(^^i4, 0, 1);
  requires (forall Q#j$1^929.15#tc1#1435: int :: {:weight 10} { $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1435 } $in_range_i4(Q#j$1^929.15#tc1#1435) ==> Q#j$1^929.15#tc1#1435 >= 0 && Q#j$1^929.15#tc1#1435 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1435)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1435)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1435)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1435)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1435)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1435)))));
  requires $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  requires $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  requires $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  requires $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  modifies $s, $cev_pc;
  ensures $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < $rd_inv(old($s), HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  ensures $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == $rd_inv(old($s), PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
  free ensures -1 == $unchk_sub(^^i4, 0, 1);
  ensures (forall Q#j$1^929.15#tc1#1436: int :: {:weight 10} { $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1436 } $in_range_i4(Q#j$1^929.15#tc1#1436) ==> Q#j$1^929.15#tc1#1436 >= 0 && Q#j$1^929.15#tc1#1436 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1436)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1436)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1436)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1436)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1436)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#tainted_coord, 3200) + Q#j$1^929.15#tc1#1436)))));
  ensures $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  ensures $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  ensures $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  ensures $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ls, ^LocalStores)));
  free ensures $call_transition(old($s), $s);



implementation handoff_hint_seq(P#tainted_key: int, P#tainted_coord: int, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr)
{
  var owns#272: $ptrset;
  var staticWrapState#270: $state;
  var prestate#269: $state;
  var owns#268: $ptrset;
  var staticWrapState#266: $state;
  var prestate#265: $state;
  var res_lambda#55#102: $map_t..^^u8.^^bool;
  var h#43: int where $in_range_u8(h#43);
  var res_addone_iset#101: $map_t..^^i4.^^bool;
  var res_delone_iset#100: $map_t..^^i4.^^bool;
  var ite#20: bool;
  var prestate#264: $state;
  var prestate#262: $state;
  var owns#263: $ptrset;
  var prestate#261: $state;
  var prestate#259: $state;
  var owns#260: $ptrset;
  var L#x: int where $in_range_i4(L#x);
  var L#last_hint: int where $in_range_u8(L#last_hint);
  var L#dst_node: int where $in_range_i4(L#dst_node);
  var L#key: int where $in_range_i4(L#key);
  var thisDecr#313: int where $in_range_u8(thisDecr#313);
  var #wrTime$1^924.1: int;
  var #stackframe: int;

  anon196:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^924.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^924.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^924.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ls, ^LocalStores)));
    assume $thread_owned($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    assume $thread_owned($s, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @in_range_i4(tainted_key); 
    assume $in_range_i4(P#tainted_key);
    // assume @in_range_i4(tainted_coord); 
    assume $in_range_i4(P#tainted_coord);
    // assume true
    // assume true
    // assume true
    // assume true
    // uint64_t thisDecr#313; 
    // thisDecr#313 := *((hhs->size)); 
    thisDecr#313 := $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @decreases_level_is(2); 
    assume 2 == $decreases_level;
    // assert @_vcc_in_domain(@state, ps, ps); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ps, ^PendingSet), $phys_ptr_cast(P#ps, ^PendingSet), l#public);
    // assert @_vcc_in_domain(@state, pl, pl); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#pl, ^PreferenceLists), l#public);
    // assert @_vcc_in_domain(@state, ls, ls); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ls, ^LocalStores), l#public);
    // assert @_vcc_in_domain(@state, hhs, hhs); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), l#public);
    // assume ==(18446744073709551615, @unchecked_u8((uint64_t)unchecked-(0, 1))); 
    assume 18446744073709551615 == $unchecked(^^u8, $unchk_sub(^^i4, 0, 1));
    // assume ==(3199, unchecked-(3200, 1)); 
    assume 3199 == $unchk_sub(^^i4, 3200, 1);
    // assume true
    // int32_t key; 
    // int32_t dst_node; 
    // uint64_t last_hint; 
    // int32_t x; 
    // assert ==(tainted_coord, get_coord_for_key(tainted_key)); 
    assert P#tainted_coord == F#get_coord_for_key(P#tainted_key);
    // assume ==(tainted_coord, get_coord_for_key(tainted_key)); 
    assume P#tainted_coord == F#get_coord_for_key(P#tainted_key);
    // assert @in_range_i4(*(tainted_coord, 3200)); 
    assert $in_range_i4($op_mul(P#tainted_coord, 3200));
    // x := *(tainted_coord, 3200); 
    L#x := $op_mul(P#tainted_coord, 3200);
    // assert @reads_check_normal((hhs->hint_store)[-(*((hhs->size)), 1)]); 
    assert $thread_local($s, $idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1));
    // assert @in_range_u8(-(*((hhs->size)), 1)); 
    assert $in_range_u8($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1);
    // assert @reads_check_normal((hhs->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // last_hint := *((hhs->hint_store)[-(*((hhs->size)), 1)]); 
    L#last_hint := $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1)));
    // dst_node := get_dst(last_hint); 
    call L#dst_node := get_dst(L#last_hint);
    assume $full_stop_ext(#tok$1^948.17, $s);
    // key := get_key(last_hint); 
    call L#key := get_key(L#last_hint);
    assume $full_stop_ext(#tok$1^949.12, $s);
    // _math \objset owns#260; 
    // owns#260 := @_vcc_set_empty; 
    owns#260 := $set_empty();
    // _math \state prestate#259; 
    // prestate#259 := @_vcc_current_state(@state); 
    prestate#259 := $current_state($s);
    // _math \state prestate#261; 
    // prestate#261 := @_vcc_current_state(@state); 
    prestate#261 := $current_state($s);
    // assert @_vcc_wrapped(@state, hhs); 
    assert $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^924.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // prestate#261 := pure(@_vcc_start_release(prestate#261, prestate#261)); 
    prestate#261 := $start_release(prestate#261, prestate#261);
    // assume @_vcc_inv(@state, hhs); 
    assume $inv($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
    // assume ==(owns#260, @_vcc_owns(@state, hhs)); 
    assume owns#260 == $owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(hhs), prestate#261)
    call $static_unwrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), prestate#261);
    assume $good_state_ext(#tok$1^951.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _math \objset owns#263; 
    // owns#263 := @_vcc_set_empty; 
    owns#263 := $set_empty();
    // _math \state prestate#262; 
    // prestate#262 := @_vcc_current_state(@state); 
    prestate#262 := $current_state($s);
    // _math \state prestate#264; 
    // prestate#264 := @_vcc_current_state(@state); 
    prestate#264 := $current_state($s);
    // assert @_vcc_wrapped(@state, ls); 
    assert $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^924.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // prestate#264 := pure(@_vcc_start_release(prestate#264, prestate#264)); 
    prestate#264 := $start_release(prestate#264, prestate#264);
    // assume @_vcc_inv(@state, ls); 
    assume $inv($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
    // assume ==(owns#263, @_vcc_owns(@state, ls)); 
    assume owns#263 == $owns($s, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(ls), prestate#264)
    call $static_unwrap($phys_ptr_cast(P#ls, ^LocalStores), prestate#264);
    assume $good_state_ext(#tok$1^952.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _Bool ite#20; 
    assume true;
    // if (>=(dst_node, *((pl->preference_list)[x]))) ...
    if (L#dst_node >= $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x))))
    {
      anon187:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
        // assert @in_range_i4(+(x, 3199)); 
        assert $in_range_i4(L#x + 3199);
        // ite#20 := <=(dst_node, *((pl->preference_list)[+(x, 3199)])); 
        ite#20 := L#dst_node <= $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x + 3199)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#x + 3199)));
    }
    else
    {
      anon188:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
        // ite#20 := false; 
        ite#20 := false;
    }

  anon197:
    assume true;
    // if (ite#20) ...
    if (ite#20)
    {
      anon189:
        // (int32_t -> _Bool) res_delone_iset#100; 
        // res_delone_iset#100 := delone_iset(*((hhs->tainted_nodes)), dst_node); 
        call res_delone_iset#100 := delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#dst_node);
        assume $full_stop_ext(#tok$1^956.24, $s);
        // assert @prim_writes_check((hhs->tainted_nodes)); 
        assert $writable_prim($s, #wrTime$1^924.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.tainted_nodes));
        // *(hhs->tainted_nodes) := res_delone_iset#100; 
        call $write_int(HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^i4.^^bool_to_int(res_delone_iset#100));
        assume $full_stop_ext(#tok$1^956.3, $s);
        // (int32_t -> _Bool) res_addone_iset#101; 
        // res_addone_iset#101 := addone_iset(*((ls->tainted_nodes)), dst_node); 
        call res_addone_iset#101 := addone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node);
        assume $full_stop_ext(#tok$1^958.24, $s);
        // assert @prim_writes_check((ls->tainted_nodes)); 
        assert $writable_prim($s, #wrTime$1^924.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.tainted_nodes));
        // *(ls->tainted_nodes) := res_addone_iset#101; 
        call $write_int(LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores), $map_t..^^i4.^^bool_to_int(res_addone_iset#101));
        assume $full_stop_ext(#tok$1^958.3, $s);
    }
    else
    {
      anon190:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon198:
    assume true;
    // if (@check_termination(44)) ...
    if ($check_termination(44))
    {
      anon193:
        // uint64_t h#43; 
        assume true;
        // if (==(h#43, last_hint)) ...
        if (h#43 == L#last_hint)
        {
          anon191:
            // skip
        }
        else
        {
          anon192:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
        }

      anon194:
        // assume false; 
        assume false;
    }
    else
    {
      anon195:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon199:
    // (uint64_t -> _Bool) res_lambda#55#102; 
    // res_lambda#55#102 := lambda#55(*((hhs->hset)), last_hint); 
    call res_lambda#55#102 := lambda#55($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint);
    assume $full_stop_ext(#tok$1^960.22, $s);
    // assert @prim_writes_check((hhs->hset)); 
    assert $writable_prim($s, #wrTime$1^924.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hset));
    // *(hhs->hset) := res_lambda#55#102; 
    call $write_int(HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $map_t..^^u8.^^bool_to_int(res_lambda#55#102));
    assume $full_stop_ext(#tok$1^960.10, $s);
    // assert @map_eq(addone_hset(delone_hset(*((hhs->hset)), last_hint), last_hint), *((hhs->hset))); 
    assert $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
    // assume @map_eq(addone_hset(delone_hset(*((hhs->hset)), last_hint), last_hint), *((hhs->hset))); 
    assume $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), L#last_hint), L#last_hint), $int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))));
    // assert @map_eq(addone_iset(delone_iset(*((ls->tainted_nodes)), dst_node), dst_node), *((ls->tainted_nodes))); 
    assert $eq.$map_t..^^i4.^^bool(F#addone_iset(F#delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node), L#dst_node), $int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))));
    // assume @map_eq(addone_iset(delone_iset(*((ls->tainted_nodes)), dst_node), dst_node), *((ls->tainted_nodes))); 
    assume $eq.$map_t..^^i4.^^bool(F#addone_iset(F#delone_iset($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), L#dst_node), L#dst_node), $int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))));
    // assert @prim_writes_check((hhs->hint_store)[-(*((hhs->size)), 1)]); 
    assert $writable_prim($s, #wrTime$1^924.1, $idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1));
    // assert @in_range_u8(-(*((hhs->size)), 1)); 
    assert $in_range_u8($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1);
    // assert @reads_check_normal((hhs->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // *(hhs->hint_store)[-(*((hhs->size)), 1)] := 18446744073709551615; 
    call $write_int($field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1)), 18446744073709551615);
    assume $full_stop_ext(#tok$1^965.2, $s);
    // assert @prim_writes_check((hhs->size)); 
    assert $writable_prim($s, #wrTime$1^924.1, $dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.size));
    // assert @in_range_u8(-(*((hhs->size)), 1)); 
    assert $in_range_u8($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1);
    // assert @reads_check_normal((hhs->size)); 
    assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // *(hhs->size) := -(*((hhs->size)), 1); 
    call $write_int(HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) - 1);
    assume $full_stop_ext(#tok$1^966.2, $s);
    // assert @prim_writes_check((ls->local_store)[+(*(dst_node, 10000), key)]); 
    assert $writable_prim($s, #wrTime$1^924.1, $idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key));
    // assert @in_range_i4(+(*(dst_node, 10000), key)); 
    assert $in_range_i4($op_mul(L#dst_node, 10000) + L#key);
    // assert @in_range_i4(*(dst_node, 10000)); 
    assert $in_range_i4($op_mul(L#dst_node, 10000));
    // *(ls->local_store)[+(*(dst_node, 10000), key)] := key; 
    call $write_int($field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key)), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $op_mul(L#dst_node, 10000) + L#key)), L#key);
    assume $full_stop_ext(#tok$1^969.2, $s);
    // assert @prim_writes_check((ls->size)); 
    assert $writable_prim($s, #wrTime$1^924.1, $dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.size));
    // *(ls->size) := unchecked+(*((ls->size)), 1); 
    call $write_int(LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores), $unchk_add(^^nat, $rd_inv($s, LocalStores.size, $phys_ptr_cast(P#ls, ^LocalStores)), 1));
    assume $full_stop_ext(#tok$1^970.10, $s);
    // _math \state prestate#265; 
    // prestate#265 := @_vcc_current_state(@state); 
    prestate#265 := $current_state($s);
    // _math \state staticWrapState#266; 
    // staticWrapState#266 := @_vcc_current_state(@state); 
    staticWrapState#266 := $current_state($s);
    // _math \objset owns#268; 
    // owns#268 := @_vcc_set_empty; 
    owns#268 := $set_empty();
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^924.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(hhs), staticWrapState#266, owns#268)
    call $static_wrap($phys_ptr_cast(P#hhs, ^HintedHandoffStores), staticWrapState#266, owns#268);
    assume $good_state_ext(#tok$1^971.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, hhs), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)), $set_empty());
    // assert @inv_check(<=(*((hhs->size)), 16777215)); 
    assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
    // assert @inv_check(forall(uint64_t i; @in_range_u8(i); ==>(<(i, *((hhs->size))), @map_get(*((hhs->hset)), *((hhs->hint_store)[i]))))); 
    assert (forall Q#i$1^184.14#tc2#1410: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))) } $in_range_u8(Q#i$1^184.14#tc2#1410) ==> Q#i$1^184.14#tc2#1410 < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), Q#i$1^184.14#tc2#1410)))));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), <(@map_get(*((hhs->idx)), h), *((hhs->size)))))); 
    assert (forall Q#h$1^185.14#tc2#1411: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) } $in_range_u8(Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) ==> $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^185.14#tc2#1411) < $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    // assert @inv_check(forall(uint64_t h; @in_range_u8(h); ==>(@map_get(*((hhs->hset)), h), ==(*((hhs->hint_store)[@map_get(*((hhs->idx)), h)]), h)))); 
    assert (forall Q#h$1^186.14#tc2#1412: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } { $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) } $in_range_u8(Q#h$1^186.14#tc2#1412) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412) ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412))), $prim_emb($idx($dot($phys_ptr_cast(P#hhs, ^HintedHandoffStores), HintedHandoffStores.hint_store), $select.$map_t..^^u8.^^u8($int_to_map_t..^^u8.^^u8($rd_inv($s, HintedHandoffStores.idx, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^186.14#tc2#1412)))) == Q#h$1^186.14#tc2#1412);
    // assert @inv_check(==>(&&(>=(*((hhs->tkey)), 0), <(*((hhs->tkey)), 10000)), ==(*((hhs->tcoord)), get_coord_for_key(*((hhs->tkey)))))); 
    assert $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 10000 ==> $rd_inv($s, HintedHandoffStores.tcoord, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == F#get_coord_for_key($rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // _math \state prestate#269; 
    // prestate#269 := @_vcc_current_state(@state); 
    prestate#269 := $current_state($s);
    // _math \state staticWrapState#270; 
    // staticWrapState#270 := @_vcc_current_state(@state); 
    staticWrapState#270 := $current_state($s);
    // _math \objset owns#272; 
    // owns#272 := @_vcc_set_empty; 
    owns#272 := $set_empty();
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^924.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ls), staticWrapState#270, owns#272)
    call $static_wrap($phys_ptr_cast(P#ls, ^LocalStores), staticWrapState#270, owns#272);
    assume $good_state_ext(#tok$1^972.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ls), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ls, ^LocalStores)), $set_empty());
    // assert @inv_check(<=(*((ls->len)), 100000000)); 
    assert $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores)) <= 100000000;
    // assert @inv_check(||(==(*((ls->tainted_key)), -1), &&(>=(*((ls->tainted_key)), 0), <(*((ls->tainted_key)), 10000)))); 
    assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) < 10000);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure get_arbitrary_bool() returns ($result: int);
  modifies $s, $cev_pc;
  free ensures $in_range_i4($result);
  ensures $result == 1 || $result == 0;
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



procedure get_arbitrary_num_in_range(P#low: int, P#high: int) returns ($result: int);
  requires P#high > P#low;
  modifies $s, $cev_pc;
  free ensures $in_range_i4($result);
  ensures $result >= P#low && $result < P#high;
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



procedure get_alive_coordinator(P#ln: $ptr, P#coord: int);
  requires P#coord >= 0;
  requires P#coord < 10000;
  requires $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  modifies $s, $cev_pc;
  ensures $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), P#coord)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), P#coord))) == 1;
  ensures $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
  free ensures $call_transition(old($s), $s);



implementation get_alive_coordinator(P#ln: $ptr, P#coord: int)
{
  var owns#279: $ptrset;
  var staticWrapState#277: $state;
  var prestate#276: $state;
  var prestate#275: $state;
  var prestate#273: $state;
  var owns#274: $ptrset;
  var #wrTime$1^989.1: int;
  var #stackframe: int;

  anon200:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^989.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^989.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^989.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
    assume $thread_owned($s, $phys_ptr_cast(P#ln, ^LiveNodes));
    // assume true
    // assume @in_range_i4(coord); 
    assume $in_range_i4(P#coord);
    // assume @decreases_level_is(1); 
    assume 1 == $decreases_level;
    // assert @_vcc_in_domain(@state, ln, ln); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ln, ^LiveNodes), l#public);
    // assume true
    // _math \objset owns#274; 
    // owns#274 := @_vcc_set_empty; 
    owns#274 := $set_empty();
    // _math \state prestate#273; 
    // prestate#273 := @_vcc_current_state(@state); 
    prestate#273 := $current_state($s);
    // _math \state prestate#275; 
    // prestate#275 := @_vcc_current_state(@state); 
    prestate#275 := $current_state($s);
    // assert @_vcc_wrapped(@state, ln); 
    assert $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
    // assert @writes_check(ln); 
    assert $top_writable($s, #wrTime$1^989.1, $phys_ptr_cast(P#ln, ^LiveNodes));
    // prestate#275 := pure(@_vcc_start_release(prestate#275, prestate#275)); 
    prestate#275 := $start_release(prestate#275, prestate#275);
    // assume @_vcc_inv(@state, ln); 
    assume $inv($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
    // assume ==(owns#274, @_vcc_owns(@state, ln)); 
    assume owns#274 == $owns($s, $phys_ptr_cast(P#ln, ^LiveNodes));
    // assume @_vcc_pre_static_unwrap(@state); 
    assume $pre_static_unwrap($s);
    // @_vcc_static_unwrap(pure(ln), prestate#275)
    call $static_unwrap($phys_ptr_cast(P#ln, ^LiveNodes), prestate#275);
    assume $good_state_ext(#tok$1^996.4, $s);
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // assert @prim_writes_check((ln->live_nodes)[coord]); 
    assert $writable_prim($s, #wrTime$1^989.1, $idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), P#coord));
    // *(ln->live_nodes)[coord] := 1; 
    call $write_int($field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), P#coord)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), P#coord)), 1);
    assume $full_stop_ext(#tok$1^997.2, $s);
    // _math \state prestate#276; 
    // prestate#276 := @_vcc_current_state(@state); 
    prestate#276 := $current_state($s);
    // _math \state staticWrapState#277; 
    // staticWrapState#277 := @_vcc_current_state(@state); 
    staticWrapState#277 := $current_state($s);
    // _math \objset owns#279; 
    // owns#279 := @_vcc_set_empty; 
    owns#279 := $set_empty();
    // assert @writes_check(ln); 
    assert $top_writable($s, #wrTime$1^989.1, $phys_ptr_cast(P#ln, ^LiveNodes));
    // assume @_vcc_pre_static_wrap(@state); 
    assume $pre_static_wrap($s);
    // @_vcc_static_wrap(pure(ln), staticWrapState#277, owns#279)
    call $static_wrap($phys_ptr_cast(P#ln, ^LiveNodes), staticWrapState#277, owns#279);
    assume $good_state_ext(#tok$1^998.4, $s);
    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ln), @_vcc_set_empty)); 
    assert $set_eq($owns($s, $phys_ptr_cast(P#ln, ^LiveNodes)), $set_empty());
    // assume @_vcc_full_stop(@state); 
    assume $full_stop($s);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure nodes_fail_and_recover_arbitrarily(P#ln: $ptr);
  requires $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  modifies $s, $cev_pc;
  ensures (forall Q#i$1^1004.12#tc1#1326: int :: {:weight 10} { $idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#i$1^1004.12#tc1#1326) } $in_range_i4(Q#i$1^1004.12#tc1#1326) ==> Q#i$1^1004.12#tc1#1326 >= 0 && Q#i$1^1004.12#tc1#1326 < 10000 ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#i$1^1004.12#tc1#1326)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#i$1^1004.12#tc1#1326))) == 1 || $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#i$1^1004.12#tc1#1326)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#i$1^1004.12#tc1#1326))) == 0);
  ensures $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
  free ensures $call_transition(old($s), $s);



implementation nodes_fail_and_recover_arbitrarily(P#ln: $ptr)
{
  var loopDecrEnd#315: int;
  var owns#286: $ptrset;
  var staticWrapState#284: $state;
  var prestate#283: $state;
  var res_get_arbitrary_bool#103: int where $in_range_i4(res_get_arbitrary_bool#103);
  var prestate#282: $state;
  var prestate#280: $state;
  var owns#281: $ptrset;
  var loopDecrBeg#314: int;
  var #wrTime$1^1008.12: int;
  var loopState#6: $state;
  var L#i: int where $in_range_i4(L#i);
  var #wrTime$1^1001.1: int;
  var #stackframe: int;

  anon204:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^1001.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^1001.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^1001.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
    assume $thread_owned($s, $phys_ptr_cast(P#ln, ^LiveNodes));
    // assume true
    // assume @decreases_level_is(2); 
    assume 2 == $decreases_level;
    // assert @_vcc_in_domain(@state, ln, ln); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ln, ^LiveNodes), l#public);
    // assume true
    // int32_t i; 
    // i := 0; 
    L#i := 0;
    call $bump_timestamp();
    assume $full_stop_ext(#tok$1^1008.12, $s);
    loopState#6 := $s;
    assume #wrTime$1^1008.12 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^1008.12, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
    assert (forall #loopWrites^$1^1008.12: $ptr :: { $dont_instantiate(#loopWrites^$1^1008.12) } $listed_in_writes($s, #wrTime$1^1008.12, #loopWrites^$1^1008.12) ==> $top_writable($s, #wrTime$1^1001.1, #loopWrites^$1^1008.12));
    assume true;
    while (true)
      invariant $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
      invariant (forall Q#j$1^1010.15#tc1#1325: int :: {:weight 10} { $idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#j$1^1010.15#tc1#1325) } $in_range_i4(Q#j$1^1010.15#tc1#1325) ==> Q#j$1^1010.15#tc1#1325 >= 0 && Q#j$1^1010.15#tc1#1325 < L#i ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#j$1^1010.15#tc1#1325)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#j$1^1010.15#tc1#1325))) == 1 || $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#j$1^1010.15#tc1#1325)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#j$1^1010.15#tc1#1325))) == 0);
    {
      anon203:
        assume $modifies(loopState#6, $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
        assume $timestamp_post(loopState#6, $s);
        assume $full_stop_ext(#tok$1^1007.2, $s);
        // \integer loopDecrBeg#314; 
        // loopDecrBeg#314 := @prelude_int_distance(i, 10000); 
        loopDecrBeg#314 := $int_distance(L#i, 10000);
        assume true;
        // if (<(i, 10000)) ...
        if (L#i < 10000)
        {
          anon201:
            // _math \objset owns#281; 
            // owns#281 := @_vcc_set_empty; 
            owns#281 := $set_empty();
            // _math \state prestate#280; 
            // prestate#280 := @_vcc_current_state(@state); 
            prestate#280 := $current_state($s);
            // _math \state prestate#282; 
            // prestate#282 := @_vcc_current_state(@state); 
            prestate#282 := $current_state($s);
            // assert @_vcc_wrapped(@state, ln); 
            assert $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
            // assert @writes_check(ln); 
            assert $top_writable($s, #wrTime$1^1008.12, $phys_ptr_cast(P#ln, ^LiveNodes));
            // prestate#282 := pure(@_vcc_start_release(prestate#282, prestate#282)); 
            prestate#282 := $start_release(prestate#282, prestate#282);
            // assume @_vcc_inv(@state, ln); 
            assume $inv($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
            // assume ==(owns#281, @_vcc_owns(@state, ln)); 
            assume owns#281 == $owns($s, $phys_ptr_cast(P#ln, ^LiveNodes));
            // assume @_vcc_pre_static_unwrap(@state); 
            assume $pre_static_unwrap($s);
            // @_vcc_static_unwrap(pure(ln), prestate#282)
            call $static_unwrap($phys_ptr_cast(P#ln, ^LiveNodes), prestate#282);
            assume $good_state_ext(#tok$1^1012.5, $s);
            // assume @_vcc_full_stop(@state); 
            assume $full_stop($s);
            // int32_t res_get_arbitrary_bool#103; 
            // res_get_arbitrary_bool#103 := get_arbitrary_bool(); 
            call res_get_arbitrary_bool#103 := get_arbitrary_bool();
            assume $full_stop_ext(#tok$1^1013.23, $s);
            // assert @prim_writes_check((ln->live_nodes)[i]); 
            assert $writable_prim($s, #wrTime$1^1008.12, $idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#i));
            // *(ln->live_nodes)[i] := res_get_arbitrary_bool#103; 
            call $write_int($field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#i)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#i)), res_get_arbitrary_bool#103);
            assume $full_stop_ext(#tok$1^1013.3, $s);
            // _math \state prestate#283; 
            // prestate#283 := @_vcc_current_state(@state); 
            prestate#283 := $current_state($s);
            // _math \state staticWrapState#284; 
            // staticWrapState#284 := @_vcc_current_state(@state); 
            staticWrapState#284 := $current_state($s);
            // _math \objset owns#286; 
            // owns#286 := @_vcc_set_empty; 
            owns#286 := $set_empty();
            // assert @writes_check(ln); 
            assert $top_writable($s, #wrTime$1^1008.12, $phys_ptr_cast(P#ln, ^LiveNodes));
            // assume @_vcc_pre_static_wrap(@state); 
            assume $pre_static_wrap($s);
            // @_vcc_static_wrap(pure(ln), staticWrapState#284, owns#286)
            call $static_wrap($phys_ptr_cast(P#ln, ^LiveNodes), staticWrapState#284, owns#286);
            assume $good_state_ext(#tok$1^1014.5, $s);
            // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ln), @_vcc_set_empty)); 
            assert $set_eq($owns($s, $phys_ptr_cast(P#ln, ^LiveNodes)), $set_empty());
            // assume @_vcc_full_stop(@state); 
            assume $full_stop($s);
        }
        else
        {
          anon202:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
            // goto #break_62; 
            goto #break_62;
        }

      #continue_62:
        // assert @in_range_i4(+(i, 1)); 
        assert $in_range_i4(L#i + 1);
        // i := +(i, 1); 
        L#i := L#i + 1;
        // \integer loopDecrEnd#315; 
        // loopDecrEnd#315 := @prelude_int_distance(i, 10000); 
        loopDecrEnd#315 := $int_distance(L#i, 10000);
        // assert @prelude_int_lt_or(loopDecrEnd#315, loopDecrBeg#314, false); 
        assert $int_lt_or(loopDecrEnd#315, loopDecrBeg#314, false);
        assume true;
    }

  anon205:
    assume $full_stop_ext(#tok$1^1007.2, $s);

  #break_62:
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure all_nodes_recover(P#ln: $ptr);
  requires $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  modifies $s, $cev_pc;
  ensures (forall Q#i$1^1021.12#tc1#1331: int :: {:weight 10} { $idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#i$1^1021.12#tc1#1331) } $in_range_i4(Q#i$1^1021.12#tc1#1331) ==> Q#i$1^1021.12#tc1#1331 >= 0 && Q#i$1^1021.12#tc1#1331 < 10000 ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#i$1^1021.12#tc1#1331)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#i$1^1021.12#tc1#1331))) == 1);
  ensures $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
  free ensures $call_transition(old($s), $s);



implementation all_nodes_recover(P#ln: $ptr)
{
  var loopDecrEnd#317: int;
  var owns#293: $ptrset;
  var staticWrapState#291: $state;
  var prestate#290: $state;
  var prestate#289: $state;
  var prestate#287: $state;
  var owns#288: $ptrset;
  var loopDecrBeg#316: int;
  var #wrTime$1^1025.12: int;
  var loopState#7: $state;
  var L#i: int where $in_range_i4(L#i);
  var #wrTime$1^1018.1: int;
  var #stackframe: int;

  anon209:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^1018.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^1018.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^1018.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
    assume $thread_owned($s, $phys_ptr_cast(P#ln, ^LiveNodes));
    // assume true
    // assume @decreases_level_is(1); 
    assume 1 == $decreases_level;
    // assert @_vcc_in_domain(@state, ln, ln); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ln, ^LiveNodes), l#public);
    // assume true
    // int32_t i; 
    // i := 0; 
    L#i := 0;
    call $bump_timestamp();
    assume $full_stop_ext(#tok$1^1025.12, $s);
    loopState#7 := $s;
    assume #wrTime$1^1025.12 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^1025.12, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
    assert (forall #loopWrites^$1^1025.12: $ptr :: { $dont_instantiate(#loopWrites^$1^1025.12) } $listed_in_writes($s, #wrTime$1^1025.12, #loopWrites^$1^1025.12) ==> $top_writable($s, #wrTime$1^1018.1, #loopWrites^$1^1025.12));
    assume true;
    while (true)
      invariant $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
      invariant (forall Q#j$1^1027.15#tc1#1330: int :: {:weight 10} { $idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#j$1^1027.15#tc1#1330) } $in_range_i4(Q#j$1^1027.15#tc1#1330) ==> Q#j$1^1027.15#tc1#1330 >= 0 && Q#j$1^1027.15#tc1#1330 < L#i ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#j$1^1027.15#tc1#1330)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), Q#j$1^1027.15#tc1#1330))) == 1);
    {
      anon208:
        assume $modifies(loopState#7, $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
        assume $timestamp_post(loopState#7, $s);
        assume $full_stop_ext(#tok$1^1024.2, $s);
        // \integer loopDecrBeg#316; 
        // loopDecrBeg#316 := @prelude_int_distance(i, 10000); 
        loopDecrBeg#316 := $int_distance(L#i, 10000);
        assume true;
        // if (<(i, 10000)) ...
        if (L#i < 10000)
        {
          anon206:
            // _math \objset owns#288; 
            // owns#288 := @_vcc_set_empty; 
            owns#288 := $set_empty();
            // _math \state prestate#287; 
            // prestate#287 := @_vcc_current_state(@state); 
            prestate#287 := $current_state($s);
            // _math \state prestate#289; 
            // prestate#289 := @_vcc_current_state(@state); 
            prestate#289 := $current_state($s);
            // assert @_vcc_wrapped(@state, ln); 
            assert $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
            // assert @writes_check(ln); 
            assert $top_writable($s, #wrTime$1^1025.12, $phys_ptr_cast(P#ln, ^LiveNodes));
            // prestate#289 := pure(@_vcc_start_release(prestate#289, prestate#289)); 
            prestate#289 := $start_release(prestate#289, prestate#289);
            // assume @_vcc_inv(@state, ln); 
            assume $inv($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
            // assume ==(owns#288, @_vcc_owns(@state, ln)); 
            assume owns#288 == $owns($s, $phys_ptr_cast(P#ln, ^LiveNodes));
            // assume @_vcc_pre_static_unwrap(@state); 
            assume $pre_static_unwrap($s);
            // @_vcc_static_unwrap(pure(ln), prestate#289)
            call $static_unwrap($phys_ptr_cast(P#ln, ^LiveNodes), prestate#289);
            assume $good_state_ext(#tok$1^1029.5, $s);
            // assume @_vcc_full_stop(@state); 
            assume $full_stop($s);
            // assert @prim_writes_check((ln->live_nodes)[i]); 
            assert $writable_prim($s, #wrTime$1^1025.12, $idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#i));
            // *(ln->live_nodes)[i] := 1; 
            call $write_int($field($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#i)), $prim_emb($idx($dot($phys_ptr_cast(P#ln, ^LiveNodes), LiveNodes.live_nodes), L#i)), 1);
            assume $full_stop_ext(#tok$1^1030.3, $s);
            // _math \state prestate#290; 
            // prestate#290 := @_vcc_current_state(@state); 
            prestate#290 := $current_state($s);
            // _math \state staticWrapState#291; 
            // staticWrapState#291 := @_vcc_current_state(@state); 
            staticWrapState#291 := $current_state($s);
            // _math \objset owns#293; 
            // owns#293 := @_vcc_set_empty; 
            owns#293 := $set_empty();
            // assert @writes_check(ln); 
            assert $top_writable($s, #wrTime$1^1025.12, $phys_ptr_cast(P#ln, ^LiveNodes));
            // assume @_vcc_pre_static_wrap(@state); 
            assume $pre_static_wrap($s);
            // @_vcc_static_wrap(pure(ln), staticWrapState#291, owns#293)
            call $static_wrap($phys_ptr_cast(P#ln, ^LiveNodes), staticWrapState#291, owns#293);
            assume $good_state_ext(#tok$1^1031.5, $s);
            // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ln), @_vcc_set_empty)); 
            assert $set_eq($owns($s, $phys_ptr_cast(P#ln, ^LiveNodes)), $set_empty());
            // assume @_vcc_full_stop(@state); 
            assume $full_stop($s);
        }
        else
        {
          anon207:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
            // goto #break_63; 
            goto #break_63;
        }

      #continue_63:
        // assert @in_range_i4(+(i, 1)); 
        assert $in_range_i4(L#i + 1);
        // i := +(i, 1); 
        L#i := L#i + 1;
        // \integer loopDecrEnd#317; 
        // loopDecrEnd#317 := @prelude_int_distance(i, 10000); 
        loopDecrEnd#317 := $int_distance(L#i, 10000);
        // assert @prelude_int_lt_or(loopDecrEnd#317, loopDecrBeg#316, false); 
        assert $int_lt_or(loopDecrEnd#317, loopDecrBeg#316, false);
        assume true;
    }

  anon210:
    assume $full_stop_ext(#tok$1^1024.2, $s);

  #break_63:
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure empty_hhs_ps(P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr, P#tainted_key: int, P#tainted_coord: int, P#tmp_coord: int);
  requires P#tainted_key >= 0;
  requires P#tainted_key < 10000;
  requires P#tainted_coord == F#get_coord_for_key(P#tainted_key);
  requires P#tmp_coord == $op_mul(P#tainted_coord, 3200);
  requires $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  requires $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  requires $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  requires $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  requires (forall Q#j$1^1040.16#tc1#1437: int :: {:weight 10} { P#tmp_coord + Q#j$1^1040.16#tc1#1437 } $in_range_i4(Q#j$1^1040.16#tc1#1437) ==> Q#j$1^1040.16#tc1#1437 >= 0 && Q#j$1^1040.16#tc1#1437 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1437)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1437)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1437)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1437)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1437)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1437)))));
  modifies $s, $cev_pc;
  ensures $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == 0;
  ensures $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == 0;
  ensures $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists) && $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores) && $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores) && $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  ensures (forall Q#j$1^1040.16#tc1#1438: int :: {:weight 10} { P#tmp_coord + Q#j$1^1040.16#tc1#1438 } $in_range_i4(Q#j$1^1040.16#tc1#1438) ==> Q#j$1^1040.16#tc1#1438 >= 0 && Q#j$1^1040.16#tc1#1438 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1438)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1438)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1438)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1438)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1438)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1040.16#tc1#1438)))));
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
  free ensures $call_transition(old($s), $s);



implementation empty_hhs_ps(P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr, P#tainted_key: int, P#tainted_coord: int, P#tmp_coord: int)
{
  var loopDecrEnd#319: int where $in_range_u8(loopDecrEnd#319);
  var res_star#104: int where $in_range_i4(res_star#104);
  var ite#24: bool;
  var ite#23: bool;
  var ite#22: bool;
  var SL#s0: $state;
  var ite#21: bool;
  var loopDecrBeg#318: int where $in_range_u8(loopDecrBeg#318);
  var #wrTime$1^1061.13: int;
  var loopState#8: $state;
  var #wrTime$1^1035.1: int;
  var #stackframe: int;

  anon229:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^1035.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^1035.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^1035.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
    assume $thread_owned($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    assume $thread_owned($s, $phys_ptr_cast(P#ls, ^LocalStores));
    assume $thread_owned($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume true
    // assume true
    // assume true
    // assume true
    // assume @in_range_i4(tainted_key); 
    assume $in_range_i4(P#tainted_key);
    // assume @in_range_i4(tainted_coord); 
    assume $in_range_i4(P#tainted_coord);
    // assume @in_range_i4(tmp_coord); 
    assume $in_range_i4(P#tmp_coord);
    // assume @decreases_level_is(3); 
    assume 3 == $decreases_level;
    // assert @_vcc_in_domain(@state, ps, ps); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ps, ^PendingSet), $phys_ptr_cast(P#ps, ^PendingSet), l#public);
    // assert @_vcc_in_domain(@state, ls, ls); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ls, ^LocalStores), l#public);
    // assert @_vcc_in_domain(@state, hhs, hhs); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), l#public);
    // assert @_vcc_in_domain(@state, pl, pl); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#pl, ^PreferenceLists), l#public);
    // assume true
    call $bump_timestamp();
    assume $full_stop_ext(#tok$1^1061.13, $s);
    loopState#8 := $s;
    assume #wrTime$1^1061.13 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^1061.13, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
    assert (forall #loopWrites^$1^1061.13: $ptr :: { $dont_instantiate(#loopWrites^$1^1061.13) } $listed_in_writes($s, #wrTime$1^1061.13, #loopWrites^$1^1061.13) ==> $top_writable($s, #wrTime$1^1035.1, #loopWrites^$1^1061.13));
    assume true;
    while (true)
      invariant $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
      invariant $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
      invariant $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
      invariant $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
      invariant $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
      invariant $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
      invariant $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
      invariant P#tainted_coord == F#get_coord_for_key(P#tainted_key);
      invariant (forall Q#j$1^1056.17#tc1#1342: int :: {:weight 10} { P#tmp_coord + Q#j$1^1056.17#tc1#1342 } $in_range_i4(Q#j$1^1056.17#tc1#1342) ==> Q#j$1^1056.17#tc1#1342 >= 0 && Q#j$1^1056.17#tc1#1342 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1056.17#tc1#1342)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1056.17#tc1#1342)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1056.17#tc1#1342)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1056.17#tc1#1342)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1056.17#tc1#1342)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), P#tmp_coord + Q#j$1^1056.17#tc1#1342)))));
    {
      anon227:
        assume $modifies(loopState#8, $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
        assume $timestamp_post(loopState#8, $s);
        assume $full_stop_ext(#tok$1^1051.3, $s);
        // uint64_t loopDecrBeg#318; 
        // loopDecrBeg#318 := +(*((hhs->size)), *(2, *((ps->size)))); 
        loopDecrBeg#318 := $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + $op_mul(2, $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)));
        // _Bool ite#21; 
        // assert @reads_check_normal((hhs->size)); 
        assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
        assume true;
        // if (>(*((hhs->size)), 0)) ...
        if ($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) > 0)
        {
          anon211:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
            // ite#21 := true; 
            ite#21 := true;
        }
        else
        {
          anon212:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
            // assert @reads_check_normal((ps->size)); 
            assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
            // ite#21 := >(*((ps->size)), 0); 
            ite#21 := $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) > 0;
        }

      anon228:
        assume true;
        // if (ite#21) ...
        if (ite#21)
        {
          anon224:
            // _math \state s0; 
            // s0 := @_vcc_current_state(@state); 
            SL#s0 := $current_state($s);
            // _Bool ite#22; 
            // assert @reads_check_normal((hhs->size)); 
            assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
            assume true;
            // if (>(*((hhs->size)), 0)) ...
            if ($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) > 0)
            {
              anon213:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
                // assert @reads_check_normal((ps->size)); 
                assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                // ite#22 := <=(*((ps->size)), 0); 
                ite#22 := $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 0;
            }
            else
            {
              anon214:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
                // ite#22 := false; 
                ite#22 := false;
            }

          anon225:
            assume true;
            // if (ite#22) ...
            if (ite#22)
            {
              anon215:
                // assert @writes_check(hhs); 
                assert $top_writable($s, #wrTime$1^1061.13, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                // assert @writes_check(ls); 
                assert $top_writable($s, #wrTime$1^1061.13, $phys_ptr_cast(P#ls, ^LocalStores));
                // stmt handoff_hint_seq(tainted_key, tainted_coord, pl, hhs, ls, ps); 
                call handoff_hint_seq(P#tainted_key, P#tainted_coord, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ps, ^PendingSet));
                assume $full_stop_ext(#tok$1^1066.4, $s);
                // assert <(*((hhs->size)), old(s0, *((hhs->size)))); 
                assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < $rd_inv(SL#s0, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                // assert <=(*((ps->size)), old(s0, *((ps->size)))); 
                assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= $rd_inv(SL#s0, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
                // assume &&(<(*((hhs->size)), old(s0, *((hhs->size)))), <=(*((ps->size)), old(s0, *((ps->size))))); 
                assume $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < $rd_inv(SL#s0, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= $rd_inv(SL#s0, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
            }
            else
            {
              anon222:
                // _Bool ite#23; 
                // assert @reads_check_normal((hhs->size)); 
                assert $thread_local($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                assume true;
                // if (<=(*((hhs->size)), 0)) ...
                if ($rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 0)
                {
                  anon216:
                    // assert @_vcc_possibly_unreachable; 
                    assert {:PossiblyUnreachable true} true;
                    // assert @reads_check_normal((ps->size)); 
                    assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                    // ite#23 := >(*((ps->size)), 0); 
                    ite#23 := $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) > 0;
                }
                else
                {
                  anon217:
                    // assert @_vcc_possibly_unreachable; 
                    assert {:PossiblyUnreachable true} true;
                    // ite#23 := false; 
                    ite#23 := false;
                }

              anon223:
                assume true;
                // if (ite#23) ...
                if (ite#23)
                {
                  anon218:
                    // assume <(*((hhs->size)), 16777215); 
                    assume $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 16777215;
                    // skip
                    // assert @writes_check(hhs); 
                    assert $top_writable($s, #wrTime$1^1061.13, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                    // assert @writes_check(ls); 
                    assert $top_writable($s, #wrTime$1^1061.13, $phys_ptr_cast(P#ls, ^LocalStores));
                    // assert @writes_check(ps); 
                    assert $top_writable($s, #wrTime$1^1061.13, $phys_ptr_cast(P#ps, ^PendingSet));
                    // stmt rm_pending_seq(tainted_key, tainted_coord, pl, hhs, ls, ps); 
                    call rm_pending_seq(P#tainted_key, P#tainted_coord, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ps, ^PendingSet));
                    assume $full_stop_ext(#tok$1^1070.4, $s);
                    // assert <(*((ps->size)), old(s0, *((ps->size)))); 
                    assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < $rd_inv(SL#s0, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
                    // assert <=(*((hhs->size)), +(old(s0, *((hhs->size))), 1)); 
                    assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= $rd_inv(SL#s0, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1;
                    // assume &&(<(*((ps->size)), old(s0, *((ps->size)))), <=(*((hhs->size)), +(old(s0, *((hhs->size))), 1))); 
                    assume $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < $rd_inv(SL#s0, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= $rd_inv(SL#s0, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1;
                }
                else
                {
                  anon221:
                    // _Bool ite#24; 
                    // int32_t res_star#104; 
                    // res_star#104 := star(); 
                    call res_star#104 := star();
                    assume $full_stop_ext(#tok$1^1074.8, $s);
                    // ite#24 := (_Bool)res_star#104; 
                    ite#24 := $int_to_bool(res_star#104);
                    assume true;
                    // if (ite#24) ...
                    if (ite#24)
                    {
                      anon219:
                        // assert @writes_check(hhs); 
                        assert $top_writable($s, #wrTime$1^1061.13, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                        // assert @writes_check(ls); 
                        assert $top_writable($s, #wrTime$1^1061.13, $phys_ptr_cast(P#ls, ^LocalStores));
                        // stmt handoff_hint_seq(tainted_key, tainted_coord, pl, hhs, ls, ps); 
                        call handoff_hint_seq(P#tainted_key, P#tainted_coord, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ps, ^PendingSet));
                        assume $full_stop_ext(#tok$1^1075.5, $s);
                        // assert <(*((hhs->size)), old(s0, *((hhs->size)))); 
                        assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < $rd_inv(SL#s0, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                        // assert <=(*((ps->size)), old(s0, *((ps->size)))); 
                        assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= $rd_inv(SL#s0, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
                        // assume &&(<(*((hhs->size)), old(s0, *((hhs->size)))), <=(*((ps->size)), old(s0, *((ps->size))))); 
                        assume $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < $rd_inv(SL#s0, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= $rd_inv(SL#s0, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
                    }
                    else
                    {
                      anon220:
                        // assume <(*((hhs->size)), 16777215); 
                        assume $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 16777215;
                        // skip
                        // assert @writes_check(hhs); 
                        assert $top_writable($s, #wrTime$1^1061.13, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                        // assert @writes_check(ls); 
                        assert $top_writable($s, #wrTime$1^1061.13, $phys_ptr_cast(P#ls, ^LocalStores));
                        // assert @writes_check(ps); 
                        assert $top_writable($s, #wrTime$1^1061.13, $phys_ptr_cast(P#ps, ^PendingSet));
                        // stmt rm_pending_seq(tainted_key, tainted_coord, pl, hhs, ls, ps); 
                        call rm_pending_seq(P#tainted_key, P#tainted_coord, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ps, ^PendingSet));
                        assume $full_stop_ext(#tok$1^1079.5, $s);
                        // assert <(*((ps->size)), old(s0, *((ps->size)))); 
                        assert $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < $rd_inv(SL#s0, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
                        // assert <=(*((hhs->size)), +(old(s0, *((hhs->size))), 1)); 
                        assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= $rd_inv(SL#s0, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1;
                        // assume &&(<(*((ps->size)), old(s0, *((ps->size)))), <=(*((hhs->size)), +(old(s0, *((hhs->size))), 1))); 
                        assume $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < $rd_inv(SL#s0, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= $rd_inv(SL#s0, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + 1;
                    }
                }
            }
        }
        else
        {
          anon226:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
            // goto #break_64; 
            goto #break_64;
        }

      #continue_64:
        // uint64_t loopDecrEnd#319; 
        // loopDecrEnd#319 := +(*((hhs->size)), *(2, *((ps->size)))); 
        loopDecrEnd#319 := $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) + $op_mul(2, $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)));
        // assert @prelude_int_lt_or(loopDecrEnd#319, loopDecrBeg#318, false); 
        assert $int_lt_or(loopDecrEnd#319, loopDecrBeg#318, false);
        assume true;
    }

  anon230:
    assume $full_stop_ext(#tok$1^1051.3, $s);

  #break_64:
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



procedure permute_ps_idx(P#ps: $ptr);
  requires $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
  requires $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  modifies $s, $cev_pc;
  ensures (forall Q#h$1^1090.12#tc2#1346: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^1090.12#tc2#1346) } { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(old($s), PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^1090.12#tc2#1346) } $in_range_u8(Q#h$1^1090.12#tc2#1346) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^1090.12#tc2#1346) == $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(old($s), PendingSet.pset, $phys_ptr_cast(P#ps, ^PendingSet))), Q#h$1^1090.12#tc2#1346));
  ensures (forall Q#i$1^1091.12#tc1#1347: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^1091.12#tc1#1347) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(old($s), PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^1091.12#tc1#1347) } $in_range_i4(Q#i$1^1091.12#tc1#1347) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^1091.12#tc1#1347) == $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(old($s), PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), Q#i$1^1091.12#tc1#1347));
  ensures $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == $rd_inv(old($s), PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
  ensures $rd_inv($s, PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet)) == $rd_inv(old($s), PendingSet.tkey, $phys_ptr_cast(P#ps, ^PendingSet));
  ensures $rd_inv($s, PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet)) == $rd_inv(old($s), PendingSet.tcoord, $phys_ptr_cast(P#ps, ^PendingSet));
  ensures $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  ensures $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= 16777215;
  ensures $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ps, ^PendingSet)));
  free ensures $call_transition(old($s), $s);



procedure permute_hhs_idx(P#hhs: $ptr);
  requires $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
  requires $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  modifies $s, $cev_pc;
  ensures (forall Q#h$1^1103.12#tc2#1350: int :: {:weight 10} { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^1103.12#tc2#1350) } { $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(old($s), HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^1103.12#tc2#1350) } $in_range_u8(Q#h$1^1103.12#tc2#1350) ==> $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv($s, HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^1103.12#tc2#1350) == $select.$map_t..^^u8.^^bool($int_to_map_t..^^u8.^^bool($rd_inv(old($s), HintedHandoffStores.hset, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#h$1^1103.12#tc2#1350));
  ensures (forall Q#i$1^1104.12#tc1#1351: int :: {:weight 10} { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^1104.12#tc1#1351) } { $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(old($s), HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^1104.12#tc1#1351) } $in_range_i4(Q#i$1^1104.12#tc1#1351) ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^1104.12#tc1#1351) == $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv(old($s), HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), Q#i$1^1104.12#tc1#1351));
  ensures $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == $rd_inv(old($s), HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  ensures $rd_inv($s, HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == $rd_inv(old($s), HintedHandoffStores.tkey, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  ensures $rd_inv($s, HintedHandoffStores.tcoord, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == $rd_inv(old($s), HintedHandoffStores.tcoord, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  ensures $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  ensures $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
  ensures $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
  free ensures $call_transition(old($s), $s);



procedure harness(P#ln: $ptr, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr) returns ($result: int, OP#tkey: int, OP#tcoord: int);
  requires $non_null($phys_ptr_cast(P#pl, ^PreferenceLists));
  requires $non_null($phys_ptr_cast(P#ls, ^LocalStores));
  requires $non_null($phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  requires $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 16777215;
  requires $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < 16777215;
  modifies $s, $cev_pc;
  free ensures $in_range_i4($result);
  free ensures $in_range_i4(OP#tkey);
  free ensures $in_range_i4(OP#tcoord);
  ensures $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists) && $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores) && $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  ensures $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || $set_in(#p, $extent(old($s), $phys_ptr_cast(P#ln, ^LiveNodes))) || $set_in(#p, $extent(old($s), $phys_ptr_cast(P#pl, ^PreferenceLists))) || $set_in(#p, $extent(old($s), $phys_ptr_cast(P#hhs, ^HintedHandoffStores))) || $set_in(#p, $extent(old($s), $phys_ptr_cast(P#ls, ^LocalStores))) || $set_in(#p, $extent(old($s), $phys_ptr_cast(P#ps, ^PendingSet)))));
  free ensures $call_transition(old($s), $s);



implementation harness(P#ln: $ptr, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr) returns ($result: int, OP#tkey: int, OP#tcoord: int)
{
  var ite#26: bool;
  var loopDecrEnd#322: int where $in_range_i4(loopDecrEnd#322);
  var L#ret_put: int where $in_range_i4(L#ret_put);
  var ite#25: bool;
  var loopDecrBeg#321: int where $in_range_i4(loopDecrBeg#321);
  var #wrTime$1^1152.12: int;
  var loopState#9: $state;
  var L#tainted_key: int where $in_range_i4(L#tainted_key);
  var L#tainted_coord: int where $in_range_i4(L#tainted_coord);
  var L#tainted_key_set: int where $in_range_i4(L#tainted_key_set);
  var L#lo: int where $in_range_i4(L#lo);
  var L#hi: int where $in_range_i4(L#hi);
  var L#num_rounds: int where $in_range_i4(L#num_rounds);
  var L#tmp_coord: int where $in_range_i4(L#tmp_coord);
  var thisDecr#320: int where $in_range_u8(thisDecr#320);
  var #wrTime$1^1113.1: int;
  var #stackframe: int;

  anon244:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^1113.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^1113.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^1113.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ln, ^LiveNodes) || $set_in(#p, $extent($s, $phys_ptr_cast(P#ln, ^LiveNodes))) || $set_in(#p, $extent($s, $phys_ptr_cast(P#pl, ^PreferenceLists))) || $set_in(#p, $extent($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))) || $set_in(#p, $extent($s, $phys_ptr_cast(P#ls, ^LocalStores))) || $set_in(#p, $extent($s, $phys_ptr_cast(P#ps, ^PendingSet)))));
    assume $thread_owned($s, $phys_ptr_cast(P#ln, ^LiveNodes));
    assume $extent_mutable($s, $phys_ptr_cast(P#ln, ^LiveNodes));
    assume $extent_mutable($s, $phys_ptr_cast(P#pl, ^PreferenceLists));
    assume $extent_mutable($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    assume $extent_mutable($s, $phys_ptr_cast(P#ls, ^LocalStores));
    assume $extent_mutable($s, $phys_ptr_cast(P#ps, ^PendingSet));
    // assume true
    // assume true
    // assume true
    // assume true
    // assume true
    // assume @in_range_i4(tkey); 
    assume $in_range_i4(OP#tkey);
    // assume @in_range_i4(tcoord); 
    assume $in_range_i4(OP#tcoord);
    // uint64_t thisDecr#320; 
    // thisDecr#320 := *((hhs->size)); 
    thisDecr#320 := $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @decreases_level_is(4); 
    assume 4 == $decreases_level;
    // assume true
    // assume ==(-1, unchecked-(0, 1)); 
    assume -1 == $unchk_sub(^^i4, 0, 1);
    // int32_t tmp_coord; 
    // int32_t num_rounds; 
    // int32_t hi; 
    // int32_t lo; 
    // int32_t tainted_key_set; 
    // int32_t tainted_coord; 
    // int32_t tainted_key; 
    // assert @writes_check(@_vcc_extent(@state, pl)); 
    assert (forall #writes$1^1123.2: $ptr :: { $dont_instantiate(#writes$1^1123.2) } $set_in(#writes$1^1123.2, $extent($s, $phys_ptr_cast(P#pl, ^PreferenceLists))) ==> $top_writable($s, #wrTime$1^1113.1, #writes$1^1123.2));
    // stmt init_preference_lists(pl); 
    call init_preference_lists($phys_ptr_cast(P#pl, ^PreferenceLists));
    assume $full_stop_ext(#tok$1^1123.2, $s);
    // assert @writes_check(@_vcc_extent(@state, ls)); 
    assert (forall #writes$1^1124.2: $ptr :: { $dont_instantiate(#writes$1^1124.2) } $set_in(#writes$1^1124.2, $extent($s, $phys_ptr_cast(P#ls, ^LocalStores))) ==> $top_writable($s, #wrTime$1^1113.1, #writes$1^1124.2));
    // stmt init_local_stores(ls); 
    call init_local_stores($phys_ptr_cast(P#ls, ^LocalStores));
    assume $full_stop_ext(#tok$1^1124.2, $s);
    // assert @writes_check(@_vcc_extent(@state, hhs)); 
    assert (forall #writes$1^1125.2: $ptr :: { $dont_instantiate(#writes$1^1125.2) } $set_in(#writes$1^1125.2, $extent($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))) ==> $top_writable($s, #wrTime$1^1113.1, #writes$1^1125.2));
    // stmt init_hinted_handoff_stores(hhs); 
    call init_hinted_handoff_stores($phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    assume $full_stop_ext(#tok$1^1125.2, $s);
    // assert @writes_check(@_vcc_extent(@state, ps)); 
    assert (forall #writes$1^1126.2: $ptr :: { $dont_instantiate(#writes$1^1126.2) } $set_in(#writes$1^1126.2, $extent($s, $phys_ptr_cast(P#ps, ^PendingSet))) ==> $top_writable($s, #wrTime$1^1113.1, #writes$1^1126.2));
    // stmt init_pending(ps); 
    call init_pending($phys_ptr_cast(P#ps, ^PendingSet));
    assume $full_stop_ext(#tok$1^1126.2, $s);
    // assert @writes_check(@_vcc_extent(@state, ln)); 
    assert (forall #writes$1^1127.2: $ptr :: { $dont_instantiate(#writes$1^1127.2) } $set_in(#writes$1^1127.2, $extent($s, $phys_ptr_cast(P#ln, ^LiveNodes))) ==> $top_writable($s, #wrTime$1^1113.1, #writes$1^1127.2));
    // stmt init_live_nodes(ln); 
    call init_live_nodes($phys_ptr_cast(P#ln, ^LiveNodes));
    assume $full_stop_ext(#tok$1^1127.2, $s);
    // tainted_key := -1; 
    L#tainted_key := -1;
    // tainted_coord := -1; 
    L#tainted_coord := -1;
    // tainted_key_set := 0; 
    L#tainted_key_set := 0;
    // lo := 10; 
    L#lo := 10;
    // hi := 1000; 
    L#hi := 1000;
    // non-pure function
    // num_rounds := get_arbitrary_num_in_range(lo, hi); 
    call L#num_rounds := get_arbitrary_num_in_range(L#lo, L#hi);
    assume $full_stop_ext(#tok$1^1134.19, $s);
    // assert ==(*((ls->tainted_key)), -1); 
    assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1;
    // assume ==(*((ls->tainted_key)), -1); 
    assume $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1;
    call $bump_timestamp();
    assume $full_stop_ext(#tok$1^1152.12, $s);
    loopState#9 := $s;
    assume #wrTime$1^1152.12 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^1152.12, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet) || #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
    assert (forall #loopWrites^$1^1152.12: $ptr :: { $dont_instantiate(#loopWrites^$1^1152.12) } $listed_in_writes($s, #wrTime$1^1152.12, #loopWrites^$1^1152.12) ==> $top_writable($s, #wrTime$1^1113.1, #loopWrites^$1^1152.12));
    assume true;
    while (true)
      invariant L#num_rounds >= 0;
      invariant L#num_rounds <= 1000;
      invariant $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
      invariant $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
      invariant $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
      invariant $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
      invariant $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
      invariant $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
      invariant $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
      invariant $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < 16777215;
      invariant $int_to_bool(L#tainted_key_set) ==> L#tainted_key >= 0;
      invariant $int_to_bool(L#tainted_key_set) ==> L#tainted_key < 10000;
      invariant L#tainted_key != -1 && L#tainted_coord == F#get_coord_for_key(L#tainted_key) ==> (forall Q#j$1^1146.11#tc1#1367: int :: {:weight 10} { $op_mul(L#tainted_coord, 3200) + Q#j$1^1146.11#tc1#1367 } $in_range_i4(Q#j$1^1146.11#tc1#1367) ==> Q#j$1^1146.11#tc1#1367 >= 0 && Q#j$1^1146.11#tc1#1367 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1146.11#tc1#1367)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1146.11#tc1#1367)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1146.11#tc1#1367)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1146.11#tc1#1367)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1146.11#tc1#1367)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1146.11#tc1#1367)))));
      invariant $int_to_bool(L#tainted_key_set) ==> L#tainted_key != -1;
      invariant $int_to_bool(L#tainted_key_set) ==> L#tainted_coord == F#get_coord_for_key(L#tainted_key);
      invariant L#tainted_key != -1 ==> L#tainted_coord == F#get_coord_for_key(L#tainted_key);
    {
      anon241:
        assume $modifies(loopState#9, $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet) || #p == $phys_ptr_cast(P#ln, ^LiveNodes)));
        assume $timestamp_post(loopState#9, $s);
        assume $full_stop_ext(#tok$1^1136.2, $s);
        // int32_t loopDecrBeg#321; 
        // loopDecrBeg#321 := num_rounds; 
        loopDecrBeg#321 := L#num_rounds;
        assume true;
        // if (>(num_rounds, 0)) ...
        if (L#num_rounds > 0)
        {
          anon237:
            // _Bool ite#25; 
            // ite#25 := (_Bool)tainted_key_set; 
            ite#25 := $int_to_bool(L#tainted_key_set);
            assume true;
            // if (unchecked!(ite#25)) ...
            if (!ite#25)
            {
              anon233:
                // int32_t ret_put; 
                // non-pure function
                // tainted_key := get_arbitrary_num_in_range(0, 10000); 
                call L#tainted_key := get_arbitrary_num_in_range(0, 10000);
                assume $full_stop_ext(#tok$1^1160.18, $s);
                // tainted_coord := get_coord_for_key(tainted_key); 
                call L#tainted_coord := get_coord_for_key(L#tainted_key);
                assume $full_stop_ext(#tok$1^1161.20, $s);
                // assert @writes_check(ln); 
                assert $top_writable($s, #wrTime$1^1152.12, $phys_ptr_cast(P#ln, ^LiveNodes));
                // stmt get_alive_coordinator(ln, tainted_coord); 
                call get_alive_coordinator($phys_ptr_cast(P#ln, ^LiveNodes), L#tainted_coord);
                assume $full_stop_ext(#tok$1^1162.4, $s);
                // assert >=(*((hhs->size)), 0); 
                assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
                // assert <=(*((hhs->size)), 16777215); 
                assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
                // assume &&(>=(*((hhs->size)), 0), <=(*((hhs->size)), 16777215)); 
                assume $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
                // non-pure function
                // assert @writes_check(ln); 
                assert $top_writable($s, #wrTime$1^1152.12, $phys_ptr_cast(P#ln, ^LiveNodes));
                // assert @writes_check(ls); 
                assert $top_writable($s, #wrTime$1^1152.12, $phys_ptr_cast(P#ls, ^LocalStores));
                // assert @writes_check(hhs); 
                assert $top_writable($s, #wrTime$1^1152.12, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
                // assert @writes_check(ps); 
                assert $top_writable($s, #wrTime$1^1152.12, $phys_ptr_cast(P#ps, ^PendingSet));
                // ret_put := put(tainted_key, tainted_coord, 1, 1, ln, pl, ls, hhs, ps); 
                call L#ret_put := put(L#tainted_key, L#tainted_coord, 1, 1, $phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ps, ^PendingSet));
                assume $full_stop_ext(#tok$1^1164.18, $s);
                // assert >=(*((hhs->size)), 0); 
                assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
                // assert <=(*((hhs->size)), 16777215); 
                assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
                // assume &&(>=(*((hhs->size)), 0), <=(*((hhs->size)), 16777215)); 
                assume $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
                // assert @reads_check_normal((wrap#WDT->data)); 
                assert $thread_local($s, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT));
                assume true;
                // if (>=(ret_put, *((wrap#WDT->data)))) ...
                if (L#ret_put >= $rd_inv($s, swrap#WDT.data, $phys_ptr_cast(G#wrap#WDT#dt10, ^swrap#WDT)))
                {
                  anon231:
                    // tainted_key_set := 1; 
                    L#tainted_key_set := 1;
                }
                else
                {
                  anon232:
                    // tainted_key := -1; 
                    L#tainted_key := -1;
                }
            }
            else
            {
              anon234:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
            }

          anon238:
            // assert @reads_check_normal((ps->size)); 
            assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
            assume true;
            // if (==(*((ps->size)), 16777215)) ...
            if ($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == 16777215)
            {
              anon235:
                // return -1; 
                $result := -1;
                assume true;
                assert $position_marker();
                goto #exit;
            }
            else
            {
              anon236:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
            }

          anon239:
            // assert @writes_check(ln); 
            assert $top_writable($s, #wrTime$1^1152.12, $phys_ptr_cast(P#ln, ^LiveNodes));
            // stmt nodes_fail_and_recover_arbitrarily(ln); 
            call nodes_fail_and_recover_arbitrarily($phys_ptr_cast(P#ln, ^LiveNodes));
            assume $full_stop_ext(#tok$1^1178.3, $s);
            // assert @in_range_i4(-(num_rounds, 1)); 
            assert $in_range_i4(L#num_rounds - 1);
            // num_rounds := -(num_rounds, 1); 
            L#num_rounds := L#num_rounds - 1;
        }
        else
        {
          anon240:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
            // goto #break_65; 
            goto #break_65;
        }

      #continue_65:
        // int32_t loopDecrEnd#322; 
        // loopDecrEnd#322 := num_rounds; 
        loopDecrEnd#322 := L#num_rounds;
        // assert @prelude_int_lt_or(loopDecrEnd#322, loopDecrBeg#321, false); 
        assert $int_lt_or(loopDecrEnd#322, loopDecrBeg#321, false);
        assume true;
    }

  anon245:
    assume $full_stop_ext(#tok$1^1136.2, $s);

  #break_65:
    // _Bool ite#26; 
    // ite#26 := (_Bool)tainted_key_set; 
    ite#26 := $int_to_bool(L#tainted_key_set);
    assume true;
    // if (unchecked!(ite#26)) ...
    if (!ite#26)
    {
      anon242:
        // return -1; 
        $result := -1;
        assume true;
        assert $position_marker();
        goto #exit;
    }
    else
    {
      anon243:
        // assert @_vcc_possibly_unreachable; 
        assert {:PossiblyUnreachable true} true;
    }

  anon246:
    // assert >=(*((hhs->size)), 0); 
    assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0;
    // assert <=(*((hhs->size)), 16777215); 
    assert $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
    // assume &&(>=(*((hhs->size)), 0), <=(*((hhs->size)), 16777215)); 
    assume $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) >= 0 && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) <= 16777215;
    // assert >=(tainted_key, 0); 
    assert L#tainted_key >= 0;
    // assert <(tainted_key, 10000); 
    assert L#tainted_key < 10000;
    // assume &&(>=(tainted_key, 0), <(tainted_key, 10000)); 
    assume L#tainted_key >= 0 && L#tainted_key < 10000;
    // assert ==>((_Bool)tainted_key_set, !=(tainted_key, -1)); 
    assert $int_to_bool(L#tainted_key_set) ==> L#tainted_key != -1;
    // assert ==>((_Bool)tainted_key_set, ==(tainted_coord, get_coord_for_key(tainted_key))); 
    assert $int_to_bool(L#tainted_key_set) ==> L#tainted_coord == F#get_coord_for_key(L#tainted_key);
    // assume ==>((_Bool)tainted_key_set, &&(!=(tainted_key, -1), ==(tainted_coord, get_coord_for_key(tainted_key)))); 
    assume $int_to_bool(L#tainted_key_set) ==> L#tainted_key != -1 && L#tainted_coord == F#get_coord_for_key(L#tainted_key);
    // assert forall(int32_t j; @in_range_i4(j); ==>(&&(>=(j, 0), <(j, 3200)), ||(||(@map_get(*((ls->tainted_nodes)), *((pl->preference_list)[+(*(tainted_coord, 3200), j)])), @map_get(*((hhs->tainted_nodes)), *((pl->preference_list)[+(*(tainted_coord, 3200), j)]))), @map_get(*((ps->tainted_nodes)), *((pl->preference_list)[+(*(tainted_coord, 3200), j)]))))); 
    assert (forall Q#j$1^1191.12#tc1#1368: int :: {:weight 10} { $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1368 } $in_range_i4(Q#j$1^1191.12#tc1#1368) ==> Q#j$1^1191.12#tc1#1368 >= 0 && Q#j$1^1191.12#tc1#1368 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1368)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1368)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1368)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1368)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1368)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1368)))));
    // assume forall(int32_t j; @in_range_i4(j); ==>(&&(>=(j, 0), <(j, 3200)), ||(||(@map_get(*((ls->tainted_nodes)), *((pl->preference_list)[+(*(tainted_coord, 3200), j)])), @map_get(*((hhs->tainted_nodes)), *((pl->preference_list)[+(*(tainted_coord, 3200), j)]))), @map_get(*((ps->tainted_nodes)), *((pl->preference_list)[+(*(tainted_coord, 3200), j)]))))); 
    assume (forall Q#j$1^1191.12#tc1#1465: int :: {:weight 10} { $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1465 } $in_range_i4(Q#j$1^1191.12#tc1#1465) ==> Q#j$1^1191.12#tc1#1465 >= 0 && Q#j$1^1191.12#tc1#1465 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1465)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1465)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1465)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1465)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1465)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(L#tainted_coord, 3200) + Q#j$1^1191.12#tc1#1465)))));
    // assert @writes_check(ln); 
    assert $top_writable($s, #wrTime$1^1113.1, $phys_ptr_cast(P#ln, ^LiveNodes));
    // stmt all_nodes_recover(ln); 
    call all_nodes_recover($phys_ptr_cast(P#ln, ^LiveNodes));
    assume $full_stop_ext(#tok$1^1197.2, $s);
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^1113.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // stmt permute_ps_idx(ps); 
    call permute_ps_idx($phys_ptr_cast(P#ps, ^PendingSet));
    assume $full_stop_ext(#tok$1^1198.2, $s);
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^1113.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // stmt permute_hhs_idx(hhs); 
    call permute_hhs_idx($phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    assume $full_stop_ext(#tok$1^1199.2, $s);
    // assert @in_range_i4(*(tainted_coord, 3200)); 
    assert $in_range_i4($op_mul(L#tainted_coord, 3200));
    // tmp_coord := *(tainted_coord, 3200); 
    L#tmp_coord := $op_mul(L#tainted_coord, 3200);
    // assert ==>((_Bool)tainted_key_set, !=(tainted_key, -1)); 
    assert $int_to_bool(L#tainted_key_set) ==> L#tainted_key != -1;
    // assert ==>((_Bool)tainted_key_set, ==(tainted_coord, get_coord_for_key(tainted_key))); 
    assert $int_to_bool(L#tainted_key_set) ==> L#tainted_coord == F#get_coord_for_key(L#tainted_key);
    // assume ==>((_Bool)tainted_key_set, &&(!=(tainted_key, -1), ==(tainted_coord, get_coord_for_key(tainted_key)))); 
    assume $int_to_bool(L#tainted_key_set) ==> L#tainted_key != -1 && L#tainted_coord == F#get_coord_for_key(L#tainted_key);
    // assert forall(int32_t j; @in_range_i4(j); ==>(&&(>=(j, 0), <(j, 3200)), ||(||(@map_get(*((ls->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)])), @map_get(*((hhs->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)]))), @map_get(*((ps->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)]))))); 
    assert (forall Q#j$1^1205.12#tc1#1370: int :: {:weight 10} { L#tmp_coord + Q#j$1^1205.12#tc1#1370 } $in_range_i4(Q#j$1^1205.12#tc1#1370) ==> Q#j$1^1205.12#tc1#1370 >= 0 && Q#j$1^1205.12#tc1#1370 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1370)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1370)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1370)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1370)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1370)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1370)))));
    // assume forall(int32_t j; @in_range_i4(j); ==>(&&(>=(j, 0), <(j, 3200)), ||(||(@map_get(*((ls->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)])), @map_get(*((hhs->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)]))), @map_get(*((ps->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)]))))); 
    assume (forall Q#j$1^1205.12#tc1#1466: int :: {:weight 10} { L#tmp_coord + Q#j$1^1205.12#tc1#1466 } $in_range_i4(Q#j$1^1205.12#tc1#1466) ==> Q#j$1^1205.12#tc1#1466 >= 0 && Q#j$1^1205.12#tc1#1466 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1466)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1466)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1466)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1466)))) || $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1466)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1205.12#tc1#1466)))));
    // assert @writes_check(hhs); 
    assert $top_writable($s, #wrTime$1^1113.1, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assert @writes_check(ls); 
    assert $top_writable($s, #wrTime$1^1113.1, $phys_ptr_cast(P#ls, ^LocalStores));
    // assert @writes_check(ps); 
    assert $top_writable($s, #wrTime$1^1113.1, $phys_ptr_cast(P#ps, ^PendingSet));
    // stmt empty_hhs_ps(pl, hhs, ls, ps, tainted_key, tainted_coord, tmp_coord); 
    call empty_hhs_ps($phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ps, ^PendingSet), L#tainted_key, L#tainted_coord, L#tmp_coord);
    assume $full_stop_ext(#tok$1^1212.2, $s);
    // assert forall(int32_t j; @in_range_i4(j); ==>(&&(>=(j, 0), <(j, 3200)), ||(||(@map_get(*((ls->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)])), &&(@map_get(*((hhs->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)])), ==(*((hhs->size)), 0))), &&(@map_get(*((ps->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)])), ==(*((ps->size)), 0))))); 
    assert (forall Q#j$1^1215.12#tc1#1371: int :: {:weight 10} { L#tmp_coord + Q#j$1^1215.12#tc1#1371 } $in_range_i4(Q#j$1^1215.12#tc1#1371) ==> Q#j$1^1215.12#tc1#1371 >= 0 && Q#j$1^1215.12#tc1#1371 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1371)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1371)))) || ($select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1371)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1371)))) && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == 0) || ($select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1371)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1371)))) && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == 0));
    // assume forall(int32_t j; @in_range_i4(j); ==>(&&(>=(j, 0), <(j, 3200)), ||(||(@map_get(*((ls->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)])), &&(@map_get(*((hhs->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)])), ==(*((hhs->size)), 0))), &&(@map_get(*((ps->tainted_nodes)), *((pl->preference_list)[+(tmp_coord, j)])), ==(*((ps->size)), 0))))); 
    assume (forall Q#j$1^1215.12#tc1#1467: int :: {:weight 10} { L#tmp_coord + Q#j$1^1215.12#tc1#1467 } $in_range_i4(Q#j$1^1215.12#tc1#1467) ==> Q#j$1^1215.12#tc1#1467 >= 0 && Q#j$1^1215.12#tc1#1467 < 3200 ==> $select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, LocalStores.tainted_nodes, $phys_ptr_cast(P#ls, ^LocalStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1467)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1467)))) || ($select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, HintedHandoffStores.tainted_nodes, $phys_ptr_cast(P#hhs, ^HintedHandoffStores))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1467)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1467)))) && $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) == 0) || ($select.$map_t..^^i4.^^bool($int_to_map_t..^^i4.^^bool($rd_inv($s, PendingSet.tainted_nodes, $phys_ptr_cast(P#ps, ^PendingSet))), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1467)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), L#tmp_coord + Q#j$1^1215.12#tc1#1467)))) && $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == 0));
    // return 1; 
    $result := 1;
    assume true;
    assert $position_marker();
    goto #exit;

  anon247:
    // skip

  #exit:
}



function F#star() : int;

const unique cf#star: $pure_function;

axiom $in_range_i4(F#star());

axiom $function_arg_type(cf#star, 0, ^^i4);

procedure star() returns ($result: int);
  free ensures $in_range_i4($result);
  free ensures $result == F#star();
  free ensures $call_transition(old($s), $s);



procedure merge(P#val: int, P#value: int) returns ($result: int);
  modifies $s, $cev_pc;
  free ensures $in_range_i4($result);
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



procedure harness_read_repair(P#key: int, P#coord: int, P#ln: $ptr, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr);
  requires $non_null($phys_ptr_cast(P#pl, ^PreferenceLists));
  requires $non_null($phys_ptr_cast(P#ls, ^LocalStores));
  requires $non_null($phys_ptr_cast(P#hhs, ^HintedHandoffStores));
  requires P#coord == F#get_coord_for_key(P#key);
  requires P#key >= 0;
  requires P#key < 10000;
  requires $rd_inv($s, HintedHandoffStores.size, $phys_ptr_cast(P#hhs, ^HintedHandoffStores)) < 16777215;
  requires $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < 16777215;
  requires $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) >= 0;
  requires $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  requires $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  requires $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  requires $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  requires $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  modifies $s, $cev_pc;
  ensures $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
  ensures $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
  ensures $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
  ensures $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
  ensures $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
  free ensures $modifies(old($s), $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
  free ensures $call_transition(old($s), $s);



implementation harness_read_repair(P#key: int, P#coord: int, P#ln: $ptr, P#pl: $ptr, P#hhs: $ptr, P#ls: $ptr, P#ps: $ptr)
{
  var loopDecrEnd#328: int where $in_range_u8(loopDecrEnd#328);
  var loopDecrEnd#326: int where $in_range_i4(loopDecrEnd#326);
  var res_star#108: int where $in_range_i4(res_star#108);
  var ite#34: bool;
  var ite#33: bool;
  var owns#300: $ptrset;
  var staticWrapState#298: $state;
  var prestate#297: $state;
  var prestate#296: $state;
  var prestate#294: $state;
  var owns#295: $ptrset;
  var res_star#107: int where $in_range_i4(res_star#107);
  var ite#32: bool;
  var ite#31: bool;
  var loopDecrBeg#325: int where $in_range_i4(loopDecrBeg#325);
  var #wrTime$1^1296.13: int;
  var loopState#12: $state;
  var loopDecrEnd#324: int where $in_range_i4(loopDecrEnd#324);
  var res_star#106: int where $in_range_i4(res_star#106);
  var ite#30: bool;
  var ite#29: bool;
  var res_star#105: int where $in_range_i4(res_star#105);
  var ite#28: bool;
  var ite#27: bool;
  var loopDecrBeg#323: int where $in_range_i4(loopDecrBeg#323);
  var #wrTime$1^1267.3: int;
  var loopState#11: $state;
  var loopDecrBeg#327: int where $in_range_u8(loopDecrBeg#327);
  var #wrTime$1^1262.12: int;
  var loopState#10: $state;
  var L#consistent: int where $in_range_i4(L#consistent);
  var L#cur_node: int where $in_range_i4(L#cur_node);
  var L#i: int where $in_range_i4(L#i);
  var L#val: int where $in_range_i4(L#val);
  var #wrTime$1^1231.1: int;
  var #stackframe: int;

  anon285:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^1231.1, $s);
    assume $can_use_all_frame_axioms($s);
    assume #wrTime$1^1231.1 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^1231.1, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    assume $thread_owned($s, $phys_ptr_cast(P#ls, ^LocalStores));
    assume $thread_owned($s, $phys_ptr_cast(P#ps, ^PendingSet));
    assume $thread_owned($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores));
    // assume @in_range_i4(key); 
    assume $in_range_i4(P#key);
    // assume @in_range_i4(coord); 
    assume $in_range_i4(P#coord);
    // assume true
    // assume true
    // assume true
    // assume true
    // assume true
    // assume @decreases_level_is(3); 
    assume 3 == $decreases_level;
    // assert @_vcc_in_domain(@state, pl, pl); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#pl, ^PreferenceLists), l#public);
    // assert @_vcc_in_domain(@state, ps, ps); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ps, ^PendingSet), $phys_ptr_cast(P#ps, ^PendingSet), l#public);
    // assert @_vcc_in_domain(@state, ls, ls); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ls, ^LocalStores), l#public);
    // assert @_vcc_in_domain(@state, hhs, hhs); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), $phys_ptr_cast(P#hhs, ^HintedHandoffStores), l#public);
    // assert @_vcc_in_domain(@state, ln, ln); 
    assert $in_domain_lab($s, $phys_ptr_cast(P#ln, ^LiveNodes), $phys_ptr_cast(P#ln, ^LiveNodes), l#public);
    // assume true
    // int32_t val; 
    // int32_t i; 
    // int32_t cur_node; 
    // int32_t consistent; 
    // consistent := 0; 
    L#consistent := 0;
    // var int32_t cur_node
    // i := 0; 
    L#i := 0;
    // var int32_t val
    call $bump_timestamp();
    assume $full_stop_ext(#tok$1^1262.12, $s);
    loopState#10 := $s;
    assume #wrTime$1^1262.12 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^1262.12, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
    assert (forall #loopWrites^$1^1262.12: $ptr :: { $dont_instantiate(#loopWrites^$1^1262.12) } $listed_in_writes($s, #wrTime$1^1262.12, #loopWrites^$1^1262.12) ==> $top_writable($s, #wrTime$1^1231.1, #loopWrites^$1^1262.12));
    assume true;
    while (true)
      invariant $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
      invariant $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
      invariant $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
      invariant $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
      invariant $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
      invariant $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < 16777215;
      invariant $int_to_bool(L#consistent) ==> (forall Q#j$1^1261.30#tc1#1389: int :: {:weight 10} { $op_mul(P#coord, 3200) + Q#j$1^1261.30#tc1#1389 } $in_range_i4(Q#j$1^1261.30#tc1#1389) ==> Q#j$1^1261.30#tc1#1389 >= 0 && Q#j$1^1261.30#tc1#1389 < 3200 ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1261.30#tc1#1389)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1261.30#tc1#1389))))), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1261.30#tc1#1389)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1261.30#tc1#1389)))))) == L#val);
    {
      anon284:
        assume $modifies(loopState#10, $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
        assume $timestamp_post(loopState#10, $s);
        assume $full_stop_ext(#tok$1^1253.2, $s);
        // uint64_t loopDecrBeg#327; 
        // loopDecrBeg#327 := *((ps->size)); 
        loopDecrBeg#327 := $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
        assume true;
        // if (==(consistent, 0)) ...
        if (L#consistent == 0)
        {
          anon280:
            call $bump_timestamp();
            assume $full_stop_ext(#tok$1^1267.3, $s);
            loopState#11 := $s;
            assume #wrTime$1^1267.3 == $current_timestamp($s);
            assume $def_writes($s, #wrTime$1^1267.3, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
            assert (forall #loopWrites^$1^1267.3: $ptr :: { $dont_instantiate(#loopWrites^$1^1267.3) } $listed_in_writes($s, #wrTime$1^1267.3, #loopWrites^$1^1267.3) ==> $top_writable($s, #wrTime$1^1262.12, #loopWrites^$1^1267.3));
            assume true;
            while (true)
              invariant $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
              invariant $wrapped($s, $phys_ptr_cast(P#hhs, ^HintedHandoffStores), ^HintedHandoffStores);
              invariant $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
              invariant $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
              invariant $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
              invariant $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < 16777215;
              invariant $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) <= $rd_inv(loopState#11, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
              invariant $int_to_bool(L#consistent) ==> (forall Q#j$1^1276.31#tc1#1387: int :: {:weight 10} { $op_mul(P#coord, 3200) + Q#j$1^1276.31#tc1#1387 } $in_range_i4(Q#j$1^1276.31#tc1#1387) ==> Q#j$1^1276.31#tc1#1387 >= 0 && Q#j$1^1276.31#tc1#1387 < 3200 ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1276.31#tc1#1387)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1276.31#tc1#1387))))), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1276.31#tc1#1387)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1276.31#tc1#1387)))))) == $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200)))))), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200))), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200))))))));
            {
              anon262:
                assume $modifies(loopState#11, $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet) || #p == $phys_ptr_cast(P#hhs, ^HintedHandoffStores)));
                assume $timestamp_post(loopState#11, $s);
                assume $full_stop_ext(#tok$1^1267.3, $s);
                // int32_t loopDecrBeg#323; 
                // loopDecrBeg#323 := -(3200, i); 
                loopDecrBeg#323 := 3200 - L#i;
                assume true;
                // if (<(i, 3200)) ...
                if (L#i < 3200)
                {
                  anon256:
                    // assert @reads_check_normal((pl->preference_list)[+(*(coord, 3200), i)]); 
                    assert $thread_local($s, $idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i));
                    // assert @in_range_i4(+(*(coord, 3200), i)); 
                    assert $in_range_i4($op_mul(P#coord, 3200) + L#i);
                    // assert @in_range_i4(*(coord, 3200)); 
                    assert $in_range_i4($op_mul(P#coord, 3200));
                    // cur_node := *((pl->preference_list)[+(*(coord, 3200), i)]); 
                    L#cur_node := $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i)));
                    // _Bool ite#27; 
                    // _Bool ite#28; 
                    // int32_t res_star#105; 
                    // res_star#105 := star(); 
                    call res_star#105 := star();
                    assume $full_stop_ext(#tok$1^1280.7, $s);
                    // ite#28 := (_Bool)res_star#105; 
                    ite#28 := $int_to_bool(res_star#105);
                    assume true;
                    // if (ite#28) ...
                    if (ite#28)
                    {
                      anon248:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                        // assert @reads_check_normal((ps->size)); 
                        assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                        // ite#27 := >(*((ps->size)), 0); 
                        ite#27 := $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) > 0;
                    }
                    else
                    {
                      anon249:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                        // ite#27 := false; 
                        ite#27 := false;
                    }

                  anon257:
                    assume true;
                    // if (ite#27) ...
                    if (ite#27)
                    {
                      anon250:
                        // assert @writes_check(ls); 
                        assert $top_writable($s, #wrTime$1^1267.3, $phys_ptr_cast(P#ls, ^LocalStores));
                        // assert @writes_check(ps); 
                        assert $top_writable($s, #wrTime$1^1267.3, $phys_ptr_cast(P#ps, ^PendingSet));
                        // stmt rm_pending_rr(pl, ls, ps); 
                        call rm_pending_rr($phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ps, ^PendingSet));
                        assume $full_stop_ext(#tok$1^1281.5, $s);
                    }
                    else
                    {
                      anon251:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                    }

                  anon258:
                    // non-pure function
                    // assert @reads_check_normal((ls->local_store)[cur_node]); 
                    assert $thread_local($s, $idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), L#cur_node));
                    // val := merge(val, *((ls->local_store)[cur_node])); 
                    call L#val := merge(L#val, $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), L#cur_node))));
                    assume $full_stop_ext(#tok$1^1284.10, $s);
                    // _Bool ite#29; 
                    // _Bool ite#30; 
                    // int32_t res_star#106; 
                    // res_star#106 := star(); 
                    call res_star#106 := star();
                    assume $full_stop_ext(#tok$1^1286.7, $s);
                    // ite#30 := (_Bool)res_star#106; 
                    ite#30 := $int_to_bool(res_star#106);
                    assume true;
                    // if (ite#30) ...
                    if (ite#30)
                    {
                      anon252:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                        // assert @reads_check_normal((ps->size)); 
                        assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                        // ite#29 := >(*((ps->size)), 0); 
                        ite#29 := $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) > 0;
                    }
                    else
                    {
                      anon253:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                        // ite#29 := false; 
                        ite#29 := false;
                    }

                  anon259:
                    assume true;
                    // if (ite#29) ...
                    if (ite#29)
                    {
                      anon254:
                        // assert @writes_check(ls); 
                        assert $top_writable($s, #wrTime$1^1267.3, $phys_ptr_cast(P#ls, ^LocalStores));
                        // assert @writes_check(ps); 
                        assert $top_writable($s, #wrTime$1^1267.3, $phys_ptr_cast(P#ps, ^PendingSet));
                        // stmt rm_pending_rr(pl, ls, ps); 
                        call rm_pending_rr($phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ps, ^PendingSet));
                        assume $full_stop_ext(#tok$1^1287.5, $s);
                    }
                    else
                    {
                      anon255:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                    }

                  anon260:
                    // assert @in_range_i4(+(i, 1)); 
                    assert $in_range_i4(L#i + 1);
                    // i := +(i, 1); 
                    L#i := L#i + 1;
                }
                else
                {
                  anon261:
                    // assert @_vcc_possibly_unreachable; 
                    assert {:PossiblyUnreachable true} true;
                    // goto #break_67; 
                    goto #break_67;
                }

              #continue_67:
                // int32_t loopDecrEnd#324; 
                // loopDecrEnd#324 := -(3200, i); 
                loopDecrEnd#324 := 3200 - L#i;
                // assert @prelude_int_lt_or(loopDecrEnd#324, loopDecrBeg#323, false); 
                assert $int_lt_or(loopDecrEnd#324, loopDecrBeg#323, false);
                assume true;
            }

          anon281:
            assume $full_stop_ext(#tok$1^1267.3, $s);

          #break_67:
            // consistent := 1; 
            L#consistent := 1;
            // i := 0; 
            L#i := 0;
            call $bump_timestamp();
            assume $full_stop_ext(#tok$1^1296.13, $s);
            loopState#12 := $s;
            assume #wrTime$1^1296.13 == $current_timestamp($s);
            assume $def_writes($s, #wrTime$1^1296.13, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
            assert (forall #loopWrites^$1^1296.13: $ptr :: { $dont_instantiate(#loopWrites^$1^1296.13) } $listed_in_writes($s, #wrTime$1^1296.13, #loopWrites^$1^1296.13) ==> $top_writable($s, #wrTime$1^1262.12, #loopWrites^$1^1296.13));
            assume true;
            while (true)
              invariant L#i > 0 ==> L#cur_node >= 0;
              invariant L#i > 0 ==> L#cur_node < 10000;
              invariant $wrapped($s, $phys_ptr_cast(P#ln, ^LiveNodes), ^LiveNodes);
              invariant $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
              invariant $wrapped($s, $phys_ptr_cast(P#ps, ^PendingSet), ^PendingSet);
              invariant $wrapped($s, $phys_ptr_cast(P#pl, ^PreferenceLists), ^PreferenceLists);
              invariant $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < 16777215;
              invariant $int_to_bool(L#consistent) ==> (forall Q#j$1^1304.31#tc1#1388: int :: {:weight 10} { $op_mul(P#coord, 3200) + Q#j$1^1304.31#tc1#1388 } $in_range_i4(Q#j$1^1304.31#tc1#1388) ==> Q#j$1^1304.31#tc1#1388 >= 0 && Q#j$1^1304.31#tc1#1388 < L#i ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1304.31#tc1#1388)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1304.31#tc1#1388))))), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1304.31#tc1#1388)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1304.31#tc1#1388)))))) == L#val);
              invariant $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) < $rd_inv(loopState#12, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) || ($rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) == $rd_inv(loopState#12, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) && L#consistent == 1);
            {
              anon277:
                assume $modifies(loopState#12, $s, (lambda #p: $ptr :: #p == $phys_ptr_cast(P#ls, ^LocalStores) || #p == $phys_ptr_cast(P#ps, ^PendingSet)));
                assume $timestamp_post(loopState#12, $s);
                assume $full_stop_ext(#tok$1^1294.3, $s);
                // int32_t loopDecrBeg#325; 
                // loopDecrBeg#325 := -(3200, i); 
                loopDecrBeg#325 := 3200 - L#i;
                assume true;
                // if (<(i, 3200)) ...
                if (L#i < 3200)
                {
                  anon271:
                    // assert @reads_check_normal((pl->preference_list)[+(*(coord, 3200), i)]); 
                    assert $thread_local($s, $idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i));
                    // assert @in_range_i4(+(*(coord, 3200), i)); 
                    assert $in_range_i4($op_mul(P#coord, 3200) + L#i);
                    // assert @in_range_i4(*(coord, 3200)); 
                    assert $in_range_i4($op_mul(P#coord, 3200));
                    // cur_node := *((pl->preference_list)[+(*(coord, 3200), i)]); 
                    L#cur_node := $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + L#i)));
                    // _Bool ite#31; 
                    // _Bool ite#32; 
                    // int32_t res_star#107; 
                    // res_star#107 := star(); 
                    call res_star#107 := star();
                    assume $full_stop_ext(#tok$1^1308.7, $s);
                    // ite#32 := (_Bool)res_star#107; 
                    ite#32 := $int_to_bool(res_star#107);
                    assume true;
                    // if (ite#32) ...
                    if (ite#32)
                    {
                      anon263:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                        // assert @reads_check_normal((ps->size)); 
                        assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                        // ite#31 := >(*((ps->size)), 0); 
                        ite#31 := $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) > 0;
                    }
                    else
                    {
                      anon264:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                        // ite#31 := false; 
                        ite#31 := false;
                    }

                  anon272:
                    assume true;
                    // if (ite#31) ...
                    if (ite#31)
                    {
                      anon265:
                        // assert @writes_check(ls); 
                        assert $top_writable($s, #wrTime$1^1296.13, $phys_ptr_cast(P#ls, ^LocalStores));
                        // assert @writes_check(ps); 
                        assert $top_writable($s, #wrTime$1^1296.13, $phys_ptr_cast(P#ps, ^PendingSet));
                        // stmt rm_pending_rr(pl, ls, ps); 
                        call rm_pending_rr($phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ps, ^PendingSet));
                        assume $full_stop_ext(#tok$1^1310.5, $s);
                        // consistent := 0; 
                        L#consistent := 0;
                    }
                    else
                    {
                      anon266:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                    }

                  anon273:
                    // _math \objset owns#295; 
                    // owns#295 := @_vcc_set_empty; 
                    owns#295 := $set_empty();
                    // _math \state prestate#294; 
                    // prestate#294 := @_vcc_current_state(@state); 
                    prestate#294 := $current_state($s);
                    // _math \state prestate#296; 
                    // prestate#296 := @_vcc_current_state(@state); 
                    prestate#296 := $current_state($s);
                    // assert @_vcc_wrapped(@state, ls); 
                    assert $wrapped($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
                    // assert @writes_check(ls); 
                    assert $top_writable($s, #wrTime$1^1296.13, $phys_ptr_cast(P#ls, ^LocalStores));
                    // prestate#296 := pure(@_vcc_start_release(prestate#296, prestate#296)); 
                    prestate#296 := $start_release(prestate#296, prestate#296);
                    // assume @_vcc_inv(@state, ls); 
                    assume $inv($s, $phys_ptr_cast(P#ls, ^LocalStores), ^LocalStores);
                    // assume ==(owns#295, @_vcc_owns(@state, ls)); 
                    assume owns#295 == $owns($s, $phys_ptr_cast(P#ls, ^LocalStores));
                    // assume @_vcc_pre_static_unwrap(@state); 
                    assume $pre_static_unwrap($s);
                    // @_vcc_static_unwrap(pure(ls), prestate#296)
                    call $static_unwrap($phys_ptr_cast(P#ls, ^LocalStores), prestate#296);
                    assume $good_state_ext(#tok$1^1314.6, $s);
                    // assume @_vcc_full_stop(@state); 
                    assume $full_stop($s);
                    // assert @prim_writes_check((ls->local_store)[cur_node]); 
                    assert $writable_prim($s, #wrTime$1^1296.13, $idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), L#cur_node));
                    // *(ls->local_store)[cur_node] := val; 
                    call $write_int($field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), L#cur_node)), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), L#cur_node)), L#val);
                    assume $full_stop_ext(#tok$1^1315.4, $s);
                    // _math \state prestate#297; 
                    // prestate#297 := @_vcc_current_state(@state); 
                    prestate#297 := $current_state($s);
                    // _math \state staticWrapState#298; 
                    // staticWrapState#298 := @_vcc_current_state(@state); 
                    staticWrapState#298 := $current_state($s);
                    // _math \objset owns#300; 
                    // owns#300 := @_vcc_set_empty; 
                    owns#300 := $set_empty();
                    // assert @writes_check(ls); 
                    assert $top_writable($s, #wrTime$1^1296.13, $phys_ptr_cast(P#ls, ^LocalStores));
                    // assume @_vcc_pre_static_wrap(@state); 
                    assume $pre_static_wrap($s);
                    // @_vcc_static_wrap(pure(ls), staticWrapState#298, owns#300)
                    call $static_wrap($phys_ptr_cast(P#ls, ^LocalStores), staticWrapState#298, owns#300);
                    assume $good_state_ext(#tok$1^1316.6, $s);
                    // assert @inv_check(@_vcc_set_eq(@_vcc_owns(@state, ls), @_vcc_set_empty)); 
                    assert $set_eq($owns($s, $phys_ptr_cast(P#ls, ^LocalStores)), $set_empty());
                    // assert @inv_check(<=(*((ls->len)), 100000000)); 
                    assert $rd_inv($s, LocalStores.len, $phys_ptr_cast(P#ls, ^LocalStores)) <= 100000000;
                    // assert @inv_check(||(==(*((ls->tainted_key)), -1), &&(>=(*((ls->tainted_key)), 0), <(*((ls->tainted_key)), 10000)))); 
                    assert $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) == -1 || ($rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) >= 0 && $rd_inv($s, LocalStores.tainted_key, $phys_ptr_cast(P#ls, ^LocalStores)) < 10000);
                    // assume @_vcc_full_stop(@state); 
                    assume $full_stop($s);
                    // _Bool ite#33; 
                    // _Bool ite#34; 
                    // int32_t res_star#108; 
                    // res_star#108 := star(); 
                    call res_star#108 := star();
                    assume $full_stop_ext(#tok$1^1317.7, $s);
                    // ite#34 := (_Bool)res_star#108; 
                    ite#34 := $int_to_bool(res_star#108);
                    assume true;
                    // if (ite#34) ...
                    if (ite#34)
                    {
                      anon267:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                        // assert @reads_check_normal((ps->size)); 
                        assert $thread_local($s, $phys_ptr_cast(P#ps, ^PendingSet));
                        // ite#33 := >(*((ps->size)), 0); 
                        ite#33 := $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet)) > 0;
                    }
                    else
                    {
                      anon268:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                        // ite#33 := false; 
                        ite#33 := false;
                    }

                  anon274:
                    assume true;
                    // if (ite#33) ...
                    if (ite#33)
                    {
                      anon269:
                        // assert @writes_check(ls); 
                        assert $top_writable($s, #wrTime$1^1296.13, $phys_ptr_cast(P#ls, ^LocalStores));
                        // assert @writes_check(ps); 
                        assert $top_writable($s, #wrTime$1^1296.13, $phys_ptr_cast(P#ps, ^PendingSet));
                        // stmt rm_pending_rr(pl, ls, ps); 
                        call rm_pending_rr($phys_ptr_cast(P#pl, ^PreferenceLists), $phys_ptr_cast(P#ls, ^LocalStores), $phys_ptr_cast(P#ps, ^PendingSet));
                        assume $full_stop_ext(#tok$1^1318.5, $s);
                        // consistent := 0; 
                        L#consistent := 0;
                    }
                    else
                    {
                      anon270:
                        // assert @_vcc_possibly_unreachable; 
                        assert {:PossiblyUnreachable true} true;
                    }

                  anon275:
                    // assert @in_range_i4(+(i, 1)); 
                    assert $in_range_i4(L#i + 1);
                    // i := +(i, 1); 
                    L#i := L#i + 1;
                }
                else
                {
                  anon276:
                    // assert @_vcc_possibly_unreachable; 
                    assert {:PossiblyUnreachable true} true;
                    // goto #break_68; 
                    goto #break_68;
                }

              #continue_68:
                // int32_t loopDecrEnd#326; 
                // loopDecrEnd#326 := -(3200, i); 
                loopDecrEnd#326 := 3200 - L#i;
                // assert @prelude_int_lt_or(loopDecrEnd#326, loopDecrBeg#325, false); 
                assert $int_lt_or(loopDecrEnd#326, loopDecrBeg#325, false);
                assume true;
            }

          anon282:
            assume $full_stop_ext(#tok$1^1294.3, $s);

          #break_68:
            assume true;
            // if (==(consistent, 1)) ...
            if (L#consistent == 1)
            {
              anon278:
                // goto #break_66; 
                goto #break_66;
            }
            else
            {
              anon279:
                // assert @_vcc_possibly_unreachable; 
                assert {:PossiblyUnreachable true} true;
            }
        }
        else
        {
          anon283:
            // assert @_vcc_possibly_unreachable; 
            assert {:PossiblyUnreachable true} true;
            // goto #break_66; 
            goto #break_66;
        }

      #continue_66:
        // uint64_t loopDecrEnd#328; 
        // loopDecrEnd#328 := *((ps->size)); 
        loopDecrEnd#328 := $rd_inv($s, PendingSet.size, $phys_ptr_cast(P#ps, ^PendingSet));
        // assert @prelude_int_lt_or(loopDecrEnd#328, loopDecrBeg#327, false); 
        assert $int_lt_or(loopDecrEnd#328, loopDecrBeg#327, false);
        assume true;
    }

  anon286:
    assume $full_stop_ext(#tok$1^1253.2, $s);

  #break_66:
    // assert forall(int32_t j; @in_range_i4(j); ==>(&&(>=(j, 0), <(j, 3200)), ==(*((ls->local_store)[*((pl->preference_list)[+(*(coord, 3200), j)])]), val))); 
    assert (forall Q#j$1^1328.11#tc1#1390: int :: {:weight 10} { $op_mul(P#coord, 3200) + Q#j$1^1328.11#tc1#1390 } $in_range_i4(Q#j$1^1328.11#tc1#1390) ==> Q#j$1^1328.11#tc1#1390 >= 0 && Q#j$1^1328.11#tc1#1390 < 3200 ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1328.11#tc1#1390)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1328.11#tc1#1390))))), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1328.11#tc1#1390)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1328.11#tc1#1390)))))) == L#val);
    // assume forall(int32_t j; @in_range_i4(j); ==>(&&(>=(j, 0), <(j, 3200)), ==(*((ls->local_store)[*((pl->preference_list)[+(*(coord, 3200), j)])]), val))); 
    assume (forall Q#j$1^1328.11#tc1#1468: int :: {:weight 10} { $op_mul(P#coord, 3200) + Q#j$1^1328.11#tc1#1468 } $in_range_i4(Q#j$1^1328.11#tc1#1468) ==> Q#j$1^1328.11#tc1#1468 >= 0 && Q#j$1^1328.11#tc1#1468 < 3200 ==> $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1328.11#tc1#1468)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1328.11#tc1#1468))))), $prim_emb($idx($dot($phys_ptr_cast(P#ls, ^LocalStores), LocalStores.local_store), $rd_inv($s, $field($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1328.11#tc1#1468)), $prim_emb($idx($dot($phys_ptr_cast(P#pl, ^PreferenceLists), PreferenceLists.preference_list), $op_mul(P#coord, 3200) + Q#j$1^1328.11#tc1#1468)))))) == L#val);
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



axiom (forall Q#i$1^43.10#tc1#1391: int :: {:weight 10} { $select.$map_t..^^i4.^^bool(F#empty_iset(), Q#i$1^43.10#tc1#1391) } $in_range_i4(Q#i$1^43.10#tc1#1391) ==> !$select.$map_t..^^i4.^^bool(F#empty_iset(), Q#i$1^43.10#tc1#1391));

axiom (forall Q#s$1^50.10#dt2#1392: $map_t..^^i4.^^bool, Q#i$1^50.10#tc1#1393: int :: {:weight 10} { F#delone_iset(Q#s$1^50.10#dt2#1392, Q#i$1^50.10#tc1#1393) } $in_range_i4(Q#i$1^50.10#tc1#1393) ==> $eq.$map_t..^^i4.^^bool(F#addone_iset(F#delone_iset(Q#s$1^50.10#dt2#1392, Q#i$1^50.10#tc1#1393), Q#i$1^50.10#tc1#1393), Q#s$1^50.10#dt2#1392));

axiom F#card_iset(F#empty_iset()) == 0;

axiom (forall Q#s$1^52.9#dt2#1394: $map_t..^^i4.^^bool, Q#i$1^52.9#tc1#1395: int :: {:weight 10} { $select.$map_t..^^i4.^^bool(Q#s$1^52.9#dt2#1394, Q#i$1^52.9#tc1#1395) } { F#addone_iset(Q#s$1^52.9#dt2#1394, Q#i$1^52.9#tc1#1395) } $in_range_i4(Q#i$1^52.9#tc1#1395) ==> F#card_iset(Q#s$1^52.9#dt2#1394) >= 0 && !$select.$map_t..^^i4.^^bool(Q#s$1^52.9#dt2#1394, Q#i$1^52.9#tc1#1395) ==> F#card_iset(F#addone_iset(Q#s$1^52.9#dt2#1394, Q#i$1^52.9#tc1#1395)) == F#card_iset(Q#s$1^52.9#dt2#1394) + 1);

axiom (forall Q#s$1^53.9#dt2#1396: $map_t..^^i4.^^bool, Q#i$1^53.9#tc1#1397: int :: {:weight 10} { $select.$map_t..^^i4.^^bool(Q#s$1^53.9#dt2#1396, Q#i$1^53.9#tc1#1397) } { F#addone_iset(Q#s$1^53.9#dt2#1396, Q#i$1^53.9#tc1#1397) } $in_range_i4(Q#i$1^53.9#tc1#1397) ==> F#card_iset(Q#s$1^53.9#dt2#1396) >= 0 && $select.$map_t..^^i4.^^bool(Q#s$1^53.9#dt2#1396, Q#i$1^53.9#tc1#1397) ==> F#card_iset(F#addone_iset(Q#s$1^53.9#dt2#1396, Q#i$1^53.9#tc1#1397)) == F#card_iset(Q#s$1^53.9#dt2#1396));

axiom (forall Q#s$1^55.9#dt2#1398: $map_t..^^i4.^^bool, Q#i$1^55.9#tc1#1399: int :: {:weight 10} { $select.$map_t..^^i4.^^bool(Q#s$1^55.9#dt2#1398, Q#i$1^55.9#tc1#1399) } { F#delone_iset(Q#s$1^55.9#dt2#1398, Q#i$1^55.9#tc1#1399) } $in_range_i4(Q#i$1^55.9#tc1#1399) ==> F#card_iset(Q#s$1^55.9#dt2#1398) >= 0 && $select.$map_t..^^i4.^^bool(Q#s$1^55.9#dt2#1398, Q#i$1^55.9#tc1#1399) ==> F#card_iset(F#delone_iset(Q#s$1^55.9#dt2#1398, Q#i$1^55.9#tc1#1399)) == F#card_iset(Q#s$1^55.9#dt2#1398) - 1);

axiom (forall Q#s$1^57.9#dt2#1400: $map_t..^^i4.^^bool :: {:weight 10} { F#card_iset(Q#s$1^57.9#dt2#1400) } F#card_iset(Q#s$1^57.9#dt2#1400) == 0 ==> $eq.$map_t..^^i4.^^bool(Q#s$1^57.9#dt2#1400, F#empty_iset()));

axiom (forall Q#s$1^58.9#dt2#1401: $map_t..^^i4.^^bool :: {:weight 10} { F#card_iset(Q#s$1^58.9#dt2#1401) } F#card_iset(Q#s$1^58.9#dt2#1401) >= 0);

axiom (forall Q#s$1^119.10#dt3#1402: $map_t..^^u8.^^bool, Q#i$1^119.10#tc2#1403: int :: {:weight 10} { F#delone_hset(Q#s$1^119.10#dt3#1402, Q#i$1^119.10#tc2#1403) } $in_range_u8(Q#i$1^119.10#tc2#1403) ==> $eq.$map_t..^^u8.^^bool(F#addone_hset(F#delone_hset(Q#s$1^119.10#dt3#1402, Q#i$1^119.10#tc2#1403), Q#i$1^119.10#tc2#1403), Q#s$1^119.10#dt3#1402));

axiom F#card_hset(F#empty_hset()) == 0;

axiom (forall Q#s$1^121.9#dt3#1404: $map_t..^^u8.^^bool, Q#i$1^121.9#tc2#1405: int :: {:weight 10} { $select.$map_t..^^u8.^^bool(Q#s$1^121.9#dt3#1404, Q#i$1^121.9#tc2#1405) } { F#addone_hset(Q#s$1^121.9#dt3#1404, Q#i$1^121.9#tc2#1405) } $in_range_u8(Q#i$1^121.9#tc2#1405) ==> F#card_hset(Q#s$1^121.9#dt3#1404) >= 0 && !$select.$map_t..^^u8.^^bool(Q#s$1^121.9#dt3#1404, Q#i$1^121.9#tc2#1405) ==> F#card_hset(F#addone_hset(Q#s$1^121.9#dt3#1404, Q#i$1^121.9#tc2#1405)) == F#card_hset(Q#s$1^121.9#dt3#1404) + 1);

axiom (forall Q#s$1^122.9#dt3#1406: $map_t..^^u8.^^bool, Q#i$1^122.9#tc2#1407: int :: {:weight 10} { $select.$map_t..^^u8.^^bool(Q#s$1^122.9#dt3#1406, Q#i$1^122.9#tc2#1407) } { F#delone_hset(Q#s$1^122.9#dt3#1406, Q#i$1^122.9#tc2#1407) } $in_range_u8(Q#i$1^122.9#tc2#1407) ==> F#card_hset(Q#s$1^122.9#dt3#1406) >= 0 && $select.$map_t..^^u8.^^bool(Q#s$1^122.9#dt3#1406, Q#i$1^122.9#tc2#1407) ==> F#card_hset(F#delone_hset(Q#s$1^122.9#dt3#1406, Q#i$1^122.9#tc2#1407)) == F#card_hset(Q#s$1^122.9#dt3#1406) - 1);

axiom true;

axiom 32000000 == $unchk_mul(^^i4, 10000, 3200);

axiom -1 == $unchk_sub(^^i4, 0, 1);

axiom 100000000 == $unchecked(^^u8, $unchk_mul(^^i4, 10000, 10000));

axiom -1 == $unchk_sub(^^i4, 0, 1);

axiom true;

axiom -1 == $unchk_sub(^^i4, 0, 1);

axiom -1 == $unchk_sub(^^i4, 0, 1);

function F#lambda#55(#l1: $map_t..^^u8.^^bool, #l0: int) : $map_t..^^u8.^^bool;

const unique cf#lambda#55: $pure_function;

axiom $function_arg_type(cf#lambda#55, 0, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#55, 1, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#55, 2, ^^u8);

procedure lambda#55(#l1: $map_t..^^u8.^^bool, #l0: int) returns ($result: $map_t..^^u8.^^bool);
  free ensures $result == F#lambda#55(#l1, #l0);
  free ensures $call_transition(old($s), $s);



axiom (forall Q#h$1^960.22#tc2#1313: int, #l1: $map_t..^^u8.^^bool, #l0: int :: {:weight 10} { $select.$map_t..^^u8.^^bool(F#lambda#55(#l1, #l0), Q#h$1^960.22#tc2#1313) } $in_range_u8(Q#h$1^960.22#tc2#1313) && $in_range_u8(#l0) ==> $select.$map_t..^^u8.^^bool(F#lambda#55(#l1, #l0), Q#h$1^960.22#tc2#1313) == (if Q#h$1^960.22#tc2#1313 == #l0 then false else $select.$map_t..^^u8.^^bool(#l1, Q#h$1^960.22#tc2#1313)));

function F#lambda#54(#l1: $map_t..^^u8.^^bool, #l0: int) : $map_t..^^u8.^^bool;

const unique cf#lambda#54: $pure_function;

axiom $function_arg_type(cf#lambda#54, 0, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#54, 1, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#54, 2, ^^u8);

procedure lambda#54(#l1: $map_t..^^u8.^^bool, #l0: int) returns ($result: $map_t..^^u8.^^bool);
  free ensures $result == F#lambda#54(#l1, #l0);
  free ensures $call_transition(old($s), $s);



axiom (forall Q#h$1^907.22#tc2#1300: int, #l1: $map_t..^^u8.^^bool, #l0: int :: {:weight 10} { $select.$map_t..^^u8.^^bool(F#lambda#54(#l1, #l0), Q#h$1^907.22#tc2#1300) } $in_range_u8(Q#h$1^907.22#tc2#1300) && $in_range_u8(#l0) ==> $select.$map_t..^^u8.^^bool(F#lambda#54(#l1, #l0), Q#h$1^907.22#tc2#1300) == (if Q#h$1^907.22#tc2#1300 == #l0 then false else $select.$map_t..^^u8.^^bool(#l1, Q#h$1^907.22#tc2#1300)));

function F#lambda#53(#l1: $map_t..^^u8.^^bool, #l0: int) : $map_t..^^u8.^^bool;

const unique cf#lambda#53: $pure_function;

axiom $function_arg_type(cf#lambda#53, 0, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#53, 1, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#53, 2, ^^u8);

procedure lambda#53(#l1: $map_t..^^u8.^^bool, #l0: int) returns ($result: $map_t..^^u8.^^bool);
  free ensures $result == F#lambda#53(#l1, #l0);
  free ensures $call_transition(old($s), $s);



axiom (forall Q#h$1^815.21#tc2#1285: int, #l1: $map_t..^^u8.^^bool, #l0: int :: {:weight 10} { $select.$map_t..^^u8.^^bool(F#lambda#53(#l1, #l0), Q#h$1^815.21#tc2#1285) } $in_range_u8(Q#h$1^815.21#tc2#1285) && $in_range_u8(#l0) ==> $select.$map_t..^^u8.^^bool(F#lambda#53(#l1, #l0), Q#h$1^815.21#tc2#1285) == (if Q#h$1^815.21#tc2#1285 == #l0 then false else $select.$map_t..^^u8.^^bool(#l1, Q#h$1^815.21#tc2#1285)));

function F#lambda#52(#l1: $map_t..^^u8.^^bool, #l0: int) : $map_t..^^u8.^^bool;

const unique cf#lambda#52: $pure_function;

axiom $function_arg_type(cf#lambda#52, 0, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#52, 1, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#52, 2, ^^u8);

procedure lambda#52(#l1: $map_t..^^u8.^^bool, #l0: int) returns ($result: $map_t..^^u8.^^bool);
  free ensures $result == F#lambda#52(#l1, #l0);
  free ensures $call_transition(old($s), $s);



axiom (forall Q#h$1^712.21#tc2#1259: int, #l1: $map_t..^^u8.^^bool, #l0: int :: {:weight 10} { $select.$map_t..^^u8.^^bool(F#lambda#52(#l1, #l0), Q#h$1^712.21#tc2#1259) } $in_range_u8(Q#h$1^712.21#tc2#1259) && $in_range_u8(#l0) ==> $select.$map_t..^^u8.^^bool(F#lambda#52(#l1, #l0), Q#h$1^712.21#tc2#1259) == (if Q#h$1^712.21#tc2#1259 == #l0 then false else $select.$map_t..^^u8.^^bool(#l1, Q#h$1^712.21#tc2#1259)));

function F#lambda#51(#l1: $map_t..^^u8.^^bool, #l0: int) : $map_t..^^u8.^^bool;

const unique cf#lambda#51: $pure_function;

axiom $function_arg_type(cf#lambda#51, 0, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#51, 1, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#51, 2, ^^u8);

procedure lambda#51(#l1: $map_t..^^u8.^^bool, #l0: int) returns ($result: $map_t..^^u8.^^bool);
  free ensures $result == F#lambda#51(#l1, #l0);
  free ensures $call_transition(old($s), $s);



axiom (forall Q#h$1^658.21#tc2#1250: int, #l1: $map_t..^^u8.^^bool, #l0: int :: {:weight 10} { $select.$map_t..^^u8.^^bool(F#lambda#51(#l1, #l0), Q#h$1^658.21#tc2#1250) } $in_range_u8(Q#h$1^658.21#tc2#1250) && $in_range_u8(#l0) ==> $select.$map_t..^^u8.^^bool(F#lambda#51(#l1, #l0), Q#h$1^658.21#tc2#1250) == (if Q#h$1^658.21#tc2#1250 == #l0 then false else $select.$map_t..^^u8.^^bool(#l1, Q#h$1^658.21#tc2#1250)));

function F#lambda#50(#l1: $map_t..^^u8.^^bool, #l0: int) : $map_t..^^u8.^^bool;

const unique cf#lambda#50: $pure_function;

axiom $function_arg_type(cf#lambda#50, 0, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#50, 1, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#50, 2, ^^u8);

procedure lambda#50(#l1: $map_t..^^u8.^^bool, #l0: int) returns ($result: $map_t..^^u8.^^bool);
  free ensures $result == F#lambda#50(#l1, #l0);
  free ensures $call_transition(old($s), $s);



axiom (forall Q#j$1^118.12#tc2#1428: int, #l1: $map_t..^^u8.^^bool, #l0: int :: {:weight 10} { $select.$map_t..^^u8.^^bool(F#lambda#50(#l1, #l0), Q#j$1^118.12#tc2#1428) } $in_range_u8(Q#j$1^118.12#tc2#1428) && $in_range_u8(#l0) ==> $select.$map_t..^^u8.^^bool(F#lambda#50(#l1, #l0), Q#j$1^118.12#tc2#1428) == (if #l0 == Q#j$1^118.12#tc2#1428 then false else $select.$map_t..^^u8.^^bool(#l1, Q#j$1^118.12#tc2#1428)));

function F#lambda#49(#l1: $map_t..^^u8.^^bool, #l0: int) : $map_t..^^u8.^^bool;

const unique cf#lambda#49: $pure_function;

axiom $function_arg_type(cf#lambda#49, 0, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#49, 1, $map_t(^^u8, ^^bool));

axiom $function_arg_type(cf#lambda#49, 2, ^^u8);

procedure lambda#49(#l1: $map_t..^^u8.^^bool, #l0: int) returns ($result: $map_t..^^u8.^^bool);
  free ensures $result == F#lambda#49(#l1, #l0);
  free ensures $call_transition(old($s), $s);



axiom (forall Q#j$1^115.12#tc2#1427: int, #l1: $map_t..^^u8.^^bool, #l0: int :: {:weight 10} { $select.$map_t..^^u8.^^bool(F#lambda#49(#l1, #l0), Q#j$1^115.12#tc2#1427) } $in_range_u8(Q#j$1^115.12#tc2#1427) && $in_range_u8(#l0) ==> $select.$map_t..^^u8.^^bool(F#lambda#49(#l1, #l0), Q#j$1^115.12#tc2#1427) == (#l0 == Q#j$1^115.12#tc2#1427 || $select.$map_t..^^u8.^^bool(#l1, Q#j$1^115.12#tc2#1427)));

function F#lambda#48() : $map_t..^^u8.^^bool;

const unique cf#lambda#48: $pure_function;

axiom $function_arg_type(cf#lambda#48, 0, $map_t(^^u8, ^^bool));

procedure lambda#48() returns ($result: $map_t..^^u8.^^bool);
  free ensures $result == F#lambda#48();
  free ensures $call_transition(old($s), $s);



axiom (forall Q#i$1^112.12#tc2#1426: int :: {:weight 10} { $select.$map_t..^^u8.^^bool(F#lambda#48(), Q#i$1^112.12#tc2#1426) } $in_range_u8(Q#i$1^112.12#tc2#1426) ==> $select.$map_t..^^u8.^^bool(F#lambda#48(), Q#i$1^112.12#tc2#1426) == false);

function F#lambda#47(#l1: $map_t..^^i4.^^bool, #l0: int) : $map_t..^^i4.^^bool;

const unique cf#lambda#47: $pure_function;

axiom $function_arg_type(cf#lambda#47, 0, $map_t(^^i4, ^^bool));

axiom $function_arg_type(cf#lambda#47, 1, $map_t(^^i4, ^^bool));

axiom $function_arg_type(cf#lambda#47, 2, ^^i4);

procedure lambda#47(#l1: $map_t..^^i4.^^bool, #l0: int) returns ($result: $map_t..^^i4.^^bool);
  free ensures $result == F#lambda#47(#l1, #l0);
  free ensures $call_transition(old($s), $s);



axiom (forall Q#j$1^49.12#tc1#1425: int, #l1: $map_t..^^i4.^^bool, #l0: int :: {:weight 10} { $select.$map_t..^^i4.^^bool(F#lambda#47(#l1, #l0), Q#j$1^49.12#tc1#1425) } $in_range_i4(Q#j$1^49.12#tc1#1425) && $in_range_i4(#l0) ==> $select.$map_t..^^i4.^^bool(F#lambda#47(#l1, #l0), Q#j$1^49.12#tc1#1425) == (if #l0 == Q#j$1^49.12#tc1#1425 then false else $select.$map_t..^^i4.^^bool(#l1, Q#j$1^49.12#tc1#1425)));

function F#lambda#46(#l1: $map_t..^^i4.^^bool, #l0: int) : $map_t..^^i4.^^bool;

const unique cf#lambda#46: $pure_function;

axiom $function_arg_type(cf#lambda#46, 0, $map_t(^^i4, ^^bool));

axiom $function_arg_type(cf#lambda#46, 1, $map_t(^^i4, ^^bool));

axiom $function_arg_type(cf#lambda#46, 2, ^^i4);

procedure lambda#46(#l1: $map_t..^^i4.^^bool, #l0: int) returns ($result: $map_t..^^i4.^^bool);
  free ensures $result == F#lambda#46(#l1, #l0);
  free ensures $call_transition(old($s), $s);



axiom (forall Q#j$1^46.12#tc1#1424: int, #l1: $map_t..^^i4.^^bool, #l0: int :: {:weight 10} { $select.$map_t..^^i4.^^bool(F#lambda#46(#l1, #l0), Q#j$1^46.12#tc1#1424) } $in_range_i4(Q#j$1^46.12#tc1#1424) && $in_range_i4(#l0) ==> $select.$map_t..^^i4.^^bool(F#lambda#46(#l1, #l0), Q#j$1^46.12#tc1#1424) == (#l0 == Q#j$1^46.12#tc1#1424 || $select.$map_t..^^i4.^^bool(#l1, Q#j$1^46.12#tc1#1424)));

function F#lambda#45() : $map_t..^^i4.^^bool;

const unique cf#lambda#45: $pure_function;

axiom $function_arg_type(cf#lambda#45, 0, $map_t(^^i4, ^^bool));

procedure lambda#45() returns ($result: $map_t..^^i4.^^bool);
  free ensures $result == F#lambda#45();
  free ensures $call_transition(old($s), $s);



axiom (forall Q#i$1^42.12#tc1#1423: int :: {:weight 10} { $select.$map_t..^^i4.^^bool(F#lambda#45(), Q#i$1^42.12#tc1#1423) } $in_range_i4(Q#i$1^42.12#tc1#1423) ==> $select.$map_t..^^i4.^^bool(F#lambda#45(), Q#i$1^42.12#tc1#1423) == false);

procedure is_the_last_tainted#reads(P#key: int, P#tainted_key: int, P#tainted_coord: int, P#dst_node: int, P#ps: $ptr);
  requires $reads_check_pre($s);
  modifies $s, $cev_pc;
  ensures F#is_the_last_tainted(old($s), P#key, P#tainted_key, P#tainted_coord, P#dst_node, $phys_ptr_cast(P#ps, ^PendingSet)) == F#is_the_last_tainted($s, P#key, P#tainted_key, P#tainted_coord, P#dst_node, $phys_ptr_cast(P#ps, ^PendingSet));
  ensures $reads_check_post($s);
  free ensures $writes_nothing(old($s), $s);
  free ensures $call_transition(old($s), $s);



implementation is_the_last_tainted#reads(P#key: int, P#tainted_key: int, P#tainted_coord: int, P#dst_node: int, P#ps: $ptr)
{
  var #wrTime$1^593.3: int;
  var #stackframe: int;

  anon287:
    assume $function_entry($s);
    assume $full_stop_ext(#tok$1^593.3, $s);
    assume #wrTime$1^593.3 == $current_timestamp($s);
    assume $def_writes($s, #wrTime$1^593.3, (lambda #p: $ptr :: false));
    // assume ==(tainted_coord, get_coord_for_key(tainted_key)); 
    assume P#tainted_coord == F#get_coord_for_key(P#tainted_key);
    // assume @in_int_range(key); 
    assume $in_range_i4(P#key);
    // assume @in_int_range(tainted_key); 
    assume $in_range_i4(P#tainted_key);
    // assume @in_int_range(tainted_coord); 
    assume $in_range_i4(P#tainted_coord);
    // assume @in_int_range(dst_node); 
    assume $in_range_i4(P#dst_node);
    // assume @in_int_range(ps); 
    assume true;
    // assume @can_use_frame_axiom_of(get_coord_for_key()); 
    assume $can_use_frame_axiom_of(cf#get_coord_for_key);
    // assume @_vcc_in_domain(@state, ps, ps); 
    assume $in_domain_lab($s, $phys_ptr_cast(P#ps, ^PendingSet), $phys_ptr_cast(P#ps, ^PendingSet), l#public);
    // @_vcc_reads_havoc
    call $reads_havoc();
    assume $full_stop_ext(#tok$1^593.3, $s);
    // assume @reads_same(ps); 
    assume $read_version($s, $phys_ptr_cast(P#ps, ^PendingSet)) == old($read_version($s, $phys_ptr_cast(P#ps, ^PendingSet)));
    // assume ==(tainted_coord, get_coord_for_key(tainted_key)); 
    assume P#tainted_coord == F#get_coord_for_key(P#tainted_key);
    // assume @in_int_range(key); 
    assume $in_range_i4(P#key);
    // assume @in_int_range(tainted_key); 
    assume $in_range_i4(P#tainted_key);
    // assume @in_int_range(tainted_coord); 
    assume $in_range_i4(P#tainted_coord);
    // assume @in_int_range(dst_node); 
    assume $in_range_i4(P#dst_node);
    // assume @in_int_range(ps); 
    assume true;
    // return; 
    assume true;
    assert $position_marker();
    goto #exit;

  #exit:
}



const unique l#public: $label;

type $map_t..^^i4.^^i4;

function $select.$map_t..^^i4.^^i4(M: $map_t..^^i4.^^i4, p: int) : int;

function $store.$map_t..^^i4.^^i4(M: $map_t..^^i4.^^i4, p: int, v: int) : $map_t..^^i4.^^i4;

function $eq.$map_t..^^i4.^^i4(M1: $map_t..^^i4.^^i4, M2: $map_t..^^i4.^^i4) : bool;

const MT#$select.$map_t..^^i4.^^i4: $ctype;

axiom MT#$select.$map_t..^^i4.^^i4 == $map_t(^^i4, ^^i4);

const $zero.$map_t..^^i4.^^i4: $map_t..^^i4.^^i4;

axiom (forall M: $map_t..^^i4.^^i4, p: int, v: int :: true);

axiom (forall M: $map_t..^^i4.^^i4, p: int, v: int, q: int :: $select.$map_t..^^i4.^^i4($store.$map_t..^^i4.^^i4(M, q, v), p) == (if $unchecked(^^i4, p) == $unchecked(^^i4, q) then $unchecked(^^i4, v) else $select.$map_t..^^i4.^^i4(M, p)));

axiom (forall M1: $map_t..^^i4.^^i4, M2: $map_t..^^i4.^^i4 :: { $eq.$map_t..^^i4.^^i4(M1, M2) } (forall p: int :: $unchecked(^^i4, $select.$map_t..^^i4.^^i4(M1, $unchecked(^^i4, p))) == $unchecked(^^i4, $select.$map_t..^^i4.^^i4(M2, $unchecked(^^i4, p)))) ==> $eq.$map_t..^^i4.^^i4(M1, M2));

axiom (forall M1: $map_t..^^i4.^^i4, M2: $map_t..^^i4.^^i4 :: { $eq.$map_t..^^i4.^^i4(M1, M2) } $eq.$map_t..^^i4.^^i4(M1, M2) ==> M1 == M2);

axiom $int_to_map_t..^^i4.^^i4(0) == $zero.$map_t..^^i4.^^i4;

axiom (forall p: int :: $select.$map_t..^^i4.^^i4($zero.$map_t..^^i4.^^i4, p) == 0);

axiom (forall M: $map_t..^^i4.^^i4, p: int :: $in_range_t(^^i4, $select.$map_t..^^i4.^^i4(M, p)));

type $map_t..^^u8.^^bool;

function $select.$map_t..^^u8.^^bool(M: $map_t..^^u8.^^bool, p: int) : bool;

function $store.$map_t..^^u8.^^bool(M: $map_t..^^u8.^^bool, p: int, v: bool) : $map_t..^^u8.^^bool;

function $eq.$map_t..^^u8.^^bool(M1: $map_t..^^u8.^^bool, M2: $map_t..^^u8.^^bool) : bool;

const MT#$select.$map_t..^^u8.^^bool: $ctype;

axiom MT#$select.$map_t..^^u8.^^bool == $map_t(^^u8, ^^bool);

const $zero.$map_t..^^u8.^^bool: $map_t..^^u8.^^bool;

axiom (forall M: $map_t..^^u8.^^bool, p: int, v: bool :: true);

axiom (forall M: $map_t..^^u8.^^bool, p: int, v: bool, q: int :: $select.$map_t..^^u8.^^bool($store.$map_t..^^u8.^^bool(M, q, v), p) == (if $unchecked(^^u8, p) == $unchecked(^^u8, q) then v else $select.$map_t..^^u8.^^bool(M, p)));

axiom (forall M1: $map_t..^^u8.^^bool, M2: $map_t..^^u8.^^bool :: { $eq.$map_t..^^u8.^^bool(M1, M2) } (forall p: int :: $select.$map_t..^^u8.^^bool(M1, $unchecked(^^u8, p)) == $select.$map_t..^^u8.^^bool(M2, $unchecked(^^u8, p))) ==> $eq.$map_t..^^u8.^^bool(M1, M2));

axiom (forall M1: $map_t..^^u8.^^bool, M2: $map_t..^^u8.^^bool :: { $eq.$map_t..^^u8.^^bool(M1, M2) } $eq.$map_t..^^u8.^^bool(M1, M2) ==> M1 == M2);

axiom $int_to_map_t..^^u8.^^bool(0) == $zero.$map_t..^^u8.^^bool;

axiom (forall p: int :: $select.$map_t..^^u8.^^bool($zero.$map_t..^^u8.^^bool, p) == false);

type $map_t..^^u8.^^u8;

function $select.$map_t..^^u8.^^u8(M: $map_t..^^u8.^^u8, p: int) : int;

function $store.$map_t..^^u8.^^u8(M: $map_t..^^u8.^^u8, p: int, v: int) : $map_t..^^u8.^^u8;

function $eq.$map_t..^^u8.^^u8(M1: $map_t..^^u8.^^u8, M2: $map_t..^^u8.^^u8) : bool;

const MT#$select.$map_t..^^u8.^^u8: $ctype;

axiom MT#$select.$map_t..^^u8.^^u8 == $map_t(^^u8, ^^u8);

const $zero.$map_t..^^u8.^^u8: $map_t..^^u8.^^u8;

axiom (forall M: $map_t..^^u8.^^u8, p: int, v: int :: true);

axiom (forall M: $map_t..^^u8.^^u8, p: int, v: int, q: int :: $select.$map_t..^^u8.^^u8($store.$map_t..^^u8.^^u8(M, q, v), p) == (if $unchecked(^^u8, p) == $unchecked(^^u8, q) then $unchecked(^^u8, v) else $select.$map_t..^^u8.^^u8(M, p)));

axiom (forall M1: $map_t..^^u8.^^u8, M2: $map_t..^^u8.^^u8 :: { $eq.$map_t..^^u8.^^u8(M1, M2) } (forall p: int :: $unchecked(^^u8, $select.$map_t..^^u8.^^u8(M1, $unchecked(^^u8, p))) == $unchecked(^^u8, $select.$map_t..^^u8.^^u8(M2, $unchecked(^^u8, p)))) ==> $eq.$map_t..^^u8.^^u8(M1, M2));

axiom (forall M1: $map_t..^^u8.^^u8, M2: $map_t..^^u8.^^u8 :: { $eq.$map_t..^^u8.^^u8(M1, M2) } $eq.$map_t..^^u8.^^u8(M1, M2) ==> M1 == M2);

axiom $int_to_map_t..^^u8.^^u8(0) == $zero.$map_t..^^u8.^^u8;

axiom (forall p: int :: $select.$map_t..^^u8.^^u8($zero.$map_t..^^u8.^^u8, p) == 0);

axiom (forall M: $map_t..^^u8.^^u8, p: int :: $in_range_t(^^u8, $select.$map_t..^^u8.^^u8(M, p)));

type $map_t..^^i4.^^bool;

function $select.$map_t..^^i4.^^bool(M: $map_t..^^i4.^^bool, p: int) : bool;

function $store.$map_t..^^i4.^^bool(M: $map_t..^^i4.^^bool, p: int, v: bool) : $map_t..^^i4.^^bool;

function $eq.$map_t..^^i4.^^bool(M1: $map_t..^^i4.^^bool, M2: $map_t..^^i4.^^bool) : bool;

const MT#$select.$map_t..^^i4.^^bool: $ctype;

axiom MT#$select.$map_t..^^i4.^^bool == $map_t(^^i4, ^^bool);

const $zero.$map_t..^^i4.^^bool: $map_t..^^i4.^^bool;

axiom (forall M: $map_t..^^i4.^^bool, p: int, v: bool :: true);

axiom (forall M: $map_t..^^i4.^^bool, p: int, v: bool, q: int :: $select.$map_t..^^i4.^^bool($store.$map_t..^^i4.^^bool(M, q, v), p) == (if $unchecked(^^i4, p) == $unchecked(^^i4, q) then v else $select.$map_t..^^i4.^^bool(M, p)));

axiom (forall M1: $map_t..^^i4.^^bool, M2: $map_t..^^i4.^^bool :: { $eq.$map_t..^^i4.^^bool(M1, M2) } (forall p: int :: $select.$map_t..^^i4.^^bool(M1, $unchecked(^^i4, p)) == $select.$map_t..^^i4.^^bool(M2, $unchecked(^^i4, p))) ==> $eq.$map_t..^^i4.^^bool(M1, M2));

axiom (forall M1: $map_t..^^i4.^^bool, M2: $map_t..^^i4.^^bool :: { $eq.$map_t..^^i4.^^bool(M1, M2) } $eq.$map_t..^^i4.^^bool(M1, M2) ==> M1 == M2);

axiom $int_to_map_t..^^i4.^^bool(0) == $zero.$map_t..^^i4.^^bool;

axiom (forall p: int :: $select.$map_t..^^i4.^^bool($zero.$map_t..^^i4.^^bool, p) == false);

const unique #tok$1^593.3: $token;

const unique #tok$1^1318.5: $token;

const unique #tok$1^1317.7: $token;

const unique #tok$1^1316.6: $token;

const unique #tok$1^1315.4: $token;

const unique #tok$1^1314.6: $token;

const unique #tok$1^1310.5: $token;

const unique #tok$1^1308.7: $token;

const unique #tok$1^1294.3: $token;

const unique #tok$1^1296.13: $token;

const unique #tok$1^1287.5: $token;

const unique #tok$1^1286.7: $token;

const unique #tok$1^1284.10: $token;

const unique #tok$1^1281.5: $token;

const unique #tok$1^1280.7: $token;

const unique #tok$1^1267.3: $token;

const unique #tok$1^1253.2: $token;

const unique #tok$1^1262.12: $token;

const unique #tok$1^1231.1: $token;

const unique #tok$1^1212.2: $token;

const unique #tok$1^1199.2: $token;

const unique #tok$1^1198.2: $token;

const unique #tok$1^1197.2: $token;

const unique #tok$1^1178.3: $token;

const unique #tok$1^1164.18: $token;

const unique #tok$1^1162.4: $token;

const unique #tok$1^1161.20: $token;

const unique #tok$1^1160.18: $token;

const unique #tok$1^1136.2: $token;

const unique #tok$1^1152.12: $token;

const unique #tok$1^1134.19: $token;

const unique #tok$1^1127.2: $token;

const unique #tok$1^1126.2: $token;

const unique #tok$1^1125.2: $token;

const unique #tok$1^1124.2: $token;

const unique #tok$1^1123.2: $token;

const unique #tok$1^1113.1: $token;

const unique #tok$1^1079.5: $token;

const unique #tok$1^1075.5: $token;

const unique #tok$1^1074.8: $token;

const unique #tok$1^1070.4: $token;

const unique #tok$1^1066.4: $token;

const unique #tok$1^1051.3: $token;

const unique #tok$1^1061.13: $token;

const unique #tok$1^1035.1: $token;

const unique #tok$1^1031.5: $token;

const unique #tok$1^1030.3: $token;

const unique #tok$1^1029.5: $token;

const unique #tok$1^1024.2: $token;

const unique #tok$1^1025.12: $token;

const unique #tok$1^1018.1: $token;

const unique #tok$1^1014.5: $token;

const unique #tok$1^1013.3: $token;

const unique #tok$1^1013.23: $token;

const unique #tok$1^1012.5: $token;

const unique #tok$1^1007.2: $token;

const unique #tok$1^1008.12: $token;

const unique #tok$1^1001.1: $token;

const unique #tok$1^998.4: $token;

const unique #tok$1^997.2: $token;

const unique #tok$1^996.4: $token;

const unique #tok$1^989.1: $token;

const unique #tok$1^972.4: $token;

const unique #tok$1^971.4: $token;

const unique #tok$1^970.10: $token;

const unique #tok$1^969.2: $token;

const unique #tok$1^966.2: $token;

const unique #tok$1^965.2: $token;

const unique #tok$1^960.10: $token;

const unique #tok$1^960.22: $token;

const unique #tok$1^958.3: $token;

const unique #tok$1^958.24: $token;

const unique #tok$1^956.3: $token;

const unique #tok$1^956.24: $token;

const unique #tok$1^952.4: $token;

const unique #tok$1^951.4: $token;

const unique #tok$1^949.12: $token;

const unique #tok$1^948.17: $token;

const unique #tok$1^924.1: $token;

const unique #tok$1^921.2: $token;

const unique #tok$1^919.4: $token;

const unique #tok$1^918.4: $token;

const unique #tok$1^917.10: $token;

const unique #tok$1^916.2: $token;

const unique #tok$1^913.2: $token;

const unique #tok$1^912.2: $token;

const unique #tok$1^907.10: $token;

const unique #tok$1^907.22: $token;

const unique #tok$1^905.3: $token;

const unique #tok$1^905.24: $token;

const unique #tok$1^903.3: $token;

const unique #tok$1^903.24: $token;

const unique #tok$1^899.4: $token;

const unique #tok$1^897.12: $token;

const unique #tok$1^896.17: $token;

const unique #tok$1^891.3: $token;

const unique #tok$1^889.5: $token;

const unique #tok$1^886.4: $token;

const unique #tok$1^884.2: $token;

const unique #tok$1^866.1: $token;

const unique #tok$1^861.2: $token;

const unique #tok$1^859.4: $token;

const unique #tok$1^858.4: $token;

const unique #tok$1^855.3: $token;

const unique #tok$1^854.11: $token;

const unique #tok$1^853.11: $token;

const unique #tok$1^853.23: $token;

const unique #tok$1^852.3: $token;

const unique #tok$1^849.4: $token;

const unique #tok$1^847.6: $token;

const unique #tok$1^846.6: $token;

const unique #tok$1^842.4: $token;

const unique #tok$1^841.12: $token;

const unique #tok$1^840.12: $token;

const unique #tok$1^840.24: $token;

const unique #tok$1^839.4: $token;

const unique #tok$1^836.5: $token;

const unique #tok$1^834.7: $token;

const unique #tok$1^833.7: $token;

const unique #tok$1^829.11: $token;

const unique #tok$1^828.3: $token;

const unique #tok$1^825.4: $token;

const unique #tok$1^824.2: $token;

const unique #tok$1^823.2: $token;

const unique #tok$1^815.10: $token;

const unique #tok$1^815.21: $token;

const unique #tok$1^810.4: $token;

const unique #tok$1^810.25: $token;

const unique #tok$1^807.5: $token;

const unique #tok$1^807.26: $token;

const unique #tok$1^805.4: $token;

const unique #tok$1^805.25: $token;

const unique #tok$1^802.3: $token;

const unique #tok$1^802.23: $token;

const unique #tok$1^797.23: $token;

const unique #tok$1^796.24: $token;

const unique #tok$1^794.12: $token;

const unique #tok$1^793.17: $token;

const unique #tok$1^790.4: $token;

const unique #tok$1^789.4: $token;

const unique #tok$1^786.3: $token;

const unique #tok$1^784.5: $token;

const unique #tok$1^782.4: $token;

const unique #tok$1^780.2: $token;

const unique #tok$1^751.1: $token;

const unique #tok$1^721.4: $token;

const unique #tok$1^720.2: $token;

const unique #tok$1^718.4: $token;

const unique #tok$1^717.2: $token;

const unique #tok$1^716.2: $token;

const unique #tok$1^712.10: $token;

const unique #tok$1^712.21: $token;

const unique #tok$1^711.4: $token;

const unique #tok$1^710.4: $token;

const unique #tok$1^708.12: $token;

const unique #tok$1^707.17: $token;

const unique #tok$1^690.1: $token;

const unique #tok$1^686.4: $token;

const unique #tok$1^685.4: $token;

const unique #tok$1^682.3: $token;

const unique #tok$1^681.11: $token;

const unique #tok$1^680.11: $token;

const unique #tok$1^680.23: $token;

const unique #tok$1^679.3: $token;

const unique #tok$1^676.4: $token;

const unique #tok$1^675.12: $token;

const unique #tok$1^674.12: $token;

const unique #tok$1^674.24: $token;

const unique #tok$1^673.4: $token;

const unique #tok$1^671.11: $token;

const unique #tok$1^670.3: $token;

const unique #tok$1^667.4: $token;

const unique #tok$1^666.2: $token;

const unique #tok$1^665.2: $token;

const unique #tok$1^658.10: $token;

const unique #tok$1^658.21: $token;

const unique #tok$1^654.5: $token;

const unique #tok$1^654.26: $token;

const unique #tok$1^651.6: $token;

const unique #tok$1^651.27: $token;

const unique #tok$1^649.5: $token;

const unique #tok$1^649.26: $token;

const unique #tok$1^646.4: $token;

const unique #tok$1^646.24: $token;

const unique #tok$1^644.7: $token;

const unique #tok$1^642.4: $token;

const unique #tok$1^641.4: $token;

const unique #tok$1^640.4: $token;

const unique #tok$1^638.23: $token;

const unique #tok$1^637.24: $token;

const unique #tok$1^635.12: $token;

const unique #tok$1^634.17: $token;

const unique #tok$1^600.1: $token;

const unique #tok$1^577.4: $token;

const unique #tok$1^575.6: $token;

const unique #tok$1^574.5: $token;

const unique #tok$1^573.13: $token;

const unique #tok$1^572.13: $token;

const unique #tok$1^572.24: $token;

const unique #tok$1^571.5: $token;

const unique #tok$1^570.14: $token;

const unique #tok$1^566.6: $token;

const unique #tok$1^566.26: $token;

const unique #tok$1^565.6: $token;

const unique #tok$1^564.6: $token;

const unique #tok$1^558.5: $token;

const unique #tok$1^556.7: $token;

const unique #tok$1^554.6: $token;

const unique #tok$1^552.4: $token;

const unique #tok$1^543.5: $token;

const unique #tok$1^541.7: $token;

const unique #tok$1^537.8: $token;

const unique #tok$1^537.28: $token;

const unique #tok$1^535.9: $token;

const unique #tok$1^534.9: $token;

const unique #tok$1^527.6: $token;

const unique #tok$1^525.14: $token;

const unique #tok$1^524.14: $token;

const unique #tok$1^524.25: $token;

const unique #tok$1^523.6: $token;

const unique #tok$1^519.7: $token;

const unique #tok$1^517.9: $token;

const unique #tok$1^515.15: $token;

const unique #tok$1^514.7: $token;

const unique #tok$1^512.5: $token;

const unique #tok$1^506.5: $token;

const unique #tok$1^504.7: $token;

const unique #tok$1^502.7: $token;

const unique #tok$1^501.7: $token;

const unique #tok$1^501.28: $token;

const unique #tok$1^500.7: $token;

const unique #tok$1^497.5: $token;

const unique #tok$1^496.7: $token;

const unique #tok$1^494.5: $token;

const unique #tok$1^493.8: $token;

const unique #tok$1^471.2: $token;

const unique #tok$1^475.12: $token;

const unique #tok$1^431.1: $token;

const unique #tok$1^420.3: $token;

const unique #tok$1^418.5: $token;

const unique #tok$1^416.4: $token;

const unique #tok$1^416.25: $token;

const unique #tok$1^415.4: $token;

const unique #tok$1^412.5: $token;

const unique #tok$1^410.3: $token;

const unique #tok$1^387.2: $token;

const unique #tok$1^396.12: $token;

const unique #tok$1^364.1: $token;

const unique #tok$1^361.4: $token;

const unique #tok$1^360.2: $token;

const unique #tok$1^359.10: $token;

const unique #tok$1^359.21: $token;

const unique #tok$1^358.10: $token;

const unique #tok$1^357.10: $token;

const unique #tok$1^356.10: $token;

const unique #tok$1^356.30: $token;

const unique #tok$1^347.1: $token;

const unique #tok$1^344.4: $token;

const unique #tok$1^343.2: $token;

const unique #tok$1^342.10: $token;

const unique #tok$1^342.22: $token;

const unique #tok$1^341.10: $token;

const unique #tok$1^340.10: $token;

const unique #tok$1^339.10: $token;

const unique #tok$1^339.31: $token;

const unique #tok$1^330.1: $token;

const unique #tok$1^326.4: $token;

const unique #tok$1^325.10: $token;

const unique #tok$1^324.2: $token;

const unique #tok$1^323.10: $token;

const unique #tok$1^322.10: $token;

const unique #tok$1^322.30: $token;

const unique #tok$1^316.4: $token;

const unique #tok$1^312.3: $token;

const unique #tok$1^307.2: $token;

const unique #tok$1^298.1: $token;

const unique #tok$1^294.4: $token;

const unique #tok$1^287.12: $token;

const unique #tok$1^286.4: $token;

const unique #tok$1^277.3: $token;

const unique #tok$1^267.2: $token;

const unique #tok$1^260.1: $token;

const unique #tok$1^256.4: $token;

const unique #tok$1^250.1: $token;

const unique #tok$1^158.3: $token;

const unique #tok$1^149.3: $token;

const unique #tok$1^125.3: $token;

const unique #distTp10: $ctype;

axiom #distTp10 == $ptr_to(^swrap#WDT);

const unique #distTp9: $ctype;

axiom #distTp9 == $ptr_to(^swrap#RDT);

const unique #tok$1^216.9: $token;

const unique #distTp8: $ctype;

axiom #distTp8 == $ptr_to(^PendingSet);

const unique #distTp7: $ctype;

axiom #distTp7 == $ptr_to(^HintedHandoffStores);

const unique #distTp6: $ctype;

axiom #distTp6 == $ptr_to(^LocalStores);

const unique #distTp5: $ctype;

axiom #distTp5 == $ptr_to(^PreferenceLists);

function $map_t..^^i4.^^bool_to_int(x: $map_t..^^i4.^^bool) : int;

function $int_to_map_t..^^i4.^^bool(x: int) : $map_t..^^i4.^^bool;

axiom (forall #x: $map_t..^^i4.^^bool :: #x == $int_to_map_t..^^i4.^^bool($map_t..^^i4.^^bool_to_int(#x)));

const unique #tok$1^192.9: $token;

const unique #tok$1^169.9: $token;

function $map_t..^^u8.^^u8_to_int(x: $map_t..^^u8.^^u8) : int;

function $int_to_map_t..^^u8.^^u8(x: int) : $map_t..^^u8.^^u8;

axiom (forall #x: $map_t..^^u8.^^u8 :: #x == $int_to_map_t..^^u8.^^u8($map_t..^^u8.^^u8_to_int(#x)));

const unique #distTp4: $ctype;

axiom #distTp4 == $map_t(^^u8, ^^u8);

function $map_t..^^u8.^^bool_to_int(x: $map_t..^^u8.^^bool) : int;

function $int_to_map_t..^^u8.^^bool(x: int) : $map_t..^^u8.^^bool;

axiom (forall #x: $map_t..^^u8.^^bool :: #x == $int_to_map_t..^^u8.^^bool($map_t..^^u8.^^bool_to_int(#x)));

const unique #distTp3: $ctype;

axiom #distTp3 == $map_t(^^u8, ^^bool);

axiom $type_code_is(2, ^^u8);

const unique #tok$1^83.9: $token;

const unique #distTp2: $ctype;

axiom #distTp2 == $map_t(^^i4, ^^bool);

const unique #tok$1^69.9: $token;

function $map_t..^^i4.^^i4_to_int(x: $map_t..^^i4.^^i4) : int;

function $int_to_map_t..^^i4.^^i4(x: int) : $map_t..^^i4.^^i4;

axiom (forall #x: $map_t..^^i4.^^i4 :: #x == $int_to_map_t..^^i4.^^i4($map_t..^^i4.^^i4_to_int(#x)));

const unique #distTp1: $ctype;

axiom #distTp1 == $map_t(^^i4, ^^i4);

axiom $type_code_is(1, ^^i4);

const unique #file^C?3A?5Cwork?5Cmachine_learning?5Cverified?2Dmodel?2Dcl.c: $token;

axiom $file_name_is(1, #file^C?3A?5Cwork?5Cmachine_learning?5Cverified?2Dmodel?2Dcl.c);
