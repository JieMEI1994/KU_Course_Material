#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define NSITE 50
#define RADIUS 100

#define  TOTAL      40000  // total number of steps
#define  OUTSTEP      100  // output every OUTSTEP

typedef struct {double x; double y;} SITE;  // 構造体 SITE を定義

SITE sdata[ ] = {    // SITE構造体の配列 sdata を宣言，初期化する
  {   0.000000,   0.000000}, 
  {  -8.224738,  11.636708}, 
  {  -4.116947, -95.056001}, 
  { -87.450789,  24.710837}, 
  { -34.757530, -33.182775}, 
  {  29.960021, -75.280007}, 
  {  24.527726, -37.052522}, 
  { -36.252937,  24.387341}, 
  {  19.681387, -96.728416}, 
  { -59.160131, -27.256081}, 
  { -75.566881,  -7.199316}, 
  {   1.321451, -17.166662}, 
  { -26.786096,  28.879666}, 
  { -13.199255,  22.196112}, 
  {  36.906034, -14.932707}, 
  {  -1.272622, -21.878719}, 
  {  80.535295,  19.669179}, 
  {  40.470595,  90.325632}, 
  {  23.416852,  17.862484}, 
  {  28.275399,  -8.890042}, 
  {  94.500565, -13.724174}, 
  {  19.058809,  56.950591}, 
  {  58.165227, -15.640736}, 
  {  92.748802, -22.727134}, 
  { -17.203284,  24.326304}, 
  { -74.059267,  26.474807}, 
  {  37.076937, -88.824122}, 
  { -56.315806,  64.030885}, 
  {   2.420118, -70.091861}, 
  {  90.301218, -17.215491}, 
  {  23.319193, -23.075045}, 
  {  88.421278,  16.116825}, 
  { -46.452223, -44.291513}, 
  { -42.905972,  40.415662}, 
  {  44.120609,  30.130924}, 
  { -93.591113,  -2.395703}, 
  {  -4.959258,  -3.762932}, 
  {  92.535173, -37.144078}, 
  {  -2.432325,  86.388745}, 
  { -48.893704, -66.759239}, 
  {  48.460341,  46.385083}, 
  { -63.383892, -30.368969}, 
  {  -7.840205, -38.285470}, 
  {  36.088137,  80.590228}, 
  {  -5.880917,  62.724693}, 
  { -24.668111,  45.847957}, 
  { -85.436567,  -7.889035}, 
  {  24.320200,  64.098025}, 
  {  83.935057,  17.361980}, 
  {   0.000000,   0.000000}
};

void output(int step, double distance)  // 途中データをファイルに出力
{
	int i;
	char cfile[100];
	FILE *fout;

	sprintf(cfile, "%7.7d.dat", step);
	fout = fopen(cfile, "w");
	for (i = 0; i<NSITE; i++) {
		fprintf(fout, "%10.6f %10.6f\n", sdata[i].x, sdata[i].y);
	}
	fclose(fout);

	return;
}

double calc_dist()
{
	int i;
	double dx, dy, dsum = 0.0;

	for (i = 1; i<NSITE; i++) {
		dx = sdata[i].x - sdata[i - 1].x;
		dy = sdata[i].y - sdata[i - 1].y;
		dsum += sqrt(dx*dx + dy*dy);
	}
	return dsum;
}

double myrand()
{
	return rand() / (double)(RAND_MAX);
}

void exchange(int i, int j)
{
	SITE stemp;   // １時変数 stemp を使ってサイト i と j を交換

	stemp.x = sdata[i].x;
	stemp.y = sdata[i].y;
	sdata[i].x = sdata[j].x;
	sdata[i].y = sdata[j].y;
	sdata[j].x = stemp.x;
	sdata[j].y = stemp.y;

	return;
}

int main()
{
	int step = 0;
	int i, j;
	double temperature = 250.0;
	double distance, dtemp, prob;
	SITE stemp;     // サイト交換に使う temporary 変数（構造体 site型）
  FILE *fdist;

      fdist=fopen("dist_sa.dat","w");    // 距離を出力するファイル
      distance=calc_dist( );
      output(step,distance);

	for (step = 1; step <= TOTAL; step++) {

	PICKUP_I:                 // ランダムに２つのサイトを選ぶ
		i = (NSITE - 1)*myrand();
		if ((i == 0) || (i == NSITE - 1)) goto PICKUP_I;
	PICKUP_J:
		j = (NSITE - 1)*myrand();
		if ((j == 0) || (j == NSITE - 1)) goto PICKUP_J;
		if (i == j) goto PICKUP_J;

		exchange(i, j);                 // ２つのサイトを交換
		dtemp = calc_dist();

		if (dtemp<distance) {   // 交換したほうが距離が減少
			distance = dtemp;
		}
		else {                // 交換したほうが距離が増加
			prob = exp(-(dtemp - distance) / temperature);
			if (myrand() < prob){
				distance = dtemp; // probの確率で交換を受け入れる
			}
			else{
			    exchange(i, j); // 元に戻す
			}
		}

		printf("%10d %10.5f\n", step, distance);
		fprintf(fdist, "%10d %10.5f\n", step, distance);

		if (step%OUTSTEP==0) {
			output(step, distance);
		}
			temperature *= 0.5;  // 500ステップごとに温度を下げる
		}

   fclose(fdist);
	 return 0;
}