clear all
capture log close
set more off
//set graphics off

//Import Flanker data (EDIT: filename for updated datasets)
import excel "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\Healthy Controls\n_back\tDCS_HC_nback_full_11-10-2015.xls", sheet("Sheet1") firstrow

//make log recording what analyses were done
log using "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\Healthy Controls\n_back\tDCS_HC_nback.log", replace

//get rid of unnecessary variables
keep ExperimentName Subject Session DataFileBasename ExperimentVersion SessionStartDateTimeUtc Block correctresp Nback Stimuli TextDisplay2ACC TextDisplay2CRESP TextDisplay2RESP TextDisplay2RT TextDisplay2RTTime TextDisplay4ACC TextDisplay4CRESP TextDisplay4RESP TextDisplay4RT TextDisplay4RTTime

//~~~~Data Check~~~~~
//Duration Error?
//~~~~~End of Data Check~~~~~

//Recode nback accuracy for "correct misses"
replace TextDisplay2ACC = 1 if TextDisplay2CRESP == "?" & TextDisplay2RESP == ""
replace TextDisplay4ACC = 1 if TextDisplay4CRESP == "?" & TextDisplay2RESP == ""

//Recode nback accuracy for participants who used the wrong key
replace TextDisplay2RESP = "{END},1" if TextDisplay2RESP == "2"
replace TextDisplay4RESP = "{END},1" if TextDisplay4RESP == "2"
replace TextDisplay2RESP = "{END},1" if TextDisplay2RESP == "{DOWNARROW}"
replace TextDisplay4RESP = "{END},1" if TextDisplay4RESP == "{DOWNARROW}"
replace TextDisplay2ACC = 1 if TextDisplay2RESP == TextDisplay2CRESP 
replace TextDisplay4ACC = 1 if TextDisplay4RESP == TextDisplay4CRESP 
 
//TextDisplay4 = slide displaying the Letter
//TextDisplay2 = blank slide AFTER the letter i.e. if participant responded after the letter was displayed
//Recode TextDisplay2 variable's Accuracy, Response and Correct Response into Text4Display variable
replace TextDisplay4ACC = TextDisplay2ACC if TextDisplay2RESP != ""
replace TextDisplay4RESP = TextDisplay2RESP if TextDisplay2RESP != ""
replace TextDisplay4CRESP = TextDisplay2CRESP if TextDisplay2RESP != ""
//Recode TextDisplay 2's RT + 500 (duration of Stimulus Slide aka TextDisplay4) into TextDisplay4RT variable
replace TextDisplay4RT = TextDisplay2RT + 500 if TextDisplay2RESP != ""
drop TextDisplay2ACC TextDisplay2RESP TextDisplay2CRESP TextDisplay2RT
//Rename merged variables
rename TextDisplay4RT nback_RT
rename TextDisplay4ACC nback_ACC
rename TextDisplay4RESP nback_RESP
rename TextDisplay4CRESP nback_CRESP

//If RT is 0 (i.e. no response), then recode as 'missing'
replace nback_RT = . if nback_RT == 0

//Get rid of unneeded variables after Data Check; keep only variables needed for analysis
keep Subject Session Block Nback nback_ACC nback_RT

//Combine Subject and Session # Variables into 1 Variable
gen str3 Subject2 = string(Subject)
gen str3 Session2 = string(Session)
gen Subject_Session = Subject2 + "_" + Session2
drop Session 
move Subject_Session Block 

//~~~~Missing Data Notes~~~
//tDCS_HC_03 visit 1 prestim: only Practice nback done, keep for now.
//tDCS_HC_08 visits 1,2,3 had to reduce stim level, keep for now. (Active L: 1mA; Active R: 1mA; Sham: 0.7mA)
//tDCS_HC_17 visits 1,2,3 had to reduce stim level, keep for now. (Active L: 1.5mA; Active R: 1.3mA; Sham: 1.5mA)
//tDCS_HC_01 was run on L stim for visits 1 and 2, keep for now for t-tests only (can't run ANOVA with this subject present.
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
label variable completed "Did subject complete all 3 tDCS study visits"
label values completed yesno
replace completed = 1 if regexm(Subject_Session, "(^1_|^4_|^3_|^8_|^7_|^5_|^9_|^6_|^11_|^14_|^10_|^15_|^16_|^13_|^19_|^18_|^17_|^20_)")
drop if completed == 0 

//Find avg RT for 1 back and 2 back for all trials
egen avg_RT_12back_all = mean(nback_RT), by(Subject_Session)
egen avg_RT_1back_all = mean(nback_RT) if Nback == 1, by(Subject_Session)
egen avg_RT_2back_all = mean(nback_RT) if Nback == 2, by(Subject_Session)

