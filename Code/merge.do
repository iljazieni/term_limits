use "${root}/elections_clean.dta", clear
sort state year month
merge m:1 state using "${root}/term_limits_clean.dta"

// Generate measure for how many times candidates have been elected to office - for now this creates 2 separate variables - we might want to reconsider later depending on how term limits across the house and senate interact
foreach b in "house" "senate" {

bys state legbranch candidate_id: gen times_elected_`b'=sum(winner) if year>=yearenacted & year<=yearofimpact`b' & yearenacted!=.
gen term_limited_`b'=1 if times_elected_`b'==limitterms`b' // Construct a variable that captures whether a candidate is term limited
foreach v in "times_elected_`b'" "term_limited_`b'" {
replace `v'=0 if `v'==.
                                                    }
gen break_limit_`b'=1 if times_elected_`b' > limitterms`b'          // sanity check: make sure that candidates have not *actually* run more times than limits allow
replace break_limit_`b'=0 if break_limit_`b'==.

                              }

cap save "${root}/master_dataset.dta", replace
