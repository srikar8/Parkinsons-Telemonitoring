proc import datafile="Parkinsons-Telemonitoring-ucirvine.csv" out=Parkinsons replace;
delimiter=',';
getnames=yes;
run;


data Parkinsons_dummy;
set Parkinsons;
dummy_sex = (sex = "true");
run;

proc print data=Parkinsons_dummy;
run;

*subject age sex test_time motor_updrs total_updrs jitter jitter_abs jitter_rap jitter_ppq5 jitter_ddp shimmer shimmer_db shimmer_apq3 shimmer_apq5 shimmer_apq11 shimmer_dda nhr hnr rpde dfa ppe;

proc univariate normal data=Parkinsons_dummy;
var jitter jitter_abs jitter jitter_abs jitter_rap jitter_ppq5 jitter_ddp shimmer shimmer_db shimmer_apq3 shimmer_apq5 shimmer_apq11 shimmer_dda nhr;
histogram ; 
run;

data Parkinsons_log_tf;
set Parkinsons_dummy;
log_jitter = log(jitter);
log_jitter_abs = log(jitter_abs);
log_jitter_rap = log(jitter_rap);
log_jitter_ppq5 = log(jitter_ppq5);
log_jitter_ddp = log(jitter_ddp);
log_shimmer = log(shimmer);
log_shimmer_db = log(shimmer_db);
log_shimmer_apq3 = log(shimmer_apq3);
log_shimmer_apq5 = log(shimmer_apq5);
log_shimmer_apq11 = log(shimmer_apq11);
log_shimmer_dda = log(shimmer_dda);
log_nhr = log(nhr);
run;

proc print data=Parkinsons_log_tf;
run;

*age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_rap log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq3 log_shimmer_apq5 log_shimmer_apq11 log_shimmer_dda log_nhr;


proc sgscatter data=Parkinsons_log_tf;
title "Scatterplot Matrix";
matrix age dummy_sex motor_updrs test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_rap log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq3 log_shimmer_apq5 log_shimmer_apq11 log_shimmer_dda log_nhr / group= motor_updrs;
run;

proc corr data=Parkinsons_log_tf;
var motor_updrs age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_rap log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq3 log_shimmer_apq5 log_shimmer_apq11 log_shimmer_dda log_nhr;
run;


*VIF stb 1 ;
PROC REG data=Parkinsons_log_tf;
MODEL motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_rap log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq3 log_shimmer_apq5 log_shimmer_apq11 log_shimmer_dda log_nhr/stb vif;
RUN;


 
*Forward-Selection method;
PROC REG data=Parkinsons_log_tf;
MODEL motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_rap log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq3 log_shimmer_apq5 log_shimmer_apq11 log_shimmer_dda log_nhr /selection = forward;
*Backward-Selection method;
MODEL motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_rap log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq3 log_shimmer_apq5 log_shimmer_apq11 log_shimmer_dda log_nhr /selection = backward;
*Adiusted R-2 selection method;
MODEL motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_rap log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq3 log_shimmer_apq5 log_shimmer_apq11 log_shimmer_dda log_nhr /SELECTION = ADJRSQ;
*stepwise selection;
MODEL motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_rap log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq3 log_shimmer_apq5 log_shimmer_apq11 log_shimmer_dda log_nhr /SELECTION = STEPWISE;
*CP selection method;
MODEL motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_rap log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq3 log_shimmer_apq5 log_shimmer_apq11 log_shimmer_dda log_nhr /SELECTION = CP;
RUN;

*VIF stb 2 ;
PROC REG data=Parkinsons_log_tf;
title "model 2";
MODEL motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_rap log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq5 log_shimmer_apq11 log_shimmer_dda log_nhr/stb vif;
RUN;

*VIF stb 3 ;
PROC REG data=Parkinsons_log_tf;
title "model 3";
MODEL motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq5 log_shimmer_apq11 log_shimmer_dda log_nhr/stb vif;
RUN;

*VIF stb 4 ;
PROC REG data=Parkinsons_log_tf;
title "model 4";
MODEL motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_db log_shimmer_apq5 log_shimmer_apq11 log_nhr/stb vif;
RUN;

*VIF stb 5 ;
PROC REG data=Parkinsons_log_tf;
title "model 5";
MODEL motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_ppq5 log_jitter_ddp log_shimmer log_shimmer_apq5 log_shimmer_apq11 log_nhr/stb vif;
RUN;

*VIF stb 6 ;
PROC REG data=Parkinsons_log_tf;
title "model 6";
MODEL motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_ddp log_shimmer_apq5 log_shimmer_apq11 log_nhr/stb vif;
RUN;


PROC REG data=Parkinsons_log_tf;
model motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_ddp log_shimmer_apq5 log_shimmer_apq11 log_nhr/ r influence vif;
plot student.*predicted.;
plot student.*(age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_ddp log_shimmer_apq5 log_shimmer_apq11 log_nhr);
plot npp.*student.;
run;

data Parkinsons_log_tf_2; 
set Parkinsons_log_tf;
if _n_ in (1881) then delete;
run;

/*
* without log transform 1881,4064,4105,4043
data Parkinsons_dummy_3; 
set Parkinsons_dummy_2;
if _n_ in (4105) then delete;
run;

data Parkinsons_dummy_4; 
set Parkinsons_dummy_3;
if _n_ in (4043) then delete;
run;*/

/*
proc reg data=Parkinsons_log_tf_2;
model motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_ddp log_shimmer_apq5 log_shimmer_apq11 log_nhr/ r influence vif;
output out=reg_output rstudent=student_r;
plot student.*predicted.;
plot student.*(age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_ddp log_shimmer_apq5 log_shimmer_apq11 log_nhr);
plot npp.*student.;
run;

data rstudent_gt3;
    set reg_output;
    if abs(student_r) > 3 then output;
run;

proc print data=rstudent_gt3;
run;*/




*Final model;
PROC REG data=Parkinsons_log_tf_2;
title "Final model";
model motor_updrs = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_ddp log_shimmer_apq5 log_shimmer_apq11 log_nhr/ stb vif; 
RUN;


*split 80%;
proc surveyselect data=Parkinsons_log_tf_2 out=Parkinsons_tf_valid seed=123456
samprate=0.80 outall;
run;
proc print data=Parkinsons_tf_valid;
run;

*create new_y;
data Parkinsons_tf_valid;
set Parkinsons_tf_valid;
if Selected then new_y=motor_updrs;
run;
proc print data=Parkinsons_tf_valid;
run; 

*train;
proc reg data=Parkinsons_tf_valid;
model new_y = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_ddp log_shimmer_apq5 log_shimmer_apq11 log_nhr;
run;

*test;
proc reg data=Parkinsons_tf_valid;
model new_y = age dummy_sex test_time hnr rpde dfa ppe log_jitter log_jitter_abs log_jitter_ddp log_shimmer_apq5 log_shimmer_apq11 log_nhr;
output out=outml(where=(new_y=.)) p=yhat;
run;

proc print data=outml;
run;

data outml_sum;
set outml;
diff=motor_updrs-yhat;
absd=abs(diff);
run;

proc summary data=outml_sum;
var diff absd;
output out=outml_stat std(diff)=rmse mean(absd)=mae;
run;

proc print data=outml_stat;
run;

proc corr data=outml;
var motor_updrs yhat;
run;

