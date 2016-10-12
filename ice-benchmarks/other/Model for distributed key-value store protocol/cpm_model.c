/***********************************************************************************
   NOTE: For full verification, please perform verification of each function in 
	isolation or pass the option /z3opt:MBQI=true to VCC".
************************************************************************************/


#include <vcc.h>
#include <stdlib.h>

#define HS_SIZE 0xffffff
#define PS_SIZE 0xffffff

int RDT;
int WDT;
/****************************************************************
The proof does _not_ depend on the constant values below 
as long as the indexing into arrays, that depends on the constant
values does not cause over/under flow. 
***************************************************************/
#define VNODES        10000
#define KEYS_NUM      10000
#define NUM_REPLICAS  3000
#define PREFLIST_SIZE 3200

#define SUCCESS 1

typedef int BOOL;
#define TRUE  1
#define FALSE 0

typedef struct LiveNodes {
	BOOL live_nodes[VNODES];
} LiveNodes;


/* ----- set of integers --------- */
_(ghost typedef \bool iset_t[int])
_(ghost _(pure) \integer card_iset(iset_t s)
	_(decreases 0))  	
_(ghost _(pure) iset_t empty_iset() 
 _(decreases 0)
 _(returns \lambda int i; \false))  
 _(axiom \forall int i; !empty_iset()[i])
_(ghost _(pure) iset_t addone_iset(iset_t s, int i) 
 _(decreases 0)
 _(returns \lambda int j; i == j ? \true : s[j]))  
_(ghost _(pure) iset_t delone_iset(iset_t s, int i) 
 _(decreases 0)
 _(returns \lambda int j; i == j ? \false : s[j])) 
 _(axiom \forall iset_t s; int i; addone_iset(delone_iset(s, i), i) == s)
_(axiom card_iset(empty_iset()) == 0) 
_(axiom \forall iset_t s; int i; card_iset(s) >= 0 && !s[i] ==> card_iset(addone_iset(s, i)) == card_iset(s) + 1)
_(axiom \forall iset_t s; int i; card_iset(s) >= 0 && s[i] ==> card_iset(addone_iset(s, i)) == card_iset(s))

_(axiom \forall iset_t s; int i; card_iset(s) >= 0 && s[i] ==> card_iset(delone_iset(s, i)) == card_iset(s) - 1) 

_(axiom \forall iset_t s; card_iset(s) == 0 ==> s == empty_iset())
_(axiom \forall iset_t s; {card_iset(s) } card_iset(s) >= 0)

int _(pure) get_coord_for_key(int key)
	_(requires key >= 0 && key < KEYS_NUM)
	_(ensures \result >= 0 && \result < VNODES)
	_(decreases 0)
;
//{
	//return (VNODES * key)/KEYS_NUM;
//}

typedef struct PreferenceLists {
	_(ghost int vals[int])

	// implementation
	int preference_list[VNODES * PREFLIST_SIZE];
	_(invariant \forall int i; (i >= 0 && i < VNODES * PREFLIST_SIZE) 
		==> preference_list[i] >= 0 && preference_list[i] < VNODES)

	// coupling invariant
	_(invariant \forall int i; 
		(i >= 0 && i < VNODES * PREFLIST_SIZE) ==> vals[i] == preference_list[i])
} PreferenceLists;


typedef struct LocalStores {
	// abstraction 
	_(ghost iset_t tainted_nodes)
	_(ghost int tainted_key)
	_(ghost \natural size)

	// implementation (concrete representation)
	int local_store[VNODES * KEYS_NUM];
	size_t len;
	_(invariant len <= VNODES * KEYS_NUM)
	_(invariant tainted_key == -1 || tainted_key >= 0 && tainted_key < KEYS_NUM)

} LocalStores;


typedef size_t Hint;

_(typedef _(record) struct AbsHint {
	\natural src;
	\natural dst;
	\natural key;
} AbsHint;)

/* ---------- set of hints ------------------ */
_(ghost typedef \bool hset_t[Hint])
_(ghost _(pure) \integer card_hset(hset_t s)
	_(decreases 0))  	
_(ghost _(pure) hset_t empty_hset() 
 _(decreases 0)
 _(returns \lambda Hint i; \false))  
_(ghost _(pure) hset_t addone_hset(hset_t s, Hint h) 
 _(decreases 0)
 _(returns \lambda Hint j; h == j ? \true : s[j]))  
_(ghost _(pure) hset_t delone_hset(hset_t s, Hint h) 
 _(decreases 0)
 _(returns \lambda Hint j; h == j ? \false : s[j])) 
 _(axiom \forall hset_t s; Hint i; addone_hset(delone_hset(s, i), i) == s)
_(axiom card_hset(empty_hset()) == 0) 
_(axiom \forall hset_t s; Hint i; card_hset(s) >= 0 && !s[i] ==> card_hset(addone_hset(s, i)) == card_hset(s) + 1)
_(axiom \forall hset_t s; Hint i; card_hset(s) >= 0 &&  s[i] ==> card_hset(delone_hset(s, i)) == card_hset(s) - 1) 


_(pure) 
Hint create_hint(int src, int dst, int key _(out AbsHint ah)) 
	_(requires src >= 0 && src < VNODES)
	_(requires dst >= 0 && dst < VNODES)
	_(requires key >= 0 && key < KEYS_NUM)
	_(ensures ah.src == (\natural)src)
	_(ensures ah.dst == (\natural)dst)
	_(ensures ah.key == (\natural)key)
	_(decreases 0)
{
	Hint src_result = (size_t)src;
	Hint dst_result = (size_t)dst;
	dst_result = dst_result;
	dst_result <<= 16; 
	Hint key_result = (size_t)key;
	key_result <<= 32;
	Hint result = key_result + dst_result + src_result; 
	_(ghost ah.src = (\natural)src)
	_(ghost ah.dst = (\natural)dst)
	_(ghost ah.key = (\natural)key)

	return result;
}

_(pure)
int get_dst(Hint h) 
	_(decreases 0)
	_(ensures \result >= 0)
	_(ensures \result < VNODES)
{
	return (h >> 16) & (VNODES-1);
}

_(pure)
int get_key(Hint h) 
	_(decreases 0)
	_(ensures \result >= 0)
	_(ensures \result < KEYS_NUM)
{
	return (h >> 32) & (KEYS_NUM-1);
}

_(pure) 

typedef struct HintedHandoffStores {
	// abstraction
	_(ghost hset_t hset)
	_(ghost size_t idx[Hint])

	// tainted node abstraction
	_(ghost iset_t tainted_nodes)
	_(ghost int tkey)
	_(ghost int tcoord)

	// implementation
	Hint hint_store[HS_SIZE]; 
	size_t size;
	_(invariant size <= HS_SIZE)

	_(invariant \forall size_t i; i < size ==> hset[hint_store[i]])
	_(invariant \forall Hint h; hset[h] ==> idx[h] < size)
	_(invariant \forall Hint h; hset[h] ==> hint_store[idx[h]] == h)

	_(invariant tkey >= 0 && tkey < KEYS_NUM 
					==> tcoord == get_coord_for_key(tkey))
} HintedHandoffStores;

