/*

CREATED: 1/10/2022

This dofile cleans raw datasets

Input1:  34279-0001-Data.dta
Output1: elections_clean.dta

Input2: State_Leg_Term.xlsx
Output2: term_limits_clean

*/

clear all

local elections     0
local limits        1

if `elections' == 1 {

use "${raw_data}", clear

// rename variables
rename (CASEID V01 V02 V05 V06 V07 V08 V12 V18 V19 V22 V24 V14 V15 V16 V17 V20 V21 V23 V25 V26 V27 V28 V29 V30 V31 V32 V33 V34 V35 V36 V37 V44 V45 V50 V51 V52 V54 V13 V09 V11) (caseid state state_abrv year month legbranch distr distrtype candidate_id candidate_fullname incumbent winner term_length_law term_length_actual election_type sitting_legislator party_code_detailed party_code cand_vote nr_cand nr_dem nr_rep nr_other total_votes dem_votes rep_votes other_votes highest_vote_pct second_highest_vote_pct victory_margin_pct cand_pct_vote cand_winner_diff cand_surname cand_name cand_nickname cand_prefix cand_suffix alt_surname nr_winners distr_nr distr_id)

//Recode "legbranch" into [0,1] binary instead of current values
replace legbranch=0 if legbranch==8        // senate
replace legbranch=1 if legbranch==9       // house

// Sort data chronologically
sort state year month

// Construct an election identifier
bys state year month legbranch distr_nr total_votes: gen election_id=_n if _n==1
replace election_id=sum(election_id)

// Construct a measure that investigates how often same state-year-month-legbranch-district combination has different elections and discuss with Ian/Paolo if we should trust/keep that data
bys state year month legbranch distr_nr: gen red_flag=_n if _n==1    // add total votes here
replace red_flag=sum(red_flag)


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

// Identify speacial elections (check notes from meeting with Ian)
sort state year month election_id
//br

// save as new dataset
cap save "${root}/elections_clean.dta", replace
}

if `limits'==1 {

import excel "C:\Users\ei87\Dropbox (YLS)\Term Limits\Dataset\DS0001\State_Leg_Term.xlsx", firstrow clear

drop State
destring RoundsDisqualifiedSenate YearofImpactHouse RoundsDisqualifiedHouse LimitTermsHouse TermLengthHouse LimitYearsHouse, replace
rename *, lower
encode abbreviation, gen(state)
drop abbreviation

foreach b in "house" "senate" {
gen impact_`b'=yearenacted + limitterms`b'*termlength`b'
}
// save as new dataset
cap save "${root}/term_limits_clean.dta", replace

}
