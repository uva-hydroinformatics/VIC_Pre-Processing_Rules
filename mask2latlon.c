#include <stdio.h>
#include <stdlib.h>

int main( int argc, char *argv[] )
{
	//file pointer to the ascii mask file
	FILE *fp;
	char buffer[1024];
	int ncols, nrows;
	float xll, yll;
	float cellsize;
	int nodata;
	int **data;
	int i,j;
	float lat, lon;

	if( !(fp = fopen(argv[1],"r")) ){
	    fprintf(stderr,"Cannot open ascii mask file\t%s\n",argv[1]);
	    exit(EXIT_FAILURE);
	}

	//getting the header info 
	fscanf(fp, "%s%d", buffer, &ncols);
	fscanf(fp, "%s%d", buffer, &nrows);
	fscanf(fp, "%s%f", buffer, &xll);
	fscanf(fp, "%s%f", buffer, &yll);
	fscanf(fp, "%s%f", buffer, &cellsize);
	fscanf(fp, "%s%d", buffer, &nodata);
	
	//printf("%d %d %f %f %f %d\n", ncols, nrows, xll, yll, cellsize, nodata);		
	data = (int **) malloc (sizeof(int *) * nrows);
	for (i=0; i<nrows; i++) {
	 data[i] = (int *) malloc (sizeof(int) * ncols);
	 for (j=0; j<ncols; j++) {
	   fscanf(fp, "%d", &data[i][j]);
	   if (data[i][j] > 0) {
	    lat = yll + cellsize / 2. + (nrows - 1 - i) * cellsize;
	    lon = xll + cellsize / 2. +  j * cellsize;
	    printf("%d %f %f\n", i*ncols + j, lat, lon); 
	   }
	 }
	}
	
	return 0;					
}