typedef struct PendingSet {
	// abstraction
	_(ghost hset_t pset)
	_(ghost size_t idx[Hint])

	// tainted node abstraction
	_(ghost iset_t tainted_nodes)

	_(ghost int tkey)
	_(ghost int tcoord)

	// implementation
	Hint pending[PS_SIZE]; 
	size_t size;
	_(invariant size <= PS_SIZE)

	_(invariant \forall size_t i; i < size ==> pset[pending[i]])
	_(invariant \forall Hint h; pset[h] ==> idx[h] < size)
	_(invariant \forall Hint h; pset[h] ==> pending[idx[h]] == h)

	_(invariant tkey >= 0 && tkey < KEYS_NUM 
					==> tcoord == get_coord_for_key(tkey))
} PendingSet;

typedef struct Env {
	PreferenceLists     *pl;
	LocalStores         *ls;
	HintedHandoffStores *hhs;
	PendingSet          *ps;

	_(invariant \mine(pl) && \mine(ls) && \mine(hhs) && \mine(ps))

	_(ghost int tainted_key)
	_(ghost int tainted_coord)
	_(invariant ls->tainted_key == hhs->tkey)

	_(invariant tainted_key == ls->tainted_key == hhs->tkey == ps->tkey)
	_(invariant tainted_coord == hhs->tcoord == ps->tcoord)
	_(invariant tainted_key >= 0 && tainted_key < KEYS_NUM 
					==> tainted_coord == get_coord_for_key(tainted_key))

	_(invariant tainted_key != -1 && tainted_coord == get_coord_for_key(tainted_key) ==>
		(\forall int j; (j >= 0 && j < PREFLIST_SIZE) 
				==> (ls->tainted_nodes[pl->vals[tainted_coord * PREFLIST_SIZE + j]] 
						|| hhs->tainted_nodes[pl->vals[tainted_coord * PREFLIST_SIZE + j]]
						|| ps->tainted_nodes[pl->vals[tainted_coord * PREFLIST_SIZE + j]]))) 

} Env;


_(logic 
  \bool put_safety_check(int tainted_key, int tainted_coord, int pref_size, PreferenceLists *pl, LocalStores * ls, HintedHandoffStores *hhs, PendingSet * ps) = 
	tainted_key != -1 && tainted_coord == get_coord_for_key(tainted_key) ==>
			(\forall int j; (j >= 0 && j < pref_size) 
				==> (ls->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]] 					
						|| ps->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]]
						|| hhs->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]])))

void init_live_nodes(LiveNodes  *ln)
	_(requires ln != NULL)
	_(writes \extent(ln))
	_(ensures \wrapped(ln))
	_(decreases 0)
{
	_(wrap ln)
}


void init_preference_lists(PreferenceLists * pl) 
	_(requires pl != NULL)
	_(writes \extent(pl))
	_(ensures \wrapped(pl))
	_(decreases 0)
{
	int i = 0, j = 0;
	while(i < VNODES) 
		_(invariant i >= 0 && i <= VNODES)
		_(invariant j == 0)
		_(invariant \forall int k; (k >= 0 && k < (i * PREFLIST_SIZE + j)) ==> pl->preference_list[k] >= 0 && pl->preference_list[k] < VNODES)
		_(invariant \forall int k; (k >= 0 && k < (i * PREFLIST_SIZE + j)) ==> pl->preference_list[k] == pl->vals[k])

	{
		_(assert i >= 0 && i < VNODES)
		int count = i;
		int value = 0;
		while(j < PREFLIST_SIZE)
			_(invariant i >= 0 && i < VNODES)
			_(invariant j >= 0 & j <= PREFLIST_SIZE)
			_(invariant count == i + j)
			_(invariant value >= 0 && value < VNODES)
			_(invariant \forall int k; (k >= 0 && k < (i * PREFLIST_SIZE + j)) ==> pl->preference_list[k] >= 0 && pl->preference_list[k] < VNODES)
			_(invariant \forall int k; (k >= 0 && k < (i * PREFLIST_SIZE + j)) ==> pl->preference_list[k] == pl->vals[k])
		{
			value = (count++ % VNODES);
			pl->preference_list[i * PREFLIST_SIZE + j] = value;
			_(ghost pl->vals[i * PREFLIST_SIZE + j] = value ;)
			j ++;
		}
		j = 0;
		i ++;
	}
	_(assert i == VNODES)
	_(wrap pl)
}


void init_local_stores(LocalStores * ls) 
	_(requires ls != NULL)
	_(writes \extent(ls))
	_(ensures \wrapped(ls))
	_(ensures ls->size == 0)
	_(ensures ls->tainted_key == -1)
	_(decreases 0)
{
	int i = 0, j = 0;
	while(i < VNODES) 
		_(invariant i <= VNODES)
		_(invariant j == 0)
		_(invariant \forall int k; (k >= 0 && k < (i * KEYS_NUM + j)) ==> ls->local_store[k] == -1)
	{
		while(j < KEYS_NUM) 
			_(invariant i <= VNODES && j <= KEYS_NUM)
			_(invariant \forall int k; (k >= 0 && k < (i * KEYS_NUM + j)) ==> ls->local_store[k] == -1)
		{
			ls->local_store[i * KEYS_NUM + j] = -1;
			j ++;
		}
		j = 0;
		i ++;
	}
	_(ghost ls->tainted_nodes = empty_iset())
	_(ghost ls->tainted_key = -1)
	ls->len = 0;
	_(ghost ls->size = 0)
	_(wrap ls)
}


void init_hinted_handoff_stores(HintedHandoffStores * hhs) 
	_(requires hhs != NULL)
	_(requires \extent_mutable(hhs))
	_(writes \extent(hhs))
	_(ensures \wrapped(hhs))
	_(ensures hhs->size == 0)
	_(ensures hhs->hset == empty_hset())
	_(decreases 0)
{
	_(ghost hhs->tainted_nodes = empty_iset())
	_(ghost hhs->tkey   = -1;)
	_(ghost hhs->tcoord = -1;)
	_(ghost hhs->hset = empty_hset())
	hhs->size = 0;
	_(wrap hhs)
}

void init_pending(PendingSet * ps) 
	_(requires ps != NULL)
	_(requires \extent_mutable(ps))
	_(writes \extent(ps))
	_(ensures \wrapped(ps))
	_(ensures ps->size == 0)
	_(ensures ps->pset == empty_hset())
	_(decreases 0)
{
	_(ghost ps->tainted_nodes = empty_iset())
	_(ghost ps->tkey   = -1;)
	_(ghost ps->tcoord = -1;)
	_(ghost ps->pset = empty_hset())
	ps->size = 0;
	_(wrap ps)
}

