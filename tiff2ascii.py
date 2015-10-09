import gdal

import subprocess
result = subprocess.call("gdal_translate -a_nodata 0 -of AAIGrid ./cmd/DEM.tif ./cmd/Basin/mask_125.asc", shell=True)
if result != 0:
	print("gdal_translate failed")
