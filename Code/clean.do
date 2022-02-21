/*

CREATED: 1/10/2022

This dofile cleans raw datasets

Input1:  34279-0001-Data.dta
Output1: elections_clean.dta

Input2: State_Leg_Term.xlsx
Output2: term_limits_clean

*/

clear all

local elections       1
local limits          0


if `elections' == 1 {

use "${raw_data}", clear

// rename variables
rename (CASEID V01 V02 V05 V06 V07 V08 V12 V18 V19 V22 V24 V14 V15 V16 V17 V20 V21 V23 V25 V26 V27 V28 V29 V30 V31 V32 V33 V34 V35 V36 V37 V44 V45 V50 V51 V52 V54 V13 V09 V11 V43) (caseid state state_abrv year month legbranch distr distrtype candidate_id candidate_fullname incumbent winner term_length_law term_length_actual election_type sitting_legislator party_code_detailed party_code cand_vote nr_cand nr_dem nr_rep nr_other total_votes dem_votes rep_votes other_votes highest_vote_pct second_highest_vote_pct victory_margin_pct cand_pct_vote cand_winner_diff cand_surname cand_name cand_nickname cand_prefix cand_suffix alt_surname nr_winners distr_nr distr_id uncertainty)

//Recode "legbranch" into [0,1] binary instead of current values
replace legbranch=0 if legbranch==8        // senate
replace legbranch=1 if legbranch==9       // house

label define branches 0 "senate" 1 "house"
label val legbranch branches

// Issue with missing month values for 11 observations - I replace all missing values for month with value 13 to avoid issues with . > largest values
replace month=13 if month==.

// Clean up district variable
replace distr_id=subinstr(distr_id, " ","",.)
replace distr_id=subinstr(distr_id, "-","",.)
replace distr_id=subinstr(distr_id, ".", "999", .)
replace distr_id=subinstr(distr_id, "A", "1", .)
replace distr_id=subinstr(distr_id, "B", "2", .)
replace distr_id=subinstr(distr_id, "C", "3", .)
replace distr_id=subinstr(distr_id, "D", "4", .)
replace distr_id=subinstr(distr_id, "E", "5", .)
replace distr_id=subinstr(distr_id, "F", "6", .)
replace distr_id=subinstr(distr_id, "G", "7", .)
replace distr_id=subinstr(distr_id, "H", "8", .)
replace distr_id=subinstr(distr_id, "I", "9", .)
replace distr_id=subinstr(distr_id, "J", "10", .)
replace distr_id=subinstr(distr_id, "K", "11", .)
replace distr_id=subinstr(distr_id, "L", "12", .)
replace distr_id=subinstr(distr_id, "M", "13", .)
replace distr_id=subinstr(distr_id, "N", "14", .)
replace distr_id=subinstr(distr_id, "O", "15", .)
replace distr_id=subinstr(distr_id, "P", "16", .)
replace distr_id=subinstr(distr_id, "Q", "17", .)
replace distr_id=subinstr(distr_id, "R", "18", .)
replace distr_id=subinstr(distr_id, "S", "19", .)
replace distr_id=subinstr(distr_id, "T", "20", .)
replace distr_id=subinstr(distr_id, "U", "21", .)
replace distr_id=subinstr(distr_id, "V", "22", .)
replace distr_id=subinstr(distr_id, "W", "23", .)
replace distr_id=subinstr(distr_id, "X", "24", .)
replace distr_id=subinstr(distr_id, "Y", "25", .)
replace distr_id=subinstr(distr_id, "Z", "26", .)

destring distr_id, replace

// Construct an election identifier
bys state year month legbranch distr_id nr_cand total_votes: gen election_id=_n if _n==1
replace election_id=sum(election_id)
// double check that this is right by adding votes of each candidate within an election and making sure they equal total_votes

// keeping the last election of the year instead of dropping sitting_legislator==0
bys state year legbranch distr_id: egen latest_month=max(month)
bys state year legbranch distr_id: keep if month==latest_month

// making sure we only have 1 election per state-year-legbranch-distr_id
unique election_id, by(state year legbranch distr_id) gen(annual_check)
bys state year legbranch distr_id: egen tag=total(annual_check)

drop if sitting_legislator==0 & tag!=1

// deal with only few obs left that can't be taken care of neither via sitting_legislator==0 or the latest_month var, i.e., they're different elections in the same month both determining sitting_legislator
unique election_id, by(state year legbranch distr_id) gen(final_check)
bys state year legbranch distr_id: egen tag1=total(final_check)
drop if tag1==2 & election_type=="G"  // taking care of only keeping the runoff election that corresponds to this general election duplicate


// SANITY CHECKS that the elections we're looking at all have a winner - that candidate votes add up to total votes - that the same candidate doesn't show up more than once in the same election

bys election_id: egen winners=total(winner)
bys election_id: egen votes_total=total(cand_vote)
duplicates tag state year legbranch election_id candidate_fullname, gen(cand_dupl)
// there is 1 observation for which the winner==1 & winners==1 & cand_vote==1 and it's correct

// FIX the issue that same candidate shows up multiple times within the same election, with different vote counts
bys election_id candidate_fullname: egen cand_votes=total(cand_vote)
duplicates drop election_id candidate_fullname, force
replace cand_vote=cand_votes if cand_vote!=cand_votes

// drop all the observations for which candidate name is missing and they never win an election
drop if candidate_fullname=="SCATTERING" | candidate_fullname=="WRITEIN"

// drop all the auxilliary vars created to clean
drop latest_month annual_check tag final_check tag1 winners votes_total cand_dupl cand_votes V03 V04 V10A V10B V10C V10D V10 distr distr_nr V38 V39 V40 V41 V42 V56 V57 V58

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

// save as new dataset
cap save "${root}/term_limits_clean.dta", replace

}
