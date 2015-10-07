/*
 * SUMMARY:      Adds a column of short int binary wind data to existing 
 *               met files with three columns of short int binary data.
 *
 * AUTHOR:       Ed Maurer
 * ORG:          University of Washington, Department of Civil Engineering
 * E-MAIL:       edm@hydro.washington.edu
 * ORIG-DATE:    8/31/99
 * LAST-MOD:
 * DESCRIPTION:  requires input paths and a filename list from vicinput.c
 * DESCRIP-END.  only works for binary (2-byte short int) data
 * FUNCTIONS:    
 * COMMENTS:     
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

void get_latlong( char fname[BUFSIZ+1], float *lat, float *lon );

int main(int argc, char **argv)    
{
  FILE *fpmet, *fpwnd, *fpll, *fpout;
  char met_dir[BUFSIZ+1], wnd_dir[BUFSIZ+1], out_dir[BUFSIZ+1];
  char metname[BUFSIZ+1], wndname[BUFSIZ+1], outname[BUFSIZ+1];
  char met[BUFSIZ+1], wnd[BUFSIZ+1], out[BUFSIZ+1], ll[BUFSIZ+1];
  char fname[BUFSIZ+1];
  char str[210];
  int i=0,j=0,app_flag=0,tsteps=0,n=0,maxline=210;
  short int prec=0, tmax=0, tmin=0, wind, dummy;
  float prec1 =0, tmax1=0, tmin1=0, wind1=0, dummy2=0;
  unsigned short int usprec;
  float lat,lon;

  int dummy1;
  if (argc!=6) {           /* Must be exactly 5 arguments after filename */
  printf("Incorrect number of commandline arguments \n");
  printf("usage: combine_wind \"met_file_path\" \"wind_file_path\" \"latlong_file\" \"out_dir\" \"APPEND_FLAG\"\n");
  exit(EXIT_FAILURE); }

  /* read command line agruments */
  strcpy(met_dir,argv[1]);        printf("prcp,temp file dir: %s \n",met_dir);
  strcpy(wnd_dir,argv[2]);        printf("wind file dir: %s \n",wnd_dir);
  strcpy(ll,argv[3]);             printf("file_list: %s \n",ll);
  strcpy(out_dir,argv[4]);        printf("out_dir: %s \n",out_dir);
  app_flag=atoi(argv[5]);         printf("append flag = %d \n",app_flag);

  /* open lat long list file */
  if((fpll = fopen(ll,"r"))==NULL) {
    printf("Cannot open file %s \n",ll);exit(0);}

  /* count number of cells from lines in latlong file */
  while (fgets(str,maxline,fpll) != '\0') n++;
  printf("number of files = %d\n",n);
  rewind(fpll);

  /* Combine the data for each cell file */
  for(i=0;i<n;i++){

    /* retrieve lat and long from filename of current cell */
    if(fgets(fname,maxline,fpll) == '\0')
      printf("Latlon file error at %s",fname);
    else printf("Cell %d of %d %s",i+1,n,fname);
    get_latlong(fname, &lat, &lon );

    /* make filenames */
    sprintf(metname,"data_%.4f_%.4f",lat,lon);
    sprintf(wndname,"wind_%.4f_%.4f",lat,lon);
    sprintf(outname,"data_%.4f_%.4f",lat,lon);
    strcpy(met,met_dir);
    strcat(met,metname);
    strcpy(wnd,wnd_dir);
    strcat(wnd,wndname);
    strcpy(out,out_dir);
    strcat(out,outname);

    /* open met, wind, output files */
    if((fpmet = fopen(met,"rb"))==NULL) {
      printf("Cannot open file %s \n",met);exit(0);} 
    if((fpwnd = fopen(wnd,"rb"))==NULL) {
      printf("Cannot open file %s \n",wnd);exit(0);}
    if(app_flag!=1){
      if((fpout = fopen(out,"wb"))==NULL) {
	printf("Cannot open file %s \n",out);exit(0);}
    }
    else {
      if((fpout = fopen(out,"ab"))==NULL) {
	printf("Cannot open file %s \n",out);exit(0);}
    }

    /* count number of timesteps in first wind file */
    if(i==0) {
      while(fread(&dummy,2,1,fpwnd) != 0 ){
	//	scanf("%d", &dummy1);	
      	  //    printf("%d %d", dummy, tsteps);
	      tsteps++;
      }
      rewind(fpwnd);
      printf("Number of timeteps = %d\n",tsteps);}

    /* read data from two files and combine into one output file */
    for(j=0;j<tsteps;j++){
      //if (fread(&prec,2,1,fpmet)  !=1)  printf("Error reading prcp\n");
      //if (fread(&tmax,2,1,fpmet) !=1)  printf("Error reading tmax\n");
      //if (fread(&tmin,2,1,fpmet) !=1)  printf("Error reading tmin\n");

      if (fscanf(fpmet, "%f", &prec1)  !=1)  printf("Error reading prcp\n");
      if (fscanf(fpmet, "%f", &tmax1)  !=1)  printf("Error reading prcp\n");
      if (fscanf(fpmet, "%f", &tmin1)  !=1)  printf("Error reading prcp\n");
      if (fread(&wind,2,1,fpwnd)  !=1)  printf("Error reading wind\n");
      usprec=(unsigned short int) prec;
      
      //fwrite(&usprec,sizeof(unsigned short int),1,fpout);
      //fwrite(&tmax,sizeof(short int),1,fpout);
      //fwrite(&tmin,sizeof(short int),1,fpout);
      //fwrite(&wind,sizeof(short int),1,fpout);
      fprintf(fpout, "%f %f %f %f\n ", prec1, tmax1, tmin1, wind/100.);
      //break;
    }
    fclose(fpmet); fclose(fpwnd); fclose(fpout);
   
    //scanf("%d \n", &dummy1);

  } /* end loop for each file */
  fclose(fpll);
  return 1;
} /* end main */
/***********************************************************/
void get_latlong( char fname[BUFSIZ+1], float *lat, float *lon )
  /* extracts the lat and long from the current cell from its */
  /* filename, e.g. data_35.6875_-110.4375 */
{
int i,j, delim;
char latlong[2][BUFSIZ+1];
	for(i=0;i<2;i++){
		delim=strlen(fname)-1;
		while(fname[delim]!='_')delim--;
		fname[delim]='\0';
		delim++;
		j=0;
			while(fname[delim]!='\0'){
				latlong[i][j]=fname[delim];
				fname[delim]='\0';
				delim++;
				j++;
			}
			latlong[i][j]='\0';
	}
	*lon = atof(latlong[0]);
	*lat = atof(latlong[1]);
}