int get(int key, int coord, BOOL is_tainted, LiveNodes * ln, PreferenceLists * pl, HintedHandoffStores * hhs, LocalStores * ls, PendingSet *ps) 
	_(requires \thread_local(&RDT))
	_(requires coord == get_coord_for_key(key))
	_(requires key >= 0 && key < KEYS_NUM)
	_(requires ln != NULL && pl != NULL && hhs != NULL && ls != NULL)
	_(requires ln->live_nodes[get_coord_for_key(key)] == 1)
	_(requires \wrapped(pl))
	_(reads \extent(pl))
	_(writes ln, ls, hhs, ps)
	_(maintains \wrapped(ln))
	_(maintains \wrapped(hhs))
	_(maintains \wrapped(ls))
	_(maintains \wrapped(ps))
	_(ensures \wrapped(pl))
	_(ensures is_tainted ==> (\forall int j; (j >= 0 && j < PREFLIST_SIZE) 
						==> ls->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]
							|| hhs->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]
							|| ps->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]))
{
	int cnt_succ = 0;
	
	int cur_node = -1;
	int i = 0;
	while(i < PREFLIST_SIZE)
		_(invariant cnt_succ <= i)
		_(invariant \wrapped(pl))
		_(invariant \wrapped(ls))
		_(invariant \wrapped(ps))
		_(invariant \wrapped(hhs))
		_(invariant \wrapped(ln))
		_(invariant \thread_local(&RDT))

		_(writes ln, ls, ps, hhs)
		_(invariant i > 0 ==> cur_node >= 0 && cur_node < VNODES)
		_(invariant i > 0 && is_tainted  && ln->live_nodes[cur_node] ==> ls->tainted_nodes[cur_node] || hhs->tainted_nodes[cur_node] || ps->tainted_nodes[cur_node])
		_(invariant i > 0 && is_tainted ==> (\forall int j; (j >= 0 && j < i) 
						==> ls->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]
						    || hhs->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]
							|| ps->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]] ))
	{
		_(assert i > 0 ==> cur_node >= 0 && cur_node < VNODES) // VCC HINT
		cur_node = pl->preference_list[coord * PREFLIST_SIZE + i];
		if (ln->live_nodes[cur_node]) {
			cnt_succ ++;
		}
		i ++;
		havoc_all(ln, ls, hhs, ps);
		_(ghost \state s0 = \now() ;)
		_(unwrap ls)
		_(ghost {
		if (is_tainted) { 			
			ls->tainted_key = key;
			ls->tainted_nodes =  addone_iset(ls->tainted_nodes, cur_node);
		}})
		_(wrap ls)
		_(assert guarantee(ls, hhs, ps, s0))
		havoc_all(ln, ls, hhs, ps);	
	}

	if (cnt_succ < RDT) return -1;
	return cnt_succ;
}

BOOL write_succeeded()
	_(decreases 0) 
;

int put(int key, int coord, BOOL is_tainted, BOOL first_tainted_write, LiveNodes * ln, PreferenceLists * pl, LocalStores * ls, HintedHandoffStores * hhs, PendingSet *ps)
	_(requires \thread_local(&WDT))
	_(requires key >= 0 && key < KEYS_NUM)
	_(requires ps != NULL)
	_(requires coord == get_coord_for_key(key))
	_(requires pl != NULL)
	_(requires ln->live_nodes[coord] == 1)
	_(requires ls != NULL)
	_(requires ps->size < UINT_MAX)
	_(requires !first_tainted_write ==> (\forall int j; (j >= 0 && j < PREFLIST_SIZE) 
					==> (   ls->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]
						     || ps->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]
							 || hhs->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]) ))

	_(maintains \wrapped(ln) && \wrapped(pl) && \wrapped(ls) && \wrapped(hhs) && \wrapped(ps))

	_(writes ln, ls, hhs, ps)

	_(ensures coord == get_coord_for_key(key))
	_(ensures \result > -2 ==> ps->size <= PS_SIZE)
	_(ensures ps->size <= PS_SIZE)
	_(ensures hhs->size <= HS_SIZE)
	
	// basic safety invariant:
	_(ensures is_tainted && \result > -2 ==> put_safety_check(key, coord, PREFLIST_SIZE, pl, ls, hhs, ps))
	
	// invariant for all alive nodes:
	_(ensures is_tainted && \result > -2 
				==> (\forall int j; (j >= 0 && j < PREFLIST_SIZE) 
					==> (   ls->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]
						     || ps->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]
							 || hhs->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]) ))
	
	_(decreases 0)
{	
	
	_(ghost AbsHint abs_hint)
	int cnt_succ = 0;
	int cur_node = -1;
	int i = 0;
	while(i < PREFLIST_SIZE) 
		_(invariant cnt_succ <= i)		
		_(invariant \wrapped(ln) && \wrapped(ls) && \wrapped(ps) && \wrapped(hhs))
		_(invariant \thread_local(&WDT))
		_(writes ln, ls, hhs, ps)

		_(invariant ps->size  <= PS_SIZE)	
		_(invariant hhs->size <= HS_SIZE)
		_(invariant i > 0 && is_tainted ==> ls->tainted_nodes[cur_node] || ps->tainted_nodes[cur_node] || hhs->tainted_nodes[cur_node])		
		_(invariant is_tainted  ==> put_safety_check(key, coord, i, pl, ls, hhs, ps))
		
		_(invariant i > 0 && is_tainted  && ln->live_nodes[cur_node] && cnt_succ <= WDT ==> (ls->tainted_nodes[cur_node] || ps->tainted_nodes[cur_node] || hhs->tainted_nodes[cur_node]))
		
		_(invariant is_tainted 
					==> (\forall int j; (j >= 0 && j < i) 						 
							==> (   ls->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]
								 || ps->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]]
								 || hhs->tainted_nodes[pl->preference_list[coord * PREFLIST_SIZE + j]])))
	{
		cur_node = pl->preference_list[coord * PREFLIST_SIZE + i];
		if (ln->live_nodes[cur_node] && cnt_succ < WDT) {		
			_(assert (i > 0 && is_tainted  && (! ln->live_nodes[cur_node] || cnt_succ >= WDT) && ps->size < PS_SIZE) ==> ps->tainted_nodes[cur_node])
			if (write_succeeded()) {
				havoc_all(ln, ls, hhs, ps);
				_(ghost \state s0 = \now() ;)
				_(unwrap ls)
				ls->local_store[cur_node * KEYS_NUM + key] = key;
				_(ghost { 					
					if (is_tainted) {
						ls->tainted_key = key;
						ls->tainted_nodes =  addone_iset(ls->tainted_nodes, cur_node);
						ls->size = ls->size + 1 ;
					}})
				_(wrap ls)
				_(assert guarantee(ls, hhs, ps, s0))
				havoc_all(ln, ls, hhs, ps);
				cnt_succ ++;
			} else {
				if (ps->size == PS_SIZE) { // *** run-time error: pending set is full *** 
					return -2;
				}
				havoc_all(ln, ls, hhs, ps);
				_(ghost \state s0 = \now() ;)
				_(unwrap ps)
					Hint h = create_hint(coord, cur_node, key _(out abs_hint));
					if(ps->size == PS_SIZE) {
						_(wrap ps)
						_(assert guarantee(ls, hhs, ps, s0))
						havoc_all(ln, ls, hhs, ps);
						return -2;
					}

					ps->pending[ps->size] = h;
					_(ghost ps->pset = addone_hset(ps->pset, h))
					_(ghost ps->idx[h] = ps->size)

					ps->size = ps->size + 1;


					_(ghost {

						if (is_tainted) {
						if (ps->tkey == -1) {
								ps->tkey = key;
								ps->tcoord = coord;
							}
							ps->tainted_nodes = addone_iset(ps->tainted_nodes, cur_node);
				
					} })

				_(wrap ps)
				_(assert guarantee(ls, hhs, ps, s0))
				havoc_all(ln, ls, hhs, ps);
			}
		} else { 
			_(assert ! ln->live_nodes[cur_node] || cnt_succ >= WDT)
			if (ps->size == PS_SIZE) // *** run-time error: pending set is full *** 
				return -2;

			_(assert (! ln->live_nodes[cur_node] || cnt_succ >= WDT) && ps->size < PS_SIZE)
			
			havoc_all(ln, ls, hhs, ps);
			_(ghost \state s0 = \now() ;)
			_(unwrap ps)
			if(ps->size == PS_SIZE) {
				_(wrap ps)
				_(assert guarantee(ls, hhs, ps, s0))
				havoc_all(ln, ls, hhs, ps);
				return -2;
			}

			_(ghost {
				if (is_tainted) {
					ps->tkey = key;
					ps->tcoord = coord;
					ps->tainted_nodes = addone_iset(ps->tainted_nodes, cur_node);
					_(assert ps->tainted_nodes[cur_node])
				} })
		
				Hint h = create_hint(coord, i, key _(out abs_hint));
				ps->pending[ps->size] = h;
				_(ghost ps->pset = addone_hset(ps->pset, h))
				_(ghost ps->idx[h] = ps->size)
				ps->size = ps->size + 1;
			_(wrap ps)
			_(assert guarantee(ls, hhs, ps, s0))
			havoc_all(ln, ls, hhs, ps);			
		}
		i ++;
	}
	if (cnt_succ < WDT) return -1;
	return cnt_succ;
}

