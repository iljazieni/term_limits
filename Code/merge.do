clear all

local merge           0
local algo            1
local append          1
local clean_up        1

if `merge'==1 {

use "${root}/elections_clean.dta", clear
sort state year month
merge m:1 state using "${root}/term_limits_clean.dta"

// CONCATENATE STATE-LEGBRANCH-DISTRICT
egen unique_id=concat(state legbranch district)
destring unique_id, replace

cap save "${root}/master_dataset.dta", replace
}


if `algo'==1 {

clear all
use "${root}/master_dataset.dta", clear

// GROUP 1 - AZ, SD |  No lifeterm limits | Term length = 2 yrs | Term limit = 4 terms | Enacted 1992 | Impact 2000

keep if state_abrv=="AZ"

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1   // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore

}

// SOUTH DAKOTA

clear all
use "${root}/master_dataset.dta", clear

// GROUP 1 - AZ, SD |  No lifeterm limits | Term length = 2 yrs | Term limit = 4 terms | Enacted 1992 | Impact 2000

keep if state_abrv=="SD"

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore

}

// FLORIDA

// FL HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="FL" & legbranch==1 // split House and Senate bc terms limited are different

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore

}

// FL SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="FL" & legbranch==0  // split House and Senate bc terms limited are different

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}

// OHIO

// OH HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="OH" & legbranch==1 // split House and Senate bc terms limited are different

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore

}

// OH SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="OH" & legbranch==0  // split House and Senate bc terms limited are different

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}



// MONTANA
// MT HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="MT" & legbranch==1 // split House and Senate bc terms limited are different

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore

}

// MT SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="MT" & legbranch==0  // split House and Senate bc terms limited are different

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}

// COLORADO

// CO HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="CO" & legbranch==1 // split House and Senate bc terms limited are different

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1990

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore

}

// CO SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="CO" & legbranch==0  // split House and Senate bc terms limited are different

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1990

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}

// LOUISIANA - same for both branches - 3 terms of 4 years each | enacted 1995
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="LA"

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1 // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1995

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}

// MAINE - 4 terms max of 2 years each - enacted 1993 - impact 1996 (retroactive)
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="ME"

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1988

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}


// NEBRASKA UNICAMERAL
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="NE"

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1998

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore

}

// ARKANSAS - different across branches
clear all
use "${root}/master_dataset.dta", clear

// AR House
keep if state_abrv=="AR" & legbranch==1

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1 // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}

// AR Senate
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="AR" & legbranch==0

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}

// CALIFORNIA - different across branches

// CA HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="CA" & legbranch==1

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1990

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}


// CA SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="CA" & legbranch==0

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1 // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k'  & year>=1990

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}

*/
// MICHIGAN - different across branches
clear all
use "${root}/master_dataset.dta", clear

// MI HOUSE
keep if state_abrv=="MI" & legbranch==1

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}


// MI SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="MI" & legbranch==0

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1994

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}


// MISSOURI
clear all
use "${root}/master_dataset.dta", clear

// MO HOUSE
keep if state_abrv=="MO" & legbranch==1

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1994

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}

// MO SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="MO" & legbranch==0

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1994

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}
// NEVADA

// NV HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="NV" & legbranch==1

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1998

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}

// NV SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="NV" & legbranch==0

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k'  & year>=1998

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}

// OKLAHOMA - Lifeterm limit split across House and Senate

// OK HOUSE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="OK" & legbranch==1

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k' & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

restore
}


// OK SENATE
clear all
use "${root}/master_dataset.dta", clear

keep if state_abrv=="OK" & legbranch==0

levelsof unique_id, local(sep)

  foreach k in `sep' {

  cap preserve

  keep if winner==1  // | incumbent==1==1
  gen term_limited=.
  gen limited_seat=.

  keep if unique_id==`k'  & year>=1992

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
  bys district year: gen seat=_n
  sort year
  bys seat: replace limited_seat=1 if term_limited[_n-1]==1
  replace limited_seat=0 if limited_seat==.

  save "${root}/test/test`k'.dta", replace

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

  save "${root}/test/oklahoma.dta", replace

}

// APPEND EVERYTHING ALL AT ONCE

if `append' == 1 {

    cd "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\DS0001\test"
    clear
    append using `: dir . files "*.dta"'
    drop data house1 house2 sen1 sen2
    save "${root}/term_limited_elections.dta", replace
}


if `clean_up'==1 {

cd "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\DS0001\test"

local datafiles: dir "`workdir'" files "*.dta"

foreach datafile of local datafiles {
        rm `datafile'
}

}
