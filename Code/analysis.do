/*

CREATED: 1/10/2022

This dofile creates some descriptive statistics for the dataset and contains the main analysis for the project

Input:  master_data.dta
Output: coefficients of interest

*/


// Step 1: Identify candidates that are term limited and can't run and compare how often we see another candidate with the same last name relative to when a candidate voluntarily decides not to run


local descriptive       0
local append1           0
local consecutive       0



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


if `append1'==1 {

  cd "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\DS0001\temp"
  clear
  append using `: dir . files "*.dta"'
  save "${root}/descriptive.dta", replace

  export excel state legbranch nep using "${root}/descriptive.xlsx" , sheet("run_gaps", replace) firstrow()

}
