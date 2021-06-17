#problem compiling threads 20
#note: thread16 does not exist
INCLUDE_DIRS = 
LIB_DIRS = 

CC=gcc -std=c99 -I/usr/local/include -L/usr/local/lib 

CDEFS=
CFLAGS= -O0 -g -Wall $(INCLUDE_DIRS) $(CDEFS)
//CFLAGS= -O3 -Wall -pg -msse3 -malign-double -g $(INCLUDE_DIRS) $(CDEFS)
LIBS= -lgsl -lgslcblas -lm -lpthread


HFILES= 

all: thread0

thread0: thread0.c
	$(CC) -o thread0 thread0.c   $(CFLAGS) $(LIBS)


clean:
	-rm -f *.o *.NEW *~ gmon.out
	-rm -f thread0

depend:

.c.o:
	$(CC) $(CFLAGS) -c $<
