clear all
capture log close
set more off

/*
//Create a 'blank' .txt file first that has variables but no data
import delimited "C:\Users\Neuromod\Cerebellar_Study\cerebTMS study files (yroh@mclean.harvard.edu )\Subject Data\N-back logfiles\Cerebellar_Merged.csv"

//Get list of all Subject directories 
local dir_list: dir "C:\Users\Neuromod\Cerebellar_Study\cerebTMS study files (yroh@mclean.harvard.edu )\Subject Data\N-back logfiles" dirs "*"

//For each subject directory: convert the .txt file into stata .dta file
foreach dir in `dir_list' {
	//Get full filepath of the subject directory
	local subject_folder = "C:\Users\Neuromod\Cerebellar_Study\cerebTMS study files (yroh@mclean.harvard.edu )\Subject Data\N-back logfiles\" + "`dir'"
	//Get all files within each subject directory
	local subject_folder_data: dir "`subject_folder'" files "*real*.txt"
	cd "`subject_folder'"
	//For each file in subject directory:
	foreach file in `subject_folder_data' {
		//Convert delimited .txt file into stata .dta file
		import delimited using "`file'", clear
		local filename = subjectid1[1]
		save `filename', replace
	}
}

foreach dir in `dir_list' {
	local subject_folder = "C:\Users\Neuromod\Cerebellar_Study\cerebTMS study files (yroh@mclean.harvard.edu )\Subject Data\N-back logfiles\" + "`dir'"
	local subject_folder_data: dir "`subject_folder'" files "*.dta"
	cd "`subject_folder'"
	foreach file in `subject_folder_data' {	
		append using "`file'" 
	}
}

cd "C:\Users\Neuromod\Cerebellar_Study\cerebTMS study files (yroh@mclean.harvard.edu )\Subject Data\N-back logfiles\"
save Cerebellar_Merged, replace
*/

use "C:\Users\Neuromod\Cerebellar_Study\cerebTMS study files (yroh@mclean.harvard.edu )\Subject Data\N-back logfiles\Cerebellar_Merged.dta"

/*
// For future datsets: Get rid of all the avg statements
drop if strpos(subjectid1, "avg")!=0
*/

gen subjectid = substr(subjectid1,1,5)
replace subjectid = "1" if subjectid == "JJNAM"
replace subjectid = "2" if subjectid == "6Q4CM"

gen pre_post_stim = "1" if strpos(subjectid1, "pre") > 0
replace pre_post_stim = "2" if strpos(subjectid1, "post") > 0

gen session = substr(subjectid1,-1,1)

gen subject_session = subjectid + "_" + session + "_" + pre_post_stim
order subjectid session pre_post_stim subject_session

gen stim_cond = 0
label define stim_conds 0 "Unknown/Not completed" 1 "Sham" 2 "Inhibitory (T)" 3 "Excitatory (I)"
label values stim_cond stim_conds
replace stim_cond = 1 if regexm(subject_session, "(^1_1|^2_3)")
replace stim_cond = 2 if regexm(subject_session, "(^1_2|^2_1)")
replace stim_cond = 3 if regexm(subject_session, "(^1_3|^2_2)") 

gen completed = 0
label variable completed "Did subject complete all 3 tDCS study visits"
label values completed yesno
replace completed = 1 if regexm(subject_session, "(^1_|^2_)")
drop if completed == 0 

replace time_diff = . if time_diff < 0

gen acc2 = "1" if accuracy == "correct"
replace acc2 = "0" if accuracy == "false_alarm" || accuracy == "miss"
encode acc2, generate(acc)
drop acc2

//Find avg RT for 1 back and 2 back for all trials
egen avg_RT_12back_all = mean(time_diff), by(subject_session)
egen avg_RT_1back_all = mean(time_diff) if nback1 == 1, by(subject_session)
egen avg_RT_2back_all = mean(time_diff) if nback1 == 2, by(subject_session)

//Find avg RT for 1 back and 2 back for correct response trials 
gen RT_12back_correct = time_diff if acc == 1  
egen avg_RT_12back_correct = mean(RT_12back_correct), by(subject_session) 

gen RT_1back_correct = time_diff if acc == 1 & nback1 == 1
egen avg_RT_1back_correct = mean(RT_1back_correct), by(subject_session) 

gen RT_2back_correct = time_diff if acc == 1 & nback1 == 2
egen avg_RT_2back_correct = mean(RT_2back_correct), by(subject_session) 

//Find decimal ACC for 1 back and 2 back for all trials 
egen acc_12back_all = total(acc), by(subject_session)
egen num_12back_all = count(acc), by(subject_session)
replace acc_12back_all = acc_12back_all/num_12back_all

egen acc_1back_all = total(acc) if nback1 == 1, by(subject_session)
egen num_1back_all = count(acc) if nback1 == 1, by(subject_session)
replace acc_1back_all = acc_1back_all/num_1back_all

egen acc_2back_all = total(acc) if nback1 == 2, by(subject_session)
egen num_2back_all = count(acc) if nback1 == 2, by(subject_session)
replace acc_2back_all = acc_2back_all/num_2back_all

//Fill in missing indiv trial values
foreach var of varlist acc_2back_all avg_RT_2back_correct avg_RT_2back_all { 
	gsort subject_session `var'
	by subject_session: replace `var' = `var'[1]
}

//Take out subjects with below X accuracy?

//Find avg RT and acc variables for Sham, Active L and Active R conditions: trials w/ pos/neg/neu pics and int/nonint
foreach var of varlist acc_* avg_RT_* {
	gen sham_`var' = `var' if stim_cond == 1 
	gen actL_`var' = `var' if stim_cond == 2
	gen actR_`var' = `var' if stim_cond == 3
}

//Now that we have all the averages that we want, we can arbitrarily remove the excess rows/individual trial data and individual trial variables so we only have 1 row/1 observation per Subject's Session
bysort subject_session: drop if _n != 1  
drop completed is_target1 letter1 code2 trial1 nback1 subject session RT_* num_* acc accuracy time_diff  
