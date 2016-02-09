clear all
capture log close
set more off
//set graphics off

//Import MSIT data (EDIT filename for updated datasets)
import excel "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\Healthy Controls\MSIT_IAPS\tDCS_HC_MSIT_IAPS_Full_11-10-2015.xls", sheet("Sheet1") firstrow

//make log recording what analyses were done
log using "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\Healthy Controls\MSIT_IAPS\tDCS_HC_MSIT_IAPS_Full.log", replace

//get rid of unnecessary variables
keep ExperimentName Subject Session ExperimentVersion SessionStartDateTimeUtc Block correctans emotion interference picture presentationACC presentationCRESP presentationRESP presentationRT presentationRTTime stimuli presentation1ACC presentation1CRESP presentation1RESP presentation1RT

//Combine variables into 1
replace presentationACC = presentation1ACC if presentationACC == .
replace presentationRT = presentation1RT if presentationRT == .
replace presentationRESP = presentation1RESP if presentationRESP == ""
replace presentationCRESP = presentation1CRESP if presentationCRESP == ""
drop presentation1ACC presentation1CRESP presentation1RESP presentation1RT

//~~~~Data Check~~~~~
//MSIT run 4 was run for pre AND post stim for tDCS_HC_04, keep for now.
//~~~~~End of Data Check~~~~~

//Recode RT for trials w/ no response as Missing.
replace presentationRT = . if presentationRT == 0

//get rid of unneeded variables after Data Check; keep only variables needed for analysis
drop ExperimentName ExperimentVersion SessionStartDateTimeUtc correctans picture presentationCRESP presentationRESP presentationRTTime stimuli

//Combine Subject and Session # Variables into 1 Variable
gen str3 Subject2 = string(Subject)
gen str3 Session2 = string(Session)
gen Subject_Session = Subject2 + "_" + Session2
drop Session 
move Subject_Session Block 

//~~~~Missing Data Notes~~~
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
label values completed yesno
replace completed = 1 if regexm(Subject_Session, "(^1_|^4_|^3_|^8_|^7_|^5_|^9_|^6_|^11_|^14_|^10_|^15_|^16_|^13_|^19_|^18_|^17_|^20_)")
drop if completed == 0 

//Make capitalization of emotions consistent
replace interference = "Int" if interference == "int"
replace interference = "Non" if interference == "nonint"
replace interference = "Non" if interference == "NonInt"
replace emotion = "Neg" if emotion == "neg"
replace emotion = "Pos" if emotion == "pos"
replace emotion = "Neu" if emotion == "neu" 

//Find decimal ACC for all trials (across all 2 blocks)
egen acc_all = total(presentationACC), by(Subject_Session)
egen num_all = count(presentationACC), by(Subject_Session)
replace acc_all = acc_all/num_all
drop num_all

//Take out subjects with below X accuracy?

//Generate accuracy variables for Int and Nonint conditions
foreach x in Int Non {
	egen acc_`x' = total(presentationACC) if interference == "`x'", by(Subject_Session)
	egen num_`x' = sum(interference == "`x'"), by(Subject_Session)
	replace acc_`x' = acc_`x'/num_`x'
	drop num_`x'
}

//Generate accuracy variables for Pos, Neg, Neu pics
foreach x in Neg Pos Neu {
	egen acc_`x' = total(presentationACC) if emotion == "`x'", by(Subject_Session)
	egen num_`x' = sum(emotion == "`x'"), by(Subject_Session)
	replace acc_`x' = acc_`x'/num_`x'
	drop num_`x'
}

//Generate accuracy variables for Pox, Neg, Neu x Int, Non conditions
foreach x in Neg Pos Neu {
	foreach y in Int Non {
		egen acc_`x'_`y' = total(presentationACC) if emotion == "`x'" & interference == "`y'", by(Subject_Session)
		egen num_`x'_`y' = sum(emotion == "`x'" & interference == "`y'"), by(Subject_Session)
		replace acc_`x'_`y' = acc_`x'_`y'/num_`x'_`y'
		drop num_`x'_`y'
	}
}

