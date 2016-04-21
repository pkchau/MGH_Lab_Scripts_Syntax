clear all
capture log close
set more off

//Create a 'blank' .txt file first that has variables but no data
import delimited "C:\Users\Neuromod\Cerebellar_Study\cerebTMS study files (yroh@mclean.harvard.edu )\Subject Data\N-back logfiles\Cerebellar_Merged.csv"

//Get list of all Subject directories 
local dir_list: dir "C:\Users\Neuromod\Cerebellar_Study\cerebTMS study files (yroh@mclean.harvard.edu )\Subject Data\N-back logfiles" dirs "*"

//For each subject directory:
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
