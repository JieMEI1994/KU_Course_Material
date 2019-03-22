#include <stdio.h>
#include <math.h>

#define DFILE "jacksonpollock_1950_mono"  // 入力用画像データファイル名（拡張子は .bmp を自動的に付加する）
#define DMAX  65536   // Maximum header size
#define IMAX   9600   // Maximum image size

int Width, Height;
int Image[IMAX][IMAX];

int read_image(char* INPUT_FILE ) //=====================================================
{
   FILE *fin;
   unsigned char cdata[DMAX];
   unsigned int Offset, HeaderSize;
   unsigned short int NBit, NByte, dummy;
   unsigned int Cmprs;
   unsigned int idata;
   int x,y;
   int xmax;

   fin=fopen(INPUT_FILE,"rb");
   if (fin==NULL) {
      printf("Error: no input file\n");
      return -1;
   }

// Bitmap File Header             画像ファイルのヘッダ情報を調べる
   fread(cdata,10,1,fin);
   printf("File Type = %c%c\n",cdata[0],cdata[1]);
   if (cdata[0]!='B' || cdata[1]!='M') {
      printf("Error: file is not BMP\n");
      fclose(fin);
      return -1;
   }
   fread(&Offset,4,1,fin);

// Bitmap Info Header
   fread(&HeaderSize,4,1,fin);
   printf("Header Size = %d byte\n",HeaderSize);
   printf("Offset = %d byte\n",Offset);
   fread(&Width,4,1,fin);
   fread(&Height,4,1,fin);
   fread(&dummy,2,1,fin);
   fread(&NBit,2,1,fin);
   fread(&Cmprs,4,1,fin);
   printf("Image Size = %d X %d (%d bit)\n",Width,Height,NBit);
   if (NBit!=8 && NBit!=24 && NBit!=32) {
      printf("Sorry, this program does not support this Pixel Bit type\n");
      return -1;
   }
   NByte=NBit/8;
   printf("Image Compression = %d\n",Cmprs);
   if (Cmprs!=0) {               // このプログラムは無圧縮 bitmap のみに対応している
      printf("Sorry, this program does not support this compression type\n");
      fclose(fin);
      return -1;
   }
   if ((Width>IMAX) || (Height>IMAX)) {
      printf("Sorry, image is too large\n");
      fclose(fin);
      return -1;
   }
   fclose(fin);

   fin=fopen(INPUT_FILE,"rb");   // 画像ファイルを開き直して，画像データを読み込む
   fread(cdata,Offset,1,fin);

// Read Image
   for (y=0;y<Height;y++) {
      for (x=0;x<Width;x++) {
         idata=(unsigned int)0;
         int status=fread(&idata, NByte, 1, fin);
//             printf("%2d %5d %5d\n",idata,x,y);
         if (status!=1) {
             printf("Error at %d %d: data end while reading\n",x,y);
             return -1;
         }
         Image[y][x] = (idata!=0);   // 黒 =0,  白 !=0 
      }
         xmax=(Width*NByte)%4;
      if (xmax!=0) {      // 水平方向のバイト数が4の倍数でない場合は，0x0 で埋められているので読み飛ばす
         for (x=0;x<xmax;x++) fread(&idata, NByte, 1, fin);
      }
   }

   fclose(fin);
   return 0;
}

int fractal(char* OUTPUT_FILE) //=============================
{
   int x, y, xi, yi;
   int resolution;       // Tile Size
   int sum;              // Number of Tiles
   int res_max;
   FILE *fout;

   fout=fopen(OUTPUT_FILE,"w");

   if (Height<Width) res_max=Height/2;
   else              res_max=Width/2;

   for (resolution=1; resolution<=res_max; resolution*=2) { // タイルサイズを２倍ずつ大きくする
         sum=0;  // 「条件」に合致するタイルの枚数
// --------------------------------------------------------------------
   for (x = 0; x < Width/resolution; x++) {
   for (y = 0; y < Height/resolution; y++) {  // タイルを１枚ずつチェックしていく


//    この間のプログラムを完成させる


			for (x = 0; x < Width / resolution; x++) {
			for (y = 0; y < Height / resolution; y++) {  // タイルを１枚ずつチェックしていく


				for (xi = x*resolution; xi < x*resolution + resolution; xi++)
        {
					for (yi = y*resolution; yi < y*resolution + resolution; yi++)
          {
						if (Image[yi][xi] != 0)
            {
							sum ++;
							break;
						}
					}
					if (Image[yi][xi] != 0)
          {
						break;
					}
				}
			  
   } }
// --------------------------------------------------------------------

     fprintf(fout,"%5d %10d\n", resolution, sum);  // タイルの枚数を出力
     printf("%5d %10d\n", resolution, sum);
   }

   fclose(fout);
   return 0;
}

int main( ) //=================================================
{
   int ret;
   char cfile[100];
   FILE *fout;

      sprintf(cfile,"%s.bmp",DFILE);
   ret=read_image(cfile);
   if (ret!=0) return -1;
      printf("Analyzing %s\n",cfile);

      sprintf(cfile,"fractal_analysis.dat");   // 出力用データファイル 
   fractal(cfile);

   return 0;
}