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
local output2             1

clear all
global controls "unopposed one_opponent two_opponents"

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


if `output1'==1 {

clear all
eststo clear

// ---------------------------------- // MEASURE 1 OF LAST NAME

use "${root}/analysis_dataset.dta", clear

// LPM

eststo: reg winner same_lastname limited_election
eststo: reg winner same_lastname limited_election lastname_limited
eststo: reg winner same_lastname limited_election $controls
eststo: reg winner same_lastname limited_election lastname_limited $controls

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n1_ols.tex", label p title(LPM - Full Sample) style(tex) replace

eststo clear

eststo: reg winner same_lastname limited_election if open_contest==1
eststo: reg winner same_lastname limited_election lastname_limited if open_contest==1
eststo: reg winner same_lastname limited_election $controls if open_contest==1
eststo: reg winner same_lastname limited_election lastname_limited $controls if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n1_ols.tex", label p title(LPM - Open Contests only) style(tex) replace

// LOGIT
eststo clear

eststo: logit winner same_lastname limited_election
eststo: logit winner same_lastname limited_election lastname_limited
eststo: logit winner same_lastname limited_election $controls
eststo: logit winner same_lastname limited_election lastname_limited $controls
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n1_lgt.tex", label p title(Logit - Full Sample) style(tex) replace

eststo clear

eststo: logit winner same_lastname limited_election if open_contest==1
eststo: logit winner same_lastname limited_election lastname_limited if open_contest==1
eststo: logit winner same_lastname limited_election $controls if open_contest==1
eststo: logit winner same_lastname limited_election lastname_limited $controls if open_contest==1

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n1_lgt.tex", label p title(Logit - Open Contests only) style(tex) replace


// ELECTION LEVEL
eststo clear
// LPM

use "${root}/election_level_data.dta", clear

eststo: reg same_lastname limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg same_lastname limited_election $controls if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg single_cand_election limited_election same_lastname lastname_limited if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n1_ols.tex", label p title(Unit of Obs: Election - Open Contest Only - LPM) style(tex) replace

// LOGIT
eststo clear

use "${root}/election_level_data.dta", clear

eststo: logit same_lastname limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit same_lastname limited_election $controls if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit single_cand_election limited_election same_lastname lastname_limited if open_contest==1

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n1_lgt.tex", label p title(Unit of Obs: Election - Open Contest Only - Logit) style(tex) replace


// -------------------------------  // MEASURE 2 OF LAST NAME - 4 consecutive obs
clear all
eststo clear

use "${root}/analysis_dataset.dta", clear

// LPM

eststo: reg winner same_truncname limited_election,
eststo: reg winner same_truncname limited_election truncname_limited, vce(cl state)
eststo: reg winner same_truncname limited_election $controls
eststo: reg winner same_truncname limited_election truncname_limited $controls

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n2_ols.tex", label p title(LPM - Full Sample) style(tex) replace

eststo clear

eststo: reg winner same_truncname limited_election if open_contest==1
eststo: reg winner same_truncname limited_election truncname_limited if open_contest==1
eststo: reg winner same_truncname limited_election $controls if open_contest==1
eststo: reg winner same_truncname limited_election truncname_limited $controls if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n2_ols.tex", label p title(LPM - Open Contests only) style(tex) replace

// LOGIT
eststo clear

eststo: logit winner same_truncname limited_election
eststo: logit winner same_truncname limited_election truncname_limited
eststo: logit winner same_truncname limited_election $controls
eststo: logit winner same_truncname limited_election truncname_limited $controls
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n2_lgt.tex", label p title(Logit - Full Sample) style(tex) replace

eststo clear

eststo: logit winner same_truncname limited_election if open_contest==1
eststo: logit winner same_truncname limited_election truncname_limited if open_contest==1
eststo: logit winner same_truncname limited_election $controls if open_contest==1
eststo: logit winner same_truncname limited_election truncname_limited $controls if open_contest==1

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n2_lgt.tex", label p title(Logit - Open Contests only) style(tex) replace


// ELECTION LEVEL
eststo clear
// LPM

use "${root}/election_level_data.dta", clear

eststo: reg same_truncname limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg same_truncname limited_election $controls if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg single_cand_election limited_election same_truncname truncname_limited if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n2_ols.tex", label p title(Unit of Obs: Election - Open Contest Only - LPM) style(tex) replace

// LOGIT
eststo clear

use "${root}/election_level_data.dta", clear

eststo: logit same_truncname limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit same_truncname limited_election $controls if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit single_cand_election limited_election same_truncname truncname_limited if open_contest==1

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n2_lgt.tex", label p title(Unit of Obs: Election - Open Contest Only - Logit) style(tex) replace

/* ------------------------------ // MEASURE 3 OF LAST NAME - matching initial of middle name with initial of previous incumbent's lastname

clear all
eststo clear

use "${root}/analysis_dataset.dta", clear

// LPM

eststo: reg winner same_initial limited_election
eststo: reg winner same_initial limited_election initial_limited
eststo: reg winner same_initial limited_election $controls
eststo: reg winner same_initial limited_election initial_limited $controls

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n3_ols.tex", label p title(LPM - Full Sample) style(tex) replace

eststo clear

eststo: reg winner same_initial limited_election if open_contest==1
eststo: reg winner same_initial limited_election initial_limited if open_contest==1
eststo: reg winner same_initial limited_election $controls if open_contest==1
eststo: reg winner same_initial limited_election initial_limited $controls if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n3_ols.tex", label p title(LPM - Open Contests only) style(tex) replace

// LOGIT
eststo clear

eststo: logit winner same_initial limited_election
eststo: logit winner same_initial limited_election initial_limited
eststo: logit winner same_initial limited_election $controls
eststo: logit winner same_initial limited_election initial_limited $controls
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n3_lgt.tex", label p title(Logit - Full Sample) style(tex) replace

eststo clear

eststo: logit winner same_initial limited_election if open_contest==1
eststo: logit winner same_initial limited_election initial_limited if open_contest==1
eststo: logit winner same_initial limited_election $controls if open_contest==1
eststo: logit winner same_initial limited_election initial_limited $controls if open_contest==1

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n3_lgt.tex", label p title(Logit - Open Contests only) style(tex) replace


// ELECTION LEVEL
eststo clear
// LPM

use "${root}/election_level_data.dta", clear

eststo: reg same_initial limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg same_initial limited_election $controls if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg single_cand_election limited_election same_initial initial_limited if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n3_ols.tex", label p title(Unit of Obs: Election - Open Contest Only - LPM) style(tex) replace

// LOGIT
eststo clear

use "${root}/election_level_data.dta", clear

eststo: logit same_initial limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit same_initial limited_election $controls if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n3_lgt.tex", label p title(Unit of Obs: Election - Open Contest Only - Logit) style(tex) replace
*/

}

// NOTES: CLUSTER ALL STANDARD ERRORS - ALSO RUN THE SAME OLS SPEICIFICATIONS WITH ROBUST SE INSTEAD OF CLUSTERED AND LOOK AT THE DIFFERENCE
// FOR LOGIT - RUN ALL SPECIFICATIONS USING "OR" OPTION WHICH GIVES TRANSFORMED COEFFICIENT ESTIMATES WHICH ARE ODDS RATIONS AND ARE INTERPRETABLE


if `output2' == 1 {

