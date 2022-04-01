clear all

local algo            0
local append          0
local clean_up        0
local single          1
local multi           1
local names1          1
local names2          1
local names3          1

if `algo'==1 {

clear all
use "${root}/master_dataset.dta", clear

// ARIZONA

// AZ HOUSE
keep if state_abrv=="AZ" & legbranch==1

egen new_district=group(distr_id)

levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1   // | incumbent==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
  sort year cand_surname // order alphabetically
  bys year: gen seat=_n
  sort seat year
  replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
// gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_az_1_`k'.dta", replace

sleep 50
restore

}


// AZ SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="AZ" & legbranch==0

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1   // | incumbent==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
  sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
// gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_az_0_`k'.dta", replace

sleep 50
restore

}

// SOUTH DAKOTA
clear all
use "${root}/master_dataset.dta", clear

//SD HOUSE
keep if state_abrv=="SD" & legbranch==1

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_sd_1_`k'.dta", replace
sleep 50
restore

}

// SD SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="SD" & legbranch==0

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_sd_0_`k'.dta", replace
sleep 50
restore

}

// FLORIDA

// FL HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="FL" & legbranch==1 // split House and Senate bc terms limited are different

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
  sort seat year
  replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_fl_1_`k'.dta", replace
sleep 50
restore

}

// FL SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="FL" & legbranch==0  // split House and Senate bc terms limited are different

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==2
  replace term_limited=2 if terms_won>2 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_fl_0_`k'.dta", replace
sleep 50
restore
}

// OHIO

// OH HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="OH" & legbranch==1 // split House and Senate bc terms limited are different

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_oh_1_`k'.dta", replace
sleep 50
restore

}

// OH SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="OH" & legbranch==0  // split House and Senate bc terms limited are different

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==2
  replace term_limited=2 if terms_won>2 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_oh_0_`k'.dta", replace
sleep 50
restore
}

// MONTANA
// MT HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="MT" & legbranch==1 // split House and Senate bc terms limited are different

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_mt_1_`k'.dta", replace
sleep 50
restore

}

// MT SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="MT" & legbranch==0  // split House and Senate bc terms limited are different

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==2
  replace term_limited=2 if terms_won>2 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_mt_0_`k'.dta", replace
sleep 50
restore
}

// COLORADO

// CO HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="CO" & legbranch==1 // split House and Senate bc terms limited are different

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1990

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_co_1_`k'.dta", replace
sleep 50
restore

}

// CO SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="CO" & legbranch==0  // split House and Senate bc terms limited are different

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1990

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==2
  replace term_limited=2 if terms_won>2 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_co_0_`k'.dta", replace
sleep 50
restore
}

// LOUISIANA - same for both branches - 3 terms of 4 years each | enacted 1995
// LA HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="LA" & legbranch==1

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1 // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1995

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==3
  replace term_limited=2 if terms_won>3 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_la_1_`k'.dta", replace
 sleep 50
restore
}

// LA SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="LA" & legbranch==0

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1 // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1995

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==3
  replace term_limited=2 if terms_won>3 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_la_0_`k'.dta", replace
 sleep 50
restore
}


// MAINE - 4 terms max of 2 years each - enacted 1993 - impact 1996 (retroactive)
// MAINE HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="ME" & legbranch==1

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1988

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_me_1_`k'.dta", replace
sleep 50
restore
}

// MAINE SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="ME" & legbranch==0

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1988

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_me_0_`k'.dta", replace
sleep 50
restore
}

// NEBRASKA UNICAMERAL
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="NE"

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1998

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==2
  replace term_limited=2 if terms_won>2 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_ne_`k'.dta", replace
sleep 50
restore

}

// ARKANSAS - different across branches
clear all
use "${root}/master_dataset.dta", clear

// AR House
keep if state_abrv=="AR" & legbranch==1

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1 // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==3
  replace term_limited=2 if terms_won>3 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_ar_1_`k'.dta", replace
sleep 50
restore
}

// AR Senate
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="AR" & legbranch==0

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_ar_0_`k'.dta", replace
sleep 50
restore
}

// CALIFORNIA - different across branches

// CA HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="CA" & legbranch==1

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1990

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==3
  replace term_limited=2 if terms_won>3 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_ca_1_`k'.dta", replace
sleep 50
restore
}


// CA SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="CA" & legbranch==0

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1 // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k'  & year>=1990

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==2
  replace term_limited=2 if terms_won>2 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_ca_0_`k'.dta", replace
sleep 50
restore
}


// MICHIGAN - different across branches
clear all
use "${root}/master_dataset.dta", clear

// MI HOUSE
keep if state_abrv=="MI" & legbranch==1

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==3
  replace term_limited=2 if terms_won>3 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_mi_1_`k'.dta", replace
sleep 50
restore
}