BOOL write_to_local_store()
	_(decreases 0)
	;

BOOL write_to_slop_store()  // slop_store == hinted_handof_table
	_(decreases 0)
	;

_(pure)
BOOL is_the_last_tainted(int key, int tainted_key, int tainted_coord, int dst_node, PendingSet *ps) 
	_(requires tainted_coord == get_coord_for_key(tainted_key))
	_(reads ps)
	_(decreases 0)
;

void rm_pending_seq(int tainted_key, int tainted_coord, PreferenceLists *pl, HintedHandoffStores *hhs, LocalStores *ls, PendingSet *ps) 
	_(requires pl != NULL && ls != NULL && hhs != NULL && ps != NULL)
	_(requires ps->size > 0)
	_(requires tainted_key >= 0 && tainted_key < KEYS_NUM)
	_(requires tainted_key != -1 ==> tainted_coord == get_coord_for_key(tainted_key))
	_(requires hhs->size < HS_SIZE)

	_(maintains 
			(\forall int j; (j >= 0 && j < PREFLIST_SIZE) 
				==> (ls->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]] 
					 || hhs->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]]
					 || ps->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]]))) 

	_(maintains \wrapped(hhs))
	_(maintains \wrapped(ls))
	_(maintains \wrapped(pl))
	_(maintains \wrapped(ps))

	_(reads \extent(pl))

	_(writes hhs)
	_(writes ls)
	_(writes ps)

	_(ensures ps->size == \old(ps->size) - 1)
	_(ensures hhs->size == \old(hhs->size) ||(hhs->size == \old(hhs->size) + 1))
	_(ensures hhs->size <= HS_SIZE)
	_(decreases ps->size)
{
	
	_(assert tainted_coord == get_coord_for_key(tainted_key))
	int x = tainted_coord * PREFLIST_SIZE;

	Hint last_hint = ps->pending[ps->size-1];
	int dst_node = get_dst(last_hint);
	int key = get_key(last_hint);

	BOOL do_local_write = write_to_local_store();
	BOOL do_slop_write = write_to_slop_store();

	_(unwrap ps)
	_(unwrap ls)
	_(unwrap hhs)
	_(ghost {
		if (is_the_last_tainted(key, tainted_key, tainted_coord, dst_node, ps)) {
			// delete from the abstract tainted store in the pending set
			ps->tainted_nodes = delone_iset(ps->tainted_nodes, dst_node); 

			if (do_local_write) { // write to the abstract tainted local store
				ls->tainted_nodes  = addone_iset(ls->tainted_nodes, dst_node);
				if (do_slop_write) {
					hhs->tainted_nodes = addone_iset(hhs->tainted_nodes, dst_node);
				}
			} else {
				hhs->tainted_nodes = addone_iset(hhs->tainted_nodes, dst_node);
			}
		} 
	})
	_(ghost ps->pset = \lambda Hint h; h == last_hint ? \false : ps->pset[h])
	_(assert addone_hset(delone_hset(ps->pset, last_hint), last_hint) == ps->pset) // *** hint for VCC ***

	_(assert addone_iset(delone_iset(ls->tainted_nodes, dst_node), dst_node) == ls->tainted_nodes) // *** hint for VCC ***
	_(assert addone_hset(delone_hset(hhs->hset, last_hint), last_hint) == hhs->hset) // *** hint for VCC ***

	// delete from the concrete pending set
	ps->pending[ps->size-1] = (size_t)-1;
	ps->size = ps->size - 1;
	_(wrap ps)

	if (do_local_write) {  // write to the concrete local store
		ls->local_store[dst_node * KEYS_NUM + key] = key;
		_(ghost ls->size = ls->size + 1 )
		if (do_slop_write) {
			hhs->hint_store[hhs->size] = last_hint;
			_(ghost hhs->hset = addone_hset(hhs->hset, last_hint))
			_(ghost hhs->idx[last_hint] = hhs->size)
			hhs->size = hhs->size + 1;
		}
	} else {
		hhs->hint_store[hhs->size] = last_hint;
		_(ghost hhs->hset = addone_hset(hhs->hset, last_hint))
		_(ghost hhs->idx[last_hint] = hhs->size)
		hhs->size = hhs->size + 1;
	}

	_(wrap hhs)
	_(wrap ls)
}


void rm_pending_rr(PreferenceLists *pl, LocalStores *ls, PendingSet *ps) 
	_(requires pl != NULL && ls != NULL && ps != NULL)
	_(requires ps->size > 0)

	_(maintains \wrapped(ls))
	_(maintains \wrapped(pl))
	_(maintains \wrapped(ps))


	_(writes ls)
	_(writes ps)

	_(ensures ps->size < \old(ps->size))
	_(decreases ps->size)
{

	Hint last_hint = ps->pending[ps->size-1];
	int dst_node = get_dst(last_hint);
	int key = get_key(last_hint);

	_(unwrap ps)
	_(unwrap ls)
	_(ghost ps->pset = \lambda Hint h; h == last_hint ? \false : ps->pset[h])
	_(assert addone_hset(delone_hset(ps->pset, last_hint), last_hint) == ps->pset) // *** hint for VCC ***

	// delete from the concrete pending set
	ps->pending[ps->size-1] = (size_t)-1;
	ps->size = ps->size - 1;
	_(wrap ps)

	ls->local_store[dst_node * KEYS_NUM + key] = key;
	_(wrap ls)
}


