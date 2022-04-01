/*

CREATED: 1/10/2022

This dofile creates some descriptive statistics for the dataset and contains the main analysis for the project

Input:  master_data.dta
Output: coefficients of interest

*/

// Step 1: Identify candidates that are term limited and can't run and compare how often we see another candidate with the same last name relative to when a candidate voluntarily decides not to run

local election_unit       1
local output              1
local test                0

clear all

if `test'==1 {

// PLAYGROUND

}


if `election_unit'==1 {

  use "${root}/analysis_dataset.dta", clear

  keep if winner==1

  gen single_cand_election=1 if nr_cand==1
  replace single_cand_election=0 if single_cand_election==.
  label var single_cand_election "Single Candidate Election"

save "${root}/election_level_data.dta", replace

}


if `output'==1 {

clear all
eststo clear

// ---------------------------------- // MEASURE 1 OF LAST NAME

use "${root}/analysis_dataset.dta", clear

local controls "unopposed one_opponent two_opponents"

// LPM

eststo: reg winner same_lastname limited_election
eststo: reg winner same_lastname limited_election lastname_limited
eststo: reg winner same_lastname limited_election `controls'
eststo: reg winner same_lastname limited_election lastname_limited `controls'

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n1_ols.tex", label p title(LPM - Full Sample) style(tex) replace

eststo clear

eststo: reg winner same_lastname limited_election if open_contest==1
eststo: reg winner same_lastname limited_election lastname_limited if open_contest==1
eststo: reg winner same_lastname limited_election `controls' if open_contest==1
eststo: reg winner same_lastname limited_election lastname_limited `controls' if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n1_ols.tex", label p title(LPM - Open Contests only) style(tex) replace

// LOGIT
eststo clear

eststo: logit winner same_lastname limited_election
eststo: logit winner same_lastname limited_election lastname_limited
eststo: logit winner same_lastname limited_election `controls'
eststo: logit winner same_lastname limited_election lastname_limited `controls'
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n1_lgt.tex", label p title(Logit - Full Sample) style(tex) replace

eststo clear

eststo: logit winner same_lastname limited_election if open_contest==1
eststo: logit winner same_lastname limited_election lastname_limited if open_contest==1
eststo: logit winner same_lastname limited_election `controls' if open_contest==1
eststo: logit winner same_lastname limited_election lastname_limited `controls' if open_contest==1

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n1_lgt.tex", label p title(Logit - Open Contests only) style(tex) replace


// ELECTION LEVEL
eststo clear
// LPM

use "${root}/election_level_data.dta", clear

local controls "unopposed one_opponent two_opponents"

eststo: reg same_lastname limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg same_lastname limited_election `controls' if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg single_cand_election limited_election same_lastname lastname_limited if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n1_ols.tex", label p title(Unit of Obs: Election - Open Contest Only - LPM) style(tex) replace

// LOGIT
eststo clear

use "${root}/election_level_data.dta", clear

eststo: logit same_lastname limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit same_lastname limited_election `controls' if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit single_cand_election limited_election same_lastname lastname_limited if open_contest==1

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n1_lgt.tex", label p title(Unit of Obs: Election - Open Contest Only - Logit) style(tex) replace


// -------------------------------  // MEASURE 2 OF LAST NAME
clear all
eststo clear

use "${root}/analysis_dataset.dta", clear

local controls "unopposed one_opponent two_opponents"

// LPM

eststo: reg winner same_truncname limited_election
eststo: reg winner same_truncname limited_election truncname_limited
eststo: reg winner same_truncname limited_election `controls'
eststo: reg winner same_truncname limited_election truncname_limited `controls'

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n2_ols.tex", label p title(LPM - Full Sample) style(tex) replace

eststo clear

eststo: reg winner same_truncname limited_election if open_contest==1
eststo: reg winner same_truncname limited_election truncname_limited if open_contest==1
eststo: reg winner same_truncname limited_election `controls' if open_contest==1
eststo: reg winner same_truncname limited_election truncname_limited `controls' if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n2_ols.tex", label p title(LPM - Open Contests only) style(tex) replace

// LOGIT
eststo clear

eststo: logit winner same_truncname limited_election
eststo: logit winner same_truncname limited_election truncname_limited
eststo: logit winner same_truncname limited_election `controls'
eststo: logit winner same_truncname limited_election truncname_limited `controls'
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n2_lgt.tex", label p title(Logit - Full Sample) style(tex) replace

eststo clear

eststo: logit winner same_truncname limited_election if open_contest==1
eststo: logit winner same_truncname limited_election truncname_limited if open_contest==1
eststo: logit winner same_truncname limited_election `controls' if open_contest==1
eststo: logit winner same_truncname limited_election truncname_limited `controls' if open_contest==1

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n2_lgt.tex", label p title(Logit - Open Contests only) style(tex) replace


// ELECTION LEVEL
eststo clear
// LPM

use "${root}/election_level_data.dta", clear

local controls "unopposed one_opponent two_opponents"

eststo: reg same_truncname limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg same_truncname limited_election `controls' if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg single_cand_election limited_election same_truncname truncname_limited if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n2_ols.tex", label p title(Unit of Obs: Election - Open Contest Only - LPM) style(tex) replace

