/* Queue */
add_queue2( Item, Queue-X, Queue-Y ) :-
	X = [Item|Y].
remove_queue2( X-Y, _, _ ) :-
	unify_with_occurs_check( X, Y ), !, fail.
remove_queue2( [Item|Queue]-X, Item, Queue-X ).

take1st([A|_],A).
take1st(A-_,A).	
take2nd([_|[B]],B).
take2nd(_-B,B).
	
list2int([], 0).
list2int([H|T], Sum) :-
   list2int(T, Rest),
   Sum is H + 10 * Rest.
   
transformation(Old, New) :-	( 

	Old = 121 -> New = 4 ; 
	Old = 114 -> New = 3 ;
	Old =  98 -> New = 2 ;
	Old = 103 -> New = 1 ;
	Old =  71 -> New = 0 ;
	New = -1 
).

turn_clockwise(Old, New, Code_no) :- (
	
	Code_no = 1 -> 
		S0 is  Old div 100000000000,
		S1 is (Old div   1000000000) mod 10,
		S2 is (Old div      1000000) mod 10,
		S3 is (Old div    100000000) mod 10,
		New is Old - (S0 * 100000000000) + (S0 * 100000000) - (S1 * 1000000000) + (S1 * 100000000000) - (S2 * 1000000) + (S2 * 1000000000)- (S3 * 100000000) + (S3 * 1000000);
	Code_no = 2 -> 
		S0 is (Old div 10000000000) mod 10,
		S1 is (Old div   100000000) mod 10,
		S2 is (Old div      100000) mod 10,
		S3 is (Old div    10000000) mod 10,
		New is Old - (S0 * 10000000000) + (S0 * 10000000) - (S1 * 100000000) + (S1 * 10000000000) - (S2 * 100000) + (S2 * 100000000)- (S3 * 10000000) + (S3 * 100000);
	Code_no = 3 -> 
		S0 is (Old div 1000000) mod 10,
		S1 is (Old div   10000) mod 10,
		S2 is (Old div      10) mod 10,
		S3 is (Old div    1000) mod 10,
		New is Old - (S0 * 1000000) + (S0 * 1000) - (S1 * 10000) + (S1 * 1000000) - (S2 * 10) + (S2 * 10000)- (S3 * 1000) + (S3 * 10);
	Code_no = 4 -> 
		S0 is (Old div 100000) mod 10,
		S1 is (Old div   1000) mod 10,
		S2 is (Old           ) mod 10,
		S3 is (Old div    100) mod 10,
		New is Old - (S0 * 100000) + (S0 * 100) - (S1 * 1000) + (S1 * 100000) - (S2) + (S2 * 1000)- (S3 * 100) + (S3);	
	false
).

turn_counterclockwise(Old, New, Code_no) :- (
	
	Code_no = 1 -> 
		S0 is (Old div    100000000) mod 10,
		S1 is (Old div 100000000000) mod 10,
		S2 is (Old div   1000000000) mod 10,
		S3 is (Old div      1000000) mod 10,
		New is Old - (S0 * 100000000) + (S0 * 100000000000) - (S1 * 100000000000) + (S1 * 1000000000) - (S2 * 1000000000) + (S2 * 1000000)- (S3 * 1000000) + (S3 * 100000000);
	Code_no = 2 -> 
		S0 is (Old div    10000000) mod 10,
		S1 is (Old div 10000000000) mod 10,
		S2 is (Old div   100000000) mod 10,
		S3 is (Old div      100000) mod 10,
		New is Old - (S0 * 10000000) + (S0 * 10000000000) - (S1 * 10000000000) + (S1 * 100000000) - (S2 * 100000000) + (S2 * 100000)- (S3 * 100000) + (S3 * 10000000);
	Code_no = 3 -> 
		S0 is (Old div    1000) mod 10,
		S1 is (Old div 1000000) mod 10,
		S2 is (Old div   10000) mod 10,
		S3 is (Old div      10) mod 10,
		New is Old - (S0 * 1000) + (S0 * 1000000) - (S1 * 1000000) + (S1 * 10000) - (S2 * 10000) + (S2 * 10)- (S3 * 10) + (S3 * 1000);
	Code_no = 4 -> 
		S0 is (Old div    100) mod 10,
		S1 is (Old div 100000) mod 10,
		S2 is (Old div   1000) mod 10,
		S3 is (Old           ) mod 10,
		New is Old - (S0 * 100) + (S0 * 100000) - (S1 * 100000) + (S1 * 1000) - (S2 * 1000) + (S2) - (S3) + (S3 * 100);	
	false
).

