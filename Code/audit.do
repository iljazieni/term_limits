clear all

local algo            0
local append          1
local clean_up        0

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
  bys year: gen seat=_n
  sort seat year
  replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_az_1_`k'.dta", replace

sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_az_0_`k'.dta", replace

sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_sd_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_sd_0_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_fl_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_fl_0_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_oh_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_oh_0_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_mt_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_mt_0_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_co_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_co_0_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_la_1_`k'.dta", replace
 sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_la_0_`k'.dta", replace
 sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_me_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_me_0_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_ne_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_ar_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_ar_0_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_ca_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_ca_0_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_mi_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_mi_0_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_mo_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_mo_0_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_nv_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
  replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_nv_0_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_ok_1_`k'.dta", replace
sleep 100
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
  bys year: gen seat=_n
   sort seat year
    replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/test_ok_0_`k'.dta", replace
sleep 100
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

  sort year
  gen counter=_n
  replace limited_seat=1 if term_limited==0 & term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test2/oklahoma.dta", replace

}

// APPEND EVERYTHING ALL AT ONCE

if `append' == 1 {

    cd "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\DS0001\test2"
    clear
    append using `: dir . files "*.dta"'
    cap drop data house1 house2 sen1 sen2
    duplicates drop state legbranch new_district year candidate_fullname candidate_id, force
    save "${root}/term_limited_elections_audit.dta", replace
}


if `clean_up'==1 {

cd "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\DS0001\test2"

local datafiles: dir "`workdir'" files "*.dta"

foreach datafile of local datafiles {
        rm `datafile'
}

}
