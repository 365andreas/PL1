#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct bfs {
    int row;
    int column;
    int *digits;
};

int N, M;
struct bfs *A[42*100000], *root;
int count_queue = 0;
int **measures;
int flag = 0;

int partition( int a[], int l, int r) {
   int pivot, i, j, t, *temp;
   pivot = a[l];
   i = l; j = r+1;
        
   while(1) {
    do ++i; while( a[i] <= pivot && i <= r );
   	do --j; while( a[j] > pivot );
   	if( i >= j ) break;
   	t = a[i]; a[i] = a[j]; a[j] = t;
   	temp = measures[i]; measures[i] = measures[j]; measures[j] = temp;
   }
   
   t = a[l]; a[l] = a[j]; a[j] = t;
   temp = measures[l]; measures[l] = measures[j]; measures[j] = temp;
   
   return j;
}

void quickSort( int a[], int l, int r) {
   int j;

   if( l < r ) 
   {
   	// divide and conquer
       j = partition( a, l, r);
       quickSort( a, l, j-1);
       quickSort( a, j+1, r);
   }	
}

int elegxos(int count, int row) {
    int i;

    for (i = 0; i < count; i++) {
        if (root->digits[measures[row][i]-1] == 0) {
            flag = 1;
            break;
        }
        else
            flag = 0;
    }
    return flag;
}

void dequeue() {
    int i;

    for (i = 0; i < count_queue-1; i++) {
        A[i] = A[i+1];
    }
}

int main( int argc, char *argv[] ) {
    
    FILE *fp;
    struct bfs *node;
    int i, j;	
    int *K;
        
    // argc should be 2 for correct execution 
    if ( argc != 2 ) {

        // We print argv[0] assuming it is the program name 
        printf( "Usage: %s filename", argv[0] );
        exit(0);
    }
    else {

        // We assume argv[1] is a filename to open
        fp = fopen( argv[1], "r" );
    }
    
    if(fp == NULL) {
        printf("File not found.\n");
        exit(0);
    }
    
    if (fscanf(fp, "%d", &N) == EOF) printf("Can't read from file.\n");
    if (fscanf(fp, "%d", &M) == EOF) printf("Can't read from file.\n");
        
    measures = malloc (M * sizeof(int*));
    K = malloc (M * sizeof(int));
    for (i = 0; i < M; i++) A[i] = malloc (sizeof(struct bfs *));
                
    for (i = 0; i < M; i++) {
        if (fscanf(fp, "%d", &K[i]) == EOF) printf("Can't read from file.\n");
        measures[i] = malloc (K[i] * sizeof(int));
        for (j = 0; j < K[i]; j++) {
            if (fscanf(fp, "%d", &measures[i][j]) == EOF) printf("Can't read from file.\n");
        }
    }
    quickSort(K,0,M-1);	
    //init struct
    node = malloc (sizeof(*node));
    root = malloc (sizeof(*node));
    node->digits = malloc (N * sizeof(int *));
    root->digits = malloc (N * sizeof(int *));	
    for (i = 0; i < N; i++) 
        node->digits[i] = 1;
    memcpy(root->digits,node->digits,N * sizeof(int *));	
    root->row = 0;
    root->column = 0;	
    i = 0;
    j = 0;
escape:
    if (flag == 1) {
        i++;
        j = 0;
    }
    while (i < M) {
        while (j < K[i]) {
            if ((j == 0) && (elegxos(K[i], i) == 1))
                goto escape;
            node = malloc (sizeof(*node));
            node->digits = malloc (N * sizeof(int *));
            memcpy(node->digits,root->digits,N * sizeof(int *));	
            node->row = i;
            node->column = j;
            A[count_queue] = node;
            count_queue++;						
            node->digits[measures[i][j]-1] = 0;			
            j++;
        }
        flag = 0;
        j = 0;
        if (i > 0) {
            dequeue();
            count_queue--;
        }
        root = A[0];
        i = root->row + 1;
    }
    for (i = 0; i < N; i++) {	
        if (root->digits[i] == 1)
            printf("%d ", i+1);
    }
    printf("\n");
    return 0;
}
