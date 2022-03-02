/*

CREATED: 1/10/2022

This dofile creates some descriptive statistics for the dataset and contains the main analysis for the project

Input:  master_data.dta
Output: coefficients of interest

*/

// Step 1: Identify candidates that are term limited and can't run and compare how often we see another candidate with the same last name relative to when a candidate voluntarily decides not to run


local descriptive       0
local nepotism          0
local alt_nep           1

if `descriptive'==1 {


forval i=1/50 {

forval j=0/1 {

  use "${root}/elections_clean.dta", clear

  gen nr_candidates=.
  gen same_surname=.

  keep if state==`i' & legbranch==`j'

  cap distinct candidate_fullname
  cap replace nr_candidates=r(ndistinct)

  cap distinct cand_surname
  cap replace same_surname=r(ndistinct)

  cap gen step1=(same_surname/nr_candidates)
  cap gen nep=1-step1

  cap keep state state_abrv legbranch nr_candidates same_surname nep
  cap duplicates drop

  save "${root}/temp/d`i'_`j'.dta", replace

}

}

}

if `nepotism'==1      {

use "${root}/term_limited_elections.dta", clear
keep if limited_seat==1 | term_limited==1
sort unique_id year
by unique_id: gen nep_wrong=1 if cand_surname==cand_surname[_n-1] & cand_name!=cand_name[_n-1]   // ISSUE HERE IS THAT NAME DIFFERS FOR SAME PERSON (JAMES JIM)
by unique_id: gen nep=1 if cand_surname==cand_surname[_n-1] & limited_seat==1
by unique_id: gen check1=1 if nep==1 & candidate_fullname==candidate_fullname[_n-1] // ADDRESS
gen check2=1 if term_limited==1 & limited_seat==1
save "${root}/nepotism.dta", replace

}

if `alt_nep' ==1 {

    clear all
    use "${root}/term_limited_elections_audit.dta", clear

duplicates drop state legbranch distr_id new_district year seat candidate_fullname, force 

  egen unique_distr=concat(state legbranch new_district)
  destring unique_distr, replace

  keep if limited_seat==1 | term_limited==1
  sort unique_distr year
  by unique_distr: gen nep_wrong=1 if cand_surname==cand_surname[_n-1] & cand_name!=cand_name[_n-1]   // ISSUE HERE IS THAT NAME DIFFERS FOR SAME PERSON (JAMES JIM)
  by unique_distr: gen nep=1 if cand_surname==cand_surname[_n-1] & limited_seat==1
  by unique_distr: gen check1=1 if nep==1 & candidate_fullname==candidate_fullname[_n-1] // ADDRESS
  gen check2=1 if term_limited==1 & limited_seat==1
  save "${root}/nepotism_audit.dta", replace


}
