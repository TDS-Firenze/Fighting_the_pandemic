proc means data=MWeek.Blood_Test n nmiss mean median std min max;
run;

proc freq data=MWeek.Blood_Test;
   table SARS_Cov_2_exam_result;
run;

proc freq data=MWeek.Virus_Test;
run;