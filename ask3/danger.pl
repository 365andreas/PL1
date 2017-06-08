danger2(File, Msrs) :- (
	read_and_return(File, N, DangerousCombinations),once(predsort(cmp_length, DangerousCombinations, Cs)),
	combinations(List, N, -1),Node = [-1|List],add_Q_fast(Node, X-X, Q-LL),
	search_function(Q-LL, Cs, _, Msrs)
).

read_and_just_print_dangers(File) :-
    open(File, read, Stream),
    repeat,
    read_line_to_codes(Stream, X),
    ( X \== end_of_file -> writeln(X), fail ; close(Stream), ! ).

read_and_return(File, N, DangerousCombinations) :-
    open(File, read, Stream),
    read_line(Stream, [N, M]),
    read_segs(Stream, M, DangerousCombinations),
    close(Stream).

read_segs(Stream, M, DangerousCombinations) :-
    ( M > 0 ->
	DangerousCombinations = [Combo|Rest],
        read_line(Stream, [K|Combo]),
	length(Combo, K), %% just an assertion for for extra safety 
        M1 is M - 1,
        read_segs(Stream, M1, Rest)
    ; M =:= 0 ->
	DangerousCombinations = []
    ).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(A, Line),
    atomic_list_concat(As, ' ', A),
    maplist(atom_number, As, L).

combinations(L, M, N) :-
	M =< 0 -> L = [] ;
	M > 0 -> (
		length(L, M),
		create(L, M, N)
	).

create([H|T], M, N) :- ( 
	N =:= M -> H = 0 ; H = 1,
	succ(N1, M),
	combinations(T, N1, N)
).

cmp_length(Result, [_|T], [_|T1]) :- (
	length(T, L),
	length(T1, L1),
	L \= L1 -> compare(Result, L, L1);
	true
).

print_solution([H|T], Old_L, Id, Length, C, Msrs) :- (
	Counter is Id+1,
	Counter =< C -> (
		H =:= 1 -> (
			Increment is Length+1,
			length([H2|T2], Increment),
			H2 = Counter,
			T2 = Old_L,
			(
				Counter < C -> print_solution(T, [H2|T2], Counter, Increment, C, Msrs)
				; reverse([H2|T2], Msrs)
			)
		);(
			(
				Counter < C -> print_solution(T, Old_L, Counter, Length,  C, Msrs)
				; reverse(Old_L, Msrs)
			)
		)
	) ; true	
).

check([H|Tl], Elem, L, List, Id, [Hd|T]-LL, Cs, Sol, Msrs) :- (
	Decrement is L - 1,
	I is H - 1,
	nth0(I, List, Number),
	(Number =:= 0 -> ( 
		Nn_Id is Id + 1,
		length(Cs, M),
		(Nn_Id >= M -> ( length(List, Len), print_solution(List, [], 0, 0, Len, Msrs) ) 
		; (nth0(Nn_Id, Cs, Nn_Elem),length(Nn_Elem, Nn_L),
		check(Nn_Elem, Nn_Elem, Nn_L, List, Nn_Id, [Hd|T]-LL, Cs, Sol, Msrs)	
		))
	) ; ( L > 1 -> (check(Tl, Elem, Decrement, List, Id, [Hd|T]-LL, Cs, Sol, Msrs)
		) ; ( length(Elem, Length), 
		search_function_row(Elem, Length, List, Id, [Hd|T]-LL, Cs, Msrs) 
		)
		)
	)
).

search_function([Hd|T]-LL, Cs, Sol, Msrs) :- (
	Hd = [Head|List], Id is Head+1,length(Cs, M),
	(Id >= M -> (length(Sol, Length), print_solution(Sol, [], 0, 0, Length, Msrs));
		(nth0(Id, Cs, Elem),length(Elem, L),check(Elem, Elem, L, List, Id, [Hd|T]-LL, Cs, Sol, Msrs))
	)
).	

add_Q(E, [], [E]).
add_Q(E, [H|T], [H|TNn]) :- add_Q(E, T, TNn).		
add_Q_fast(Elem, Q-X, Q-Y) :- X = [Elem|Y].

search_function_row([H|T], L, List, Id, Q-LL, Cs, Msrs) :- (
		succ(Decrement,L),length(List, Len),length(Node_L, Len),
		member_allag(H, List, Node_L, 0),
		Node = [Id|Node_L],
		add_Q_fast(Node, Q-LL, Nn_Q-Nn_LL),
		(L > 1 -> (search_function_row(T, Decrement, List, Id, Nn_Q-Nn_LL, Cs, Msrs));
			Nn_Q = [_|Tl], search_function(Tl-Nn_LL, Cs, Node_L, Msrs)
		)		
).

member_allag(Id, [H|T], [H1|T1], Repeat) :- (
	Repeat =< Id -> ( II is Id-1,
		II =:= Repeat -> (H1 = 0,T1 = T);
		(H1 = H,succ(Repeat, Increment),member_allag(Id, T, T1, Increment)));
	true
).