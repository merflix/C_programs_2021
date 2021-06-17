#include <stdio.h>
#include <string.h>
#include <locale.h>

void main(){

	setlocale(LC_ALL,"");	
	char *str="Abracadabraé";
	size_t l=  strlen(str);
	printf("len= %ld\n", l);

	printf("last %c\n  é=%c\n", str[l-1], 137);

}
