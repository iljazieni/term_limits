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

/*
if `consecutive'==1 {

  forval i=1/50 {

   forval j=0/1 {

    use "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\DS0001\elections_clean.dta", clear

    gen unique_name=.
    gen unique_surname=.

    keep if state==`i' & legbranch==`j'
    sort state year legbranch distr_id


      // bys election_id: gen counter=1 if _n==1
      // replace counter=sum(counter)

      // gen the var you're actually looping over
    gen


    levelsof distr_id, local(levels)
    foreach k of local levels {

// TIME TO FIX THE DISTRICT VARIABLE - DESTRING - REPLACE NON-NUMERICAL VALUES WITH NUMBERS AND THEN CONCATENATE DISTIRCT AND COUNTER AND THEN HAVE 1 LOOP

    keep if distr_id=="`k'"

    sort state year legbranch distr_id election_id

    bys election_id: gen counter=1 if _n==1
    replace counter=sum(counter)

  levelsof counter, local(levels)

  foreach p of local levels {

    cap keep if counter==`p' | counter==`p' + 1

    gen last_election=.

    cap distinct counter
    replace last_election=r(ndistinct)  // creating this simply to then drop all the datasets created with only the last election in a district - i.e. with the last levelof counter

    cap distinct cand_name
    cap replace unique_name=r(ndistinct)

    cap distinct cand_surname
    cap replace unique_surname=r(ndistinct)

    cap gen var_of_interest=unique_name - unique_surname

    keep state year legbranch distr_id election_id counter unique_name unique_surname var_of_interest

    cap save "${root}/test/e`i'_`j'_`k'_`p'.dta", replace

    }

    }

 }

}

}

*/
