# the script that Collects and process soil and vegetation data
CombineSoilVeg{ 

*start = time();

writeLine("stdout", "starting Rule that does all the minimum temperature data");

msiGetFormattedSystemTime(*myTime1,"human","%d-%d-%d %ldh:%ldm:%lds");

writeLine("stdout", "Time now is *myTime1");


#*start1 = time();
# adding preproc and append data into a combined file.
latlonSoil("ldas_latlon.scr", "./cmd/Basin/mask_125.asc ./cmd/latlon.txt", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "adding preproc and append data into a combined file.");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
#*stop1 = time();
#*duration1 = double(*stop1) - double(*start1);
#writeLine("stdout", "Time taken to run the sub-rule is  *duration1 seconds");

*start2 = time();
# prepare soil data
ldasSoil("ldas_soil.scr", "./cmd/LDAS/soil/soil_ldas.txt ./cmd/LDAS/soil/latlon.txt ./cmd/soil/ldassoildata.txt", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", " prepare soil data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop2 = time();
*duration2 = double(*stop2) - double(*start2);
writeLine("stdout", "Done with the sub-rule that prepares soil data. Time taken to run the sub-rule is  *duration2 seconds");


*start3 = time();
# prepare vegetation data
ldasVeg("ldas_veg.scr", "./cmd/LDAS/vegetation/ldas_lai.expanded.vegparams ./cmd/soil/ldassoildata.txt ./cmd/vegetation/ldasvegdata.txt", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "prepare vegetation data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop3 = time();
*duration3 = double(*stop3) - double(*start3);
writeLine("stdout", "Done with the sub-rule that prepare vegetation data. Time taken to run the sub-rule is  *duration3 seconds");


*stop = time();
*duration = double(*stop) - double(*start);
writeLine("stdout", "The total time taken to run the rule is  *duration seconds");

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