//Fill in missing indiv trial values
foreach var of varlist acc_Int acc_Non acc_Neg acc_Pos acc_Neu acc_Neg_Int acc_Pos_Int acc_Neu_Int acc_Neg_Non acc_Pos_Non acc_Neu_Non { 
	gsort Subject_Session `var'
	by Subject_Session: replace `var' = `var'[1]
}

//Find avg RT for all trials (correct + incorrect) (congruent + incongruent)
egen avg_RT_all = mean(presentationRT), by(Subject_Session)

//Find avg RT for correct response trials
gen RT_cor = presentationRT if presentationACC == 1
egen avg_RT_cor = mean(RT_cor), by(Subject_Session) 

//Find avg RT for trials w/ int, nonint
foreach x in Int Non {
	gen RT_`x' = presentationRT if interference == "`x'"
	egen avg_RT_`x' = mean(RT_`x'), by(Subject_Session)
}

//Find avg RT for trials w/ pos, neg, neu pics
foreach x in Neg Pos Neu {
	gen RT_`x' = presentationRT if emotion == "`x'"
	egen avg_RT_`x' = mean(RT_`x'), by(Subject_Session)
}

//Find avg RT for trials w/ pos, neg, neu x int, nonint
foreach x in Neg Pos Neu {
	foreach y in Int Non {
		gen RT_`x'_`y' = presentationRT if emotion == "`x'" & interference == "`y'"
		egen avg_RT_`x'_`y' = mean(RT_`x'_`y'), by(Subject_Session)
	}
}

//Find avg RT for CORRECT trials only for: positive, negative, neutral, interference, no interference, pos/neg/neu x int/no int
foreach var of varlist RT_Int RT_Non RT_Neg RT_Pos RT_Neu RT_Neg_Int RT_Pos_Int RT_Neu_Int RT_Neg_Non RT_Pos_Non RT_Neu_Non {
	gen `var'_cor = `var' if presentationACC == 1
	egen avg_`var'_cor = mean(`var'_cor), by(Subject_Session)
}

//Find avg RT and acc variables for Sham, Active L and Active R conditions: trials w/ pos/neg/neu pics and int/nonint
foreach var of varlist acc_* avg_RT_* {	
	gen sham_`var' = `var' if stim_cond == 1 
	gen actL_`var' = `var' if stim_cond == 2
	gen actR_`var' = `var' if stim_cond == 3
}

//Now that we have all the averages that we want, we can arbitrarily remove the excess rows/individual trial data and individual trial variables so we only have 1 row/1 observation per Subject's Session
drop if Block !=1
drop emotion interference presentationACC Block presentationRT Subject2 Session2 completed RT_*  

//Get Subject and Session variables ready for reshape (we need the pre and post RTs for each subject combined into 1 row to perform ttests)
replace Subject_Session = substr(Subject_Session,1,length(Subject_Session)-1)
reshape wide sham_* actL_* actR_* acc_* avg_RT_*, i (Subject_Session) j (pre_post_stim)
order _all, alphabetic
move stim_cond acc_all1

//Sham, Active L, Active R fill
foreach var of varlist sham_* actL_* actR_* {
	gsort Subject `var'
	by Subject: replace `var' = `var'[1]
}

/*
//graph individual subjects' post stim values by StimCond
sort stim_cond
foreach var of varlist acc_*2 avg_RT_*2 {
	scatter `var' stim_cond, connect(l) by(Subject) xlabel(#3) xtitle("1 Sham 2 ActiveL 3  ActiveR") ytitle(PostStim `var')
	graph export `var'_Post_StimCond_by_Subject.pdf, replace
}
*/

gen visit = 1 if regexm(Subject_Session, "(_1$)")
replace visit = 2 if regexm(Subject_Session, "(_2$)")
replace visit = 3 if regexm(Subject_Session, "(_3$)")
move visit acc_Int1

/*
//graph individual subjects' post stim values by Visit #
sort visit
foreach var of varlist acc_*2 avg_RT_*2 {
	scatter `var' visit, connect(l) by(Subject) xlabel(#3) xtitle("Visit# 1 2 3") ytitle(PostStim `var')
	graph export `var'_Post_Visit#_by_Subject.pdf, replace
}
*/

local RT_acc_vars "acc_all acc_Int acc_Non acc_Neg acc_Pos acc_Neu acc_Neg_Int acc_Pos_Int acc_Neu_Int acc_Neg_Non acc_Pos_Non acc_Neu_Non avg_RT_all avg_RT_cor avg_RT_Int avg_RT_Int_cor avg_RT_Non avg_RT_Non_cor avg_RT_Neg avg_RT_Neg_cor avg_RT_Pos avg_RT_Pos_cor avg_RT_Neu avg_RT_Neu_cor avg_RT_Neg_Int avg_RT_Neg_Int_cor avg_RT_Pos_Int avg_RT_Pos_Int_cor avg_RT_Neu_Int avg_RT_Neu_Int_cor avg_RT_Neg_Non avg_RT_Neg_Non_cor avg_RT_Pos_Non avg_RT_Pos_Non_cor avg_RT_Neu_Non avg_RT_Neu_Non_cor"

//Table of means: Accuracy Variables
foreach x in acc_all acc_Int acc_Non acc_Neg acc_Pos acc_Neu acc_Neg_Int acc_Pos_Int acc_Neu_Int acc_Neg_Non acc_Pos_Non acc_Neu_Non {
	di as result _newline "Table of Means by Stim Condition: `x'" _continue
	tabstat `x'1 `x'2, by(stim_cond) columns(statistics) varwidth(16)
}

//Table of means: Reaction Time Variables
foreach x in avg_RT_all avg_RT_cor avg_RT_Int avg_RT_Int_cor avg_RT_Non avg_RT_Non_cor avg_RT_Neg avg_RT_Neg_cor avg_RT_Pos avg_RT_Pos_cor avg_RT_Neu avg_RT_Neu_cor avg_RT_Neg_Int avg_RT_Neg_Int_cor avg_RT_Pos_Int avg_RT_Pos_Int_cor avg_RT_Neu_Int avg_RT_Neu_Int_cor avg_RT_Neg_Non avg_RT_Neg_Non_cor avg_RT_Pos_Non avg_RT_Pos_Non_cor avg_RT_Neu_Non avg_RT_Neu_Non_cor {
	di as result _newline "Table of Means by Stim Cond: `x'" _continue
	tabstat `x'1 `x'2, by(stim_cond) columns(statistics) varwidth(16)
}

//~~~Paired t-tests for all variables pre vs. post each stimulation condition~~~//
foreach x in `RT_acc_vars' {
	di as result _newline "Paired ttest post vs. pre `x' Sham" _continue
	ttest `x'1 == `x'2 if stim_cond == 1 
	di as result _newline "Paired ttest post vs. pre `x' Active Left" _continue
	ttest `x'1 == `x'2 if stim_cond == 2
	di as result _newline "Paired ttest post vs. pre `x' Active Right" _continue
	ttest `x'1 == `x'2 if stim_cond == 3
}

