local merge           0
local algo            1
local check         1


if `merge'==1 {

use "${root}/elections_clean.dta", clear
sort state year month
merge m:1 state using "${root}/term_limits_clean.dta"

/* Generate measure for how many times candidates have been elected to office - for now this creates 2 separate variables - we might want to reconsider later depending on how term limits across the house and senate interact

foreach b in "house" "senate" {

bys state legbranch candidate_id: gen times_elected_`b'=sum(winner) if year>=yearenacted & year<=yearofimpact`b' & yearenacted!=.
gen term_limited_`b'=1 if times_elected_`b'==limitterms`b' // Construct a variable that captures whether a candidate is term limited
foreach v in "times_elected_`b'" "term_limited_`b'" {
replace `v'=0 if `v'==.
                                                    }
gen break_limit_`b'=1 if times_elected_`b' > limitterms`b'          // sanity check: make sure that candidates have not *actually* run more times than limits allow
replace break_limit_`b'=0 if break_limit_`b'==.

                              }

*/



cap save "${root}/master_dataset.dta", replace
}

/*PICK UP HERE  - TRYING TO IDENTIFY TERM_LIMITED CANDIDATES BY GOING TO _N-1
{
gen times_elected=.
gen term_limited=.
bys state legbranch distr_id election_id: gen election_counter=1 if _n==1
replace election_counter=sum(election_counter)
keep if winner==1 | incumbent==1 & year>=1990
br state year legbranch distr_id election_id candidate_fullname winner incumbent
foreach y in 1992 1994 1996 1998 2000 2002 {
bys distr_id candidate_id: replace times_elected=sum(winner) if year>=`y' & year<=`y'+6

bys candidate_id: gen terms_won=sum(winner)

}
*/

if `algo'==1  {

/*
Constructing algorithm for term_limited variable

1. Deal with states that have lifeterm limits separately

2. Figure out how to make code as compact for states with similar patterns

TRIAL:

Group 1: AZ, FL, MT, OH, SD

- No lifeterm limits
- Term length = 2 yrs | Term limit = 4 terms | Enacted 1992 | Impact 2000

I need to identify candidates that have won 4 consecutive terms
A candidate will have had to win elections in '92, '94, '96 & '98 to be term limited by 2000, etc for every time window thereafter

*/

use "${root}/master_dataset.dta", clear

drop if year<1990
keep if incumbent==1 | winner==1

gen term_limited=.
gen limited_seat=.

cap preserve

// Group 1

keep if state_abrv=="SD" // |  state_abrv=="SD"

// foreach st in AZ SD {

// keep if state_abrv=="`st'"

//foreach j in 0 1  {

 //keep if legbranch==`j'

//levelsof distr_id, local(dis)

//foreach lev in `dis' {

//keep if distr_id==`lev'
xtset candidate_id year
bys legbranch distr_id candidate_id: egen terms_won=total(winner)
sort candidate_id year
by candidate_id: replace terms_won=. if year!=year[_N]
replace term_limited=1 if terms_won==4
replace term_limited=2 if terms_won>4
replace term_limited=0 if term_limited==.
sort legbranch distr_id year
by legbranch distr_id: gen counter=_n
sort legbranch counter
replace limited_seat=1 if term_limited==0 & term_limited[_n-1]==1
replace limited_seat=0 if limited_seat==.
// tempfile group1
// sa `group1'

save "${root}/test/test.dta", replace

//}
// }


//}

