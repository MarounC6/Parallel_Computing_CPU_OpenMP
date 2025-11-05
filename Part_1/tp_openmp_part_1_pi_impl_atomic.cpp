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
	  double x, pi, sum = 0.0;

    // printf("Using %d threads\n", omp_get_num_threads()); // devra donner un car pas de parallélisme ici
    // printf("Maximum available threads: %d\n", omp_get_max_threads());
	  
    omp_set_num_threads(num_threads);
    
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
      private(x) // on crée num_steps threads (par défaut, le nombre de threads est égal au nombre de coeurs physiques de la machine)
                 // chaque thread a sa propre variable x (private) mais ils partagent la variable sum (shared)
                 // on protège l'accès à la variable sum avec une section critique (exclusion mutuelle)
    
    
       for (i=1;i<= num_steps; i++){
      //   if (omp_get_thread_num() == 0) {
      //     printf("  [Master] Number of threads: %d\n", omp_get_num_threads());
      //   }
      // On ne peut pas faire ca car on n a que 12 ou 6 threads max or on utilise environ 1 milliars de threads donc on aura plusieurs threads numero 0 et pas un seul fhemet 3laye? So on fait plus haut le single pour ne pas l'imprimer 100000000/12 fois.
        x = (i-0.5)*step; // x est une variable privée private donc elle est différente pour chaque thread, il n'est pas nécessaire de l'inclure dans l'exclusion mutuelle
                         // sum est une variable partagée entre les threads, il faut donc la protéger avec une section critique (exclusion muttuelle)
        #pragma omp atomic
        sum = sum + 4.0/(1.0+x*x);
    }

	  pi = step * sum;

      
      gettimeofday( &end, NULL );

      // Calculate time.
      double time = 1.0 * ( end.tv_sec - begin.tv_sec ) +
                1.0e-6 * ( end.tv_usec - begin.tv_usec );
                
      printf("\n pi with %ld steps is %lf in %lf seconds\n ",num_steps,pi,time);
}