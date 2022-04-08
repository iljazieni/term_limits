/*

2/2/22 QUESTIONS

1. How are elections that don't determine a sitting legislator different from those that do *for our purposes*? Why would we keep them in our dataset? If they don't determine a sitting legislator, doesn't that mean that those candidates don't serve in office and that 'win' doesn't count towards their term limit?
2. Why is it that there are Senate elections in the same district for FL, MT, OH that are 2 years apart when the senate term is 4 years? [these states are just an example; write code to check how often this happens for both house and senate]
3. Issue with district identifiers for creating unique election_id



1. PRIMARY RESEARCH

1. How many different elections could there be in the same state-year-month-legbranch-district? [ex. Alabama-1970-11-0-12 has 7 different elections - is there an issue with the data? You can use variable "red_flag" in elections_clean.dta to check this]

- The number of elections would depend on the type of district. For example, Alabama-1970-11-0-12 is technically just one election for the 12th district of the Alabama House of Representatives. However, because the 12th district is a multi-member district (MMD), there are several posts (seats) in the 12th district. Numbers under "V10b" correspond to the post/seat for which the corresponding candidate has run. - Show issues with district variables




- If we need a unique election identifier, perhaps state-year-month-legbranch-district-V10A-V10B-V10C-V10D might work better. It's a long string but it will be unique. V10 and subs would correspond to the election type (single-member, multi-member, etc.)

2. Have there ever been any term limiting legislations enacted in any state before our dataset starts?

- None. The first term limits were enacted in 1990 in Colorado and Oklahoma.

3. For the 5 states that have lifetime term limits, what is the limit for each of them? [Please complete in table below]

| State | Lifetime term limit (House) | Lifetime term limit (Senate) |
| ----- | --------------------------- | ---------------------------- |
| CA    |              3 terms        |               2 terms        |
| MI    |              3 terms        |               2 terms        |
| MO    |              8 years        |               8 years        |
| NV    |              12 years       |               12 years       |
| OK    |                12 years, House and Senate combined         |



2. DATA ISSUES(?)

- HOUSE

| State | Year Enacted | Limit Years House | Year of Impact House (data) | Year of Impact (calc'd using LimitTermsHouse) |
| ----- | ------------ | ----------------- | --------------------------- | --------------------------------------------- |
| ME    | 1993         | 8                 | 1996 (correct; retroactive) | 2001                                          |
| MO    | 1992         | 8                 | 2002 (correct; delayed)     | 2000                                          |
| NV    | 1996         | 12                | 2010 (correct; delayed)     | 2008                                          |
| OK    | 1990         | 12                | 2004 (correct; delayed)     | 2002                                          |

- Notes
-- ME - The year of impact is 1996, i.e., the Nov. 1996 election. The term limits measure was enacted in 1993 (off-cycle election), but provided that term limits would be effective on "terms of office that begin on or after Dec. 3, 1996." Because of the wording of the measure, legislators who already served eight consecutive years by Dec. 2, 1996 (so elected in 1988) were term-limited and barred from running in the Nov. 1996 election.
-- MO - The year of impact is 2002, i.e., the Nov. 2002 election. The term limits measure was enacted in Nov. 1992, but had a provision that "service in the General Assembly resulting from an election or appointment prior to the effective date of this section shall not be counted." As the term-limit measure took effect in Dec. 1992, the the first election that counted in the 8-year term limit was the Nov. 1994 election. This meant that a candidate who won in Nov. 1994 and every election thereafter would be first barred from running in the Nov. 2002 election.
-- NV - The year of impact is 2010, i.e., the Nov. 2010 election. Courts have interpreted the Nevada measure as beginning the 12-year count to legislators elected during the Nov. 1998 election, not the immediately prior Nov. 1996 election.
-- OK - The year of impact is 2004, i.e., the Nov. 2004 election. The term-limits measure was approved on September 1990 and provided that it would take effect on January 1, 1991. While there was an election in the interim (on Nov. 1990), the 12-year count began for legislators elected during the Nov. 1992 election.

- SENATE

| State | Year Enacted | Limit Years Senate| Year of Impact Senate (data) | Year of Impact (calc'd using LimitYearsSenate) |
| ----- | ------------ | ----------------- | --------------------------- | ----------------------------------------------- |
| ME    |    1993      |        8          | 1996 (correct; retroactive) | 2001                                            |
| MI    |    1992      |        8          | 2002 (correct; delayed)     | 2000                                            |
| MO    |    1992      |        8          | 2002 (correct; delayed)     | 2000                                            |
| NE    |    2000      |        8          | 2006 (correct; retroactive) | 2008                                            |
| NV    |    1996      |        12         | 2010 (correct; delayed)     | 2008                                            |
| OK    |    1990      |        12         | 2004 (correct; delayed)     | 2002                                            |

- Notes
-- ME - The year of impact is 1996, i.e., the Nov. 1996 election. Same notes as House, above.
-- MI - The year of impact is 2002, i.e., the Nov. 2002 election. The term-limits measure was approved on November 1992 and provided that it would take effect on January 1, 1993. As the first election following effectivity is the Nov. 1994 election, that was the beginning of the 8-year count.
-- MO - The year of impact is 2002, ie., the Nov. 1992 election. Same notes as House, above.
-- NE - The year of impact is 2006, i.e., the Nov. 2006 election. The term-limits measure was approved on Nov. 2000 and provided that "Service prior to January 1, 2001, as a member of the Legislature shall not be counted for the purpose of calculating consecutive terms," which means it is retroactive. However, Nebraska's senate terms are staggered, so there were senators elected in Nov. 1998 whose term-limits started to run during their Year 3 in office. If they were to run two rounds after Nov. 1998, i.e., in Nov. 2006, they would be on Year 8 in office and thus term-limited.
-- NV - The year of impact is 2010, i.e., the Nov. 2010 election. Same notes as House, above.
-- OK - The year of impact is 2004, i.e., the Nov. 2004 election. Same notes as House, above.


3. TECHNICAL/CODING

- Investigate whether the issue with number of candidates variables (the fact that nr_cand!=nr_dems + nr_reps) could be caused by write-in candidates not being counted for this variable (nr_cand)


3/2/2022

AUDITING ALGORITHM THAT GENERATED THE FOLLOWING VARIABLES: term_limited, limited_seat

*/

