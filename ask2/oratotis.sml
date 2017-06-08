fun parse file =
    	let
		(* a function to read an integer from an input stream *)
        	fun next_int input =
	    	Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
		(* a function to read a real that spans till the end of line *)
        	fun next_real input =
	    	Option.valOf (TextIO.inputLine input)
		(* open input file and read one integer in the first line *)
        	val stream = TextIO.openIn file
        	val n = next_int stream
		val _ = TextIO.inputLine stream
		(* a function to read four integers & a real in subsequent lines *)
        	fun scanner 0 (acc,intervals) = (acc,intervals)
          	| scanner i (acc,intervals) =
            	let
                	val xsw = next_int stream
			val ysw = next_int stream
			val xne = next_int stream
			val yne = next_int stream
                	val (SOME h) = Real.fromString (next_real stream)
            	in
                	scanner (i - 1) (((xsw, ysw, xne, yne, h) :: acc), xsw :: xne :: intervals)
            	end
    	in
        	(scanner n ([],[]),n)
    	end

fun compare_ysw ((a,b,c,d,e), (f,g,h,i,j)) = 

	if b > g then
        	true
    	else
            	false;

fun oratotis fileName = 
	let
		val input = (parse fileName)
		val n = (#2(input))
	 	val sorted = ListMergeSort.sort compare_ysw (#1(#1(input)))
		val arr_sorted = Array.fromList(sorted)
		val intervals = ListMergeSort.uniqueSort (fn (i,j) => if i > j then GREATER else if i < j then LESS else EQUAL) (#2(#1(input)))
		val arr_heights = Array.tabulate(List.length intervals,fn x => 0.0)
		val arr_intervals = Array.fromList(intervals)
		val ht = IntHashTable.mkTable (2*n, Fail "not found") : int IntHashTable.hash_table
		
		fun make_ht (a,0) = nil  
		| make_ht ((head::remain),i) =
		let
			val tmp = IntHashTable.insert ht (head,i-1)
		in
			make_ht (remain,i-1)
		end 
		val temp = make_ht (rev(intervals),List.length intervals)

	    	fun visibility (k,i,cnt) = if (k=i) then cnt else
		let 
			val flag = ref false
			val left = IntHashTable.lookup ht (#1(Array.sub(arr_sorted,i)))
			val right = IntHashTable.lookup ht (#3(Array.sub(arr_sorted,i)))
			val height = (#5(Array.sub(arr_sorted,i)))
			fun hash_search (j,r) = if (j = r) then !flag else
			let
			in
				if (Array.sub(arr_heights,j) < height) then( 
					flag := true;
					Array.update(arr_heights,j,height)
				)
				else();
				hash_search (j+1,r)
			end			
		in
			hash_search (left,right);
			visibility (k,(i+1),(if !flag then cnt+1 else cnt))
		end
	in
		visibility (n,0,0)
	end