turn_it_save_it(Tmp, Mov, Id, Q, Qnew, A, Anew) :- (

	turn_clockwise(Tmp, Curr, Id),
	(get_assoc(Curr,A,_) -> (
		Anew = A,
		Qnew = Q
	);(
		TT is Mov * 10 + Id,
		put_assoc(Curr, A, TT, Anew),
		add_queue2([Curr, TT], Q, Qnew)
	))
).

counter_turn_it_save_it(Tmp, Mov, Id, Q, Qnew, A, Anew) :- (

	turn_counterclockwise(Tmp, Curr, Id),
	(get_assoc(Curr,A,_) -> (
		Anew = A,
		Qnew = Q
	);(
		TT is Mov * 10 + Id,
		put_assoc(Curr, A, TT, Anew),
		add_queue2([Curr, TT], Q, Qnew)
	))
).

loop(Q, Qb, Moves, Assoc, Assocb) :- (
	
	remove_queue2(Q, Head, Qu) -> (
		take1st(Head, Value),
		take2nd(Head, Mov),(
		Value =:= 212010030434 -> (
			take2nd(Head, Moves)
		);(
			turn_it_save_it(Value, Mov, 1, Qu, Que, Assoc, Associ),
			turn_it_save_it(Value, Mov, 2, Que, Queu, Associ, Associa),
			turn_it_save_it(Value, Mov, 3, Queu, Queue, Associa, Associat),
			turn_it_save_it(Value, Mov, 4, Queue, Qnew, Associat, Assoc_new),
			
			remove_queue2(Qb, Headb, Qub),
			take1st(Headb, Valueb),
			take2nd(Headb, Movb),
			((get_assoc(Valueb,Assoc_new,MO)) -> (
				number_codes(MO,CCodes),
				number_codes(Movb,C),
				reverse(C,CCodesback),
				append(CCodes,CCodesback,Moves)
			);(
				counter_turn_it_save_it(Valueb, Movb, 1, Qub, Queb, Assocb, Associb),
				counter_turn_it_save_it(Valueb, Movb, 2, Queb, Queub, Associb, Associab),
				counter_turn_it_save_it(Valueb, Movb, 3, Queub, Queueb, Associab, Associatb),
				counter_turn_it_save_it(Valueb, Movb, 4, Queueb, Qnewb, Associatb, Assoc_newb),
				loop(Qnew, Qnewb, Moves, Assoc_new, Assoc_newb)
			))
			)
		)
	)
).

diapragmateysi4(String, Moves) :- (

	string_codes(String, AsciiCodes),
	maplist(transformation, AsciiCodes, Codes),
	reverse(Codes, Rev),
	list2int(Rev, Curr_value),
	Curr_value_back = 212010030434,
	add_queue2([Curr_value,0], X-X, Q),
	add_queue2([Curr_value_back,0], Z-Z, Qb),
	is_assoc(As),
	is_assoc(Asb),
	put_assoc(Curr_value, As, 0, Assoc),
	put_assoc(Curr_value_back, Asb, 0, Assocb),
	loop(Q, Qb, Moves, Assoc, Assocb)%,
	%number_codes(Moves,Movs)
).

/*
	set_prolog_flag(toplevel_print_options,[quoted(true), portray(true), max_depth(0), spacing(next_argument)]).
*/