use "${root}/analysis_gender.dta", clear

eststo clear

xtset state_branch

eststo clear

// LPM

// INTERACTIONS
eststo: xtreg winner same_truncname##limited_election open $controls , fe vce(cl state_branch)
eststo: xtreg winner limited_election##gender open $controls , fe vce(cl state_branch)
eststo: xtreg winner same_truncname##limited_election##gender open $controls , fe vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\lpm.tex", p label  title(Unit of Obs: Candidate - LPM with State-Branch Fixed Effects) noomitted style(tex) replace


eststo clear
// INTERACTIONS LIMITED TO OPEN==1

eststo: xtreg winner same_truncname##limited_election $controls if open==1, fe vce(cl state_branch)
eststo: xtreg winner limited_election##gender $controls if open==1, fe vce(cl state_branch)
eststo: xtreg winner same_truncname##limited_election##gender $controls if open==1, fe vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\lpm_open.tex", p label noomitted title(Unit of Obs: Candidate - LPM with State-Branch Fixed Effects - Subsample of Open Contests only) style(tex) replace

// Logit
eststo clear
// INTERACTIONS
eststo: logit winner i.same_truncname##i.limited_election i.open $controls , or vce(cl state_branch)
eststo: logit winner i.limited_election##i.gender i.open $controls , or vce(cl state_branch)
eststo: logit winner i.same_truncname##i.limited_election##i.gender i.open $controls , or vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\logit.tex", p label noomitted title(Unit of Obs: Candidate - Logit - Fixed Effects) style(tex) replace

eststo clear
// INTERACTIONS LIMITED TO OPEN==1

eststo: logit winner i.same_truncname##i.limited_election $controls if open==1, or vce(cl state_branch)
eststo: logit winner i.limited_election##i.gender $controls if open==1, or vce(cl state_branch)
eststo: logit winner i.same_truncname##i.limited_election##gender $controls if open==1, or vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\logit_open.tex", p label noomitted title(Unit of Obs: Candidate - Logit - Subsample of Open Contests only) style(tex) replace

______________________________________________ // USING TERM_LIMIT DUMMY

// INTERACTIONS WITH TERM LIMITS
eststo: xtreg winner same_truncname##term_limits open $controls , fe vce(cl state_branch)
eststo: xtreg winner term_limits##gender open $controls , fe vce(cl state_branch)
eststo: xtreg winner same_truncname##term_limits##gender open $controls , fe vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\lpm_tlims.tex", p label  title(Unit of Obs: Candidate - LPM with State-Branch Fixed Effects) noomitted style(tex) replace


eststo clear
// INTERACTIONS LIMITED TO OPEN==1

eststo: xtreg winner same_truncname##term_limits $controls if open==1, fe vce(cl state_branch)
eststo: xtreg winner term_limits##gender $controls if open==1, fe vce(cl state_branch)
eststo: xtreg winner same_truncname##term_limits##gender $controls if open==1, fe vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\lpm_open_tlims.tex", p label noomitted title(Unit of Obs: Candidate - LPM with State-Branch Fixed Effects - Subsample of Open Contests only) style(tex) replace

// Logit
eststo clear
// INTERACTIONS
eststo: logit winner i.same_truncname##i.term_limits i.open $controls , or vce(cl state_branch)
eststo: logit winner i.term_limits##i.gender i.open $controls , or vce(cl state_branch)
eststo: logit winner i.same_truncname##i.term_limits##i.gender i.open $controls , or vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\logit_tlims.tex", p label noomitted title(Unit of Obs: Candidate - Logit - Fixed Effects) style(tex) replace

eststo clear
// INTERACTIONS LIMITED TO OPEN==1

eststo: logit winner i.same_truncname##i.term_limits $controls if open==1, or vce(cl state_branch)
eststo: logit winner i.term_limits##i.gender $controls if open==1, or vce(cl state_branch)
eststo: logit winner i.same_truncname##i.term_limits##gender $controls if open==1, or vce(cl state_branch)
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\logit_open_tlims.tex", p label noomitted title(Unit of Obs: Candidate - Logit - Subsample of Open Contests only) style(tex) replace


}
