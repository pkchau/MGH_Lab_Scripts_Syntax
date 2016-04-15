clear all
capture log close
set more off

//import delimited using "C:\Users\Neuromod\Cerebellar_Study\cerebTMS study files (yroh@mclean.harvard.edu )\Subject Data\N-back logfiles\6Q4CM\6Q4CM-post-01-tDCS_nback_real.txt"

local dir_list: dir "C:\Users\Neuromod\Cerebellar_Study\cerebTMS study files (yroh@mclean.harvard.edu )\Subject Data\N-back logfiles" dirs "*"

display `dir_list'

foreach dir in `dir_list' {
	local subject_folder = "C:\Users\Neuromod\Desktop\Cerebellar_Behavioral_Data\" + "`dir'"
	local subject_folder_data: dir "`subject_folder'" files "*real*.txt"
	cd `subject_folder'
	foreach file in `subject_folder_data' {
		import delimited using "`file'", clear
		local filename = subjectid1[1]
		save `filename', replace
		//stuck on merge step currently
		merge 1:1 subjectid1 using `filename'
	}
}

//MSIT
gen acc = 0
replace acc = 1 if rm_type == "rm_hit"
egen acc_all = total(acc) 
egen num_all = count(acc)
replace acc_all = acc_all/num_all

egen acc_level1 = total(acc) if level1 == 1
egen acc_level2 = total(acc) if level1 == 2
egen acc_level3 = total(acc) if level1 == 3
egen acc_level4 = total(acc) if level1 == 4
egen acc_level5 = total(acc) if level1 == 5
egen acc_level6 = total(acc) if level1 == 6
egen num_level1 = sum(level1 == 1)
egen num_level2 = sum(level1 == 2)
egen num_level3 = sum(level1 == 3)
egen num_level4 = sum(level1 == 4)
egen num_level5 = sum(level1 == 5)
egen num_level6 = sum(level1 == 6)

replace acc_level1 = acc_level1/num_level1
replace acc_level2 = acc_level2/num_level2
replace acc_level3 = acc_level3/num_level3
replace acc_level4 = acc_level4/num_level4
replace acc_level5 = acc_level5/num_level5
replace acc_level6 = acc_level6/num_level6

/*
//nback
gen acc = 0
replace acc = 1 if accuracy == "correct"

egen acc_12back = total(acc) 
egen num_12back = count(acc)
replace acc_12back = acc_12back/num_12back

egen acc_1back = total(acc) if nback == 1
egen acc_2back = total(acc) if nback == 2
egen num_1back = sum(nback1 == 1)
egen num_2back = sum(nback1 == 2)
replace acc_1back = acc_1back/num_1back
replace acc_2back = acc_2back/num_2back

egen avg_RT_12back = mean(time_diff) if time_diff > 0
egen avg_RT_1back = mean(time_diff) if time_diff > 0 & nback == 1
egen avg_RT_2back = mean(time_diff) if time_diff > 0 & nback == 2
*/