void havoc_all(LiveNodes * ln, LocalStores *ls, HintedHandoffStores *hhs, PendingSet *ps)
	_(maintains \wrapped(ln) && \wrapped(ls) && \wrapped(hhs) && \wrapped(ps))
	_(writes ln, ls, hhs, ps)
	_(ensures \old(ls->tainted_key) != -1 ==> ls->tainted_key != -1)
	_(ensures \old(hhs->tkey) != -1 ==> hhs->tkey != -1)
	_(ensures \old(ps->tkey) != -1 ==> \old(ps->tkey) == ps->tkey)
	_(ensures hhs->size >= 0 && hhs->size <= HS_SIZE )
	_(ensures ps->size >= 0 && ps->size <= PS_SIZE)

	_(ensures \forall int i; (\old(ls->tainted_nodes[i]) || \old(hhs->tainted_nodes[i]) || \old(ps->tainted_nodes[i])) 
								==>  (ls->tainted_nodes[i] || hhs->tainted_nodes[i] || ps->tainted_nodes[i]))
	_(ensures \thread_local(&RDT))
	_(ensures \thread_local(&WDT))
	_(decreases 0)
;

_(logic \bool guarantee(LocalStores *ls, HintedHandoffStores *hhs, PendingSet *ps, \state s0) = 
  		   \at(s0, ls->tainted_key) != -1 ==> ls->tainted_key != -1
		&& \at(s0, hhs->tkey) != -1 ==> hhs->tkey != -1
		&& \at(s0, ps->tkey) != -1 ==> ps->tkey != -1
		&& hhs->size >= 0 && hhs->size <= HS_SIZE 
		&& ps->size >= 0  && ps->size  <= PS_SIZE 
		&& \forall int i; (\at(s0, ls->tainted_nodes[i]) || \at(s0, hhs->tainted_nodes[i]) || \at(s0, ps->tainted_nodes[i])) 
						==>  (ls->tainted_nodes[i] || hhs->tainted_nodes[i] || ps->tainted_nodes[i])
  )

void rm_pending_conc(int tainted_key, int tainted_coord, LiveNodes * ln, PreferenceLists *pl, HintedHandoffStores *hhs, LocalStores *ls, PendingSet *ps) 
	_(requires pl != NULL && ls != NULL && hhs != NULL && ps != NULL)
	_(requires ps->size >= 0)
	_(requires tainted_key >= 0 && tainted_key < KEYS_NUM)
	_(requires tainted_key != -1 ==> tainted_coord == get_coord_for_key(tainted_key))
	_(requires hhs->size < HS_SIZE)

	_(maintains 
			(\forall int j; (j >= 0 && j < PREFLIST_SIZE) 
				==> (ls->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]] 
					 || hhs->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]]
					 || ps->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]]))) 

	_(maintains \wrapped(hhs))
	_(maintains \wrapped(ls))
	_(maintains \wrapped(pl))
	_(maintains \wrapped(ps))
	_(maintains \wrapped(ln))

	_(reads \extent(pl))

	_(writes ln, ls, hhs, ps)

	_(decreases 0)
{
	
	_(assert tainted_coord == get_coord_for_key(tainted_key))
	int x = tainted_coord * PREFLIST_SIZE;

	havoc_all(ln, ls, hhs, ps);
	_(ghost \state s0 = \now() ;)
	_(unwrap ps)
	if (ps->size == 0) {
		_(wrap ps)
		_(assert guarantee(ls, hhs, ps, s0))
		havoc_all(ln, ls, hhs, ps);
		return;
	}
	_(unwrap ls)
	_(unwrap hhs)

	Hint last_hint = ps->pending[ps->size-1];
	int dst_node = get_dst(last_hint);
	int key = get_key(last_hint);

	BOOL do_local_write = write_to_local_store();
	BOOL do_slop_write = write_to_slop_store();

	_(ghost {
	if (dst_node >= pl->preference_list[x] && dst_node <= pl->preference_list[x + (PREFLIST_SIZE - 1)]) {
		// delete from the abstract tainted store in the pending set
		ps->tainted_nodes = delone_iset(ps->tainted_nodes, dst_node); 

		if (do_local_write) { // write to the abstract tainted local store
			ls->tainted_nodes  = addone_iset(ls->tainted_nodes, dst_node);
			if (do_slop_write) {
				hhs->tainted_nodes = addone_iset(hhs->tainted_nodes, dst_node);
			}
		} else {
			hhs->tainted_nodes = addone_iset(hhs->tainted_nodes, dst_node);
		}				
	} })


	_(ghost ps->pset = \lambda Hint h; h == last_hint ? \false : ps->pset[h])
	_(assert addone_hset(delone_hset(ps->pset, last_hint), last_hint) == ps->pset) // *** hint for VCC ***

	_(assert addone_iset(delone_iset(ls->tainted_nodes, dst_node), dst_node) == ls->tainted_nodes) // *** hint for VCC ***
	_(assert addone_hset(delone_hset(hhs->hset, last_hint), last_hint) == hhs->hset) // *** hint for VCC ***


	// delete from the concrete hint store
	ps->pending[ps->size-1] = (size_t)-1;
	ps->size = ps->size - 1;
	_(wrap ps)

	if (do_local_write) {  // write to the concrete local store
		ls->local_store[dst_node * KEYS_NUM + key] = key;
		_(ghost ls->size = ls->size + 1 )
		if (do_slop_write) {
			_(assert hhs->size >= 0)
			if (hhs->size == HS_SIZE) {
				_(wrap hhs)
				_(wrap ls)
				_(assert guarantee(ls, hhs, ps, s0))
				havoc_all(ln, ls, hhs, ps);
				return;
			}
			hhs->hint_store[hhs->size] = last_hint;
			_(ghost hhs->hset = addone_hset(hhs->hset, last_hint))
			_(ghost hhs->idx[last_hint] = hhs->size)
			hhs->size = hhs->size + 1;
		}
	} else {
		if (hhs->size == HS_SIZE) {
			_(wrap hhs)
			_(wrap ls)
			_(assert guarantee(ls, hhs, ps, s0))
			havoc_all(ln, ls, hhs, ps);
			return;
		}
		hhs->hint_store[hhs->size] = last_hint;
		_(ghost hhs->hset = addone_hset(hhs->hset, last_hint))
		_(ghost hhs->idx[last_hint] = hhs->size)
		hhs->size = hhs->size + 1;
	}

	_(wrap hhs)
	_(wrap ls)
	_(assert guarantee(ls, hhs, ps, s0))
	havoc_all(ln, ls, hhs, ps);

}
					

