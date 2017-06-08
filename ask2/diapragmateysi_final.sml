fun power ((m, n) :(IntInf.int * IntInf.int))
  = if n <= 0 
  then 1
  else (m * power(m, n-1)) :IntInf.int

fun power5 n : IntInf.int
  = if n <= 0 
  then 1
  else (5 * power5 (n-1)) :IntInf.int

fun power10 n : IntInf.int
  = if n <= 0 
  then 1
  else (10 * power10 (n-1)) :IntInf.int

val five_exp = Array.tabulate(12, power5 ): IntInf.int array
val dec_exp = Array.tabulate(12, power10 ): IntInf.int array

fun compute_dec  12 (base) (value ) = value 
  | compute_dec  i base value = 
     compute_dec (i+1) (base mod (Array.sub(dec_exp,(11-i)))) (value + (base div (Array.sub(dec_exp,(11-i)))) * (Array.sub(five_exp,(11-i))))


fun turn_clockwise (li : IntInf.int) (number : IntInf.int) = 
    let
        val save = ref 0 : IntInf.int ref
        val tmp = ref 0 : IntInf.int ref
        val lint = ref li : IntInf.int ref
    in
        if (number = 1) then (
            save := (!lint div 100000000000); (* 0->3 *)
            tmp := !lint - (!save * 100000000000) + (!save * 100000000);
            save := ((!lint div 1000000000) mod 10); (* 2->0 *)
            tmp := !tmp - (!save * 1000000000) + (!save * 100000000000);
            save := ((!lint div 1000000) mod 10); (* 5->2 *)
            tmp := !tmp - (!save * 1000000) + (!save * 1000000000);
            save := ((!lint div 100000000) mod 10); (* 3->5 *)
            tmp := !tmp - (!save * 100000000) + (!save * 1000000)
        ) else if (number = 2) then (
            save := (!lint div 10000000000) mod 10; (* 1->4 *)
            tmp := !lint - (!save * 10000000000) + (!save * 10000000);
            save := ((!lint div 100000000) mod 10); (* 3->1 *)
            tmp := !tmp - (!save * 100000000) + (!save * 10000000000);
            save := ((!lint div 100000) mod 10); (* 6->3 *)
            tmp := !tmp - (!save * 100000) + (!save * 100000000);
            save := ((!lint div 10000000) mod 10); (* 4->6 *)
            tmp := !tmp - (!save * 10000000) + (!save * 100000)
        ) else if (number = 3) then (
            save := (!lint div 1000000) mod 10; (* 5->8 *)
            tmp := !lint - (!save * 1000000) + (!save * 1000);
            save := ((!lint div 10000) mod 10); (* 7->5 *)
            tmp := !tmp - (!save * 10000) + (!save * 1000000);
            save := ((!lint div 10) mod 10); (* 10->7 *)
            tmp := !tmp - (!save * 10) + (!save * 10000);
            save := ((!lint div 1000) mod 10); (* 8->10 *)
            tmp := !tmp - (!save * 1000) + (!save * 10)
        ) else if (number = 4) then (
            save := (!lint div 100000) mod 10; (* 6->9 *)
            tmp := !lint - (!save * 100000) + (!save * 100);
            save := ((!lint div 1000) mod 10); (* 8->6 *)
            tmp := !tmp - (!save * 1000) + (!save * 100000);
            save := (!lint mod 10); (* 11->8 *)
            tmp := !tmp - !save + (!save * 1000);
            save := ((!lint div 100) mod 10); (* 9->11 *)
            tmp := !tmp - (!save * 100) + !save
        ) else ();
        !tmp
    end

fun turn_counterclockwise (li : IntInf.int) (number : IntInf.int) = 
    let
        val save = ref 0 : IntInf.int ref
        val tmp = ref 0 : IntInf.int ref
        val lint = ref li : IntInf.int ref
    in
        if (number = 1) then (
            save := (!lint div 100000000) mod 10; (* 0<-3 *)
            tmp := !lint - (!save * 100000000) + (!save * 100000000000);
            save := ((!lint div 100000000000) mod 10); (* 2<-0 *)
            tmp := !tmp - (!save * 100000000000) + (!save * 1000000000);
            save := ((!lint div 1000000000) mod 10); (* 5<-2 *)
            tmp := !tmp - (!save * 1000000000) + (!save * 1000000);
            save := ((!lint div 1000000) mod 10); (* 3<-5 *)
            tmp := !tmp - (!save * 1000000) + (!save * 100000000)
        ) else if (number = 2) then (
            save := (!lint div 10000000) mod 10; (* 1<-4 *)
            tmp := !lint - (!save * 10000000) + (!save * 10000000000);
            save := ((!lint div 10000000000) mod 10); (* 3<-1 *)
            tmp := !tmp - (!save * 10000000000) + (!save * 100000000);
            save := ((!lint div 100000000) mod 10); (* 6<-3 *)
            tmp := !tmp - (!save * 100000000) + (!save * 100000);
            save := ((!lint div 100000) mod 10); (* 4<-6 *)
            tmp := !tmp - (!save * 100000) + (!save * 10000000)
        ) else if (number = 3) then (
            save := (!lint div 1000) mod 10; (* 5<-8 *)
            tmp := !lint - (!save * 1000) + (!save * 1000000);
            save := ((!lint div 1000000) mod 10); (* 7<-5 *)
            tmp := !tmp - (!save * 1000000) + (!save * 10000);
            save := ((!lint div 10000) mod 10); (* 10<-7 *)
            tmp := !tmp - (!save * 10000) + (!save * 10);
            save := ((!lint div 10) mod 10); (* 8<-10 *)
            tmp := !tmp - (!save * 10) + (!save * 1000)
        ) else if (number = 4) then (
            save := (!lint div 100) mod 10; (* 6<-9 *)
            tmp := !lint - (!save * 100) + (!save * 100000);
            save := ((!lint div 100000) mod 10); (* 8<-6 *)
            tmp := !tmp - (!save * 100000) + (!save * 1000);
            save := ((!lint div 1000) mod 10); (* 11<-8 *)
            tmp := !tmp - (!save * 1000) + !save ;
            save := (!lint mod 10); (* 9<-11 *)
            tmp := !tmp - !save + (!save * 100)
        ) else ();
        !tmp
    end

