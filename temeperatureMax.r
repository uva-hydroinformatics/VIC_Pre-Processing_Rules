# the script does all the process of the maximum temperature data
CombineTmax{ 

*start = time();

writeLine("stdout", "starting Rule that does all the maximum temperature data");

msiGetFormattedSystemTime(*myTime1,"human","%d-%d-%d %ldh:%ldm:%lds");

writeLine("stdout", "Time now is *myTime1");

*start1 = time();
# process maximum temperature data from study area
processncdcTmax("run_convert_tmax.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "process maximum temperature data from study area");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop1 = time();
*duration1 = double(*stop1) - double(*start1);
writeLine("stdout", "Done with the sub-rule that process maximum temperature data from study area .Time taken to run the sub-rule is  *duration9 seconds");


*start2 = time();
# formatting the combined data
readPreprocTmaxDly("inputTmax.scr", "./cmd/Tmax/tmax.daily ./cmd/Tmax/tmax.inf ./cmd/Tmax/basin_tmax.fmt \"1998 2007\"", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "formatting the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop2 = time();
*duration2 = double(*stop2) - double(*start2);
writeLine("stdout", "Done with the sub-rule for formatting the combined data. Time taken to run the sub-rule is  *duration10 seconds");


*start3 = time();
# time of adjustment of the combined data
tmaxTobAdj("tmax_tobAdj.scr", "./cmd/Tmax/tmax_tob_adj.input", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "time of adjustment of the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop3 = time();
*duration3 = double(*stop3) - double(*start3);
writeLine("stdout", "Done with the sub-rule for time of adjustment of the combined data. Time taken to run the sub-rule is  *duration11 seconds");


*start4 = time();
# regridding the maximum temperature data for the basin
regridTmax("regrd_tmax.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "regridding the maximum temperature data for the basin");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop4 = time();
*duration4 = double(*stop4) - double(*start4);
writeLine("stdout", "Done with the sub-rule that regridds the maximum temperature data for the basinTime taken to run the sub-rule is  *duration12 seconds");

*stop = time();
*duration = double(*stop) - double(*start);
writeLine("stdout", "The total time taken to run the rule is  *duration seconds");

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

INPUT null
OUTPUT ruleExecOut