//Get post-pre stim change values 
foreach x in `RT_acc_vars' {
	gen ch_`x' = `x'2 - `x'1
}

/*
//graph individual subjects' change (post - prestim) values by StimCond
sort stim_cond
foreach var of varlist ch* {
	scatter `var' stim_cond, connect(l) by(Subject) xlabel(#3) xtitle("1 Sham 2 ActiveL 3 ActiveR") ytitle(`var')
	graph export `var'_StimCond_bySubject.pdf, replace
}
*/

//graph individual subjects' change (post - prestim) values by Visit #
sort visit
foreach var of varlist ch* {
	scatter `var' visit, connect(l) by(Subject) xlabel(#3) xtitle("Visit# 1 2 3") ytitle(`var')
	graph export `var'_Visit#_bySubject.pdf, replace
}

//First convert Subject variable to numeric for ANOVA
destring(Subject), replace

//Get rid of Subject 1 for ANOVAs (can't run ANOVA with this subject present b/c was run on Active L for visits)
drop if Subject == 1 

//~~~Comparing post stim trials using repeated measures ANOVA~~~
//Repeated measures ANOVA syntax: anova DepVar CaseID IndepVar, repeated(IndepVar)
foreach var of varlist acc_*2 avg_RT_*2 {
	di as result _newline "Repeated Measures One-way ANOVA Post-Stim `var'" _continue
	anova `var' Subject stim_cond, repeated(stim_cond)
}

//Table of Means
foreach var of varlist ch_* {
	di as result _newline "Table of Means by Stim Condition: `x'" _continue
	tabstat `var', by(stim_cond) columns(statistics) varwidth(16)
}

//~~~Comparing post - pre stim changes using repeated measures ANOVA~~~
foreach var of varlist ch_* {
	di as result _newline "Repeated Measures One-way ANOVA Post-PreStim Change `var'" _continue
	anova `var' Subject stim_cond, repeated(stim_cond)
}

//linear regression?? ASK JOAN

//Restructure dataset for paired t-tests comparing L and R active vs. Sham
keep Subject Subject_Session stim_cond sham* actL* actR* 

//Get post-pre stim change values of post - pre stim change
foreach x in `RT_acc_vars' {
	gen sham_ch_`x' = sham_`x'2 - sham_`x'1
	gen actL_ch_`x' = actL_`x'2 - actL_`x'1
	gen actR_ch_`x' = actR_`x'2 - actR_`x'1	
}

