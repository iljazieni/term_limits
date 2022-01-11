/*

CREATED: 1/10/2022

This dofile cleans the raw dataset

Input:  34279-0001-Data.dta
Output: clean_data.dta

Misc. notes:
- V20 needs detailed cleaning


*/

clear all

use "${raw_data}", clear


// rename variables

rename (CASEID V02 V05 V06 V07 V08 V12 V18 V19 V22 V24 V14 V15 V16 V17 V20 V21 V23 V25 V26 V27 V28 V29 V30 V31 V32 V33 V34 V35 V36 V37 V44 V45 V50 V51 V52 V54 V13) (caseid state year month legbranch distr distrtype candidate_id candidate_fullname incumbent winner term_length_law term_length_actual election_type sitting_legislator party_code_detailed party_code cand_vote nr_cand nr_dem nr_rep nr_other total_votes dem_votes rep_votes other_votes highest_vote_pct second_highest_vote_pct victory_margin_pct cand_pct_vote cand_winner_diff cand_surname cand_name cand_nickname cand_prefix cand_suffix alt_surname nr_winners)


//Recode "legbranch" into [0,1] binary instead of current values
replace legbranch=0 if legbranch==8        // senate
replace legbranch=1 if legbranch==9       // house


/*
Cleaning Tasks

1. convert election_type to int once you have the ICPSR codebook
2. nr_dem/nr_rep/nr_other seem prone to extreme outliers - investigate further (conduct sanity checks w/ nr_candidates)


*/

// Sanity checks re nr of candidates
gen sum_cand = nr_dem + nr_rep + nr_other
compare nr_cand sum_cand    // issue: these two vars are not identical
gen check= sum_cand-nr_cand   // very skewed distribution - watch out for nr_cand outliers
// save as new dataset
cap save "${root}/clean_data.dta", replace
