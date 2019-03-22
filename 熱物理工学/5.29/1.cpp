// Numerical Integration of Fokker-Planck Equation: 1-D Diffusion in Potential Field
#include <stdio.h>
#include <math.h>

#define MAX_STEP   100000    // 必要ならもっとステップ数を増やしてもよい
#define SAVE_STEP    1000

double  DT =    0.00002;     // 時間刻み．計算精度が悪いときは小さくしてみよう
double  GAMMA = 1.0;
double  TEMPERATURE = 40.0;  // 温度：いろいろと変えてみよう

#define NX_CELL   400       // 領域の分割数
double XMIN = -10.0;          // 領域の下限
double XMAX = 10.0;          // 領域の上限

double    prob[NX_CELL];
double   dprob[NX_CELL];
double prob_eq[NX_CELL];
double dx;                   // ヒストグラムの幅

//-------------------------------------------------
double potential(double x)
{
   return  0.5*x*x*x*x -12.0*x*x -6.0*x;
}

//-------------------------------------------------
double force(double x)
{
   return  -2.0*x*x*x +24.0*x +6.0;
}

//-------------------------------------------------
void initial( )
{
   int ix;
   double sum, factor, x;

   dx=(XMAX-XMIN)/NX_CELL;

   for (ix=0;ix<NX_CELL;ix++) {
      prob[ix]=0.0;
   }
      ix=(int)((-5.0-XMIN)/dx);
      prob[ix  ]=0.2/dx;     // 初期分布を x=-5 近くでステップ状に与えた
      prob[ix+1]=0.2/dx;
      prob[ix+2]=0.2/dx;
      prob[ix+3]=0.2/dx;
      prob[ix+4]=0.2/dx;

      sum=0.0;
   for (ix=0;ix<NX_CELL;ix++) {       // 平衡分布
      x=dx*ix+XMIN;
      prob_eq[ix]=exp(-potential(x)/TEMPERATURE);
      sum+=prob_eq[ix];
   }
      factor=1/(dx*sum);             // 規格化しておく
   for (ix=0;ix<NX_CELL;ix++) {
      prob_eq[ix]*=factor;
   }
}

//-------------------------------------------------
void output(int nstep)
{
   int ix, iv;
   char cdum[100];
   FILE *fout;

   printf("%6d\n",nstep);
   sprintf(cdum,"fp%6.6d.dat",nstep);
   fout=fopen(cdum,"w");

   for (ix=0;ix<NX_CELL;ix++) {          // 現時点の分布関数と平衡分布をファイルに出力
      fprintf(fout,"%6.2f %9.5f %9.5f\n",ix*dx+XMIN,prob[ix],prob_eq[ix]);
   }

   fclose(fout);
}
//--------------------------------------------------------
int main( )
{
   int    ix, nstep;
   double dp;
   double  x,xm,xp,sum;
   double  f, d;

   initial( );

   nstep=0;
      output(nstep);

   for (nstep=1;nstep<=MAX_STEP;nstep++) {

   for (ix=1;ix<NX_CELL-1;ix++) {         // 増分を求める
      x = dx*ix+XMIN;
      xm = x-dx;
      xp = x+dx;
      dprob[ix] = -(force(xp)*prob[ix+1]-force(xm)*prob[ix-1])/(2*dx)/GAMMA;              // convection term
      dprob[ix]+= (prob[ix+1]-2*prob[ix]+prob[ix-1])/(dx*dx)*(TEMPERATURE/GAMMA);    // diffusion term
   }

      sum=0.0;
   for (ix=1;ix<NX_CELL-1;ix++) {         // 確率密度の更新と再規格化，ただし両端はゼロのまま
      prob[ix] += dprob[ix]*DT;
      if (prob[ix] <= 0.0) {                // 確率密度は非負でなければならない
         prob[ix] = 0.0;}
      else {
         sum+=prob[ix];
      }
   }

      sum*=dx;
   for (ix=1;ix<NX_CELL-1;ix++) {         // 再規格化
      prob[ix] /= sum;
   }
   if (nstep%SAVE_STEP==0) output(nstep);  // 分布をファイルに出力
   }

   return 0;
}