// MI SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="MI" & legbranch==0

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1994

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==2
  replace term_limited=2 if terms_won>2 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_mi_0_`k'.dta", replace
sleep 50
restore
}


// MISSOURI
clear all
use "${root}/master_dataset.dta", clear

// MO HOUSE
keep if state_abrv=="MO" & legbranch==1

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1994

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==4
  replace term_limited=2 if terms_won>4 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_mo_1_`k'.dta", replace
sleep 50
restore
}

// MO SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="MO" & legbranch==0

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1994

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==2
  replace term_limited=2 if terms_won>2 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_mo_0_`k'.dta", replace
sleep 50
restore
}
// NEVADA

// NV HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="NV" & legbranch==1

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1998

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==6
  replace term_limited=2 if terms_won>6 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_nv_1_`k'.dta", replace
sleep 50
restore
}

// NV SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="NV" & legbranch==0

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k'  & year>=1998

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==3
  replace term_limited=2 if terms_won>3 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
    sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
  replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_nv_0_`k'.dta", replace
sleep 50
restore
}

// OKLAHOMA - Lifeterm limit split across House and Senate

// OK HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="OK" & legbranch==1

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k' & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==6
  replace term_limited=2 if terms_won>6 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
  sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_ok_1_`k'.dta", replace
sleep 50
restore
}


// OK SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="OK" & legbranch==0

cap egen new_district=group(distr_id)
levelsof new_district, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if new_district==`k'  & year>=1992

  cap assert _N == 0
  if _rc == 0 {
      set obs 1
      gen data="empty"
  }

  bys candidate_id: egen terms_won=total(winner)
  egen max_year = max(year), by(candidate_id)
  by candidate_id: replace terms_won=. if year!=max_year
  sort candidate_id year
  replace term_limited=1 if terms_won==3
  replace term_limited=2 if terms_won>3 & terms_won!=.
  replace term_limited=0 if term_limited==.
  cap drop seat
  sort year cand_surname // order alphabetically
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]!=0 & _n!=1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/test_ok_0_`k'.dta", replace
sleep 50
restore

}

// ISSUE IS THAT THEY'RE TERM LIMITED IN MULTIPLE WAYS - COULD BE BC OF JUST HOUSE, JUST SENATE, OR BOTH
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="OK" & year>=1992

  gen term_limited=.
  gen limited_seat=.
  keep if winner==1  // | incumbent==1==1

  egen terms_won=total(winner), by(candidate_id legbranch)
  egen max_year = max(year), by(candidate_id)

  sort candidate_id year
  gen house1=1 if terms_won==2 & legbranch==1
  gen house2=1 if terms_won==4 & legbranch==1

  gen sen1=1 if terms_won==2 & legbranch==0
  gen sen2=1 if terms_won==1 & legbranch==0

  replace term_limited=1 if house1==1 & sen1==2 & year==max_year
  replace term_limited=1 if house2==4 & sen2==1 & year==max_year
  replace term_limited=0 if term_limited==.

  sort year cand_surname // order alphabetically
  replace limited_seat=1 if term_limited==0 & term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.
//gen same_lastname=1 if cand_surname==cand_surname[_n-1] & candidate_fullname!=candidate_fullname[_n-1]
  save "${root}/test/oklahoma.dta", replace
*/
}


if `append' == 1 {

    cd "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\DS0001\test"
    clear
    append using `: dir . files "*.dta"'
    cap drop data house1 house2 sen1 sen2
    drop if new_district==.
    save "${root}/term_limited_elections.dta", replace
}


if `clean_up'==1 {

cd "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\DS0001\test"

local datafiles: dir "`workdir'" files "*.dta"

foreach datafile of local datafiles {
        rm `: dir . files "*.dta"'
}

}


if `single'==1 {

clear all

use "${root}/master_dataset.dta", clear

keep if dis_type=="single"

/*VERSION 1 - WRONG
sort counter winner

// gen a var for lastname
bys counter: gen winrv1=candidate_fullname if winner==1 & _n==_N & unique_id==unique_id[_n-1]
gen prev_winnerv1=winrv1[_n-1] if unique_id==unique_id[_n-1]
bys counter: replace prev_winnerv1=prev_winnerv1[1] if unique_id==unique_id[_n-1]

// gen a var for firstname
bys counter: gen prev_sv1=cand_surname if winner==1 & _n==_N & unique_id==unique_id[_n-1]
gen prev_sur_winnerv1=prev_sv1[_n-1] if unique_id==unique_id[_n-1]
bys counter: replace prev_sur_winnerv1=prev_sur_winnerv1[1] if unique_id==unique_id[_n-1]

gen same_lastnamev1=1 if cand_surname==prev_sur_winnerv1 & candidate_fullname!=prev_winnerv1
replace same_lastnamev1=0 if same_lastnamev1==.
*/

sort counter winner
// gen a var for lastname
gen winr=candidate_fullname if winner==1 & unique_id==unique_id[_n-1]
gen prev_winner=winr[_n-1] if unique_id==unique_id[_n-1]
bys counter: replace prev_winner=prev_winner[1] if unique_id==unique_id[_n-1]

// gen a var for firstname
gen prev_s=cand_surname if winner==1 & unique_id==unique_id[_n-1]
gen prev_sur_winner=prev_s[_n-1] if unique_id==unique_id[_n-1]
bys counter: replace prev_sur_winner=prev_sur_winner[1] if unique_id==unique_id[_n-1]

gen same_lastname=1 if cand_surname==prev_sur_winner & candidate_fullname!=prev_winner
replace same_lastname=0 if same_lastname==.


cap save "${root}/single1.dta", replace

}


