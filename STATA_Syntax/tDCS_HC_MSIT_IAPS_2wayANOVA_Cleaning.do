clear all
capture log close
set more off

//Import MSIT data (EDIT filename for updated datasets)
import excel "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\Healthy Controls\MSIT_IAPS\tDCS_HC_MSIT_IAPS_Full_11-10-2015.xls", sheet("Sheet1") firstrow

//make log recording what analyses were done
log using "C:\Users\Neuromod\Desktop\tDCS_Behavioral_Data\Healthy Controls\MSIT_IAPS\tDCS_HC_MSIT_IAPS_Full_2WayANOVA.log", replace

//get rid of unnecessary variables
keep ExperimentName Subject Session ExperimentVersion SessionStartDateTimeUtc Block correctans emotion interference picture presentationACC presentationCRESP presentationRESP presentationRT presentationRTTime stimuli presentation1ACC presentation1CRESP presentation1RESP presentation1RT

//Combine variables into 1
replace presentationACC = presentation1ACC if presentationACC == .
replace presentationRT = presentation1RT if presentationRT == .
replace presentationRESP = presentation1RESP if presentationRESP == ""
replace presentationCRESP = presentation1CRESP if presentationCRESP == ""
drop presentation1ACC presentation1CRESP presentation1RESP presentation1RT

//~~~~Data Check~~~~~
//MSIT run 4 was run for pre AND post stim for tDCS_HC_04, still usable? Ask Joan.
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
//~~~~End Missing Data Notes~~~
//drop if regexm(Subject_Session, "(^8_)")
//tDCS_HC_01 was run on L stim for visits 1 and 2, REMOVE (can't run ANOVA with this subject present.
drop if regexm(Subject_Session, "(^1_)")

//Create variable for: sham, active L, active R stim conditions (EDIT: Subject_Sessions for updated datasets)
gen stim_cond = 0
label variable stim_cond "Did subject receive L sham, L active or R active for this session?"
label define stim_conds 0 "Unknown/Not completed" 1 "Sham" 2 "Active_L" 3 "Active_R"
label values stim_cond stim_conds
replace stim_cond = 1 if regexm(Subject_Session, "(^1_3|^4_1|^3_1|^8_3|^7_2|^5_1|^9_1|^6_1|^11_2|^14_3|^10_3|^15_3|^16_2|^13_2|^19_2|^18_2|^17_3|^20_2)")
replace stim_cond = 2 if regexm(Subject_Session, "(^1_1|^1_2|^4_2|^3_2|^8_1|^7_3|^10_2|^5_3|^9_2|^12_1|^6_3|^11_3|^12_1|^14_1|^15_1|^10_2|^16_3|^13_3|^19_1|^18_1|^17_2|^20_3)")
replace stim_cond = 3 if regexm(Subject_Session, "(^2_1|^4_3|^3_3|^8_2|^7_1|^10_1|^5_2|^9_3|^6_2|^11_1|^13_1|^14_2|^10_1|^15_2|^16_1|^19_3|^18_3|^17_1|^20_1)") 

//Create variable for: Pre vs. Post stimulation
gen pre_post_stim = 0
label variable pre_post_stim "PreStim or PostStim"
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

//Make capitalization of emotions consistent
replace emotion = "Neg" if emotion == "neg"
replace emotion = "Pos" if emotion == "pos"
replace emotion = "Neu" if emotion == "neu" 
replace interference = "Int" if interference == "int"
replace interference = "Non" if interference == "nonint"
replace interference = "Non" if interference == "NonInt"

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

//Generate accuracy variables for Pox, Neg, Neu x Int, NonInt conditions
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

//Find avg RT for trials w/ pos, neg, neu pics
foreach x in Neg Pos Neu {
	gen RT_`x' = presentationRT if emotion == "`x'"
	egen avg_RT_`x' = mean(RT_`x'), by(Subject_Session)
}

//Find avg RT for trials w/ int, nonint
foreach x in Int Non {
	gen RT_`x' = presentationRT if interference == "`x'"
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

//Find avg RT for Sham, Active L and Active R conditions: trials w/ pos/neg/neu pics and int/nonint
foreach var of varlist acc_* avg_RT_* {
	gen sham_`var' = `var' if stim_cond == 1 
	gen actL_`var' = `var' if stim_cond == 2
	gen actR_`var' = `var' if stim_cond == 3
}

//Generate separate pre and post variables
foreach var of varlist acc_* avg_RT_* sham_* actL_* actR_* {
	gen `var'_pre = `var' if pre_post_stim == 1
	gen `var'_post = `var' if pre_post_stim == 2
}

//Now that we have all the averages that we want, we can arbitrarily remove the excess rows/individual trial data and individual trial variables so we only have 1 row/1 observation per Subject's Session
drop if Block !=1
drop presentationACC Block presentationRT Subject2 Session2 completed RT_*  

//Fill in the rows that have pre stim data with post stim data and vice versa so we can then calculate the post - pre stim change values
gen Sub_Ses = substr(Subject_Session,1,length(Subject_Session)-1)
foreach var of varlist *_post *_pre {
	gsort Sub_Ses `var'
	by Sub_Ses: replace `var' = `var'[1]
}

//Sham, Active L, Active R fill
foreach var of varlist sham_* actL_* actR_* {
	gsort Subject `var'
	by Subject: replace `var' = `var'[1]
}

local RT_acc_vars "acc_all acc_Int acc_Non acc_Neg acc_Pos acc_Neu acc_Neg_Int acc_Pos_Int acc_Neu_Int acc_Neg_Non acc_Pos_Non acc_Neu_Non avg_RT_all avg_RT_cor avg_RT_Int avg_RT_Int_cor avg_RT_Non avg_RT_Non_cor avg_RT_Neg avg_RT_Neg_cor avg_RT_Pos avg_RT_Pos_cor avg_RT_Neu avg_RT_Neu_cor avg_RT_Neg_Int avg_RT_Neg_Int_cor avg_RT_Pos_Int avg_RT_Pos_Int_cor avg_RT_Neu_Int avg_RT_Neu_Int_cor avg_RT_Neg_Non avg_RT_Neg_Non_cor avg_RT_Pos_Non avg_RT_Pos_Non_cor avg_RT_Neu_Non avg_RT_Neu_Non_cor"
 
//Get post-pre stim change values for repeated measures ANOVA of post - pre stim change
foreach x in `RT_acc_vars' {
	gen ch_`x' = `x'_post - `x'_pre
}

foreach x in `RT_acc_vars' {
	gen ch_sham_`x' = sham_`x'_post - sham_`x'_pre
	gen ch_actL_`x' = actL_`x'_post - actL_`x'_pre
	gen ch_actR_`x' = actR_`x'_post - actR_`x'_pre
}

