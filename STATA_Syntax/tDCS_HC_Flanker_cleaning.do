clear all
capture log close
set more off
//set graphics off

//Import Flanker data (EDIT: change filename for updated datasets)
import excel "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\Healthy Controls\Flanker\tDCS_HC_Flanker_Full_11-10-2015.xls", sheet("Sheet1") firstrow

//make log recording what analyses were done
log using "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\Healthy Controls\Flanker\tDCS_HC_Flanker_Full.log", replace

//get rid of unnecessary variables
keep DataFileBasename Subject Session ExperimentVersion RespWindow SessionStartDateTimeUtc BlockList Trial Block1List Block2List CellLabel CorResp Feedback FixDur2 FlankerProbeACC FlankerProbeCRESP FlankerProbeRESP FlankerProbeRT Flankers FlankerProbeRTTime Probe

//~~~~Data Check~~~~~
//Duration Error?
//Different Experiment Versions?
//~~~~~End of Data Check~~~~~

//get rid of unneeded variables after Data Check; keep only variables needed for analysis
keep Subject Session CellLabel FixDur2 FlankerProbeACC FlankerProbeRT Trial BlockList

//Note: There is a ratio of 2 congruent : 1 incongruent stimuli "to build a tendency towards congruent responses" according to Dr. Avram Holmes who programmed the E-prime version of the task.

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
//tDCS_HC_01 was run on L stim for visits 1 and 2, keep for now for t-tests only (can't run ANOVA with this subject present)
//~~~~End Missing Data Notes~~~
//drop if regexm(Subject_Session, "(^8_)")

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

//Fill in missing indiv trial values
foreach var of varlist acc_CON acc_INC { 
	gsort Subject_Session `var'
	by Subject_Session: replace `var' = `var'[1]
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

//Find avg RT for CORRECT trials only for: congruent and incongruent
foreach var of varlist RT_CON RT_INC {
	gen `var'_cor = `var' if FlankerProbeACC == 1
	egen avg_`var'_cor = mean(`var'_cor), by(Subject_Session)
}

//Find avg RT and acc variables for Sham, Active L and Active R conditions: trials w/ pos/neg/neu pics and int/nonint
foreach var of varlist acc_* avg_RT_* {
	gen sham_`var' = `var' if stim_cond == 1 
	gen actL_`var' = `var' if stim_cond == 2
	gen actR_`var' = `var' if stim_cond == 3
}

//Now that we have all the averages that we want, we can arbitrarily remove the excess rows/individual trial data and variables so we only have 1 row/1 observation per Subject's Session
drop if Trial !=1 | BlockList == 2
drop num_* completed CellLabel FixDur2 FlankerProbeACC FlankerProbeRT RT_* BlockList Trial Subject2 Session2

//Get Subject and Session variables ready for reshape (we need the pre and post RTs for each subject combined into 1 row to perform ttests)
replace Subject_Session = substr(Subject_Session,1,length(Subject_Session)-1)
reshape wide sham_* actL_* actR_* acc_* avg_RT_*, i (Subject_Session) j (pre_post_stim)
order _all, alphabetic
move stim_cond acc_CON1

//Sham, Active L, Active R fill
foreach var of varlist sham_* actL_* actR_* {
	gsort Subject `var'
	by Subject: replace `var' = `var'[1]
}

//Graph Indiv. Subjects' PostStim Vars by StimCond
sort stim_cond
foreach var of varlist acc_*2 avg_RT_*2 {
	scatter `var' stim_cond, connect(l) by(Subject) xlabel(#3) xtitle("1 Sham 2 ActiveL 3 ActiveR") ytitle(PostStim `var')
	graph export `var'_Post_StimCond_by_Subject.pdf, replace
}

gen visit = 1 if regexm(Subject_Session, "(_1$)")
replace visit = 2 if regexm(Subject_Session, "(_2$)")
replace visit = 3 if regexm(Subject_Session, "(_3$)")
move visit acc_CON1

//Graph Indiv. Subjects' PostStim Vars by Visit#  
sort visit
foreach var of varlist acc_*2 avg_RT_*2  {
	scatter `var' visit, connect(l) by(Subject) xlabel(#3) xtitle("Visit# 1 2 3") ytitle(PostStim `var')
	graph export `var'_Post_Visit#_by_Subject.pdf, replace
}

local RT_acc_vars "acc_all acc_CON acc_INC avg_RT_all avg_RT_cor avg_RT_CON avg_RT_CON_cor avg_RT_INC avg_RT_INC_cor" 

//Table of means by Stim Cond
foreach x in `RT_acc_vars' {
	di as result _newline "Table of Means by Stim Cond: `x'" _continue
	tabstat `x'1 `x'2, by(stim_cond) columns(statistics) varwidth(16)
}

//Paired t-tests for all vars Pre vs. Post by StimCond
foreach x in `RT_acc_vars' {
	di as result _newline "Paired T-Test Post vs. PreStim Sham: `x'" _continue
	ttest `x'1 == `x'2 if stim_cond == 1 
	di as result _newline "Paired T-Test Post vs. PreStim ActL: `x'" _continue
	ttest `x'1 == `x'2 if stim_cond == 2
	di as result _newline "Paired T-Test Post vs. PreStim ActR: `x'" _continue
	ttest `x'1 == `x'2 if stim_cond == 3
}

