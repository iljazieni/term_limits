/*

CREATED: 1/10/2022

This dofile creates some descriptive statistics for the dataset and contains the main analysis for the project

Input:  master_data.dta
Output: coefficients of interest

*/

// Step 1: Identify candidates that are term limited and can't run and compare how often we see another candidate with the same last name relative to when a candidate voluntarily decides not to run
local test                0
local gender              0
local output1             0
local output2             0
local toy_output          1

clear all
global controls "unopposed one_opponent two_opponents"
global lcontrols "i.unopposed i.one_opponent i.two_opponents"

if `test'==1 {

// PLAYGROUND

}

if `gender'==1 {

use "${root}/names_gender.dta", clear
append using "${root}/attempt.dta"
duplicates drop name, force
replace name=upper(name)
rename name cand_name
merge 1:m cand_name using "${root}/analysis_dataset.dta", gen(gender_merge)
drop if gender_merge==1
rename gender old_gender
encode old_gender, gen(gender)
replace gender=0 if gender==2
label define gender_label 0 "male" 1 "female"
label val gender gender_label

// Think about what you want the gender interaction to be
gen gender_intr1=gender*term_limits            // option 1
gen gender_intr2=gender*limited_election      // option 2

cap save "${root}/analysis_gender.dta", replace

clear all

use "${root}/analysis_gender.dta", clear

preserve
keep if dis_type=="single"

sort counter year

// gen a var for different gender
gen prev_g=gender if winner==1 & unique_id==unique_id[_n-1]
gen prev_wnr_g=prev_g[_n-1] if unique_id==unique_id[_n-1]
bys counter: replace prev_wnr_g=prev_wnr_g[1] if unique_id==unique_id[_n-1]

gen diff_gender=1 if gender!=prev_wnr_g & gender!=. & prev_wnr_g!=.
replace diff_gender=0 if gender==prev_wnr_g & gender!=. & prev_wnr_g!=.

tempfile gender_single
sa `gender_single'

restore

keep if dis_type=="multim"

sort counter

forval i=1/15 {

gen diff_g_`i'=1 if gender!=gender[_n-`i'] &  gender!=. & gender[_n-`i']!=. & election_id!=election_id[_n-`i'] & unique_id==unique_id[_n-`i'] & winner[_n-`i']==1  & counter[_n-`i']==counter-1

}

egen sumdiff=rowtotal(diff_g*)

gen diff_gender=1 if sumdiff!=0

append using `gender_single'

gen same_truncname_diff_g=1 if same_truncname==1 & diff_gender==1
replace same_truncname_diff_g=0 if same_truncname==1 & diff_gender==0


drop diff_g_* sumdiff

cap save "${root}/analysis_gender_s.dta", replace

}


// NOTES: CLUSTER ALL STANDARD ERRORS - ALSO RUN THE SAME OLS SPEICIFICATIONS WITH ROBUST SE INSTEAD OF CLUSTERED AND LOOK AT THE DIFFERENCE
// FOR LOGIT - RUN ALL SPECIFICATIONS USING "OR" OPTION WHICH GIVES TRANSFORMED COEFFICIENT ESTIMATES WHICH ARE ODDS RATIONS AND ARE INTERPRETABLE


if `output1' == 1 {

use "${root}/analysis_gender.dta", clear

eststo clear

xtset state_branch


// LPM
eststo clear

// INTERACTIONS
eststo: xtreg winner same_truncname##limited_election open $controls i.year, fe vce(cl state_branch)
eststo: xtreg winner limited_election##gender open $controls i.year, fe vce(cl state_branch)
eststo: xtreg winner same_truncname##limited_election##gender open $controls i.year, fe vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\lpm.tex", p label  title(Unit of Obs: Candidate - LPM with State-Branch Fixed Effects) noomitted style(tex) drop(19* 20*) nobaselevels star(* 0.10 ** 0.05) replace

eststo clear
// INTERACTIONS LIMITED TO OPEN==1