//Find avg RT for 1 back and 2 back for correct response trials 
gen RT_12back_correct = nback_RT if nback_ACC == 1  
egen avg_RT_12back_correct = mean(RT_12back_correct), by(Subject_Session) 

gen RT_1back_correct = nback_RT if nback_ACC == 1 & Nback == 1
egen avg_RT_1back_correct = mean(RT_1back_correct), by(Subject_Session) 

gen RT_2back_correct = nback_RT if nback_ACC == 1 & Nback == 2
egen avg_RT_2back_correct = mean(RT_2back_correct), by(Subject_Session) 

//Find decimal ACC for 1 back and 2 back for all trials 
egen acc_12back_all = total(nback_ACC), by(Subject_Session)
egen num_12back_all = count(nback_ACC), by(Subject_Session)
replace acc_12back_all = acc_12back_all/num_12back_all

egen acc_1back_all = total(nback_ACC) if Nback == 1, by(Subject_Session)
egen num_1back_all = count(nback_ACC) if Nback == 1, by(Subject_Session)
replace acc_1back_all = acc_1back_all/num_1back_all

egen acc_2back_all = total(nback_ACC) if Nback == 2, by(Subject_Session)
egen num_2back_all = count(nback_ACC) if Nback == 2, by(Subject_Session)
replace acc_2back_all = acc_2back_all/num_2back_all

//Fill in missing indiv trial values
foreach var of varlist acc_2back_all avg_RT_2back_correct avg_RT_2back_all { 
	gsort Subject_Session `var'
	by Subject_Session: replace `var' = `var'[1]
}

//Take out subjects with below X accuracy?

//Find avg RT and acc variables for Sham, Active L and Active R conditions: trials w/ pos/neg/neu pics and int/nonint
foreach var of varlist acc_* avg_RT_* {
	gen sham_`var' = `var' if stim_cond == 1 
	gen actL_`var' = `var' if stim_cond == 2
	gen actR_`var' = `var' if stim_cond == 3
}

//Now that we have all the averages that we want, we can arbitrarily remove the excess rows/individual trial data and individual trial variables so we only have 1 row/1 observation per Subject's Session
drop if Block !=1 
drop completed Block Nback Subject2 Session2 RT_* num_* nback_ACC nback_RT  

//Get Subject and Session variables ready for reshape (we need the pre and post RTs for each subject combined into 1 row to perform ttests)
replace Subject_Session = substr(Subject_Session,1,length(Subject_Session)-1)
reshape wide sham_* actL_* actR_* acc_* avg_RT_* , i (Subject_Session) j (pre_post_stim)

//Sham, Active L, Active R fill
foreach var of varlist sham_* actL_* actR_* {
	gsort Subject `var'
	by Subject: replace `var' = `var'[1]
}

//Rearrange variables
order _all, alphabetic
move stim_cond acc_12back_all1

//graph individual subjects' post stim values
sort stim_cond
foreach var of varlist *all2 *correct2 {
	scatter `var' stim_cond, connect(l) by(Subject) xlabel(#3) xtitle("1 Sham 2 ActiveL 3 ActiveR") ytitle(PostStim `var')
	graph export `var'_Post_StimCond_by_Subject.pdf, replace
}


gen visit = 1 if regexm(Subject_Session, "(_1$)")
replace visit = 2 if regexm(Subject_Session, "(_2$)")
replace visit = 3 if regexm(Subject_Session, "(_3$)")
move visit acc_12back_all1

//graph individual subjects' post stim values
sort visit
foreach var of varlist *all2 *correct2 {
	scatter `var' stim_cond, connect(l) by(Subject) xlabel(#3) xtitle("Visit# 1 2 3") ytitle(PostStim `var')
	graph export `var'_Post_Visit#_by_Subject.pdf, replace
}

local RT_acc_vars "acc_12back_all acc_1back_all acc_2back_all avg_RT_12back_all avg_RT_12back_correct avg_RT_1back_all avg_RT_1back_correct avg_RT_2back_all avg_RT_2back_correct"

//Table of means
foreach x in `RT_acc_vars' {
	di as result _newline "Table of Means by Stim Cond: `x'" _continue
	tabstat `x'1 `x'2, by(stim_cond) columns(statistics) varwidth(16)
}