void handoff_hint_conc(int tainted_key, int tainted_coord, LiveNodes *ln, PreferenceLists *pl, HintedHandoffStores *hhs, LocalStores *ls, PendingSet * ps) 
	_(requires pl != NULL && ls != NULL && hhs != NULL)
	_(requires hhs->size >= 0)
	_(requires tainted_key >= 0 && tainted_key < KEYS_NUM)
	_(requires tainted_key != -1 ==> tainted_coord == get_coord_for_key(tainted_key))
	_(maintains (\forall int j; (j >= 0 && j < PREFLIST_SIZE) 
				==> (ls->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]] 
						|| hhs->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]]
						|| ps->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]])))

	_(maintains \wrapped(ln) && \wrapped(pl) && \wrapped(ls) && \wrapped(hhs) && \wrapped(ps))
	_(reads \extent(pl))
	_(writes ln, ls, hhs, ps)
	_(decreases 0)
{
	
	_(assert tainted_coord == get_coord_for_key(tainted_key))
	int x = tainted_coord * PREFLIST_SIZE;
	havoc_all(ln, ls, hhs, ps);
	_(ghost \state s0 = \now() ;)
	_(unwrap hhs)
	// this is required because other threads can concurrently remove the hints
	if (hhs->size == 0) {
		_(wrap hhs)
		_(assert guarantee(ls, hhs, ps, s0))
		havoc_all(ln, ls, hhs, ps);
		return;
	}
	
	Hint last_hint = hhs->hint_store[hhs->size-1];
	int dst_node = get_dst(last_hint);
	int key = get_key(last_hint);

	_(unwrap ls)
	_(ghost {
	if (dst_node >= pl->preference_list[x] && dst_node <= pl->preference_list[x + (PREFLIST_SIZE - 1)]) {
		// write to the abstract tainted hinted handoff store
		hhs->tainted_nodes = delone_iset(hhs->tainted_nodes, dst_node); 
		// delete from the abstract tainted store
		ls->tainted_nodes  = addone_iset(ls->tainted_nodes, dst_node);		
	} })
	_(ghost hhs->hset = \lambda Hint h; h == last_hint ? \false : hhs->hset[h])
	_(assert addone_hset(delone_hset(hhs->hset, last_hint), last_hint) == hhs->hset) // *** hint for VCC ***
	_(assert addone_iset(delone_iset(ls->tainted_nodes, dst_node), dst_node) == ls->tainted_nodes) // *** hint for VCC ***

	// delete from the concrete hint store
	hhs->hint_store[hhs->size - 1] = (size_t)-1;
	hhs->size = hhs->size - 1;

	// write to the concrete local store
	ls->local_store[dst_node * KEYS_NUM + key] = key;
	_(ghost ls->size = ls->size + 1 ;)
	_(wrap hhs)
	_(wrap ls)
	_(assert guarantee(ls, hhs, ps, s0))
	havoc_all(ln, ls, hhs, ps);
}

void handoff_hint_seq(int tainted_key, int tainted_coord, PreferenceLists *pl, HintedHandoffStores *hhs, LocalStores *ls, PendingSet * ps) 
	_(requires pl != NULL && ls != NULL && hhs != NULL)
	_(requires hhs->size > 0)
	_(requires tainted_key >= 0 && tainted_key < KEYS_NUM)
	_(requires tainted_key != -1 ==> tainted_coord == get_coord_for_key(tainted_key))
	_(maintains (\forall int j; (j >= 0 && j < PREFLIST_SIZE) 
				==> (ls->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]] 
						|| hhs->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]]
						|| ps->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]])))
	_(maintains \wrapped(hhs))
	_(maintains \wrapped(ls))
	_(maintains \wrapped(pl))
	_(maintains \wrapped(ps))
	_(reads \extent(pl))
	_(writes hhs)
	_(writes ls)
	_(ensures hhs->size < \old(hhs->size))
	_(ensures ps->size == \old(ps->size))
	_(decreases hhs->size)
{
	
	_(assert tainted_coord == get_coord_for_key(tainted_key))
	int x = tainted_coord * PREFLIST_SIZE;
	Hint last_hint = hhs->hint_store[hhs->size-1];
	int dst_node = get_dst(last_hint);
	int key = get_key(last_hint);

	_(unwrap hhs)
	_(unwrap ls)
	_(ghost {
	if (dst_node >= pl->preference_list[x] && dst_node <= pl->preference_list[x + (PREFLIST_SIZE - 1)]) {
		// write to the abstract tainted hinted handoff store
		hhs->tainted_nodes = delone_iset(hhs->tainted_nodes, dst_node); 
		// delete from the abstract tainted store
		ls->tainted_nodes  = addone_iset(ls->tainted_nodes, dst_node);
	} })
	_(ghost hhs->hset = \lambda Hint h; h == last_hint ? \false : hhs->hset[h])
	_(assert addone_hset(delone_hset(hhs->hset, last_hint), last_hint) == hhs->hset) // *** hint for VCC ***
	_(assert addone_iset(delone_iset(ls->tainted_nodes, dst_node), dst_node) == ls->tainted_nodes) // *** hint for VCC ***

	// delete from the concrete hint store
	hhs->hint_store[hhs->size-1] = (size_t)-1;
	hhs->size = hhs->size - 1;

	// write to the concrete local store
	ls->local_store[dst_node * KEYS_NUM + key] = key;
	_(ghost ls->size = ls->size + 1 ;)
	_(wrap hhs)
	_(wrap ls)
}


BOOL get_arbitrary_bool() 
	_(ensures \result == TRUE || \result == FALSE)
	_(decreases 0)
// IMPLEMENTATION: use random() implementation for an executable
;

int get_arbitrary_num_in_range(int low, int high) 
	_(requires high > low)
	_(ensures \result >= low && \result < high)
	_(decreases 0)
// IMPLEMENTATION: use random() implementation for an executable
;

void get_alive_coordinator(LiveNodes * ln, int coord) 
	_(requires coord >= 0 && coord < VNODES)
	_(maintains \wrapped(ln))
	_(writes ln)
	_(ensures ln->live_nodes[coord] == TRUE)
	_(decreases 0)
{
	_(unwrap ln)
	ln->live_nodes[coord] = TRUE;
	_(wrap ln)
}

void nodes_fail_and_recover_arbitrarily(LiveNodes *ln)  
	_(maintains \wrapped(ln))
	_(writes ln)
	_(ensures \forall int i;  (i >= 0 && i < VNODES) ==> (ln->live_nodes[i] == TRUE || ln->live_nodes[i] == FALSE))
	_(decreases 0)
{
	for(int i = 0; i < VNODES; i++) 
		_(writes ln)
		_(invariant \wrapped(ln))
		_(invariant \forall int j;  (j >= 0 && j < i) ==> (ln->live_nodes[j] == TRUE || ln->live_nodes[j] == FALSE))
	{
		_(unwrap ln)
		ln->live_nodes[i] = get_arbitrary_bool();
		_(wrap ln)
	}
}