fun make_long_integer arr 12 num = num 
   |make_long_integer arr i num = 
    make_long_integer arr (i+1) (num*10 + Int.toLarge(Array.sub(arr,i))) 


fun diapragmateysi (str : string) =
    let
    val str_reverse = implode o rev o explode;
    val int_arr = Array.tabulate(String.size(str),(fn x => if (String.sub(str,x) >= #"y") then 4 else if (String.sub(str,x) >= #"r") then 3 else if (String.sub(str,x) >= #"g") then 1 else if (String.sub(str,x) >= #"b") then 2 else if (String.sub(str,x) >= #"G") then 0 else 1))

    val curr_value = ref (make_long_integer int_arr 0 0 ): IntInf.int ref
    val forward = ref true
    val curr_value_back = ref 212010030434: IntInf.int ref
    val start_value = (make_long_integer int_arr 0 0 ): IntInf.int
    val ht = IntHashTable.mkTable ( 1, Fail "not found") : IntInf.int IntHashTable.hash_table
    val ht_back = IntHashTable.mkTable ( 1, Fail "not found") : IntInf.int IntHashTable.hash_table
    val moves = ref 0 : IntInf.int ref
    val moves2 = ref 0 : IntInf.int ref
	val i = ref 1 : IntInf.int ref
	val root = ref (!curr_value,!moves) : (IntInf.int * IntInf.int) ref
	val q = Queue.mkQueue() : (IntInf.int * IntInf.int) Queue.queue
	val root_back = ref (!curr_value_back,!moves) : (IntInf.int * IntInf.int) ref
	val q_back = Queue.mkQueue() : (IntInf.int * IntInf.int) Queue.queue
    val continue = ref true
    val dec = ref 0 : int ref
    val dec_back = ref 0 : int ref
    val output = ref "" : string ref

    in
        Queue.enqueue(q,!root);
        Queue.enqueue(q_back,!root_back);
    
        while ( not(Queue.isEmpty(q)) ) do (
        root := Queue.dequeue(q);
        
        i := 1; 
		while (!i < 5) do (
            if (!curr_value = 212010030434) then (
                moves2 := 0;
                i := 6; 
                continue := false;
                Queue.clear q
            ) else(
                curr_value := turn_clockwise (#1(!root)) (!i);	
                dec := Int.fromLarge(compute_dec 0 (!curr_value) 0);
            
                if ( (IntHashTable.find ht (!dec)) = NONE ) then ( 
                    moves := ((#2(!root)) * 10) + !i;
                    Queue.enqueue(q,(!curr_value, !moves));
                    IntHashTable.insert ht (!dec,!moves)
                ) else ();
            
                if ( (IntHashTable.find ht_back (!dec)) <> NONE ) then ( 
                    
                    moves2 := IntHashTable.lookup ht_back (!dec);
                    i := 6; 
                    continue := false;
                    Queue.clear(q)
                ) else ();
                i := !i + 1
            )
        );
        
        if (!continue = true) then (
            i := 1;
            root_back := Queue.dequeue(q_back)
        ) else();
        while (!i < 5) do (
            curr_value_back := turn_counterclockwise (#1(!root_back)) (!i);	
            dec_back := Int.fromLarge(compute_dec 0 (!curr_value_back) 0);
            if ( (IntHashTable.find ht_back (!dec_back)) = NONE ) then ( 
                moves2 := ((#2(!root_back)) * 10) + !i;
                Queue.enqueue(q_back,(!curr_value_back, !moves2));
                IntHashTable.insert ht_back (!dec_back,!moves2)
            ) else ();

            if ( (IntHashTable.find ht (!dec_back)) <> NONE ) then ( 
                print("deuteri\n");
                moves := IntHashTable.lookup ht (!dec_back);
                i := 6; 
                Queue.clear q
            ) else ();			
            i := !i + 1
                )
        );
    if ( (!moves mod 1000000000) <> 0 ) then (
        output := !output ^ Int.toString(Int.fromLarge(!moves mod 1000000000))
    ) else ();
    if ( (!moves div 1000000000) <> 0 ) then (	
        output :=  Int.toString(Int.fromLarge(!moves div 1000000000)) ^ !output 
    ) else ();
    if ( (!moves2 mod 1000000000) <> 0 ) then (
        output := !output ^ str_reverse(Int.toString(Int.fromLarge(!moves2 mod 1000000000)))
    ) else ();
    if ( (!moves2 div 1000000000) <> 0 ) then (	
        output :=  str_reverse (Int.toString(Int.fromLarge(!moves2 div 1000000000))) ^ !output 
    ) else ();
    !output
     end