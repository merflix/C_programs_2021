/*
   Solving a system of linear equations by LU decomposition
   System: a*x= b
   Using linear interpolation with GSL
   Author: Analabha Roy (daneel@utexas.edu)
*/
//--------------------------------------------------------------------------------------------------------------------
// https://sites.google.com/a/phys.buruniv.ac.in/numerical/laboratory/example-codes/systems-of-linear-equations-in-gsl
//--------------------------------------------------------------------------------------------------------------------
#include <stdio.h>
#include <gsl/gsl_linalg.h>
#define M 3 // number of rows :wmatrix A

// print matrix line by line with precision set to 6
//--------------------------------------------------
int print_matrix(FILE *f, const gsl_matrix *m)
{
  int status, n = 0;

  for (size_t i = 0; i < m->size1; i++) {
		for (size_t j = 0; j < m->size2; j++) {
			if ((status = fprintf(f, "%*g ", 6,  gsl_matrix_get(m, i, j))) < 0)
				return -1;
			n += status;
	   }

	   if ((status = fprintf(f, "\n")) < 0)
			return -1;
		n += status;
  }
  return n;
}

// solve the system a*x=b and print matrice a and vectors 
int main (void)
{
	double a_data[M][M] = {{5.1, 2.0, 1.0},
		{2.21, 1.0, 3.0},
		{-1.03, 1.0, 2.0}
	};

	double b_data[M] = {25.0, 12.0, 5.0};
	gsl_matrix * a = gsl_matrix_alloc (M, M);
	gsl_vector * x = gsl_vector_alloc (M);
	gsl_vector * b = gsl_vector_alloc (M);
	int s;
	int i, j;
	for (i=0;i<M;i++)
		for (j=0;j<M;j++)
			gsl_matrix_set (a, i, j, a_data[i][j]);
	for (i=0;i<M;i++)
		gsl_vector_set (b, i, b_data[i]);
	
	printf ("Matrix A = \n");
	//gsl_matrix_fprintf (stdout, a, "%g"); //ok but one column format
	print_matrix(stdout, a);
	printf ("\nVector b = \n");
	gsl_vector_fprintf (stdout, b, "%g");
	gsl_permutation * p = gsl_permutation_alloc (3);
	gsl_linalg_LU_decomp (a, p, &s);
	gsl_linalg_LU_solve (a, p, b, x);
	printf ("\nSolution Vector x = \n");
	gsl_vector_fprintf (stdout, x, "%g");

	//free the memory
	gsl_permutation_free (p);
	gsl_matrix_free (a);
	gsl_vector_free (x);
	gsl_vector_free (b);
	return 0;
}
