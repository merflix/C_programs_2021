//An example of thread creation and deletion follows:

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

typedef struct {
    int *ar;
    long n;
} subarray;


void *
incer(void *arg)
{
    long i;
	 printf("\n");
    for (i = 0; i < ((subarray *)arg)->n; i++) {
        ((subarray *)arg)->ar[i] = i;
		  printf("ar[%ld]= %d\n", i, ((subarray *)arg)->ar[i] );
	 }
	 return NULL; //required to avoid a warning
}


int main(void)
{
    int        ar[100];
    pthread_t  th1, th2;
    subarray   sb1, sb2;


    sb1.ar = &ar[1];
    sb1.n  = 5;
    (void) pthread_create(&th1, NULL, incer, &sb1);


    sb2.ar = &ar[2];
    sb2.n  = 6;
    (void) pthread_create(&th2, NULL, incer, &sb2);


    (void) pthread_join(th1, NULL);
    (void) pthread_join(th2, NULL);
    return 0;
}
