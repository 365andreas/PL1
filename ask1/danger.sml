fun parse file =
    let
    (* a function to read an integer from an input stream *)
        fun next_int input =
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
    (* open input file and read the two integers in the first line *)
        val stream = TextIO.openIn file
        val n = next_int stream
        val m = next_int stream
    val _ = TextIO.inputLine stream
    (* a function to read a list of lists of integers in subsequent lines *)
        fun scanner 0 acc = acc
          | scanner i acc =
            let
                val k = next_int stream
		(* a function to read a list of k integers in one line *)
                fun scanline 0 acc = acc
                  | scanline i acc =
                    let
                        val l = next_int stream
                    in
                        scanline (i - 1) (l :: acc)
                    end
                val line = rev(scanline k [k])
            in
                scanner (i - 1) (line :: acc)
            end
    in
        (n, m, rev(scanner m []))
    end;

fun compare (x, y) = 
	if List.nth(x,0) > List.nth(y,0) then
		true
	else
		false;

fun dangerous file =
let
    val (N, M, list_a) = parse file
in
	(N, M, ListMergeSort.sort compare list_a)
end;

(*val (N,M,list) = dangerous "danger.txt";*)
(*val z = Array.fromList(a);
hd(lista) -- head of list , K[i]
val que = Queue.mkQueue(): (int * int * int list) Queue.queue
val qu = Queue.mkQueue(): (int * int * int array) Queue.queue

*)
fun danger file =
	let
		val counter = ref 0		
		val (N, M, lista) = dangerous file                
		val arr = Array.fromList(lista)
		val i = ref 0
		val j = ref 1
                val flag = ref false
		val root = (~1,0,List.tabulate(N,fn x => 1))
		val q = Queue.mkQueue(): (int * int * int list) Queue.queue
		fun elegxos (count,row) = 
			let 
				val cnt = ref 1;
				val out = ref false;
			in
				while ( (!cnt <= count) andalso (!out = false) ) do(
					if ( List.nth(#3 (Queue.head(q)),List.nth(Array.sub(arr,row),!cnt) - 1 ) = 0 ) then (
						out := true
					) else();
					cnt := !cnt + 1
				);
				!out
			end
        in
		Queue.enqueue(q,root);
                while ( !i < M ) do (
			j := 1; 
			while ( (!flag = false) andalso (!j <= hd(Array.sub(arr,!i)))  ) do (
				(* elegxos *)
				if (!j = 1) then (
					flag := elegxos(hd(Array.sub(arr,!i)),!i);
					if !flag  then (
						i := !i + 1
					)
					else ()
				)
				else ();
				if ( !flag = false ) then (		
					counter := 0;
					Queue.enqueue(q, (!i, !j, List.map (fn x => if (!counter = List.nth(Array.sub(arr,!i),!j) - 1) then (counter := !counter + 1;0) else (counter := (!counter + 1);x)) (#3 (Queue.head(q)))));
					j := !j + 1
				)
				else ()
			);

			if (!i < M ) then (
				if ( !flag = false ) then (
					(*dequeue*)
					Queue.dequeue(q);
					i := (#1 (Queue.head(q)) + 1))
				else ( 
					flag := false 
				)
			)
			else()
		);
		counter := 0;
		List.filter (fn x => x<>0) (List.map (fn x => if x = 1 then (counter := !counter + 1;!counter) else (counter := !counter + 1;0)) (#3 (Queue.head(q))))
        end;