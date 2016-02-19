clear all
capture log close
set more off

//Import Flanker data (EDIT: change filename for updated datasets)
import excel "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\ADD\Flanker\tDCS_ADD_Flanker_Full_2-18-2016.xls", sheet("Sheet1") firstrow

//make log recording what analyses were done
log using "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\ADD\Flanker\tDCS_ADD_Flanker_Full_2WayAnova_log.log", replace

//get rid of unnecessary variables
keep DataFileBasename Subject Session ExperimentVersion RespWindow SessionStartDateTimeUtc BlockList Trial Block1List Block2List CellLabel CorResp Feedback FixDur2 FlankerProbeACC FlankerProbeCRESP FlankerProbeRESP FlankerProbeRT Flankers FlankerProbeRTTime Probe

//~~~~Data Check~~~~~
//Duration Error?
//Different Experiment Versions?
//~~~~~End of Data Check~~~~~

//get rid of unneeded variables after Data Check; keep only variables needed for analysis
keep Subject Session CellLabel FixDur2 FlankerProbeACC FlankerProbeRT Trial BlockList

//Combine Subject and Session # Variables into 1 Variable
gen str3 Subject2 = string(Subject)
gen str3 Session2 = string(Session)
gen Subject_Session = Subject2 + "_" + Session2
drop Session 
move Subject_Session CellLabel 

//~~~Data Notes~~~
//tDCS_ADD_01 did not go off ADD meds--keep?
//tDCS_ADD_02 did 1mA stim for 2nd study visit
//tDCS_ADD_03 did 1.8mA for 1st and 3rd visits
//~~~~End Data Notes~~~

//Create variable for: sham, active L, active R stim conditions (EDIT: Subject_Sessions for updated datasets)
gen stim_cond = 0
label define stim_conds 0 "Unknown/Not completed" 1 "Sham" 2 "Active_L" 3 "Active_R"
label values stim_cond stim_conds
replace stim_cond = 1 if regexm(Subject_Session, "(^1_3|^2_2|^3_2|^4_3|^5_1)")
replace stim_cond = 2 if regexm(Subject_Session, "(^1_1|^2_3|^3_1|^4_2|^5_3)")
replace stim_cond = 3 if regexm(Subject_Session, "(^1_2|^2_1|^3_3|^4_1|^5_2)") 

//Create variable for: Pre vs. Post stimulation
gen pre_post_stim = 0
label define pre_post_stim 0 "Unknown/Not Completed" 1 "PreStim" 2 "PostStim"
label values pre_post_stim pre_post_stim
replace pre_post_stim = 1 if regexm(Subject_Session, "(1$)")
replace pre_post_stim = 2 if regexm(Subject_Session, "(2$)")

//Filter for completed Subjects ONLY (EDIT: Subject_Sessions for updated datasets)
gen completed = 0
label values completed yesno
replace completed = 1 if regexm(Subject_Session, "(^1_|^2_|^3_|^4_|^5_)")
drop if completed == 0 

//Take out instruction trials
drop if Trial == 71|72 & FlankerProbeACC ==.

//Find decimal ACC for all trials (congruent + incongruent)
egen acc_all = total(FlankerProbeACC), by(Subject_Session)
egen num_all = count(FlankerProbeACC), by(Subject_Session)
replace acc_all = acc_all/num_all

//Take out subjects with below X accuracy?
//take out Subjects 5 and 11?

//Find decimal ACC for congruent and incongruent trials
foreach x in CON INC {
	egen acc_`x' = total(FlankerProbeACC) if CellLabel == "`x'", by(Subject_Session)
	egen num_`x' = sum(CellLabel == "`x'"), by(Subject_Session)
	replace acc_`x' = acc_`x'/num_`x'
	drop num_`x'
}

//Find avg RT for all trials (correct + incorrect) (congruent + incongruent)
egen avg_RT_all = mean(FlankerProbeRT), by(Subject_Session)

//Find avg RT for correct trials
gen RT_cor = FlankerProbeRT if FlankerProbeACC == 1
egen avg_RT_cor = mean(RT_cor), by(Subject_Session) 

//Find avg RT for congruent and incongruent trials
foreach x in CON INC {
	gen RT_`x' = FlankerProbeRT if CellLabel == "`x'"
	egen avg_RT_`x' = mean(RT_`x'), by(Subject_Session)
}

//Fill in missing indiv trial values
foreach var of varlist acc_CON acc_INC { 
	gsort Subject_Session `var'
	by Subject_Session: replace `var' = `var'[1]
}

//Find avg RT for CORRECT trials only for: congruent and incongruent
foreach var of varlist RT_CON RT_INC {
	gen `var'_cor = `var' if FlankerProbeACC == 1
	egen avg_`var'_cor = mean(`var'_cor), by(Subject_Session)
}

