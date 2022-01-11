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


// keep only relevant variables

keep CASEID VO2 VO5 V06 V07 V08

forval i=12/54 {
  keep V`i'
  rename (V*) (v*)
}


// rename variables
rename (CASEID v02 v05 v06 vO7 v08 v12 v18 v19 v22 v24 v14 v15 v16 v17 v20 v21 v23 v25 v26 v27 v28 v29 v30 v31 v32 v34 v35 v36 v37 v44 v45 v50) (caseid state year month legbranch distr distrtype candidate_id candidate_fullname incumbent winner term_length_law term_length_actual election_type sitting_legislator party_code_detailed party_code cand_vote nr_cand nr_dem nr_rep nr_other total_votes dem_votes rep_votes other_votes highest_vote_pct victory_margin_pct cand_pct_vote cand_winner_diff cand_surname cand_name cand_nickname)


// save as new dataset

cap save "${root}/clean_data.dta", replace    