// LOGIT
eststo clear

use "${root}/election_level_data.dta", clear

eststo: logit same_truncname limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit same_truncname limited_election `controls' if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit single_cand_election limited_election same_truncname truncname_limited if open_contest==1

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n2_lgt.tex", label p title(Unit of Obs: Election - Open Contest Only - Logit) style(tex) replace

// ------------------------------ // MEASURE 3 OF LAST NAME

clear all
eststo clear

use "${root}/analysis_dataset.dta", clear

local controls "unopposed one_opponent two_opponents"

// LPM

eststo: reg winner same_initial limited_election
eststo: reg winner same_initial limited_election initial_limited
eststo: reg winner same_initial limited_election `controls'
eststo: reg winner same_initial limited_election initial_limited `controls'

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n3_ols.tex", label p title(LPM - Full Sample) style(tex) replace

eststo clear

eststo: reg winner same_initial limited_election if open_contest==1
eststo: reg winner same_initial limited_election initial_limited if open_contest==1
eststo: reg winner same_initial limited_election `controls' if open_contest==1
eststo: reg winner same_initial limited_election initial_limited `controls' if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n3_ols.tex", label p title(LPM - Open Contests only) style(tex) replace

// LOGIT
eststo clear

eststo: logit winner same_initial limited_election
eststo: logit winner same_initial limited_election initial_limited
eststo: logit winner same_initial limited_election `controls'
eststo: logit winner same_initial limited_election initial_limited `controls'
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t1_n3_lgt.tex", label p title(Logit - Full Sample) style(tex) replace

eststo clear

eststo: logit winner same_initial limited_election if open_contest==1
eststo: logit winner same_initial limited_election initial_limited if open_contest==1
eststo: logit winner same_initial limited_election `controls' if open_contest==1
eststo: logit winner same_initial limited_election initial_limited `controls' if open_contest==1

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t2_n3_lgt.tex", label p title(Logit - Open Contests only) style(tex) replace


// ELECTION LEVEL
eststo clear
// LPM

use "${root}/election_level_data.dta", clear

local controls "unopposed one_opponent two_opponents"

eststo: reg same_initial limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg same_initial limited_election `controls' if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: reg single_cand_election limited_election same_initial initial_limited if open_contest==1
estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n3_ols.tex", label p title(Unit of Obs: Election - Open Contest Only - LPM) style(tex) replace

// LOGIT
eststo clear

use "${root}/election_level_data.dta", clear

eststo: logit same_initial limited_election if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit same_initial limited_election `controls' if open_contest==1 // this is the specification where LHS=1 if winner of that election has the same last name as previous incumbent and RHS is whether this is a term limited election
eststo: logit single_cand_election limited_election same_initial initial_limited if open_contest==1

estwide using "C:\Users\ei87\Dropbox (YLS)\Term Limits\Stata Output\t3_n3_lgt.tex", label p title(Unit of Obs: Election - Open Contest Only - Logit) style(tex) replace

}
