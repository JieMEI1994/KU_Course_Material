// 	calculate the velocity autocorrelation function of 2-dimensioned brownian motion
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define mass       1.0    // the mass of quantum
#define gamma      1.0    // the coefficient of friction
#define c_rand     1.0    // the random force
#define delta_t    0.3    // the intervals
#define total_step 100000 // the steps of calculation
#define out_step   1000   // the steps of out of calculation

double fr() // the uniform random numbers from 0 to 1
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
	int i, j;
    int count[total_step];
    double vaf[total_step];
	static double velx[total_step], vely[total_step]; //give a static space to the arrays of huge size

	x = 0.0; y = 0.0;
	u = 0.0; v = 0.0;

	for (step = 0; step < total_step; step++)
	{
		x += delta_t * u;
		y += delta_t * v;
		u += delta_t / mass * (-gamma * u + fr());
		v += delta_t / mass * (-gamma * v + fr());
		velx[step] = u; //accumulate the velocity data into array
		vely[step] = v;
	}

	for (step = 0; step < out_step; step++) //initilize counter 
	{ 
		count[step] = 0;
		vaf[step] = 0;
	}

	for (i = 0; i < total_step; i++) //calcukate the velocity autocorrelation function
	{
		for (j = i; j < total_step; j++)
		{
			step = j - i;
			count[step]++;
			vaf[step] += (velx[i]*velx[j] + vely[i]*vely[j]);
		}
	}

	fout = fopen("vaf.dat", "w");
	for (step = 0; step < out_step; step++) //out of the calculation
	{ 
		fprintf(fout, "%10.3f %10.3f \n", delta_t * step, vaf[step] / count[step]);
	}

	fclose(fout);

	return 0;
}