void all_nodes_recover(LiveNodes * ln)  
	_(maintains \wrapped(ln))
	_(writes ln)
	_(ensures \forall int i;  (i >= 0 && i < VNODES) ==> ln->live_nodes[i] == TRUE)
	_(decreases 0)
{
	for(int i = 0; i < VNODES; i++) 
		_(writes ln)
		_(invariant \wrapped(ln))
		_(invariant \forall int j;  (j >= 0 && j < i) ==> ln->live_nodes[j] == TRUE)
	{
		_(unwrap ln)
		ln->live_nodes[i] = TRUE;
		_(wrap ln)
	}
}

void empty_hhs_ps(PreferenceLists * pl, HintedHandoffStores * hhs, LocalStores * ls, PendingSet * ps, int tainted_key, int tainted_coord, int tmp_coord) 
		_(maintains \wrapped(pl) && \wrapped(hhs) && \wrapped(ls) && \wrapped(ps))
		_(requires tainted_key >= 0 && tainted_key < KEYS_NUM)
		_(requires tainted_coord == get_coord_for_key(tainted_key))
		_(requires tmp_coord == tainted_coord * PREFLIST_SIZE)
		_(maintains (\forall int j; (j >= 0 && j < PREFLIST_SIZE) ==>
							(ls->tainted_nodes[pl->preference_list[tmp_coord + j]] 
							|| hhs->tainted_nodes[pl->preference_list[tmp_coord + j]]
							|| ps->tainted_nodes[pl->preference_list[tmp_coord + j]])))
		_(writes hhs, ls, ps)
		_(ensures hhs->size == 0)
		_(ensures ps->size == 0)

		_(decreases 0)
		
{
		while(hhs->size > 0 || ps->size > 0) 
			_(invariant hhs->size >= 0 && hhs->size <= HS_SIZE)
			_(invariant ps->size >= 0 && ps->size <= PS_SIZE)
			_(invariant \wrapped(hhs) && \wrapped(ls) && \wrapped(ps))
			_(invariant tainted_coord == get_coord_for_key(tainted_key))
			_(invariant (\forall int j; (j >= 0 && j < PREFLIST_SIZE) ==>
							(ls->tainted_nodes[pl->preference_list[tmp_coord + j]] 
							|| hhs->tainted_nodes[pl->preference_list[tmp_coord + j]]
							|| ps->tainted_nodes[pl->preference_list[tmp_coord + j]])))

			_(writes hhs, ls, ps)
			_(decreases hhs->size + 2 * ps->size)
	{	
		_(ghost \state s0 = \now() ;)
		if (hhs->size > 0 && ps->size <= 0) {
			handoff_hint_seq(tainted_key, tainted_coord, pl, hhs, ls, ps);
			_(assert (hhs->size < \at(s0, hhs->size) && ps->size <= \at(s0, ps->size)))
		} else if (hhs->size <= 0 && ps->size > 0) {
			_(assume hhs->size < HS_SIZE);
			rm_pending_seq(tainted_key, tainted_coord, pl, hhs, ls, ps);
			_(assert (ps->size < \at(s0, ps->size) && hhs->size <= \at(s0, hhs->size) + 1))
		}
		else {
			if (star()) {
				handoff_hint_seq(tainted_key, tainted_coord, pl, hhs, ls, ps);
				_(assert (hhs->size < \at(s0, hhs->size) && ps->size <= \at(s0, ps->size)))
			} else {
				_(assume hhs->size < HS_SIZE);
				rm_pending_seq(tainted_key, tainted_coord, pl, hhs, ls, ps);
				_(assert (ps->size < \at(s0, ps->size) && hhs->size <= \at(s0, hhs->size) + 1))
			}
		} 
	}
}

void permute_ps_idx(PendingSet *ps)
	_(maintains ps->size <= PS_SIZE)
	_(maintains \wrapped(ps))
	_(writes ps)
	_(ensures \forall Hint h; ps->pset[h] == \old(ps->pset[h]))
	_(ensures \forall int i; ps->tainted_nodes[i] == \old(ps->tainted_nodes[i]))
	_(ensures ps->size == \old(ps->size))
	_(ensures ps->tkey == \old(ps->tkey))
	_(ensures ps->tcoord == \old(ps->tcoord))
	_(ensures \wrapped(ps))
	_(decreases 0)
;

void permute_hhs_idx(HintedHandoffStores *hhs)
	_(maintains hhs->size <= HS_SIZE)
	_(maintains \wrapped(hhs))
	_(writes hhs)
	_(ensures \forall Hint h; hhs->hset[h] == \old(hhs->hset[h]))
	_(ensures \forall int i; hhs->tainted_nodes[i] == \old(hhs->tainted_nodes[i]))
	_(ensures hhs->size == \old(hhs->size))
	_(ensures hhs->tkey == \old(hhs->tkey))
	_(ensures hhs->tcoord == \old(hhs->tcoord))
	_(ensures \wrapped(hhs))
	_(decreases 0)
;


