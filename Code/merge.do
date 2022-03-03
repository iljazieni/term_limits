clear all

local merge           1

if `merge'==1 {

use "${root}/elections_clean.dta", clear
sort state year month
merge m:1 state using "${root}/term_limits_clean.dta"

// CONCATENATE STATE-LEGBRANCH-DISTRICT
egen unique_id=concat(state legbranch district)
destring unique_id, replace

cap save "${root}/master_dataset.dta", replace
}
