#include <stdio.h>
#include <stdlib.h>
#define BUF_SIZE   1024
#define MAXVEG 14
void usage();

/* Extracts a vegetation parameter file to match the input soil 
   parameter file. Set up for 1/8 degree LDAS VIC implementation */
/* set for 3 root zones and monthly LAI in vegetation parameter file */

int main( int argc, char *argv[] ) 
{
  FILE *fpvegglb;
  FILE *fpsoil;

  float frac[MAXVEG];
  int rew=0;
  int ccount=0;
  int i;
  int j;
  int cellnum,cellbas;
  int nveg;
  int miss=0;
  int iveg[MAXVEG];
  float root[MAXVEG][6],lai[MAXVEG][12];
  char str[BUF_SIZE+1];

  if(argc!=3)
    usage();

  if( !(fpvegglb=fopen(argv[1],"r")) ){
    fprintf(stderr,"Cannot open LDAS vegetation parameter file:\t%s\n",argv[1]);
    exit(EXIT_FAILURE);
  }

  if( !(fpsoil=fopen(argv[2],"r")) ){
    fprintf(stderr,"Cannot open soil file:\t%s\n",argv[2]);
    exit(EXIT_FAILURE);
  }

  /* get current LDAS cell number from basin's soil file */
  while(fgets(str,BUF_SIZE,fpsoil)){
    rew=0;
    ccount++;
    sscanf(str,"%*d %d", &cellbas);
    /*    printf("soil cell %d:  ldas cell %d\n", ccount, cellbas); */
    /* read LDAS domain veg parameter file to find the same grid cell */
    while(fscanf(fpvegglb,"%d %d", &cellnum, &nveg) != EOF){

      /* check if cell numbers are out of order */
      if (cellbas<cellnum && rew==0) {    /* rewind once only */
	rewind(fpvegglb);
	fscanf(fpvegglb,"%d %d", &cellnum, &nveg); 
        rew=1; 
      } else if (cellbas<cellnum && rew==1) {/* if soil cell not in veg file */
	fprintf(stderr,"cell ordering or content problem at basin cell number: %d\n",
		cellbas);
	fprintf(stderr,"keeping cell but inserting void (-99 for nveg)\n");
        miss++;
	fprintf(stdout,"%d %d\n", cellbas, -99);
        /* read rest of record for global cell */
        for(i=0;i<nveg;i++){
	  fscanf(fpvegglb,"%d %f", &iveg[i], &frac[i]);
 	  for(j=0;j<6;j++) fscanf(fpvegglb,"%f", &root[i][j]);
	  for(j=0;j<12;j++) fscanf(fpvegglb,"%f", &lai[i][j]);
        }
        break;
      }

      /* read rest of record for global cell */
      for(i=0;i<nveg;i++){
	fscanf(fpvegglb,"%d %f", &iveg[i], &frac[i]);
	for(j=0;j<6;j++) fscanf(fpvegglb,"%f", &root[i][j]);
	for(j=0;j<12;j++) fscanf(fpvegglb,"%f", &lai[i][j]);
      }

      /* if cellnumbers are equal, write out cell vegetation data */
      if(cellbas==cellnum) {
	fprintf(stdout,"%d %d\n", cellbas, nveg);
	for(i=0;i<nveg;i++){
	  fprintf(stdout,"  %3d %f ", iveg[i], frac[i]);
	  /* roots */
	  for(j=0;j<6;j++) fprintf(stdout,"%.2f ", root[i][j]);
	  /* lai */
	  fprintf(stdout,"\n      ");
	  for(j=0;j<12;j++) fprintf(stdout,"%.3f ", lai[i][j]);
	  fprintf(stdout,"\n");
	}
	break;
      }
    }
  }
  fprintf(stderr,"wrote %d voids for cells in soil file not found in vegfile.\n", miss);

  return(EXIT_SUCCESS);
}
/*****************************************************/
void usage()
{
  fprintf(stderr,"USAGE:\tcreate_LDAS_veg_param <input LDAS veg param file> <basin soil file>\n");
  exit(EXIT_FAILURE);
}