//Get rid of pre and all variables since those are no longer needed
keep emotion interference stim_cond Subject Sub_Ses Subject_Session *_post ch_*

//Restructure data for 2 way ANOVA
//Make emotion and interference variables numeric
replace emotion = "1" if emotion == "Neg"
replace emotion = "2" if emotion == "Pos"
replace emotion = "3" if emotion == "Neu"
destring(emotion), replace
label define emotion 1 "Neg" 2 "Pos" 3 "Neu"
label values emotion emotion
replace interference = "1" if interference == "Int"
replace interference = "2" if interference == "Non"
destring(interference), replace
label define interference 1 "Int" 2 "Non"
label values interference interference

//Restructure data for graph of ActL, ActR, Sham x Interference, Noninterference with indiv bars of Pos, Neg, Neu w/ means and error bars listed.
expand 3

move stim_cond emotion
move Sub_Ses stim_cond

bysort Sub_Ses: replace emotion = 1 if _n == 1 | _n == 2  
bysort Sub_Ses: replace emotion = 2 if _n == 3 | _n == 4
bysort Sub_Ses: replace emotion = 3 if _n == 5 | _n == 6
bysort Sub_Ses: replace interference = 1 if _n == 1 | _n == 3 | _n == 5 
bysort Sub_Ses: replace interference = 2 if _n == 2 | _n == 4 | _n == 6

//Have PostStim acc, RT and correct RT variables by condition for: StimCond x Emotion x Int/NonInt
gen acc_stimxemoxint_post = acc_Neg_Int_post if emotion == 1 & interference == 1
replace acc_stimxemoxint_post = acc_Neg_Non_post if emotion == 1 & interference == 2
replace acc_stimxemoxint_post = acc_Pos_Int_post if emotion == 2 & interference == 1
replace acc_stimxemoxint_post = acc_Pos_Non_post if emotion == 2 & interference == 2
replace acc_stimxemoxint_post = acc_Neu_Int_post if emotion == 3 & interference == 1
replace acc_stimxemoxint_post = acc_Neu_Non_post if emotion == 3 & interference == 2

gen avg_RT_stimxemoxint_post = avg_RT_Neg_Int_post if emotion == 1 & interference == 1
replace avg_RT_stimxemoxint_post = avg_RT_Neg_Non_post if emotion == 1 & interference == 2
replace avg_RT_stimxemoxint_post = avg_RT_Pos_Int_post if emotion == 2 & interference == 1
replace avg_RT_stimxemoxint_post = avg_RT_Pos_Non_post if emotion == 2 & interference == 2
replace avg_RT_stimxemoxint_post = avg_RT_Neu_Int_post if emotion == 3 & interference == 1
replace avg_RT_stimxemoxint_post = avg_RT_Neu_Non_post if emotion == 3 & interference == 2

gen avg_RT_cor_stimxemoxint_post = avg_RT_Neg_Int_cor_post if emotion == 1 & interference == 1
replace avg_RT_cor_stimxemoxint_post = avg_RT_Neg_Non_cor_post if emotion == 1 & interference == 2
replace avg_RT_cor_stimxemoxint_post = avg_RT_Pos_Int_cor_post if emotion == 2 & interference == 1
replace avg_RT_cor_stimxemoxint_post = avg_RT_Pos_Non_cor_post if emotion == 2 & interference == 2
replace avg_RT_cor_stimxemoxint_post = avg_RT_Neu_Int_cor_post if emotion == 3 & interference == 1
replace avg_RT_cor_stimxemoxint_post = avg_RT_Neu_Non_cor_post if emotion == 3 & interference == 2

//Have Raw Change (Post - Pre Stim) acc, RT and correct RT variables by condition for: StimCond x Emotion x Int/NonInt
gen ch_acc_stimxemoxint = ch_acc_Neg_Int if emotion == 1 & interference == 1
replace ch_acc_stimxemoxint = ch_acc_Neg_Non if emotion == 1 & interference == 2
replace ch_acc_stimxemoxint = ch_acc_Pos_Int if emotion == 2 & interference == 1
replace ch_acc_stimxemoxint = ch_acc_Pos_Non if emotion == 2 & interference == 2
replace ch_acc_stimxemoxint = ch_acc_Neu_Int if emotion == 3 & interference == 1
replace ch_acc_stimxemoxint = ch_acc_Neu_Non if emotion == 3 & interference == 2

