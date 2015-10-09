# the script that Combines precipitation and temperature data
CombinePrcpTemp{ 

*start = time();

writeLine("stdout", "starting Rule that does all the minimum temperature data");

msiGetFormattedSystemTime(*myTime1,"human","%d-%d-%d %ldh:%ldm:%lds");

writeLine("stdout", "Time now is *myTime1");



*start = time();
# run meteorological data (prcp_grid.rsc, tmax_grid.grd and tmin_grid.grd) to create gridded data for the study area.
vicInputMeteoData("run_vicinput_ir.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "run meteorological data (prcp_grid.rsc, tmax_grid.grd and tmin_grid.grd) to create gridded data for the study area.");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop = time();
*duration = double(*stop) - double(*start);
writeLine("stdout", "Done with the sub-rule that run meteorological data (prcp_grid.rsc, tmax_grid.grd and tmin_grid.grd) to create gridded data for the study area. Time taken to run the sub-rule is  *duration seconds");



}



# run meteorological data (prcp_grid.rsc, tmax_grid.grd and tmin_grid.grd) to create gridded data for the study area.
vicInputMeteoData(*Cmd, *Arg, *Host){
   msiExecCmd(*Cmd,*Arg, *Host,"null","null",*Result);
   msiGetStdoutInExecCmdOut(*Result,*Out);

}



INPUT null
OUTPUT ruleExecOut
