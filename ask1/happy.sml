val sqr = Array.tabulate(10, fn x => x*x);

fun next_int input =
    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

fun check n =
        let
                val counter = ref n
                val temp = ref 0
        in
                while (!counter <> 0) do
                	(temp := !temp + (!counter mod 10)*(!counter mod 10);
                	counter := !counter div 10);
                !temp
        end;

fun checks n =
        let
                val counter = ref n
                val flag = ref false
                val x = ref []
        in
                while (!counter <> 1 andalso !flag = false) do
                	(counter := check(!counter);
            		flag := List.exists (fn y => y = !counter) (!x);
                	x := !x @ [!counter]);
                if !flag then
            0
        else
            1
        end;

val happylist =
        let
                val counter = ref 0
                val l = ref []
        in
                while (!counter <= 729) do
                	(l := !l @ [checks(!counter)];
                	counter := !counter+1);
                !l
        end;

val happyarray = Array.fromList happylist;

fun happy file =
        let
        val s = Array2.array(10,730,0);
        val digits = Array.array(10,0);
        val ins = TextIO.openIn file;
        val a = next_int ins;
        val b = next_int ins;
        val temp = ref 0;
        val lim = Array.array(10,0)
        val i = ref 0
        val j = ref 0
        val off = ref 0
        val num_dig = ref 0
        val up = ref 0
        val down = ref 0
        val prev = ref 0
        in
        i := 1;
            while (!i < 10) do (
            Array.update(lim,!i,Array.sub(lim,!i-1)+Array.sub(sqr,9));
            i := !i + 1
        );
        Array2.update(s,0,0,1);
        i := 1;
        while (!i < 10) do (
            j := 0;
            while ( !j <= Array.sub(lim,!i-1) ) do(
                off := 0;
                while ( !off < 10 ) do (
                    Array2.update(s,!i,!j+Array.sub(sqr,!off),Array2.sub(s,!i,(!j)+Array.sub(sqr,!off))+Array2.sub(s,!i-1,!j));
                    off := !off + 1
                );
            j := !j +1
            );
        i := !i + 1
        );
        temp := b + 1;
        while ( !temp > 0 ) do (
                Array.update(digits,!num_dig,(!temp mod 10));
                temp := !temp div 10;
                num_dig := !num_dig + 1
        );
        num_dig := !num_dig - 1;
        i := !num_dig;
        while (!i >= 0 ) do (
            off := 0;
            while (!off<Array.sub(digits,!i)) do(
                j := 0;
                while (!j <= Array.sub(lim,!i)) do (
                    up := !up  +  ( Array2.sub(s,!i,!j) * Array.sub(happyarray,(!j + Array.sub(sqr,!off) + !prev)));
                    j := !j +1
                );
                off := !off + 1
            );
            prev := !prev + Array.sub(sqr,Array.sub(digits,!i));
            i := !i - 1	
        );
        prev := 0;
        num_dig := 0;
        temp := a;
        while ( !temp > 0 ) do (
                Array.update(digits,!num_dig,(!temp mod 10));
                temp := !temp div 10;
                num_dig := !num_dig + 1
        );
        num_dig := !num_dig - 1;
        i := !num_dig;
        while (!i >= 0 ) do (
            off := 0;
            while (!off<Array.sub(digits,!i)) do(
                j := 0;
                while (!j <= Array.sub(lim,!i)) do (
                    down := !down  +  ( Array2.sub(s,!i,!j) * Array.sub(happyarray,(!j + Array.sub(sqr,!off) + !prev)));
                    j := !j +1
                );
                off := !off + 1
            );
            prev := !prev + Array.sub(sqr,Array.sub(digits,!i));
            i := !i - 1	
        );
        !up - !down
        end;