eststo: xtreg winner same_truncname##limited_election $controls i.year if open==1, fe vce(cl state_branch)
eststo: xtreg winner limited_election##gender $controls i.year if open==1, fe vce(cl state_branch)
eststo: xtreg winner same_truncname##limited_election##gender $controls i.year if open==1, fe vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\lpm_open.tex", p label noomitted title(Unit of Obs: Candidate - LPM with State-Branch Fixed Effects - Subsample of Open Contests only) drop(19* 20*) nobaselevels star(* 0.10 ** 0.05) style(tex) replace

// Logit
eststo clear
// INTERACTIONS
eststo: logit winner i.same_truncname##i.limited_election i.open i.year $lcontrols , or vce(cl state_branch)
eststo: logit winner i.limited_election##i.gender i.open i.year $lcontrols , or vce(cl state_branch)
eststo: logit winner i.same_truncname##i.limited_election##i.gender i.open i.year $lcontrols , or vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\logit.tex", p label noomitted title(Unit of Obs: Candidate - Logit (odds ratios reported)) drop(19* 20*) nobaselevels star(* 0.10 ** 0.05) style(tex) replace

eststo clear
// INTERACTIONS LIMITED TO OPEN==1

eststo: logit winner i.same_truncname##i.limited_election $lcontrols i.year if open==1, or vce(cl state_branch)
eststo: logit winner i.limited_election##i.gender $lcontrols i.year if open==1, or vce(cl state_branch)
eststo: logit winner i.same_truncname##i.limited_election##gender $lcontrols i.year if open==1, or vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\logit_open.tex", p label noomitted star(* 0.10 ** 0.05) title(Unit of Obs: Candidate - Logit - Subsample of Open Contests only) drop(19* 20*) nobaselevels style(tex) replace

}


if `output2'==1 {

eststo clear

use "${root}/analysis_gender.dta", clear
keep if winner==1
xtset state_branch

eststo: xtreg same_truncname limited_election##gender $controls open i.year, fe vce(cl state_branch) // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: xtreg same_truncname limited_election##gender $controls i.year if open==1, fe vce(cl state_branch) // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit same_truncname i.limited_election##i.gender $controls open i.year, or vce(cl state_branch) // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit same_truncname i.limited_election##i.gender $controls i.year if open==1, or vce(cl state_branch) // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\election_level.tex", label p title(Unit of Obs: Election - LPM (1) \& (2) | Logit (3) \& (4) | Open Contests only (2) \& (4)) style(tex) noomitted nobaselevels drop(19* 20* unopposed one_opponent two_opponents) star(* 0.10 ** 0.05) replace

}


if `toy_output' == 1 {

  // SEEMINGLY UNRELATED REGRESSIONS
  use "${root}/analysis_gender.dta", clear
  eststo clear
  bys election_id: egen elec_shares_lastname=total(same_truncname)
  replace elec_shares_lastname=1 if elec_shares_lastname!=0
  label var elec_shares_lastname "Some cand. shares name"

  xtset state_branch

  keep if winner==1

  eststo: xtreg elec_shares_lastname limited_election##gender $controls open i.year, fe vce(cl state_branch)
  eststo: xtreg elec_shares_lastname limited_election##gender $controls i.year if open==1, fe vce(cl state_branch)
  estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\elec_level.tex", label p title(Unit of Obs: Election - (1) Full Sample; (2) Open Contests) style(tex) noomitted nobaselevels drop(19* 20* unopposed one_opponent two_opponents) star(* 0.10 ** 0.05)  replace

  eststo clear

  sureg (elec_shares_lastname limited_election##gender unopposed one_opponent two_opponents  i.year open) (same_truncname limited_election##gender unopposed one_opponent two_opponents  i.year open)
  eststo: suregr, cluster(state_branch)
  sureg (elec_shares_lastname limited_election##gender unopposed one_opponent two_opponents  i.year if open==1) (same_truncname limited_election##gender unopposed one_opponent two_opponents  i.year if open==1)
  eststo: suregr, cluster(state_branch)
  estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\sureg.tex", label p title(Unit of Obs: Election | (1) Full Sameple, (2) Open Contests only) style(tex) noomitted nobaselevels drop(19* 20* unopposed one_opponent two_opponents) star(* 0.10 ** 0.05)  replace

}
