import os
"""
Author: Anthony Castronova
Date: 4/16/2013
Affiliation: University of South Carolina
"""

import sys
import Image
import logging

def tif_to_ascii(tiff_file, outpath = './', no_data='-9999',verbose=False):
    """
    Converts GeoTIF into ASCII raster file using the format defined by ArcGIS
    tiff_file - the path of the GeoTIF that will be converted
    outpath - the path where the ascii file will be saved
    no_data - the value used to represent pixels without data
    verbose - prints output when set to True
    """
    
    # set output level
    log = logging.getLogger(__file__)
    if verbose:
        log.setLevel(logging.INFO)
    ch = logging.StreamHandler()
    log.addHandler(ch)

    # load tif image
    log.info('Loading TIF image')
    image = Image.open(tiff_file)

    # extract geotiff headers
    log.info('Extracting GeoTIF headers')
    tags = image.tag
    cellsize = tags[33550]
    geotransform = tags[33922]
    projection = tags[34737]
    
    # set ascii attributes and read pixel data
    log.info('Saving ASCII attributes')
    xpixel_resolution = cellsize[0]
    ypixel_resolution = cellsize[1]
    easting = geotransform[3]
    northing = geotransform[4]
    log.info('Reading pixel data')
    image_data = image.getdata()
    bbox = image_data.getbbox()
    ncols = bbox[2]-bbox[0] + 1
    nrows = bbox[3]-bbox[1] + 1
    data = list(image_data)
    
    # write ascii file
    log.info('Writing ASCII raster file')
    filename = (os.path.normpath(tiff_file).split('\\')[-1]).replace('tif','txt')
    #filename = 'mask_125.asc'
    path = os.path.join(outpath+filename)
    f = open(path,'w')
    log.info('Output file: '+path)
    f.write('NCOLS '+str(ncols)+'\n')
    f.write('NROWS '+str(nrows)+'\n')
    f.write('XLLCORNER '+str(easting)+'\n')
    f.write('YLLCORNER '+str(northing)+'\n')
    f.write('CELLSIZE '+str(xpixel_resolution)+'\n')
    f.write('NODATA_VALUE '+str(no_data)+'\n')

    for r in xrange(0,nrows):
        for c in xrange(0,ncols):
            #val = str(data[c + r*ncols]) if str(data[c + r*ncols]) != '0' else no_data 
	    if str(data[c + r*ncols]) != '0':
    		val = str(data[c + r*ncols])
	    else:
    		val = no_data
            f.write(val +' ')
        f.write('\n')
    f.close()

    log.info('TIF to ASCII convertion completed successfully')

    return True

if __name__ == '__main__':
    args = sys.argv[1:]
    if len(args) < 1 or len(args) > 4 or 'help' in args:
        print """
----
HELP
----
Converts GeoTIF into ASCII raster file using the format defined by ArcGIS

tiff_file - the path of the GeoTIF that will be converted
outpath - the path where the ascii file will be saved
no_data - the value used to represent pixels without data
verbose - prints output when set to True
        """
    elif len(args) == 1:
        tif_to_ascii(args[0])
    elif len(args) == 2:
        tif_to_ascii(args[0],outpath=args[1])
    else:
        tif_to_ascii(args[0], outpath=args[1], no_data=args[2], verbose=args[3])
