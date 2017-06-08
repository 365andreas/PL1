
          
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.io.PrintWriter;
import java.lang.*;
import java.util.*;

public class  oratotita { 

    static Scanner scan;
    //static PrintWriter writer;
    static int[] xsw, ysw, xne, yne, diastimata;
    static float[] height, val_height;
    static boolean first;

    static int partition(int arr[], int left, int right) {
        int i = left, j = right;
        int tmp;
        float temp;
        int pivot = arr[(left + right) / 2];
         
        while (i <= j) {
            while (arr[i] < pivot)
                i++;
            while (arr[j] > pivot)
                j--;
            if (i <= j) {
                tmp = arr[i];
                arr[i] = arr[j];
                arr[j] = tmp;

                if (first) {
                	tmp = xsw[i];
                    xsw[i] = xsw[j];
                    xsw[j] = tmp;

                    tmp = xne[i];
                    xne[i] = xne[j];
                    xne[j] = tmp;

                    tmp = yne[i];
                    yne[i] = yne[j];
                    yne[j] = tmp;

                 	temp = height[i];
                  	height[i] = height[j];
                   	height[j] = temp;
                }
                i++;
                j--;
            }
        }
         
        return i;
    }
 
    static void quickSort(int arr[], int left, int right) {
      int index = partition(arr, left, right);
      if (left < index - 1)
            quickSort(arr, left, index - 1);
      if (index < right)
            quickSort(arr, index, right);
    }

    public static void main (String[] args) {
	int left;
	int right;
        int i = 0;
        int count = 0;
        int cnt = 0;
        int j = 0;
        boolean[] visibility;

        long startTime = System.currentTimeMillis();

        //open File
        try {
            scan = new Scanner(new File(args[0]));
        }
        catch(Exception e) {
            System.out.println("File not found");
            System.exit(1);
        }	
    
        //read File	
        int N = Integer.parseInt(scan.next());	
        //initialize arrays
        xsw = new int[N];
        ysw = new int[N];
        xne = new int[N];
        yne = new int[N];
        height = new float[N];
        visibility = new boolean[N];
        diastimata = new int[2*N];
        val_height = new float[2*N];

        //read file
        for( i = 0; i < N; i++ ) {
            xsw[i] = Integer.parseInt(scan.next());	
            ysw[i] = Integer.parseInt(scan.next());
            xne[i] = Integer.parseInt(scan.next());
            yne[i] = Integer.parseInt(scan.next());
            height[i] = Float.parseFloat(scan.next());
            visibility[i] = false;
            diastimata[cnt] = xsw[i];
            cnt++;
            diastimata[cnt] = xne[i];
            cnt++;
        }	
        Hashtable<Integer, Integer> htable = new Hashtable<Integer, Integer>(2*N);

        first = true;		
        quickSort(ysw, 0, N-1);
        first = false;
        quickSort(diastimata, 0, 2*N-1);
        cnt = 0;
        for( i = 0; i < 2*N; i++ ) {
            val_height[i] = 0;
            if (i != 2*N-1) {
                if (diastimata[i] != diastimata[i+1]) {
                    diastimata[cnt] = diastimata[i];
                    htable.put(diastimata[cnt], cnt);
                    cnt++;
                }
            }
            else {
                diastimata[cnt] = diastimata[i];
                htable.put(diastimata[cnt], cnt);
                cnt++;
            }
        }

        //compute visibility
        for ( i = 0; i < N; i++ ) {
		left = htable.get(xsw[i]);right = htable.get(xne[i]);
            for (j = left; j < right; j++) {
                if (val_height[j] < height[i]) {
                    visibility[i] = true;
                    val_height[j] = height[i];
                }
            }
            if (visibility[i] == true)
                count++;
        }
        System.out.println(count);
        long endTime   = System.currentTimeMillis();
        long totalTime = endTime - startTime;
        System.out.println(totalTime);
    }
}        