if `multi'==1 {

clear all

use "${root}/master_dataset.dta", clear

keep if dis_type=="multim"

sort counter

forval i=1/15 {

gen same`i'=1 if cand_surname==cand_surname[_n-`i'] & candidate_fullname!=candidate_fullname[_n-`i'] & election_id!=election_id[_n-`i'] & unique_id==unique_id[_n-`i']  & winner[_n-`i']==1  & counter[_n-`i']==counter-1

}

egen sum_same=rowtotal(same*)

gen same_lastname=1 if sum_same!=0
replace same_lastname=0 if same_lastname==.

cap save "${root}/multi1.dta", replace

}


if `names1'==1 {
clear all

use "${root}/single1.dta", clear
append using "${root}/multi1.dta"
cap save "${root}/names1.dta", replace

}


if `names2'==1 {

// single

clear all

use "${root}/master_dataset.dta", clear

keep if dis_type=="single"

gen trunc_surname=substr(cand_surname, 1,4)

sort counter winner
// gen a var for lastname
gen winer=candidate_fullname if winner==1 & unique_id==unique_id[_n-1]
gen prev_winer=winer[_n-1] if unique_id==unique_id[_n-1]
bys counter: replace prev_winer=prev_winer[1] if unique_id==unique_id[_n-1]

// gen a var for firstname
gen prev_su=trunc_surname if winner==1 & unique_id==unique_id[_n-1]
gen prev_sur_winer=prev_su[_n-1] if unique_id==unique_id[_n-1]
bys counter: replace prev_sur_winer=prev_sur_winer[1] if unique_id==unique_id[_n-1]

gen same_truncname=1 if trunc_surname==prev_sur_winer & candidate_fullname!=prev_winer
replace same_truncname=0 if same_truncname==.


cap save "${root}/single2.dta", replace

clear all

use "${root}/master_dataset.dta", clear

keep if dis_type=="multim"

gen trunc_surname=substr(cand_surname, 1,4)

sort counter

forval i=1/15 {

gen same_`i'=1 if trunc_surname==trunc_surname[_n-`i'] & candidate_fullname!=candidate_fullname[_n-`i'] & election_id!=election_id[_n-`i'] & unique_id==unique_id[_n-`i']  & winner[_n-`i']==1 & counter[_n-`i']==counter-1

}

egen sumsame=rowtotal(same*)

gen same_truncname=1 if sumsame!=0
replace same_truncname=0 if same_truncname==.

cap save "${root}/multi2.dta", replace

clear all

use "${root}/single2.dta", clear
append using "${root}/multi2.dta"
cap save "${root}/names2.dta", replace

}


if `names3'==1 {

// single

clear all

use "${root}/master_dataset.dta", clear

keep if dis_type=="single"

gen initial=substr(cand_surname, 1,1)
gen middle_name=substr(V46, 1,1)

sort counter winner
// gen a var for fullname
gen wnr=candidate_fullname if winner==1 & unique_id==unique_id[_n-1]
gen prev_wnr=wnr[_n-1] if unique_id==unique_id[_n-1]
bys counter: replace prev_wnr=prev_wnr[1] if unique_id==unique_id[_n-1]

// gen a var for lastname
gen prev_srn=initial if winner==1 & unique_id==unique_id[_n-1]
gen prev_sur_wnr=prev_srn[_n-1] if unique_id==unique_id[_n-1]
bys counter: replace prev_sur_wnr=prev_sur_wnr[1] if unique_id==unique_id[_n-1]

gen same_initial=1 if middle_name==prev_sur_wnr & candidate_fullname!=prev_wnr & prev_wnr!=""
replace same_initial=0 if same_initial==.


cap save "${root}/single3.dta", replace

clear all

use "${root}/master_dataset.dta", clear

keep if dis_type=="multim"

gen initial=substr(cand_surname, 1,1)
gen middle_name=substr(V46, 1,1)

sort counter

forval i=1/15 {

gen same_`i'=1 if middle_name==initial[_n-`i'] & candidate_fullname!=candidate_fullname[_n-`i'] & election_id!=election_id[_n-`i'] & unique_id==unique_id[_n-`i']  & winner[_n-`i']==1  & counter[_n-`i']==counter-1

}

egen sumsame=rowtotal(same*)

gen same_initial=1 if sumsame!=0
replace same_initial=0 if same_initial==.

cap save "${root}/multi3.dta", replace

clear all

use "${root}/single2.dta", clear
append using "${root}/multi3.dta"
cap save "${root}/names3.dta", replace



}