int harness(LiveNodes * ln, PreferenceLists * pl, HintedHandoffStores * hhs, LocalStores * ls, PendingSet * ps _(out int tkey) _(out int tcoord))
	_(requires pl != NULL && ls != NULL && hhs != NULL)
	_(requires hhs->size < HS_SIZE)
	_(requires ps->size < PS_SIZE)
	_(writes ln)
	_(writes \extent(ln), \extent(pl), \extent(hhs), \extent(ls), \extent(ps))
	_(ensures \wrapped(pl) && \wrapped(ls) && \wrapped(hhs))
	_(ensures \wrapped(ps))
	_(decreases hhs->size)
{
	init_preference_lists(pl);
	init_local_stores(ls);
	init_hinted_handoff_stores(hhs);
	init_pending(ps);
	init_live_nodes(ln);

	int tainted_key = -1;
	int tainted_coord = -1;
	BOOL tainted_key_set = FALSE;
	int lo = 10;
	int hi = 1000;
	int num_rounds = get_arbitrary_num_in_range(lo, hi);
	_(assert ls->tainted_key == -1)
	while(num_rounds > 0)
		_(invariant \wrapped(ls))
		_(invariant \wrapped(hhs))
		_(invariant \wrapped(ps))
		_(invariant \wrapped(ln))
		_(invariant num_rounds >= 0 && num_rounds <= 1000)
		_(invariant hhs->size >= 0 && hhs->size <= HS_SIZE)
		_(invariant ps->size >= 0 && ps->size < PS_SIZE)
		_(invariant tainted_key_set ==> tainted_key >= 0 && tainted_key < KEYS_NUM)
		_(invariant tainted_key != -1 && tainted_coord == get_coord_for_key(tainted_key)
					==> (\forall int j; (j >= 0 && j < PREFLIST_SIZE) 
						==> (ls->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]] 
							|| hhs->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]]
							|| ps->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]]) ))
		_(invariant tainted_key_set ==> tainted_key != -1 && tainted_coord == get_coord_for_key(tainted_key))
		_(invariant tainted_key != -1 ==> tainted_coord == get_coord_for_key(tainted_key))
		_(writes ls)
		_(writes hhs)
		_(writes ps)
		_(writes ln)
		_(decreases num_rounds)
	{

		if (!tainted_key_set) {
			tainted_key = get_arbitrary_num_in_range(0, KEYS_NUM);
			tainted_coord = get_coord_for_key(tainted_key);
			get_alive_coordinator(ln, tainted_coord);
			_(assert hhs->size >= 0 && hhs->size <= HS_SIZE)
			int ret_put = put(tainted_key, tainted_coord, TRUE, TRUE,  ln, pl, ls, hhs, ps);
			_(assert hhs->size >= 0 && hhs->size <= HS_SIZE)
			if (ret_put >= WDT) {
				tainted_key_set = TRUE;
			} else {
				tainted_key = -1;
			}
		}


		if(ps->size == PS_SIZE) {
			return -1;
		}

		nodes_fail_and_recover_arbitrarily(ln);
		num_rounds --;
	}

	if (!tainted_key_set) {
		return -1;
	}

	_(assert hhs->size >= 0 && hhs->size <= HS_SIZE)
	_(assert tainted_key >= 0 && tainted_key < KEYS_NUM)
	
	_(assert tainted_key_set ==> tainted_key != -1 && tainted_coord == get_coord_for_key(tainted_key))
	// ============================== SAFETY CHECK ===========================================
	_(assert (\forall int j; (j >= 0 && j < PREFLIST_SIZE) 
				==> (ls->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]] 
					|| hhs->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]]
					|| ps->tainted_nodes[pl->preference_list[tainted_coord * PREFLIST_SIZE + j]]) ))
	

	all_nodes_recover(ln);
	permute_ps_idx(ps);
	permute_hhs_idx(hhs);

	int tmp_coord = tainted_coord * PREFLIST_SIZE;

	_(assert tainted_key_set ==> tainted_key != -1 && tainted_coord == get_coord_for_key(tainted_key))	
	// ============================== SAFETY CHECK ===========================================
	_(assert (\forall int j; (j >= 0 && j < PREFLIST_SIZE) ==>
							(ls->tainted_nodes[pl->preference_list[tmp_coord + j]] 
							|| hhs->tainted_nodes[pl->preference_list[tmp_coord + j]]
							|| ps->tainted_nodes[pl->preference_list[tmp_coord + j]])))

	// ================= LIVENESS ===========
	// ======== EVENTUAL CONSISTENCY ========
	empty_hhs_ps(pl, hhs, ls, ps, tainted_key, tainted_coord, tmp_coord);

	// ============================== SAFETY CHECK ===========================================
	_(assert (\forall int j; (j >= 0 && j < PREFLIST_SIZE) ==>
							(ls->tainted_nodes[pl->preference_list[tmp_coord + j]] 
							|| (hhs->tainted_nodes[pl->preference_list[tmp_coord + j]] && hhs->size == 0)
							|| (ps->tainted_nodes[pl->preference_list[tmp_coord + j]] && ps->size == 0))))

	return SUCCESS;
}

_(pure)
BOOL star()
	_(decreases 0)
;

int merge(int val, int value)
	_(decreases 0);

void harness_read_repair(int key, int coord, LiveNodes * ln, PreferenceLists * pl, HintedHandoffStores * hhs, LocalStores * ls, PendingSet * ps) 
	_(requires pl != NULL && ls != NULL && hhs != NULL)
	_(requires coord == get_coord_for_key(key))
	_(requires key >= 0 && key < KEYS_NUM)
	_(requires hhs->size < HS_SIZE)
	_(requires ps->size < PS_SIZE)
	_(requires ps->size >= 0)
	_(maintains \wrapped(ln))
	_(maintains \wrapped(hhs))
	_(maintains \wrapped(ls))
	_(maintains \wrapped(ps))
	_(maintains \wrapped(pl))
	_(writes ls)
	_(writes ps)
	_(writes hhs)

	_(decreases 0)
{
	BOOL consistent = FALSE;
	int cur_node;
	int i = 0;
	int val;
	while(consistent == FALSE) 
		_(decreases ps->size)
		_(invariant \wrapped(ln))
		_(invariant \wrapped(hhs))
		_(invariant \wrapped(ls))
		_(invariant \wrapped(ps))
		_(invariant \wrapped(pl))
		_(invariant ps->size < PS_SIZE)
		_(invariant consistent ==> \forall int j; (j >= 0 && j < PREFLIST_SIZE) ==> ls->local_store[pl->preference_list[coord * PREFLIST_SIZE + j]] == val)
		_(writes ls)
		_(writes ps)
		_(writes hhs)
	{
	
		while(i < PREFLIST_SIZE)
			_(decreases PREFLIST_SIZE - i)
			_(invariant \wrapped(ln))
			_(invariant \wrapped(hhs))
			_(invariant \wrapped(ls))
			_(invariant \wrapped(ps))
			_(invariant \wrapped(pl))
			_(invariant ps->size < PS_SIZE)
			_(invariant ps->size <= \old(ps->size))
			_(invariant consistent ==> \forall int j; (j >= 0 && j < PREFLIST_SIZE) ==> ls->local_store[pl->preference_list[coord * PREFLIST_SIZE + j]] == ls->local_store[pl->preference_list[coord * PREFLIST_SIZE]])

		{
			cur_node = pl->preference_list[coord * PREFLIST_SIZE + i];
			if(star() && ps->size > 0) {
				rm_pending_rr(pl, ls, ps);
			}

			val = merge(val, ls->local_store[cur_node]);

			if(star() && ps->size > 0) {
				rm_pending_rr(pl, ls, ps);
			}

			i ++;			
		}
		consistent = TRUE;
		i = 0;
		while(i < PREFLIST_SIZE) 
			_(decreases PREFLIST_SIZE - i)
			_(writes ls)
			_(writes ps)
			_(invariant \wrapped(ln))
			_(invariant \wrapped(ls))
			_(invariant \wrapped(ps))
			_(invariant \wrapped(pl))
			_(invariant ps->size < PS_SIZE)
			_(invariant i > 0 ==> cur_node >= 0 && cur_node < VNODES)
			_(invariant consistent ==> \forall int j; (j >= 0 && j < i) ==> ls->local_store[pl->preference_list[coord * PREFLIST_SIZE + j]] == val)
			_(invariant ps->size < \old(ps->size) || (ps->size == \old(ps->size) && consistent == TRUE))
		{
			cur_node = pl->preference_list[coord * PREFLIST_SIZE + i];
			if(star() && ps->size > 0) 
			{
				rm_pending_rr(pl, ls, ps);
				consistent = FALSE;
			}

			_(unwrap ls)
			ls->local_store[cur_node] = val;
			_(wrap ls)
			if(star() && ps->size > 0) {
				rm_pending_rr(pl, ls, ps);
				consistent = FALSE;
			}
			i ++;
		}
		
		if (consistent == TRUE) 
			break;		
	
	}
	_(assert \forall int j; (j >= 0 && j < PREFLIST_SIZE) ==> ls->local_store[pl->preference_list[coord * PREFLIST_SIZE + j]] == val)
}