//~~~Paired T-Test: Post vs. PreStim for Sham, Active L, Active R~~~
foreach x in `RT_acc_vars' {
	di as result _newline "Paired T-Test Post vs. PreStim Sham: `x'" _continue
	ttest `x'1 == `x'2 if stim_cond == 1 
	di as result _newline "Paired T-Test Post vs. PreStim Active Left: `x'" _continue
	ttest `x'1 == `x'2 if stim_cond == 2
	di as result _newline "Paired T-Test Post vs. PreStim Active Right: `x' " _continue
	ttest `x'1 == `x'2 if stim_cond == 3
}

//Get post-pre stim change values
foreach x in `RT_acc_vars'{
	gen ch_`x' = `x'2 - `x'1
}

//graph individual subjects' change (post - prestim) values by StimCond
sort stim_cond
foreach var of varlist ch_*  {
	scatter `var' stim_cond, connect(l) by(Subject) xlabel(#3) xtitle("1 Sham 2 ActiveL 3 ActiveR") ytitle(`var')
	graph export `var'_StimCond_by_Subject.pdf, replace
}

//graph individual subjects' change (post - prestim) values by Visit#
sort visit
foreach var of varlist ch_*  {
	scatter `var' visit, connect(l) by(Subject) xlabel(#3) xtitle("Visit# 1 2 3") ytitle(`var')
	graph export `var'_Visit#_by_Subject.pdf, replace
}


//Get rid of Subject 1 for ANOVAs (can't run ANOVA with this subject present b/c was run on Active L for visits)
drop if regexm(Subject_Session, "(^1_)")

//First convert Subject variable to numeric for ANOVA
destring(Subject), replace

//~~~Comparing post stim trials using repeated measures ANOVA~~~
//Repeated measures ANOVA syntax: anova DepVar CaseID IndepVar, repeated(IndepVar)
foreach var of varlist acc_*2 avg_RT_*2 {
	di as result _newline "Repeated Measures One-way ANOVA Post-Stim `var'" _continue
	anova `var' Subject stim_cond, repeated(stim_cond)
}

//Table of Means for Raw Change (Post - PreStim)
foreach var of varlist ch_* {
	di as result _newline "Table of Means by Stim Cond: `x'" _continue
	tabstat `var', by(stim_cond) columns(statistics) varwidth(16)
}

//~~~Comparing Raw Change values using repeated measures 1 Way ANOVA~~~
foreach var of varlist ch_* {
	di as result _newline "Repeated Measures One-way ANOVA Raw Change `var'" _continue
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

//bar graph of post stim values by stim cond
foreach x in `RT_acc_vars' {
	graph bar sham_`x'2 actL_`x'2 actR_`x'2, bargap(5) ytitle(`x') legend( label(1 "Sham") label(2 "ActiveL") label(3 "ActiveR") cols(3)) blabel(bar)
	graph export `x'_Post_by_StimCond.pdf, replace
}

local ch_RT_acc_vars "ch_acc_12back_all ch_acc_1back_all ch_acc_2back_all ch_avg_RT_12back_all ch_avg_RT_12back_correct ch_avg_RT_1back_all ch_avg_RT_1back_correct ch_avg_RT_2back_all ch_avg_RT_2back_correct"

//bar graph of post - pre stim change values by stim cond
foreach x in `ch_RT_acc_vars' {
	graph bar sham_`x' actL_`x' actR_`x', bargap(5) ytitle(`x') legend( label(1 "Sham") label(2 "ActiveL") label(3 "ActiveR") cols(3)) blabel(bar)
	graph export `x'_by_StimCond.pdf, replace
}

//Compare post stim variables Active L vs. Sham, Active R vs. Sham, ActL vs. ActR using paired t-tests
foreach x in `RT_acc_vars' {
	di as result _newline "Paired T-Test PostStim ActL vs. Sham: `x'" _continue
	ttest sham_`x'2 == actL_`x'2
	di as result _newline "Paired T-Test PostStim ActR vs. Sham: `x'" _continue
	ttest sham_`x'2 == actR_`x'2
	di as result _newline "Paired T-Test PostStim ActL vs. ActR: `x'" _continue
	ttest actL_`x'2 == actR_`x'2
}

//Compare Raw Change variables: Active L vs. Sham, Active R vs. Sham, ActL vs. ActR using paired t-tests
foreach x in `ch_RT_acc_vars' {
	di as result _newline "Paired T-Test Raw Change ActL vs. Sham: `x'" _continue
	ttest sham_`x' == actL_`x'
	di as result _newline "Paired T-Test Raw Change ActR vs. Sham: `x'" _continue
	ttest sham_`x' == actR_`x'
	di as result _newline "Paired T-Test Raw Change ActL vs. ActR `x'" _continue
	ttest actL_`x' == actR_`x'
}

//Save as new dataset
save tDCS_HC_nback_full_CLEANED, replace

log close
