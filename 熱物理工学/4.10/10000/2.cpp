// tracing the 2-dimensioned brownian motion: ver.2
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define mass       1.0  // the mass of quantum
#define gamma      1.0  // the coefficient of friction
#define c_rand     1.0  // the random force 
#define delta_t    0.1  // the intervals
#define total_step 10000 // the steps of calculation

double fr()
{
	double factor;
	factor = sqrt((3 * c_rand) / (2 * delta_t));
	return (rand() / (double)RAND_MAX * 2 - 1.0) * factor;
}

int main()
{
	double x, y;
	double u, v;
	int step;
	FILE *fout;

	fout = fopen("brown.dat","w");
	if (fout == NULL)
	{  
		printf("Error: cannot open file \n");
		return -1;
	}

	x = 0.0; y = 0.0;
	u = 0.0; v = 0.0;
	for (step = 0; step < total_step; step++)
	{
		printf("%7.2f %10.3f %10.3f %10.3f %10.3f \n", step*delta_t, x, y, u, v);
		fprintf(fout, "%7.2f %12.5f %12.5f %12.5f %12.5f \n", step*delta_t, x, y, u, v);
		x += delta_t * u;
		y += delta_t * v;
		u += delta_t / mass * (-gamma * u + fr());
		v += delta_t / mass * (-gamma * v + fr());
	}
	fclose(fout);
	return 0;
}