//Get Raw (Post-Pre)Stim Values   
foreach x in `RT_acc_vars' {
	gen ch_`x' = `x'2 - `x'1
}

//Graph Indiv. Subjects' Raw (Post-Pre)Stim Change by StimCond
sort stim_cond
foreach var of varlist ch_* {
	scatter `var' stim_cond, connect(l) by(Subject) xlabel(#3) xtitle("1 Sham 2 ActiveL 3 ActiveR") ytitle(`var')
	graph export `var'_StimCond_by_Subject.pdf, replace
}

//Graph Indiv. Subjects' Raw (Post-Pre)Stim Change by Visit#
sort visit
foreach var of varlist ch_* {
	scatter `var' visit, connect(l) by(Subject) xlabel(#3) xtitle("Visit# 1 2 3") ytitle(`var')
	graph export `var'_Visit#_by_Subject.pdf, replace
}

//Convert Subject var to Numeric for ANOVA
destring(Subject), replace

//Remove Subject 1 to run ANOVA (Subject 1 was run on ActL 2x)
drop if Subject == 1 

//~~~Comparing post stim trials for all variables using repeated measures ANOVA~~~
//Repeated measures ANOVA syntax: anova DepVar CaseID IndepVar, repeated(IndepVar)
foreach var of varlist acc_*2 avg_RT_*2 {
	di as result _newline "Repeated Measures One-way ANOVA Post-Stim `var'" _continue
	anova `var' Subject stim_cond, repeated(stim_cond) 
}

//Table of Means by Stim Condition
foreach var of varlist ch_* {
	di as result _newline "Table of Means by Stim Condition: `var'" _continue
	tabstat `var', by(stim_cond) columns(statistics) varwidth(16)
}

//~~~Comparing post - pre stim changes using repeated measures One way ANOVA~~~
foreach var of varlist ch_* {
	di as result _newline "Repeated Measures One-way ANOVA Raw (Post - Pre)Stim Change `var'" _continue
	anova `var' Subject stim_cond, repeated(stim_cond)
}

//Restructure dataset for paired t-tests comparing L and R active vs. Sham
keep Subject Subject_Session stim_cond sham_* actL_* actR_* 

//Get post-pre stim change values of post - pre stim change
foreach x in `RT_acc_vars' {
	gen sham_ch_`x' = sham_`x'2 - sham_`x'1
	gen actL_ch_`x' = actL_`x'2 - actL_`x'1
	gen actR_ch_`x' = actR_`x'2 - actR_`x'1	
}

bysort Subject: drop if _n == 1 | _n == 2

local ch_RT_acc_vars "ch_acc_all ch_acc_CON ch_acc_INC ch_avg_RT_all ch_avg_RT_cor ch_avg_RT_CON ch_avg_RT_CON_cor ch_avg_RT_INC ch_avg_RT_INC_cor "

//Bar graph of post stim values by stim cond
foreach x in `RT_acc_vars' {
	graph bar sham_`x'2 actL_`x'2 actR_`x'2, bargap(5) ytitle(PostStim `x') legend( label(1 "Sham") label(2 "ActiveL") label(3 "ActiveR") cols(3)) blabel(bar)
	graph export `x'_Post_by_StimCond.pdf, replace
}

//Bar graph of post - pre stim change values by stim cond
foreach x in `ch_RT_acc_vars' {
	graph bar sham_`x' actL_`x' actR_`x', bargap(5) ytitle(`x') legend( label(1 "Sham") label(2 "ActiveL") label(3 "ActiveR") cols(3)) blabel(bar)
	graph export `x'_by_StimCond.pdf, replace
}

//Compare PostStim variables for: Active L vs. Sham, Active R vs. Sham, ActL vs. ActR using paired t-tests
foreach x in `RT_acc_vars' {
	di as result _newline "Paired T-Test PostStim ActL vs. Sham: `x'" _continue
	ttest sham_`x'2 == actL_`x'2
	di as result _newline "Paired T-Test PostStim ActR vs. Sham: `x'" _continue
	ttest sham_`x'2 == actR_`x'2
	di as result _newline "Paired T-Test PostStim ActL vs. ActR: `x'" _continue
	ttest actL_`x'2 == actR_`x'2
}

//Compare Raw Change (Post - PreStim) for: Active L vs. Sham, Active R vs. Sham, ActL vs. ActR using paired t-tests
foreach x in `ch_RT_acc_vars' {
	di as result _newline "Paired T-Test Raw Change ActL vs. Sham: `x'" _continue
	ttest sham_`x' == actL_`x'
	di as result _newline "Paired T-Test Raw Change ActR vs. Sham `x'" _continue
	ttest sham_`x' == actR_`x'
	di as result _newline "Paired T-Test Raw Change ActL vs. ActR `x'" _continue
	ttest actL_`x' == actR_`x'
}

//Save as new dataset
save tDCS_HC_Flanker_full_CLEANED, replace

log close