/* alternative way to check

preserve

keep if state_abrv=="AZ" |  state_abrv=="SD" & year>=1992

duplicates tag state legbranch candidate_fullname winner, gen(elections_won) // REVISIT

*/
/* restore

// Group 2 - Colorado - limit of 4 terms each lasting 2 years - enacted 1990 - impact 1998
preserve

keep if state_abrv=="CO"
// split House and Senate bc terms limited are different

// House
foreach y in "1992" "1994" "1996" "1998" "2000" "2002"  {
  bys candidate_id: replace times_elected=sum(winner) if legbranch==1 & year>=`y' & year<="y"+6
}
replace term_limited=1 if times_elected==4

// Senate
foreach y in "1992" "1994" "1996" "1998" "2000" "2002" {
  bys candidate_id: replace times_elected=sum(winner) if legbranch==0 & year>=`y' & year<=`y'+4
}
replace term_limited=1 if times_elected==2

tempfile group2
sa `group2'

restore

// Group 3
preserve

// Louisiana - same for both brances - 3 terms of 4 years each

keep if state_abrv=="LA"

foreach y in "1995" "1999" {
  bys candidate_id legbranch: replace times_elected=sum(winner) if year>=`y' & year<=`y'+8
}

replace term_limited=1 if times_elected==3

tempfile group3
sa `group3'

restore

// Group 4 - Maine - 4 terms max of 2 years each - enacted 1993 - impact 1996 (retroactive)
preserve

keep if state_abrv=="ME"

foreach y in "1988" "1990" "1992" "1994" "1996" "1998" "2000" "2002" {
  bys candidate_id legbranch: replace times_elected=sum(winner) if year>=`y' & year<=`y'+6
}

replace term_limited=1 if times_elected==4

tempfile group4
sa `group4'

restore

// Group 5 - NE only senate limits - 2 terms 4 yrs each
preserve

keep if state_abrv=="NE" & legbranch==0

foreach y in "1998" "2002" {
  bys candidate_id: replace times_elected=sum(winner) if year>=`y' & year<="y"+4
}

replace term_limited=1 if times_elected==2

tempfile group5
sa `group5'

restore

// Group 6 AR - different across branches
preserve

keep if state_abrv=="AR"

// House
foreach y in "1992" "1994" "1996" "1998" "2000" "2002" "2004" {
  bys candidate_id: replace times_elected=sum(winner) if legbranch==1 & year>=`y' & year<="y"+4
}
replace term_limited=1 if times_elected==3

// Senate
foreach y in "1992" "1994" "1996" "1998" "2000" "2002" {
  bys candidate_id: replace times_elected=sum(winner) if legbranch==0 & year>=`y' & year<=`y'+6
}
replace term_limited=1 if times_elected==4

tempfile group6
sa `group6'

restore

// Group 7 - starting with lifetime limits - Start w california
preserve

keep if state_abrv=="CA"

// HOUSE
foreach y in "1990" "1992" "1994" "1996" "1998" "2000" "2002" "2004" {
  bys candidate_id: replace times_elected=sum(winner) if legbranch==1 & year>=`y' & year<="y"+4
}
replace term_limited=1 if times_elected==3

// Senate
foreach y in "1990" "1992" "1994" "1996" "1998" "2000" "2002" {
  bys candidate_id: replace times_elected=sum(winner) if legbranch==0 & year>=`y' & year<=`y'+6
}
replace term_limited=1 if times_elected==2

tempfile group7
sa `group7'

restore

//Group 8 - MI
preserve

keep if state_abrv=="MI"
// House
foreach y in "1992" "1994" "1996" "1998" "2000" "2002" "2004" {
  bys candidate_id: replace times_elected=sum(winner) if legbranch==0 & year>=`y' & year<="y"+4
}
replace term_limited=1 if times_elected==3

// Senate
foreach y in "1994" "1996" "1998" "2000" "2002" {
  bys state candidate_id legbranch: replace times_elected=sum(winner) if year>=`y' & year<=`y'+4
}
replace term_limited=1 if times_elected==2

tempfile group8
sa `group8'

restore

// Group 9 - MO - same for both branches
preserve

keep if state_abrv=="MO"

foreach y in "1994" "1996" "1998" "2000" "2002" {
  bys candidate_id legbranch: replace times_elected=sum(winner) if year>=`y' & year<=`y'+6
}

replace term_limited=1 if times_elected==4

tempfile group9
sa `group9'

restore

// Group 10
preserve

keep if state_abrv=="NV"

// House - we only observe 1 election in which candidates could be term limited (the 2010 election)

bys candidate_id: replace times_elected=sum(winner) if legbranch==0 & year>=1998 & year<=2008
replace term_limited=1 if times_elected==6

// Senate
bys candidate_id: replace times_elected=sum(winner) if year>=1998 & year<=2008

replace term_limited=1 if times_elected==3  // the only times this var is going to be an issue is when a state has lifetime limits in both offices and I need a way to capture both - think about fixing this by having only the first obs of a candidate_id legbranch be 1 if candidate is term limited in that branch and all the other . and then create a new var that is sum of those 1's and see if it's >2

tempfile group10
sa `group10'

restore

// Group 11
preserve

keep if state_abrv=="FL" | state_abrv=="MT" | state_abrv=="OH"

// House
foreach y in "1992" "1994" "1996" "1998" "2000" "2002"  {
  bys state candidate_id: replace times_elected=sum(winner) if legbranch==1 & year>=`y' & year<="y"+6
}
replace term_limited=1 if times_elected==4

// Senate
foreach y in "1992" "1994" "1996" "1998" "2000" "2002" {
  bys state candidate_id: replace times_elected=sum(winner) if legbranch==0 & year>=`y' & year<=`y'+4
}
replace term_limited=1 if times_elected==2

tempfile group11
sa `group11'


/* Group 12 - OKLAHOMA - Lifetime limit of 12 for House and Senate combined! - figure out how to deal with this later
- it can probably be done if you define two
preserve

keep if state_abrv=="OK"

bys legbranch candidate_id:

*/
}


if `reconstruct'==1   {

use `group1', clear

forval i=2/10{

  append using `group`i''

}

cap save "${root}/reconstructed_data.dta", replace

}


// _____________________________________________ TERM LIMIT CONSTRUCTION

if `limited' == 1  {


  // Construct a variable that captures whether a candidate is term limited
  /* RUN AFTER YOU HAVE THESE VARIABLES

  Everything that follows has to be looped over each state because of differences across term durations/limits
  bys candidate_id: gen cand_limited=1 if times_run==term_limit - NO YOU DONT HAVE TO

  gen match=.

  foreach st in state {

  if cand_limited==1 {  // can't start with this bc it's only going to look at term limited candidates and we obviously are trying to identify the 'new' nepotistic candidate

  local surname=cand_surname
  local name=cand_name

  replace match=1 if year=`year'+1 & cand_surname==`surname' & cand_name!=`name'

  }
  }

  // another strategy would be to count how many Smiths run in each state over the entire time span and check if there are instances where their names aren't the same:
  duplicates tag state cand_surname, gen(surname_level)
  duplicates tag state cand_surname cand_name, gen(individual_level)
  gen nepotism=1 if surname_level>individual_level // note!! here you have to be careful to make sure there's an identifier of whether someone has won at least once [i.e. to avoid cases when we observe a candidate with the same name run after another candidate that shared their name but was never elected- you can use variable incumbent/winner for this]
  bys candidate_id: gen ever_elected=sum(winner)
  Nb that in this strategy you still have to incorporate the term limit element

  */

COMMENTING OUT EVERYTHING TO MAKE SURE FIRST CASE WORKS     */

}