gen ch_avg_RT_stimxemoxint = ch_avg_RT_Neg_Int if emotion == 1 & interference == 1
replace ch_avg_RT_stimxemoxint = ch_avg_RT_Neg_Non if emotion == 1 & interference == 2
replace ch_avg_RT_stimxemoxint = ch_avg_RT_Pos_Int if emotion == 2 & interference == 1
replace ch_avg_RT_stimxemoxint = ch_avg_RT_Pos_Non if emotion == 2 & interference == 2
replace ch_avg_RT_stimxemoxint = ch_avg_RT_Neu_Int if emotion == 3 & interference == 1
replace ch_avg_RT_stimxemoxint = ch_avg_RT_Neu_Non if emotion == 3 & interference == 2

gen ch_avg_RT_cor_stimxemoxint = ch_avg_RT_Neg_Int_cor if emotion == 1 & interference == 1
replace ch_avg_RT_cor_stimxemoxint = ch_avg_RT_Neg_Non_cor if emotion == 1 & interference == 2
replace ch_avg_RT_cor_stimxemoxint = ch_avg_RT_Pos_Int_cor if emotion == 2 & interference == 1
replace ch_avg_RT_cor_stimxemoxint = ch_avg_RT_Pos_Non_cor if emotion == 2 & interference == 2
replace ch_avg_RT_cor_stimxemoxint = ch_avg_RT_Neu_Int_cor if emotion == 3 & interference == 1
replace ch_avg_RT_cor_stimxemoxint = ch_avg_RT_Neu_Non_cor if emotion == 3 & interference == 2

generate stimxemoxint = interference if emotion == 1 & stim_cond == 1
replace stimxemoxint = interference + 5 if emotion == 1 & stim_cond == 2
replace stimxemoxint = interference + 10 if emotion == 1 & stim_cond == 3
replace stimxemoxint = interference + 15 if emotion == 2 & stim_cond == 1
replace stimxemoxint = interference + 20 if emotion == 2 & stim_cond == 2
replace stimxemoxint = interference + 25 if emotion == 2 & stim_cond == 3
replace stimxemoxint = interference + 30 if emotion == 3 & stim_cond == 1
replace stimxemoxint = interference + 35 if emotion == 3 & stim_cond == 2
replace stimxemoxint = interference + 40 if emotion == 3 & stim_cond == 3
sort stimxemoxint

local stimxemoxint_vars "acc_stimxemoxint_post avg_RT_stimxemoxint_post avg_RT_cor_stimxemoxint_post ch_acc_stimxemoxint ch_avg_RT_stimxemoxint ch_avg_RT_cor_stimxemoxint"

//Make mean and standard deviation variables
foreach x in `stimxemoxint_vars' {
	egen m_`x' = mean(`x'), by(stimxemoxint)
	egen sd_`x' = std(`x')
	egen n_`x' = count(`x')
}

foreach x in `stimxemoxint_vars' {
	generate hi_`x' = m_`x' + invttail(n_`x' - 1,0.025)*(sd_`x' / sqrt(n_`x'))
	generate lo_`x' = m_`x' - invttail(n_`x' - 1,0.025)*(sd_`x' / sqrt(n_`x'))
}

twoway bar m_acc_stimxemoxint_post stimxemoxint if emotion == 1 || bar m_acc_stimxemoxint_post stimxemoxint if emotion == 2 || bar m_acc_stimxemoxint_post stimxemoxint if emotion == 3, legend(row(1) order(1 "Neg" 2 "Pos" 3 "Neu")) xtitle("Stim_Cond x Int x Emotion") ytitle("acc_stimxemoxint_post")



