clear all
capture log close
set more off

//Import Flanker data (EDIT: change filename for updated datasets)
import excel "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\Healthy Controls\Flanker\tDCS_HC_Flanker_Full_11-10-2015.xls", sheet("Sheet1") firstrow

//make log recording what analyses were done
log using "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\Healthy Controls\Flanker\tDCS_HC_Flanker_Full_2WayANOVA.log", replace

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

//~~~~Missing Data Notes~~~
//tDCS_HC_03 visit 1 prestim: only Practice Flanker done, KEEP for now.
//tDCS_HC_08 visits 1,2,3 had to reduce stim level, keep for now. (Active L: 1mA; Active R: 1mA; Sham: 0.7mA)
//tDCS_HC_17 visits 1,2,3 had to reduce stim level, keep for now. (Active L: 1.5mA; Active R: 1.3mA; Sham: 1.5mA)
//~~~~End Missing Data Notes~~~
//drop if regexm(Subject_Session, "(^8_)")
//tDCS_HC_01 was run on L stim for visits 1 and 2, REMOVE (can't run ANOVA with this subject present.
drop if regexm(Subject_Session, "(^1_)")

//Create variable for: sham, active L, active R stim conditions (EDIT: Subject_Sessions for updated datasets)
gen stim_cond = 0
label define stim_conds 0 "Unknown/Not completed" 1 "Sham" 2 "Active_L" 3 "Active_R"
label values stim_cond stim_conds
replace stim_cond = 1 if regexm(Subject_Session, "(^1_3|^4_1|^3_1|^8_3|^7_2|^5_1|^9_1|^6_1|^11_2|^14_3|^10_3|^15_3|^16_2|^13_2|^19_2|^18_2|^17_3|^20_2)")
replace stim_cond = 2 if regexm(Subject_Session, "(^1_1|^1_2|^4_2|^3_2|^8_1|^7_3|^10_2|^5_3|^9_2|^12_1|^6_3|^11_3|^12_1|^14_1|^15_1|^10_2|^16_3|^13_3|^19_1|^18_1|^17_2|^20_3)")
replace stim_cond = 3 if regexm(Subject_Session, "(^2_1|^4_3|^3_3|^8_2|^7_1|^10_1|^5_2|^9_3|^6_2|^11_1|^13_1|^14_2|^10_1|^15_2|^16_1|^19_3|^18_3|^17_1|^20_1)") 

//Create variable for: Pre vs. Post stimulation
gen pre_post_stim = 0
label define pre_post_stim 0 "Unknown/Not Completed" 1 "PreStim" 2 "PostStim"
label values pre_post_stim pre_post_stim
replace pre_post_stim = 1 if regexm(Subject_Session, "(1$)")
replace pre_post_stim = 2 if regexm(Subject_Session, "(2$)")

//Filter for completed Subjects ONLY (EDIT: Subject_Sessions for updated datasets)
gen completed = 0
label values completed yesno
replace completed = 1 if regexm(Subject_Session, "(^1_|^4_|^3_|^8_|^7_|^5_|^9_|^6_|^11_|^14_|^10_|^15_|^16_|^13_|^19_|^18_|^17_|^20_)")
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
expand 2 if Sub_Ses == "3_1"
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
save tDCS_HC_Flanker_full_2WayANOVA_CLEANED, replace

log close
