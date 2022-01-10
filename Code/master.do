//

CREATED: 1/10/2022

This dofile runs all the dofiles necessary to clean the raw dataset

Input: none
Output: none

//

global root "C:\Users\ei87\Dropbox (YLS)\Term Limits\Dataset\DS0001"
global raw_data "C:\Users\ei87\Dropbox (YLS)\Term Limits\Dataset\DS0001\34279-0001-Data.dta"
global clean_data "C:\Users\ei87\Dropbox (YLS)\Term Limits\Dataset\DS0001\clean_data.dta"

global code "add path for dofile in git"


clear all

// Switches

local clean       0





if `clean`==1  do "${code}/clean.do"