local four               0
local five               0
local six                0
local lists              1


if `four'==1 {

  // single

  clear all

  use "${root}/master_dataset.dta", clear

  keep if dis_type=="single"

  gen trunc_surname=substr(cand_surname, 1,4)

  sort counter winner
  // gen a var for lastname
  gen winer=candidate_fullname if winner==1 & unique_id==unique_id[_n-1]
  gen prev_winer=winer[_n-1] if unique_id==unique_id[_n-1]
  bys counter: replace prev_winer=prev_winer[1] if unique_id==unique_id[_n-1]

  // gen a var for firstname
  gen prev_su=trunc_surname if winner==1 & unique_id==unique_id[_n-1]
  gen prev_sur_winer=prev_su[_n-1] if unique_id==unique_id[_n-1]
  bys counter: replace prev_sur_winer=prev_sur_winer[1] if unique_id==unique_id[_n-1]

  gen same_truncname=1 if trunc_surname==prev_sur_winer & candidate_fullname!=prev_winer
  replace same_truncname=0 if same_truncname==.


  cap save "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\single4.dta", replace

  clear all

  use "${root}/master_dataset.dta", clear

  keep if dis_type=="multim"

  gen trunc_surname=substr(cand_surname, 1,4)

  sort counter

  forval i=1/15 {

  gen same_`i'=1 if trunc_surname==trunc_surname[_n-`i'] & candidate_fullname!=candidate_fullname[_n-`i'] & election_id!=election_id[_n-`i'] & unique_id==unique_id[_n-`i']  & winner[_n-`i']==1  & counter[_n-`i']==counter-1
  gen prv_name`i'=candidate_fullname[_n-`i'] if same_`i'==1
  }

  egen sumsame=rowtotal(same*)

  gen same_truncname=1 if sumsame!=0
  replace same_truncname=0 if same_truncname==.

  cap save "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\multi4.dta", replace

  clear all

  use "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\single4.dta", clear
  append using "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\multi4.dta"
  cap save "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\names4.dta", replace

}




