clear all

local merge           1

if `merge'==1 {

use "${root}/elections_clean.dta", clear
sort state year month
merge m:1 state using "${root}/term_limits_clean.dta"

// CONCATENATE STATE-LEGBRANCH-DISTRICT
egen unique_id=concat(state_abrv legbranch distr_id)
drop if sitting_legislator==0

sort unique_id year
egen unq_id_ele=concat(unique_id election_id)
bys unq_id_ele: gen counter=_n if _n==1
replace counter=sum(counter)

cap save "${root}/master_dataset.dta", replace
}
