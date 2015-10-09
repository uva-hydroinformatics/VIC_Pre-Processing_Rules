# the script does all the process of the minimum temperature data
CombineTmin{ 

*start = time();

writeLine("stdout", "starting Rule that does all the minimum temperature data");

msiGetFormattedSystemTime(*myTime1,"human","%d-%d-%d %ldh:%ldm:%lds");

writeLine("stdout", "Time now is *myTime1");


*start1 = time();
# process minimum temperature data from study area
processncdcTmin("run_convert_tmin.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "process minimum temperature data from study area");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop1 = time();
*duration1 = double(*stop1) - double(*start1);
writeLine("stdout", "Done with the sub-rule that process minimum temperature data from study area. Time taken to run the sub-rule is  *duration1 seconds");



*start2 = time();
# formatting the combined data
readPreprocTminDly("inputTmin.scr", "./cmd/Tmin/tmin.daily ./cmd/Tmin/tmin.inf ./cmd/Tmin/basin_tmin.fmt \"1998 2007\"", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "formatting the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop2 = time();
*duration2 = double(*stop2) - double(*start2);
writeLine("stdout", "Done with the sub-rule that formats the combined data. Time taken to run the sub-rule is  *duration2 seconds");


*start3 = time();
# time of adjustment of the combined data
tminTobAdj("tmin_tobAdj.scr", "./cmd/Tmin/tmin_tob_adj.input", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", " time of adjustment of the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop3 = time();
*duration3 = double(*stop3) - double(*start3);
writeLine("stdout", "Done with the sub-rule that time of adjustment of the combined data. Time taken to run the sub-rule is  *duration3 seconds");


*start4 = time();
# regridding the minimum temperature data for the basin
regridTmin("regrd_tmin.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", " regridding the minimum temperature data for the basin");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop4 = time();
*duration4 = double(*stop4) - double(*start4);
writeLine("stdout", "Done with the sub-rule that regrids the minimum temperature data for the basin . Time taken to run the sub-rule is  *duration4 seconds");

*start5 = time();
# run meteorological data (prcp_grid.rsc, tmax_grid.grd and tmin_grid.grd) to create gridded data for the study area.
vicInputMeteoData("run_vicinput_ir.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "run meteorological data (prcp_grid.rsc, tmax_grid.grd and tmin_grid.grd) to create gridded data for the study area.");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop5 = time();
*duration5 = double(*stop5) - double(*start5);
writeLine("stdout", "Done with the sub-rule that run meteorological data (prcp_grid.rsc, tmax_grid.grd and tmin_grid.grd) to create gridded data for the study area. Time taken to run the sub-rule is  *duration5 seconds");

*stop = time();
*duration = double(*stop) - double(*start);
writeLine("stdout", "The total time taken to run the rule is  *duration seconds");

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



INPUT null
OUTPUT ruleExecOut
