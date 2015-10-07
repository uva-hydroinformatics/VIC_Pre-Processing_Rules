# the script does all the process of the precipitation data from collection to pre-processing

comnibedPrcpNCDC{

*start = time();

writeLine("stdout", "starting Rule that does all the process of the precipitation data from collection to pre-processing");
msiGetFormattedSystemTime(*myTime1,"human","%d-%d-%d %ldh:%ldm:%lds");

writeLine("stdout", "Time now is *myTime1");

*start1 = time();
# process precipitation data from study area
processncdcPrcp("run_convert_prcp.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "Done with process precipitation data from study area");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
#msiGetDiffTime(*myTime1,*myTime,"human","%d-%d-%d %ldh:%ldm:%lds")
*stop1 = time();
*duration1 = double(*stop1) - double(*start1);
writeLine("stdout", "Done with process precipitation data from study area. Time taken to run this sub-rule is  *duration1 seconds");


*start2 = time();
# formatting the combined data
readPreprocDly("inputPrcp.scr", "./cmd/prcp.daily ./cmd/prcp.inf ./cmd/basin_prcp.fmt \"1998 2007\"",  "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "Done with formatting the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop2 = time();
*duration2 = double(*stop2) - double(*start2);
writeLine("stdout", "Time taken to run the sub-rule is  *duration2 seconds");


*start3 = time();
# time of adjustment of the combined data
precTobAdj("prcp_tobAdj.scr", "./cmd/prec_tob_adj.input",  "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "Done with time of adjustment of the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop3 = time();
*duration3 = double(*stop3) - double(*start3);
writeLine("stdout", "Done with the sub-rule that does time of adjustment of the combined data. Time taken to run the sub-rule is  *duration3 seconds");


*start4 = time();
# create mask (ascii file) for the study area
createMask("run_convert_tif_ascii.scr", "",  "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "Done with create mask (ascii file) for the study area");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop4 = time();
*duration4 = double(*stop4) - double(*start4);
writeLine("stdout", "Time taken to run the sub-rule is  *duration4 seconds");


*start5 = time();
# regridding the precipitation data for the basin
regridPrcp("regrd_prcp.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "regridding the precipitation data for the basin");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop5 = time();
*duration5 = double(*stop5) - double(*start5);
writeLine("stdout", "Done with the sub-rule for regridding the precipitation data for the basin. Time taken to run the sub-rule is  *duration5 seconds");


*start6 = time();
# estimate monthly precipitation from NCDC data
mkMonthlyPrcp("mk_monthly_ir.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", " estimate monthly precipitation from NCDC data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop6 = time();
*duration6 = double(*stop6) - double(*start6);
writeLine("stdout", "Done with the sub-rule that estimates the monthly precipitation from NCDC data. Time taken to run the sub-rule is  *duration6 seconds");


*start7 = time();
# estimate monthly PRISM data 
mkPrism("get_prism_ir.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "estimate monthly PRISM data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop7 = time();
*duration7 = double(*stop7) - double(*start7);
writeLine("stdout", "Done with the sub-rule that estimates the monthly PRISM data. Time taken to run the sub-rule is  *duration7 seconds");




*start8 = time();
# rescaling the precipitation data
mkRescale("rescale_ir.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "rescaling the precipitation data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop8 = time();
*duration8 = double(*stop8) - double(*start8);
writeLine("stdout", "Done with the sub-rule that rescales the precipitation data.Time taken to run the sub-rule is  *duration8 seconds");



*start9 = time();
# process maximum temperature data from study area
processncdcTmax("run_convert_tmax.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "process maximum temperature data from study area");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop9 = time();
*duration9 = double(*stop9) - double(*start9);
writeLine("stdout", "Done with the sub-rule that process maximum temperature data from study area .Time taken to run the sub-rule is  *duration9 seconds");


*start10 = time();
# formatting the combined data
readPreprocTmaxDly("inputTmax.scr", "./cmd/Tmax/tmax.daily ./cmd/Tmax/tmax.inf ./cmd/Tmax/basin_tmax.fmt \"1998 2007\"", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "formatting the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop10 = time();
*duration10 = double(*stop10) - double(*start10);
writeLine("stdout", "Done with the sub-rule for formatting the combined data. Time taken to run the sub-rule is  *duration10 seconds");


*start11 = time();
# time of adjustment of the combined data
tmaxTobAdj("tmax_tobAdj.scr", "./cmd/Tmax/tmax_tob_adj.input", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "time of adjustment of the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop11 = time();
*duration11 = double(*stop11) - double(*start11);
writeLine("stdout", "Done with the sub-rule for time of adjustment of the combined data. Time taken to run the sub-rule is  *duration11 seconds");


*start12 = time();
# regridding the maximum temperature data for the basin
regridTmax("regrd_tmax.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "regridding the maximum temperature data for the basin");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop12 = time();
*duration12 = double(*stop12) - double(*start12);
writeLine("stdout", "Done with the sub-rule that regridds the maximum temperature data for the basinTime taken to run the sub-rule is  *duration12 seconds");


*start13 = time();
# process minimum temperature data from study area
processncdcTmin("run_convert_tmin.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "process minimum temperature data from study area");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop13 = time();
*duration13 = double(*stop13) - double(*start13);
writeLine("stdout", "Done with the sub-rule that process minimum temperature data from study area. Time taken to run the sub-rule is  *duration13 seconds");



*start14 = time();
# formatting the combined data
readPreprocTminDly("inputTmin.scr", "./cmd/Tmin/tmin.daily ./cmd/Tmin/tmin.inf ./cmd/Tmin/basin_tmin.fmt \"1998 2007\"", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "formatting the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop14 = time();
*duration14 = double(*stop14) - double(*start14);
writeLine("stdout", "Done with the sub-rule that formats the combined data. Time taken to run the sub-rule is  *duration14 seconds");


*start15 = time();
# time of adjustment of the combined data
tminTobAdj("tmin_tobAdj.scr", "./cmd/Tmin/tmin_tob_adj.input", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", " time of adjustment of the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop15 = time();
*duration15 = double(*stop15) - double(*start15);
writeLine("stdout", "Done with the sub-rule that time of adjustment of the combined data. Time taken to run the sub-rule is  *duration15 seconds");


*start16 = time();
# regridding the minimum temperature data for the basin
regridTmin("regrd_tmin.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", " regridding the minimum temperature data for the basin");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop16 = time();
*duration16 = double(*stop16) - double(*start16);
writeLine("stdout", "Done with the sub-rule that regrids the minimum temperature data for the basin . Time taken to run the sub-rule is  *duration16 seconds");


*start17 = time();
# run meteorological data (prcp_grid.rsc, tmax_grid.grd and tmin_grid.grd) to create gridded data for the study area.
vicInputMeteoData("run_vicinput_ir.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "run meteorological data (prcp_grid.rsc, tmax_grid.grd and tmin_grid.grd) to create gridded data for the study area.");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop17 = time();
*duration17 = double(*stop17) - double(*start17);
writeLine("stdout", "Done with the sub-rule that run meteorological data (prcp_grid.rsc, tmax_grid.grd and tmin_grid.grd) to create gridded data for the study area. Time taken to run the sub-rule is  *duration17 seconds");


*start18 = time();
# collect wind speed data from NCEP/NCAR 
getNCARwind("getwind.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "collect wind speed data from NCEP/NCAR");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop18 = time();
*duration18 = double(*stop18) - double(*start18);
writeLine("stdout", "Done with the sub-rule that collect wind speed data from NCEP/NCAR. Time taken to run the sub-rule is  *duration18 seconds");



*start19 = time();
# regridding the NCEP/NCAR wind speed data
regridNCARwind("run_regrid_wind_ir.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "regridding the NCEP/NCAR wind speed data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop19 = time();
*duration19 = double(*stop19) - double(*start19);
writeLine("stdout", "Done with the sub-rule that regrids the NCEP/NCAR wind speed data. Time taken to run the sub-rule is  *duration19 seconds");


*start20 = time();
# combine the wind data with meteorological data
combineWind("run_combine_wind_ir.scr","", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", " combine the wind data with meteorological data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop20 = time();
*duration20 = double(*stop20) - double(*start20);
writeLine("stdout", "Done with the sub-rule that combine the wind data with meteorological data. Time taken to run the sub-rule is  *duration20 seconds");


*start21 = time();
# adding preproc and append data into a combined file.
latlonSoil("ldas_latlon.scr", "./cmd/Basin/mask_125.asc ./cmd/latlon.txt", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "adding preproc and append data into a combined file.");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop21 = time();
*duration21 = double(*stop21) - double(*start21);
writeLine("stdout", "Time taken to run the sub-rule is  *duration21 seconds");


*start22 = time();
# prepare soil data
ldasSoil("ldas_soil.scr", "./cmd/LDAS/soil/soil_ldas.txt ./cmd/LDAS/soil/latlon.txt ./cmd/soil/ldassoildata.txt", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", " prepare soil data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop22 = time();
*duration22 = double(*stop22) - double(*start22);
writeLine("stdout", "Done with the sub-rule that prepares soil data. Time taken to run the sub-rule is  *duration22 seconds");


*start23 = time();
# prepare vegetation data
ldasVeg("ldas_veg.scr", "./cmd/LDAS/vegetation/ldas_lai.expanded.vegparams ./cmd/soil/ldassoildata.txt ./cmd/vegetation/ldasvegdata.txt", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "prepare vegetation data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop23 = time();
*duration23 = double(*stop23) - double(*start23);
writeLine("stdout", "Done with the sub-rule that prepare vegetation data. Time taken to run the sub-rule is  *duration23 seconds");


*stop = time();
*duration = double(*stop) - double(*start);
writeLine("stdout", "The total time taken to run the rule is  *duration seconds");

}



# process precipitation data from study area
processncdcPrcp(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);

}

# processing historical input data and output a single file
readPreprocDly(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}


# time of observation of the combined precipitation data
precTobAdj(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}


# create mask (ascii file) for the study area
createMask(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}


# regirdding the precipitation data 
regridPrcp(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}


# making monthly averaged precipitation data 
mkMonthlyPrcp(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}


# get monthly averaged PRISM precipitation data 
mkPrism(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}


# rescale the precipitation data 
mkRescale(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}



# process maximum temperature data from study area
processncdcTmax(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);

}


# processing historical input data and output a single file
readPreprocTmaxDly(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}

# time of observation of the combined maximum temperature data
tmaxTobAdj(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}


# regirdding the maximum temperature data 
regridTmax(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}


# process minimum temperature data from study area
processncdcTmin(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}

# processing historical input data and output a single file
readPreprocTminDly(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}

# time of observation of the combined minimum temperature data
tminTobAdj(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}


# regirdding the minimum temperature data 
regridTmin(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}


# run meteorological data (prcp_grid.rsc, tmax_grid.grd and tmin_grid.grd) to create gridded data for the study area.
vicInputMeteoData(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);

}


# collect wind speed data from NCEP/NCAR 
getNCARwind(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);

}

# regridding the NCEP/NCAR wind speed data
regridNCARwind(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);

}

# combine the wind data with meteorological data
combineWind(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);

}

latlonSoil(*Cmd, *Arg, *Host){
# adding latlon of the study region.

   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}




ldasSoil(*Cmd, *Arg, *Host){
# adding soil data from LDAS.

   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}



ldasVeg(*Cmd, *Arg, *Host){
# adding vegetation data from LDAS.

   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);
}


INPUT null
OUTPUT ruleExecOut