//Generate separate pre and post variables
foreach var of varlist acc_* avg_RT_* {
	gen `var'1 = `var' if pre_post_stim == 1
	gen `var'2 = `var' if pre_post_stim == 2
}
	
//Now that we have all the averages that we want, we can arbitrarily remove the excess rows/individual trial data and individual trial variables so we only have 1 row/1 observation per Subject's Session
drop if Trial !=1 | BlockList == 2
drop num_* completed FixDur2 FlankerProbeACC FlankerProbeRT RT* BlockList Trial Subject2 Session2 

//Fill in the rows that have pre stim data with post stim data and vice versa so we can then calculate the post - pre stim change values
gen Sub_Ses = substr(Subject_Session,1,length(Subject_Session)-1)
foreach var of varlist acc_* avg_RT_* {
	gsort Sub_Ses `var'
	by Sub_Ses: replace `var' = `var'[1]
} 

move Sub_Ses CellLabel

local RT_acc_vars "acc_all acc_CON acc_INC avg_RT_all avg_RT_cor avg_RT_CON avg_RT_CON_cor avg_RT_INC avg_RT_INC_cor" 

//Get Raw (Post-Pre)Stim Change Values for repeated measures ANOVA of post - pre stim change
foreach x in `RT_acc_vars'{
	gen ch_`x' = `x'2 - `x'1
}

//Get rid of pre and all variables since those are no longer needed
keep Subject Subject_Session Sub_Ses CellLabel stim_cond pre_post_stim *CON*2 *INC*2 ch_*CON* ch_*INC*

//Restructure data for 2 way ANOVA
//Need 6 rows per Subject: 2 of each stim cond x 1 of each trial cond (con/inc)
//First create trial_cond variable 
rename CellLabel trial_cond
label variable trial_cond ""
replace trial_cond = "1" if regexm(Subject_Session, "(1$)")
replace trial_cond = "2" if regexm(Subject_Session, "(2$)")
destring(trial_cond), replace
label define trial_cond 1 "Congruent" 2 "Incongruent"
label values trial_cond trial_cond
move stim_cond trial_cond
drop pre_post_stim

//Resolve subject 3 who is missing 3_11
replace trial_cond = 1 if _n == _N

sort Subject_Session

//Have only accuracy, RT and correct RT variables under the appropriate conditions
gen acc_by_trialcond_post = acc_CON2 if trial_cond == 1
replace acc_by_trialcond_post = acc_INC2 if trial_cond == 2

gen avg_RT_by_trialcond_post = avg_RT_CON2 if trial_cond ==1
replace avg_RT_by_trialcond_post = avg_RT_INC2 if trial_cond ==2

gen avg_RT_cor_by_trialcond_post = ch_avg_RT_CON_cor if trial_cond ==1
replace avg_RT_cor_by_trialcond_post = ch_avg_RT_INC_cor if trial_cond ==2

gen ch_acc_by_trialcond = ch_acc_CON if trial_cond == 1
replace ch_acc_by_trialcond = ch_acc_INC if trial_cond == 2

gen ch_avg_RT_by_trialcond = ch_avg_RT_CON if trial_cond == 1
replace ch_avg_RT_by_trialcond = ch_avg_RT_INC if trial_cond == 2

gen ch_avg_RT_cor_by_trialcond = ch_avg_RT_CON_cor if trial_cond == 1
replace ch_avg_RT_cor_by_trialcond = ch_avg_RT_INC_cor if trial_cond == 2

drop *CON* *INC* 

//Convert Subject variable to numeric for ANOVA
destring(Subject), replace

//~~~Comparing post stim trials using repeated measures ANOVA~~~
//http://www.stata.com/support/faqs/statistics/repeated-measures-anova/#half713
//Same as No between-subjects factors with 2 repeated variables example in link above?
foreach var of varlist *_post {
	di as result _newline "Table of StimCond x TrialCond for `var'" _continue
	tabdisp trial_cond stim_cond, cell(`var')
	di as result _newline "Repeated Measures Two-way ANOVA PostStim: StimCond x `var'" _continue
	anova `var' Subject stim_cond / Subject#stim_cond trial_cond / Subject#trial_cond stim_cond#trial_cond, repeated(stim_cond)
}

//~~~Comparing post - pre stim changes using repeated measures ANOVA~~~
foreach var of varlist ch_* {
	di as result _newline "Table of StimCond x TrialCond for `var'" _continue 
	tabdisp trial_cond stim_cond, cell(`var')
	di as result _newline "Repeated Measures Two-way ANOVA Raw Change: StimCond x `var'" _continue 
	anova `var' Subject stim_cond / Subject#stim_cond trial_cond / Subject#trial_cond stim_cond#trial_cond, repeated(stim_cond)
}

//Save as new dataset
save tDCS_ADD_Flanker_full_2WayANOVA_CLEANED, replace

log close
