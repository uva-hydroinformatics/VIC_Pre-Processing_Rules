# the script that Collects and process annual wind speed data
CombineWind{ 

*start = time();

writeLine("stdout", "starting Rule that does all the minimum temperature data");

msiGetFormattedSystemTime(*myTime1,"human","%d-%d-%d %ldh:%ldm:%lds");

writeLine("stdout", "Time now is *myTime1");


*start1 = time();
# collect wind speed data from NCEP/NCAR 
getNCARwind("getwind.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "collect wind speed data from NCEP/NCAR");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop1 = time();
*duration1 = double(*stop1) - double(*start1);
writeLine("stdout", "Done with the sub-rule that collect wind speed data from NCEP/NCAR. Time taken to run the sub-rule is  *duration1 seconds");



*start2 = time();
# regridding the NCEP/NCAR wind speed data
regridNCARwind("run_regrid_wind_ir.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "regridding the NCEP/NCAR wind speed data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop2 = time();
*duration2 = double(*stop2) - double(*start2);
writeLine("stdout", "Done with the sub-rule that regrids the NCEP/NCAR wind speed data. Time taken to run the sub-rule is  *duration2 seconds");


*start3 = time();
# combine the wind data with meteorological data
combineWind("run_combine_wind_ir.scr","", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", " combine the wind data with meteorological data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop3 = time();
*duration3 = double(*stop3) - double(*start3);
writeLine("stdout", "Done with the sub-rule that combine the wind data with meteorological data. Time taken to run the sub-rule is  *duration3 seconds");


*stop = time();
*duration = double(*stop) - double(*start);
writeLine("stdout", "The total time taken to run the rule is  *duration seconds");

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


INPUT null
OUTPUT ruleExecOut