//Create bar graphs
foreach x in `stimxemoxint_vars' {
	twoway bar `x' stimxemoxint if emotion == 1
	|| bar `x' stimxemoxint if emotion == 2)
	|| bar `x' stimxemoxint if emotion == 3)
	(rcap hi_`x' lo_`x' stimxemoxint),
    legend(row(1) order(1 "Neg" 2 "Pos" 3 "Neu")
	xtitle ("Bar Graphs of Stim_Cond x Int x Emotion") ytitle(`x')
}


	
//Restructure data for 2-way Repeated Measures ANOVA: Emotion(3) x StimCond(3)
//Need 9 rows per Subject: 3 of each stim cond x 1 of each emotion
expand 2
bysort Sub_Ses: drop if _n == 1

move stim_cond emotion
move Sub_Ses stim_cond

bysort Sub_Ses: replace emotion = 1 if _n == 1  
bysort Sub_Ses: replace emotion = 2 if _n == 2 
bysort Sub_Ses: replace emotion = 3 if _n == 3

//Have PostStim acc, RT and correct RT variables by condition for: Emotion x StimCond
gen acc_by_emo_post = acc_Neg_post if emotion == 1
replace acc_by_emo_post = acc_Pos_post if emotion == 2
replace acc_by_emo_post = acc_Neu_post if emotion == 3

gen avg_RT_by_emo_post = avg_RT_Neg_post if emotion == 1
replace avg_RT_by_emo_post = avg_RT_Pos_post if emotion == 2
replace avg_RT_by_emo_post = avg_RT_Neu_post if emotion == 3

gen avg_RT_cor_by_emo_post = avg_RT_Neg_cor_post if emotion == 1
replace avg_RT_cor_by_emo_post = avg_RT_Pos_cor_post if emotion == 2
replace avg_RT_cor_by_emo_post = avg_RT_Neu_cor_post if emotion == 3

//Have Post - Pre Stim acc, RT and correct RT variables by condition for: Emotion x StimCond
gen ch_acc_by_emo = ch_acc_Neg if emotion == 1
replace ch_acc_by_emo = ch_acc_Pos if emotion == 2
replace ch_acc_by_emo = ch_acc_Neu if emotion == 3 

gen ch_avg_RT_by_emo = ch_avg_RT_Neg if emotion == 1
replace ch_avg_RT_by_emo = ch_avg_RT_Pos if emotion == 2
replace ch_avg_RT_by_emo = ch_avg_RT_Neu if emotion == 3

gen ch_avg_RT_cor_by_emo = ch_avg_RT_Neg_cor if emotion == 1
replace ch_avg_RT_cor_by_emo = ch_avg_RT_Pos_cor if emotion == 2
replace ch_avg_RT_cor_by_emo = ch_avg_RT_Neu_cor if emotion == 3

//2-Way Repeated Measures ANOVA: Emotion(3) x StimCond(3) 
foreach var of varlist *_by_emo_post {
	di as result _newline "Repeated Measures Two-way ANOVA Post-Stim: StimCond x `var'" _continue
	anova `var' Subject stim_cond / Subject#stim_cond emotion / Subject#emotion stim_cond#emotion, repeated(stim_cond)
}

//2-Way Repeated Measures ANOVA Post - Pre Stim: Emotion(3) x StimCond(3)
foreach var of varlist ch_*_by_emo {
	di as result _newline "Repeated Measures Two-way ANOVA Post - Pre Stim `var'" _continue
	anova `var' Subject stim_cond / Subject#stim_cond emotion / Subject#emotion stim_cond#emotion, repeated(stim_cond)
}

//Restructure data for 2-Way Repeated Measures ANOVA: Int/NonInt(2) x StimCond(3)
//Need 6 rows per Subject: 2 of each stim cond x 2 of each interference
bysort Sub_Ses: drop if _n == 1
bysort Sub_Ses: replace interference = 1 if _n == 1
bysort Sub_Ses: replace interference = 2 if _n == 2 

//Have PostStim acc, RT and correct RT variables by condition for: Int/NonInt x StimCond
gen acc_by_int_post = acc_Int_post if interference == 1
replace acc_by_int_post = acc_Non_post if interference == 2

gen avg_RT_by_int_post = avg_RT_Int_post if interference == 1
replace avg_RT_by_int_post = avg_RT_Non_post if interference == 2

gen avg_RT_cor_by_int_post = avg_RT_Int_cor_post if interference == 1
replace avg_RT_cor_by_int_post = avg_RT_Non_cor_post if interference == 2

//Have Post - PreStim acc, RT and correct RT variables by condition for: Int/NonInt x StimCond
gen ch_acc_by_int = ch_acc_Int if interference == 1
replace ch_acc_by_int = ch_acc_Non if interference == 2

gen ch_avg_RT_by_int = ch_avg_RT_Int if interference == 1
replace ch_avg_RT_by_int = ch_avg_RT_Non if interference == 2

gen ch_avg_RT_cor_by_int = ch_avg_RT_Int_cor if interference == 1
replace ch_avg_RT_cor_by_int = ch_avg_RT_Non_cor if interference == 2

move ch_acc_by_int stim_cond

//2-way Repeated Measures ANOVA PostStim: Int/NonInt(2) x StimCond(3)
foreach var of varlist *_int_post {
	di as result _newline "Repeated Measures Two-way ANOVA Post-Stim: StimCond x `var'" _continue
	anova `var' Subject stim_cond / Subject#stim_cond interference / Subject#interference stim_cond#interference, repeated(stim_cond)
}

//2-way Repeated Measures ANOVA Post - PreStim: NonInt(2) x StimCond(3)
foreach var of varlist ch_*_int {
	di as result _newline "Repeated Measures Two-way ANOVA Post - PreStim: StimCond x `var'" _continue
	anova `var' Subject stim_cond / Subject#stim_cond interference / Subject#interference stim_cond#interference, repeated(stim_cond)
}

//2-way Repeated measures ANOVA: Int/NonInt(2) x StimCond(3) for Negative only
//Have PostStim acc, RT and correct RT variables by condition for: Int/NonInt x StimCond for Negative only
gen acc_Neg_by_int_post = acc_Neg_Int_post if interference == 1
replace acc_Neg_by_int_post = acc_Neg_Non_post if interference == 2

gen avg_RT_Neg_by_int_post = avg_RT_Neg_Int_post if interference == 1
replace avg_RT_Neg_by_int_post = avg_RT_Neg_Non_post if interference == 2

gen avg_RT_cor_Neg_by_int_post = avg_RT_Neg_Int_cor_post if interference == 1
replace avg_RT_cor_Neg_by_int_post = avg_RT_Neg_Non_cor_post if interference == 2

//Have Post - PreStim acc, RT and correct RT variables by condition: Int/NonInt x StimCond for Negative only
gen ch_acc_Neg_by_int = ch_acc_Neg_Int if interference == 1
replace ch_acc_Neg_by_int = ch_acc_Neg_Non if interference == 2

gen ch_avg_RT_Neg_by_int = ch_avg_RT_Neg_Int if interference == 1
replace ch_avg_RT_Neg_by_int = ch_avg_RT_Neg_Non if interference == 2

gen ch_avg_RT_cor_Neg_by_int = ch_avg_RT_Neg_Int_cor if interference == 1
replace ch_avg_RT_cor_Neg_by_int = ch_avg_RT_Neg_Non_cor if interference == 2

//2-way Repeated measures ANOVA PostStim: Int/NonInt(2) x StimCond(3) for Negative only
foreach var of varlist *_Neg_by_int_post {
	di as result _newline "Repeated Measures Two-way ANOVA Post-Stim: StimCond x `var' for Negative only" _continue
	anova `var' Subject stim_cond / Subject#stim_cond interference / Subject#interference stim_cond#interference, repeated(stim_cond)
}

//2-way Repeated measures ANOVA Post - PreStim: Int/NonInt(2) x StimCond(3) for Negative only
foreach var of varlist ch_*_Neg_by_int {
	di as result _newline "Repeated Measures Two-way ANOVA Post- PreStim: StimCond x `var' for Negative only" _continue
	anova `var' Subject stim_cond / Subject#stim_cond interference / Subject#interference stim_cond#interference, repeated(stim_cond)
}

//2-way Repeated measures ANOVA: Int/NonInt(2) x StimCond(3) for Positive only
//Have PostStim acc, RT and correct RT variables by condition for: Int/NonInt x StimCond for Positive only
gen acc_Pos_by_int_post = acc_Pos_Int_post if interference == 1
replace acc_Pos_by_int_post = acc_Pos_Non_post if interference == 2

gen avg_RT_Pos_by_int_post = avg_RT_Pos_Int_post if interference == 1
replace avg_RT_Pos_by_int_post = avg_RT_Pos_Non_post if interference == 2

gen avg_RT_cor_Pos_by_int_post = avg_RT_Pos_Int_cor_post if interference == 1
replace avg_RT_cor_Pos_by_int_post = avg_RT_Pos_Non_cor_post if interference == 2

//Have Post - PreStim acc, RT and correct RT variables by condition: Int/NonInt x StimCond for Positive only
gen ch_acc_Pos_by_int = ch_acc_Pos_Int if interference == 1
replace ch_acc_Pos_by_int = ch_acc_Pos_Non if interference == 2

gen ch_avg_RT_Pos_by_int = ch_avg_RT_Pos_Int if interference == 1
replace ch_avg_RT_Pos_by_int = ch_avg_RT_Pos_Non if interference == 2

gen ch_avg_RT_cor_Pos_by_int = ch_avg_RT_Pos_Int_cor if interference == 1
replace ch_avg_RT_cor_Pos_by_int = ch_avg_RT_Pos_Non_cor if interference == 2

//2-way Repeated measures ANOVA PostStim: Int/NonInt(2) x StimCond(3) for Positive only
foreach var of varlist *_Pos_by_int_post {
	di as result _newline "Repeated Measures Two-way ANOVA Post-Stim: StimCond x `var' for Positive only" _continue
	anova `var' Subject stim_cond / Subject#stim_cond interference / Subject#interference stim_cond#interference, repeated(stim_cond)
}

//2-way Repeated measures ANOVA Post - PreStim: Int/NonInt(2) x StimCond(3) for Positive only
foreach var of varlist ch_*_Pos_by_int {
	di as result _newline "Repeated Measures Two-way ANOVA Post- PreStim: StimCond x `var' for Positive only" _continue
	anova `var' Subject stim_cond / Subject#stim_cond interference / Subject#interference stim_cond#interference, repeated(stim_cond)
}

//Restructure data for Emotion x Int/NonInt
bysort Subject: replace emotion = 1 if _n == 1 | _n == 2
bysort Subject: replace emotion = 2 if _n == 3 | _n == 4
bysort Subject: replace emotion = 3 if _n == 5 | _n ==  6 
bysort Subject: replace interference = 1 if _n == 1 | _n == 3 | _n == 5
bysort Subject: replace interference = 2 if _n == 2 | _n == 4 | _n ==  6 

//Have PostStim acc, RT and correct RT variables by condition for: Emotion x Int/NonInt (Sham only)
gen acc_sham_by_emoxint_post = sham_acc_Pos_Int_post if interference == 1 & emotion == 2
replace acc_sham_by_emoxint_post = sham_acc_Pos_Non_post if interference == 2 & emotion == 2
replace acc_sham_by_emoxint_post = sham_acc_Neg_Int_post if interference == 1 & emotion == 1
replace acc_sham_by_emoxint_post = sham_acc_Neg_Non_post if interference == 2 & emotion == 1
replace acc_sham_by_emoxint_post = sham_acc_Neu_Int_post if interference == 1 & emotion == 3
replace acc_sham_by_emoxint_post = sham_acc_Neu_Non_post if interference == 2 & emotion == 3

gen avg_RT_sham_by_emoxint_post = sham_avg_RT_Pos_Int_post if interference == 1 & emotion == 2
replace avg_RT_sham_by_emoxint_post = sham_avg_RT_Pos_Non_post if interference == 2 & emotion == 2
replace avg_RT_sham_by_emoxint_post = sham_avg_RT_Neg_Int_post if interference == 1 & emotion == 1
replace avg_RT_sham_by_emoxint_post = sham_avg_RT_Neg_Non_post if interference == 2 & emotion == 1
replace avg_RT_sham_by_emoxint_post = sham_avg_RT_Neu_Int_post if interference == 1 & emotion == 3
replace avg_RT_sham_by_emoxint_post = sham_avg_RT_Neu_Non_post if interference == 2 & emotion == 3

gen avg_RT_cor_sham_by_emoxint_post = sham_avg_RT_Pos_Int_cor_post if interference == 1 & emotion == 2
replace avg_RT_cor_sham_by_emoxint_post = sham_avg_RT_Pos_Non_cor_post if interference == 2 & emotion == 2
replace avg_RT_cor_sham_by_emoxint_post = sham_avg_RT_Neg_Int_cor_post if interference == 1 & emotion == 1
replace avg_RT_cor_sham_by_emoxint_post = sham_avg_RT_Neg_Non_cor_post if interference == 2 & emotion == 1
replace avg_RT_cor_sham_by_emoxint_post = sham_avg_RT_Neu_Int_cor_post if interference == 1 & emotion == 3
replace avg_RT_cor_sham_by_emoxint_post = sham_avg_RT_Neu_Non_cor_post if interference == 2 & emotion == 3

//Have Post - PreStim acc, RT and correct RT variables by condition: Emotion x Int/NonInt
gen ch_acc_sham_by_emoxint = ch_sham_acc_Pos_Int if interference == 1 & emotion == 2
replace ch_acc_sham_by_emoxint = ch_sham_acc_Pos_Non if interference == 2 & emotion == 2
replace ch_acc_sham_by_emoxint = ch_sham_acc_Neg_Int if interference == 1 & emotion == 1
replace ch_acc_sham_by_emoxint = ch_sham_acc_Neg_Non if interference == 2 & emotion == 1
replace ch_acc_sham_by_emoxint = ch_sham_acc_Neu_Int if interference == 1 & emotion == 3
replace ch_acc_sham_by_emoxint = ch_sham_acc_Neu_Non if interference == 2 & emotion == 3

gen ch_RT_sham_by_emoxint = ch_avg_RT_Pos_Int if interference == 1 & emotion == 2
replace ch_RT_sham_by_emoxint = ch_sham_avg_RT_Pos_Non if interference == 2 & emotion == 2
replace ch_RT_sham_by_emoxint = ch_sham_avg_RT_Neg_Int if interference == 1 & emotion == 1
replace ch_RT_sham_by_emoxint = ch_sham_avg_RT_Neg_Non if interference == 2 & emotion == 1
replace ch_RT_sham_by_emoxint = ch_sham_avg_RT_Neu_Int if interference == 1 & emotion == 3
replace ch_RT_sham_by_emoxint = ch_sham_avg_RT_Neu_Non if interference == 2 & emotion == 3

gen ch_RT_cor_sham_by_emoxint = ch_sham_avg_RT_Pos_Int_cor if interference == 1 & emotion == 2
replace ch_RT_cor_sham_by_emoxint = ch_sham_avg_RT_Pos_Non_cor if interference == 2 & emotion == 2
replace ch_RT_cor_sham_by_emoxint = ch_sham_avg_RT_Neg_Int_cor if interference == 1 & emotion == 1
replace ch_RT_cor_sham_by_emoxint = ch_sham_avg_RT_Neg_Non_cor if interference == 2 & emotion == 1
replace ch_RT_cor_sham_by_emoxint = ch_sham_avg_RT_Neu_Int_cor if interference == 1 & emotion == 3
replace ch_RT_cor_sham_by_emoxint = ch_sham_avg_RT_Neu_Non_cor if interference == 2 & emotion == 3

//2-way ANOVA PostStim: Emotion(3) x Int/NonInt(2) for Sham only
foreach var of varlist *_sham_by_emoxint_post {
	di as result _newline "Repeated Measures Two-way ANOVA Post-Stim: `var' for Sham only" _continue
	anova `var' Subject emotion / Subject#emotion interference / Subject#interference emotion#interference
}

//2-way Repeated Measures ANOVA Post - Pre Stim: Emotion(3) x Int/NonInt(2) for Sham only
foreach var of varlist ch_*_sham_by_emoxint {
	di as result _newline "Repeated Measures Two-way ANOVA Post- PreStim: `var' for Sham only" _continue
	anova `var' Subject emotion / Subject#emotion interference / Subject#interference emotion#interference
}

//2-way Repeated Measures ANOVA PostStim: Emotion(3) x Int/NonInt(2) for Active L only
//Have PostStim acc, RT and correct RT variables by condition for: Emotion x Int/NonInt (Active L only)
gen acc_actL_by_emoxint_post = actL_acc_Pos_Int_post if interference == 1 & emotion == 2
replace acc_actL_by_emoxint_post = actL_acc_Pos_Non_post if interference == 2 & emotion == 2
replace acc_actL_by_emoxint_post = actL_acc_Neg_Int_post if interference == 1 & emotion == 1
replace acc_actL_by_emoxint_post = actL_acc_Neg_Non_post if interference == 2 & emotion == 1
replace acc_actL_by_emoxint_post = actL_acc_Neu_Int_post if interference == 1 & emotion == 3
replace acc_actL_by_emoxint_post = actL_acc_Neg_Non_post if interference == 2 & emotion == 3

gen avg_RT_actL_by_emoxint_post = actL_avg_RT_Pos_Int_post if interference == 1 & emotion == 2
replace avg_RT_actL_by_emoxint_post = actL_avg_RT_Pos_Non_post if interference == 2 & emotion == 2
replace avg_RT_actL_by_emoxint_post = actL_avg_RT_Neg_Int_post if interference == 1 & emotion == 1
replace avg_RT_actL_by_emoxint_post = actL_avg_RT_Neg_Non_post if interference == 2 & emotion == 1
replace avg_RT_actL_by_emoxint_post = actL_avg_RT_Neu_Int_post if interference == 1 & emotion == 3
replace avg_RT_actL_by_emoxint_post = actL_avg_RT_Neu_Non_post if interference == 2 & emotion == 3

gen avg_RT_cor_actL_by_emoxint_post = actL_avg_RT_Pos_Int_cor_post if interference == 1 & emotion == 2
replace avg_RT_cor_actL_by_emoxint_post = actL_avg_RT_Pos_Non_cor_post if interference == 2 & emotion == 2
replace avg_RT_cor_actL_by_emoxint_post = actL_avg_RT_Neg_Int_cor_post if interference == 1 & emotion == 1
replace avg_RT_cor_actL_by_emoxint_post = actL_avg_RT_Neg_Non_cor_post if interference == 2 & emotion == 1
replace avg_RT_cor_actL_by_emoxint_post = actL_avg_RT_Neu_Int_cor_post if interference == 1 & emotion == 3
replace avg_RT_cor_actL_by_emoxint_post = actL_avg_RT_Neu_Non_cor_post if interference == 2 & emotion == 3

//Have Post - PreStim acc, RT and correct RT variables by condition: Emotion x Int/NonInt
gen ch_acc_actL_by_emoxint = ch_actL_acc_Pos_Int if interference == 1 & emotion == 2
replace ch_acc_actL_by_emoxint = ch_actL_acc_Pos_Non if interference == 2 & emotion == 2
replace ch_acc_actL_by_emoxint = ch_actL_acc_Neg_Int if interference == 1 & emotion == 1
replace ch_acc_actL_by_emoxint = ch_actL_acc_Neg_Non if interference == 2 & emotion == 1
replace ch_acc_actL_by_emoxint = ch_actL_acc_Neu_Int if interference == 1 & emotion == 3
replace ch_acc_actL_by_emoxint = ch_actL_acc_Neu_Non if interference == 2 & emotion == 3

gen ch_avg_RT_actL_by_emoxint = ch_actL_avg_RT_Pos_Int if interference == 1 & emotion == 2
replace ch_avg_RT_actL_by_emoxint = ch_actL_avg_RT_Pos_Non if interference == 2 & emotion == 2
replace ch_avg_RT_actL_by_emoxint = ch_actL_avg_RT_Neg_Int if interference == 1 & emotion == 1
replace ch_avg_RT_actL_by_emoxint = ch_actL_avg_RT_Neg_Non if interference == 2 & emotion == 1
replace ch_avg_RT_actL_by_emoxint = ch_actL_avg_RT_Neu_Int if interference == 1 & emotion == 3
replace ch_avg_RT_actL_by_emoxint = ch_actL_avg_RT_Neu_Non if interference == 2 & emotion == 3

gen ch_avg_RT_cor_actL_by_emoxint = ch_actL_avg_RT_Pos_Int_cor if interference == 1 & emotion == 2
replace ch_avg_RT_cor_actL_by_emoxint = ch_actL_avg_RT_Pos_Non_cor if interference == 2 & emotion == 2
replace ch_avg_RT_cor_actL_by_emoxint = ch_actL_avg_RT_Neg_Int_cor if interference == 1 & emotion == 1
replace ch_avg_RT_cor_actL_by_emoxint = ch_actL_avg_RT_Neg_Non_cor if interference == 2 & emotion == 1
replace ch_avg_RT_cor_actL_by_emoxint = ch_actL_avg_RT_Neu_Int_cor if interference == 1 & emotion == 3
replace ch_avg_RT_cor_actL_by_emoxint = ch_actL_avg_RT_Neu_Non_cor if interference == 2 & emotion == 3

//2-way ANOVA PostStim: Emotion(3) x Int/NonInt(2) for Active L only
foreach var of varlist *_actL_by_emoxint_post {
	di as result _newline "Repeated Measures Two-way ANOVA Post-Stim: `var' for Active L only" _continue
	anova `var' Subject emotion / Subject#emotion interference / Subject#interference emotion#interference
}

//2-way Repeated Measures ANOVA Post - Pre Stim: Emotion(3) x Int/NonInt(2) for Active L only
foreach var of varlist ch_*_actL_by_emoxint {
	di as result _newline "Repeated Measures Two-way ANOVA Post- PreStim: `var' for Active L only" _continue
	anova `var' Subject emotion / Subject#emotion interference / Subject#interference emotion#interference
}

//2-way Repeated Measures ANOVA PostStim: Emotion(3) x Int/NonInt(2) for Active R only
//Have PostStim acc, RT and correct RT variables by condition for: Emotion x Int/NonInt (Active R only)
gen acc_actR_by_emoxint_post = actR_acc_Pos_Int_post if interference == 1 & emotion == 2
replace acc_actR_by_emoxint_post = actR_acc_Pos_Non_post if interference == 2 & emotion == 2
replace acc_actR_by_emoxint_post = actR_acc_Neg_Int_post if interference == 1 & emotion == 1
replace acc_actR_by_emoxint_post = actR_acc_Neg_Non_post if interference == 2 & emotion == 1
replace acc_actR_by_emoxint_post = actR_acc_Neu_Int_post if interference == 1 & emotion == 3
replace acc_actR_by_emoxint_post = actR_acc_Neg_Non_post if interference == 2 & emotion == 3

gen avg_RT_actR_by_emoxint_post = actR_avg_RT_Pos_Int_post if interference == 1 & emotion == 2
replace avg_RT_actR_by_emoxint_post = actR_avg_RT_Pos_Non_post if interference == 2 & emotion == 2
replace avg_RT_actR_by_emoxint_post = actR_avg_RT_Neg_Int_post if interference == 1 & emotion == 1
replace avg_RT_actR_by_emoxint_post = actR_avg_RT_Neg_Non_post if interference == 2 & emotion == 1
replace avg_RT_actR_by_emoxint_post = actR_avg_RT_Neu_Int_post if interference == 1 & emotion == 3
replace avg_RT_actR_by_emoxint_post = actR_avg_RT_Neu_Non_post if interference == 2 & emotion == 3

gen avg_RT_cor_actR_by_emoxint_post = actR_avg_RT_Pos_Int_cor_post if interference == 1 & emotion == 2
replace avg_RT_cor_actR_by_emoxint_post = actR_avg_RT_Pos_Non_cor_post if interference == 2 & emotion == 2
replace avg_RT_cor_actR_by_emoxint_post = actR_avg_RT_Neg_Int_cor_post if interference == 1 & emotion == 1
replace avg_RT_cor_actR_by_emoxint_post = actR_avg_RT_Neg_Non_cor_post if interference == 2 & emotion == 1
replace avg_RT_cor_actR_by_emoxint_post = actR_avg_RT_Neu_Int_cor_post if interference == 1 & emotion == 3
replace avg_RT_cor_actR_by_emoxint_post = actR_avg_RT_Neu_Non_cor_post if interference == 2 & emotion == 3

//Have Post - PreStim acc, RT and correct RT variables by condition: Emotion x Int/NonInt
gen ch_acc_actR_by_emoxint = ch_actR_acc_Pos_Int if interference == 1 & emotion == 2
replace ch_acc_actR_by_emoxint = ch_actR_acc_Pos_Non if interference == 2 & emotion == 2
replace ch_acc_actR_by_emoxint = ch_actR_acc_Neg_Int if interference == 1 & emotion == 1
replace ch_acc_actR_by_emoxint = ch_actR_acc_Neg_Non if interference == 2 & emotion == 1
replace ch_acc_actR_by_emoxint = ch_actR_acc_Neu_Int if interference == 1 & emotion == 3
replace ch_acc_actR_by_emoxint = ch_actR_acc_Neu_Non if interference == 2 & emotion == 3

gen ch_avg_RT_actR_by_emoxint = ch_actR_avg_RT_Pos_Int if interference == 1 & emotion == 2
replace ch_avg_RT_actR_by_emoxint = ch_actR_avg_RT_Pos_Non if interference == 2 & emotion == 2
replace ch_avg_RT_actR_by_emoxint = ch_actR_avg_RT_Neg_Int if interference == 1 & emotion == 1
replace ch_avg_RT_actR_by_emoxint = ch_actR_avg_RT_Neg_Non if interference == 2 & emotion == 1
replace ch_avg_RT_actR_by_emoxint = ch_actR_avg_RT_Neu_Int if interference == 1 & emotion == 3
replace ch_avg_RT_actR_by_emoxint = ch_actR_avg_RT_Neu_Non if interference == 2 & emotion == 3

gen ch_avg_RT_cor_actR_by_emoxint = ch_actR_avg_RT_Pos_Int_cor if interference == 1 & emotion == 2
replace ch_avg_RT_cor_actR_by_emoxint = ch_actR_avg_RT_Pos_Non_cor if interference == 2 & emotion == 2
replace ch_avg_RT_cor_actR_by_emoxint = ch_actR_avg_RT_Neg_Int_cor if interference == 1 & emotion == 1
replace ch_avg_RT_cor_actR_by_emoxint = ch_actR_avg_RT_Neg_Non_cor if interference == 2 & emotion == 1
replace ch_avg_RT_cor_actR_by_emoxint = ch_actR_avg_RT_Neu_Int_cor if interference == 1 & emotion == 3
replace ch_avg_RT_cor_actR_by_emoxint = ch_actR_avg_RT_Neu_Non_cor if interference == 2 & emotion == 3

//2-way ANOVA PostStim: Emotion(3) x Int/NonInt(2) for Active R only
foreach var of varlist *_actR_by_emoxint_post {
	di as result _newline "Repeated Measures Two-way ANOVA Post-Stim: `var' for Active R only" _continue
	anova `var' Subject emotion / Subject#emotion interference / Subject#interference emotion#interference
}

//2-way Repeated Measures ANOVA Post - Pre Stim: Emotion(3) x Int/NonInt(2) for Active R only
foreach var of varlist ch_*_actR_by_emoxint {
	di as result _newline "Repeated Measures Two-way ANOVA Post- PreStim: `var' for Active R only" _continue
	anova `var' Subject emotion / Subject#emotion interference / Subject#interference emotion#interference
}

//Save as new dataset
save tDCS_HC_MSIT_IAPS_2WayANOVA_Full_CLEANED, replace

log close
