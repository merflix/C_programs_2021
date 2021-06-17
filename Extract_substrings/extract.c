#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// argument 1 is the sub-string to etract

int main(int argc, char*argv[]){

   if(argc < 2) {
		printf("prog. need sub-string index argument ");
		return(1);
	}
	
 	char *a = argv[1];
   int subs= atoi(a);
	char str[]= {"Maurice Eichenberger\n180 cm\n85 Kg\n"};
   char sol[100];

	//find position of backslashs
	int newline[10];
	int nbk= 0; //number of backslash found
	for(int i=0; i < strlen(str); i++){
		if(str[i] == '\n') {
   		newline[nbk]= i;
 			nbk++;	
   	}  
	}
	
	//string start and end
	int is= subs; 
	int ie= newline[subs];
	if(subs == 0){ 
		is= 0;  
		ie=newline[subs]; 
	}
	else{ 
		is= newline[subs-1] + 1;  
		ie= newline[subs]; 
	}
	
	for(int i=is, k=0; i< ie; i++, k++){
		sol[k]= str[i];
	}
	printf("sol: %s\n", sol);
	
   return 0;
}