bysort Subject: drop if _n == 1 | _n == 2

/*
//bar graph of post stim values by stim cond
foreach x in `RT_acc_vars' {
	graph bar sham_`x'2 actL_`x'2 actR_`x'2, bargap(5) ytitle(PostStim `x') legend( label(1 "Sham") label(2 "ActiveL") label(3 "ActiveR") cols(3)) blabel(bar)
	graph export `x'_Post_by_StimCond.pdf, replace
}
*/

local ch_RT_acc_vars "ch_acc_all ch_acc_Int ch_acc_Non ch_acc_Neg ch_acc_Pos ch_acc_Neu ch_acc_Neg_Int ch_acc_Pos_Int ch_acc_Neu_Int ch_acc_Neg_Non ch_acc_Pos_Non ch_acc_Neu_Non ch_avg_RT_all ch_avg_RT_cor ch_avg_RT_Int ch_avg_RT_Non ch_avg_RT_Int_cor ch_avg_RT_Non_cor ch_avg_RT_Neg ch_avg_RT_Neg_cor ch_avg_RT_Neg_Int ch_avg_RT_Neg_Int_cor ch_avg_RT_Neg_Non ch_avg_RT_Neg_Non_cor ch_avg_RT_Neu ch_avg_RT_Neu_cor ch_avg_RT_Neu_Int ch_avg_RT_Neu_Int_cor ch_avg_RT_Neu_Non ch_avg_RT_Neu_Non_cor ch_avg_RT_Pos ch_avg_RT_Pos_cor ch_avg_RT_Pos_Int ch_avg_RT_Pos_Int_cor ch_avg_RT_Pos_Non ch_avg_RT_Pos_Non_cor"

/*
//bar graph of post - pre stim change values by stim cond
foreach x in `ch_RT_acc_vars' {
	graph bar sham_`x' actL_`x' actR_`x', bargap(5) ytitle(`x') legend( label(1 "Sham") label(2 "ActiveL") label(3 "ActiveR") cols(3)) blabel(bar)
	graph export `x'_by_StimCond.pdf, replace
}
*/

//Compare post stim variables Active L vs. Sham and Active R vs. Sham using paired t-tests
foreach x in `RT_acc_vars' {
	di as result _newline "Paired T-Test PostStim ActL vs. Sham: `x'" _continue
	ttest sham_`x'2 == actL_`x'2
	di as result _newline "Paired T-Test PostStim ActR vs. Sham: `x'" _continue
	ttest sham_`x'2 == actR_`x'2
	di as result _newline "Paired T-Test PostStim ActL vs. ActR: `x'" _continue
	ttest actL_`x'2 == actR_`x'2
}

//Compare post - pre stim variables Active L vs. Sham and Active R vs. Sham using paired t-tests
foreach x in `ch_RT_acc_vars' {
	di as result _newline "Paired T-Test Raw Change ActL vs. Sham: `x'" _continue 
	ttest sham_`x' == actL_`x'
	di as result _newline "Paired T-Test Raw Change ActR vs. Sham: `x'" _continue
	ttest sham_`x' == actR_`x'
	di as result _newline "Paired T-Test Raw Change ActL vs. ActR: `x'" _continue
	ttest actL_`x' == actR_`x'
}

//Save as new dataset
save tDCS_HC_MSIT_IAPS_full_CLEANED, replace

log close
