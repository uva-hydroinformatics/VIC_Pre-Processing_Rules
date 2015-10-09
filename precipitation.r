# the script does all the process of the precipitation data
Prcp{

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


#*start2 = time();
# formatting the combined data
readPreprocDly("inputPrcp.scr", "./cmd/prcp.daily ./cmd/prcp.inf ./cmd/basin_prcp.fmt \"1998 2007\"",  "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "Done with formatting the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
#*stop2 = time();
#*duration2 = double(*stop2) - double(*start2);
#writeLine("stdout", "Time taken to run the sub-rule is  *duration2 seconds");


*start3 = time();
# time of adjustment of the combined data
precTobAdj("prcp_tobAdj.scr", "./cmd/prec_tob_adj.input",  "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "Done with time of adjustment of the combined data");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop3 = time();
*duration3 = double(*stop3) - double(*start3);
writeLine("stdout", "Done with the sub-rule that does time of adjustment of the combined data. Time taken to run the sub-rule is  *duration3 seconds");


#*start4 = time();
# create mask (ascii file) for the study area
createMask("run_convert_tif_ascii.scr", "",  "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "Done with create mask (ascii file) for the study area");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
#*stop4 = time();
#*duration4 = double(*stop4) - double(*start4);
#writeLine("stdout", "Time taken to run the sub-rule is  *duration4 seconds");


*start5 = time();
# regridding the precipitation data for the basin
regridPrcp("regrd_prcp.scr", "", "ec2-54-86-215-185.compute-1.amazonaws.com")
#writeLine("stdout", "regridding the precipitation data for the basin");
#msiGetFormattedSystemTime(*myTime,"human","%d-%d-%d %ldh:%ldm:%lds");
#writeLine("stdout", "Rule Executed Successfully at *myTime");
*stop5 = time();
*duration5 = double(*stop5) - double(*start5);
writeLine("stdout", " Done with the sub-rule forregridding the precipitation data for the basin. Time taken to run the sub-rule is  *duration5 seconds");


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


INPUT null
OUTPUT ruleExecOut

