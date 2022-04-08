/*

CREATED: 1/10/2022

This dofile runs all the auxilliary dofiles for this project

Input: none
Output: none

*/

global root "C:\Users\ei87\Dropbox (YLS)\Term Limits\Dataset\DS0001"
* global raw_data "C:\Users\ei87\Dropbox (YLS)\Term Limits\Dataset\DS0001\34279-0001-Data.dta"
global raw_data "C:\Users\ei87\Dropbox (YLS)\Term Limits\Dataset\DS0001\elections_raw.dta"
global clean_data "C:\Users\ei87\Dropbox (YLS)\Term Limits\Dataset\DS0001\elections_clean.dta"

global code "C:\Users\ei87\Documents\GitHub\term_limits\Code"

clear all

// Switches

local clean           0
local merge           0
local algorithm       0
local analysis        1
local handcoding      0


if `clean'==1               do "${code}/clean.do"

if `algorithm'==1           do "${code}/algorithm.do"

if `merge'==1               do "${code}/merge.do"

if `analysis'==1            do "${code}/analysis.do"

if `handcoding'==1          do "${code}/Tasks for P.do"
