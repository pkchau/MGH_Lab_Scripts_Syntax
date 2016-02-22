clear all
capture log close
set more off

import delimited using "C:\Users\Neuromod\Desktop\Cerebellar_Behavioral_Data\JJNAM-pre-1-tDCS_nback_real.txt", clear

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