if `five'==1 {

  // single

  clear all

  use "${root}/master_dataset.dta", clear

  keep if dis_type=="single"

  gen trunc_surname=substr(cand_surname, 1,5)

  sort counter winner
  // gen a var for lastname
  gen winer=candidate_fullname if winner==1 & unique_id==unique_id[_n-1]
  gen prev_winer=winer[_n-1] if unique_id==unique_id[_n-1]
  bys counter: replace prev_winer=prev_winer[1] if unique_id==unique_id[_n-1]

  // gen a var for firstname
  gen prev_su=trunc_surname if winner==1 & unique_id==unique_id[_n-1]
  gen prev_sur_winer=prev_su[_n-1] if unique_id==unique_id[_n-1]
  bys counter: replace prev_sur_winer=prev_sur_winer[1] if unique_id==unique_id[_n-1]

  gen same_truncname=1 if trunc_surname==prev_sur_winer & candidate_fullname!=prev_winer
  replace same_truncname=0 if same_truncname==.


  cap save "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\single5.dta", replace

  clear all

  use "${root}/master_dataset.dta", clear

  keep if dis_type=="multim"

  gen trunc_surname=substr(cand_surname, 1,5)

  sort counter

  forval i=1/15 {

  gen same_`i'=1 if trunc_surname==trunc_surname[_n-`i'] & candidate_fullname!=candidate_fullname[_n-`i'] & election_id!=election_id[_n-`i'] & unique_id==unique_id[_n-`i']  & winner[_n-`i']==1 & counter[_n-`i']==counter-1
gen prv_name`i'=candidate_fullname[_n-`i'] if same_`i'==1
  }

  egen sumsame=rowtotal(same*)

  gen same_truncname=1 if sumsame!=0
  replace same_truncname=0 if same_truncname==.

  cap save "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\multi5.dta", replace

  clear all

  use "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\single5.dta", clear
  append using "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\multi5.dta"
  cap save "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\names5.dta", replace

}



if `six'==1 {

  // single

  clear all

  use "${root}/master_dataset.dta", clear

  keep if dis_type=="single"

  gen trunc_surname=substr(cand_surname, 1,6)

  sort counter winner
  // gen a var for lastname
  gen winer=candidate_fullname if winner==1 & unique_id==unique_id[_n-1]
  gen prev_winer=winer[_n-1] if unique_id==unique_id[_n-1]
  bys counter: replace prev_winer=prev_winer[1] if unique_id==unique_id[_n-1]

  // gen a var for firstname
  gen prev_su=trunc_surname if winner==1 & unique_id==unique_id[_n-1]
  gen prev_sur_winer=prev_su[_n-1] if unique_id==unique_id[_n-1]
  bys counter: replace prev_sur_winer=prev_sur_winer[1] if unique_id==unique_id[_n-1]

  gen same_truncname=1 if trunc_surname==prev_sur_winer & candidate_fullname!=prev_winer
  replace same_truncname=0 if same_truncname==.


  cap save "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\single6.dta", replace

  clear all

  use "${root}/master_dataset.dta", clear

  keep if dis_type=="multim"

  gen trunc_surname=substr(cand_surname, 1,6)

  sort counter

  forval i=1/15 {

  gen same_`i'=1 if trunc_surname==trunc_surname[_n-`i'] & candidate_fullname!=candidate_fullname[_n-`i'] & election_id!=election_id[_n-`i'] & unique_id==unique_id[_n-`i']  & winner[_n-`i']==1 & counter[_n-`i']==counter-1
gen prv_name`i'=candidate_fullname[_n-`i'] if same_`i'==1
  }

  egen sumsame=rowtotal(same*)

  gen same_truncname=1 if sumsame!=0
  replace same_truncname=0 if same_truncname==.

  cap save "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\multi6.dta", replace

  clear all

  use "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\single6.dta", clear
  append using "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\multi6.dta"
  cap save "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\names6.dta", replace
}


if `lists' ==1 {
clear all

forval j=4/6 {

use "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\single`j'.dta", clear
keep state legbranch year candidate_fullname cand_surname trunc_surname prev_winer same_truncname
keep if same_truncname==1
cap save   "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\single_list`j'.dta", replace
}

clear all

forval j=4/6 {

use "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\multi`j'.dta", clear
preserve
keep caseid prv_name*
replace prv_name3="" if caseid==152658  // dealing with 1 obs for which multiple prv_name* columns are nonempty
reshape long prv_name, i(caseid) j(aux)
keep if prv_name!=""
tempfile names_long`j'
sa `names_long`j''
restore
merge 1:1 caseid using `names_long`j'', gen(m`j')
rename prv_name prev_winer
keep if same_truncname==1
cap save   "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\multi_list`j'.dta", replace
}


clear all

forval j=4/6 {

use "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\multi_list`j'.dta", clear
append using "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\single_list`j'.dta"
sort dis_type counter
keep state legbranch year candidate_fullname cand_surname trunc_surname prev_winer same_truncname
cap save   "C:\Users\EI87\Dropbox (YLS)\Term Limits\Dataset\Name Algos\list`j'.dta", replace
}

}
