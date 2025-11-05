/*

This program will numerically compute the integral of

                  4/(1+x*x) 
				  
from 0 to 1.  The value of this integral is pi -- which 
is great since it gives us an easy way to check the answer.

History: Written by Tim Mattson, 11/1999.
         Modified/extended by Jonathan Rouzaud-Cornabas, 10/2022
*/

#include <limits>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <sys/time.h>
#include <omp.h>

static long num_steps = 100000000;
int num_threads = 6; // Par défaut 6 threads (1 par cœur physique)
double step;

int main (int argc, char** argv)
{
    
      // Read command line arguments.
      for ( int i = 0; i < argc; i++ ) {
        if ( ( strcmp( argv[ i ], "-N" ) == 0 ) || ( strcmp( argv[ i ], "-num_steps" ) == 0 ) ) {
            num_steps = atol( argv[ ++i ] );
            printf( "  User num_steps is %ld\n\n", num_steps );
        } else if ( ( strcmp( argv[ i ], "-C" ) == 0 ) || ( strcmp( argv[ i ], "-cores" ) == 0 ) ) {
            num_threads = atoi( argv[ ++i ] );
            printf( "  User num_threads is %d\n", num_threads );
        } else if ( ( strcmp( argv[ i ], "-h" ) == 0 ) || ( strcmp( argv[ i ], "-help" ) == 0 ) ) {
            printf( "  Pi Options:\n" );
            printf( "  -num_steps (-N) <int>:      Number of steps to compute Pi (by default 100000000)\n" );
            printf( "  -cores (-C) <int>:          Number of threads to use (by default 6)\n" );
            printf( "  -help (-h):            print this message\n\n" );
            exit( 1 );
        }
      }
      
	  int i;
	  double x, pi, sum, sum_per_thread = 0.0;

    // printf("Using %d threads\n", omp_get_num_threads()); // devra donner un car pas de parallélisme ici
    // printf("Maximum available threads: %d\n", omp_get_max_threads());
	  
    omp_set_num_threads(num_threads);
    int N = num_threads;
    
    step = 1.0/(double) num_steps;

    // Timer products.
    struct timeval begin, end;

    gettimeofday( &begin, NULL );

    // Print thread info before the parallel for loop
    #pragma omp parallel
    {
        #pragma omp single
        {
            printf("  Using %d threads\n", omp_get_num_threads());
            printf("  Maximum available threads: %d\n", omp_get_max_threads());
        }
    }

    #pragma omp parallel for shared(sum) \
            private(sum_per_thread)
    for (int j=0;j<N; j++){
        sum_per_thread = 0;
        for (i=1;i<= num_steps/N; i++){
            int k = i + j*(num_steps/N);
            x = (k-0.5)*step;
            sum_per_thread = sum_per_thread + 4.0/(1.0+x*x);
        }
        #pragma omp atomic
        sum = sum + sum_per_thread;
    }
    // Dans ce cas on divise les num_steps en plusieurs arrary et chaque thread calcule la somme de son array et à la fin on fait la somme de toutes les sommes partielles.
    //Cette méthode est mieux car on diminue le nombre de synchronisations qui sont très couteuses mais obligatoire pout le parallélisme.
    // Si on fait du parallelisme imbrique, on revient dans le cas precedent car chaque thread calcule l aire d un rectangle comme avant. et vu qu on ajoute le fait de diviser num step ca empire le truc car plus de synchronisaation et plus de paralleilsme inutile

	  pi = step * sum;

      
      gettimeofday( &end, NULL );

      // Calculate time.
      double time = 1.0 * ( end.tv_sec - begin.tv_sec ) +
                1.0e-6 * ( end.tv_usec - begin.tv_usec );
                
      printf("\n pi with %ld steps is %lf in %lf seconds\n ",num_steps,pi,time);
}