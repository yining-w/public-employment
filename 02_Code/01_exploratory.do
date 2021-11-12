	**********************************************
	**********************************************
	** Public Employment 
	** Created by: Yi Ning Wong on 10/31/2021
	** Modified by: Yi Ning Wong on 10/31/2021
	** Purpose: Clean and append FEVS survey results from 2014 - 2019
	**********************************************
	**********************************************
	* General program setup
	*-----------------------------------------------------------------------------
	  clear 				all
	  capture log 			close _all
	  set more 				off
	  set varabbrev 			off, permanently
	  set maxvar 			10000
	  version 				15
	*-----------------------------------------------------------------------------
	* Set globals
	  global 				data "C:/Users/`c(username)'/Documents/Github/public-employment/01_Data"
	  global 				output  "C:/Users/`c(username)'/Documents/Github/public-employment/03_Output"

	*-----------------------------------------------------------------------------
	* Install packages
	ssc install moss
	**********************************************
	* Cleaning to Panel
	*-----------------------------------------------------------------------------	
	foreach 				file in EVS2010_PRDF EVS2011_PRDF_2 evs2012_PRDF evs2013_PRDF evs2014_PRDF evs2015_PRDF fevs_2016_prdf FEVS_2017_PRDF FEVS_2018_PRDF FEVS_2019_PRDF_Revised {
		import 				delimited "$data/`file'.csv", clear
		gen 				file = "`file'"
		tostring			*, replace
		
		tempfile			`file'
		save				``file'', replace
	}
	
	foreach file in EVS2010_PRDF EVS2011_PRDF_2 evs2012_PRDF evs2013_PRDF evs2014_PRDF evs2015_PRDF fevs_2016_prdf FEVS_2017_PRDF FEVS_2018_PRDF {
		append 				using ``file'', force
	}
	drop userid
	
	* Compare panel info of 
	* 2020 38 core, 2014-2019 71 questions
// 	use "C:/Users/`c(username)'/Documents/Github/public-employment/03_Output/panel_temp.dta", clear
// 	drop 					if file == "FEVS_2020_PRDF"
	rename					file year
	keep agency postwt plevel2 plevel1 level1 year q* dsex dminority dsuper dleaving dfedten subelem
	
	// harmonize variables
	replace plevel1 = level1 if level1 != ""
	drop level1
	
	** Identify year
	moss year, match("([0-9]+)") regex
	drop year _count _pos1
	rename _match1 year
	destring year, replace
	
	order agency postwt plevel1 plevel2 year dsex dminority dsuper dleaving dfedten q*
	
	replace plevel1 = subelem if year <2013
	drop subelem
	

	
	// drop questions 72 - 85, which are not included 2016 onwards 
	// Year 2019 includes additional subquestions on government shutdown 
	drop q72-q84
	drop q75*
// 	drop q59_*
	
	// make demographic responses dummies 
	rename d* *
	rename sex male
	rename fedten yrs_exp
	
	foreach i in male super { 
		replace `i' = "0" if `i' == "A"
		replace `i' = "1" if `i' == "B"
		replace `i' = "1" if `i' == "C"
	}
	
	// asked in 2011 - 2019
	replace minority = "0" if minority == "2"
	replace minority = "0" if minority == "B"
	replace minority = "1" if minority == "A"
	replace minority = "" if minority == "."
	
	// create a categorical to look at whether respondent is leaving 
	// to stay in the federal government or not
	gen leaving2 = leaving
	replace leaving2 = "1" if leaving == "C" | leaving == "D"
	replace leaving2 = "2" if leaving == "B"
	replace leaving2 = "0" if leaving == "A"
	label var leaving2 "Leaving to stay in fed gov't versus not'"
	
	
	// create a dummy that collapses all the leaving answers
	replace leaving = "1" if leaving != "A"
	replace leaving = "0" if leaving == "A"	

	
	// Years of Experience
	replace yrs_exp = "10 or less" if yrs_exp == "A" 
	replace yrs_exp = "10 to 20" if yrs_exp == "B" & year > 2016 
	replace yrs_exp = "20+" if yrs_exp == "C" & year > 2016
	
	// collapse groupings from other years 
	replace yrs_exp = "10 or less" if year <= 2012 & (yrs_exp == "B" | yrs_exp == "C" | yrs_exp == "D")
	replace yrs_exp = "10 to 20" if year <= 2012 & (yrs_exp == "E" | yrs_exp == "C" | yrs_exp == "F")
	replace yrs_exp = "20+" if year <= 2012 & yrs_exp == "G"
	label var yrs_exp  "Years of experience from 2010-2012, 2017-2020"
	
	// years of experience dummy
	gen yrs_exp2 = yrs_exp
	replace yrs_exp2 = "1" if yrs_exp2 == "20+"
	replace yrs_exp2 = "0" if yrs_exp2 != "20+" & yrs_exp2 != ""
	label var yrs_exp "20+ Years of experience from 2010-2012, 2017-2020"
	
	// make numeric
	foreach var in male minority super leaving leaving2 yrs_exp yrs_exp2{
		destring `var', replace
	}
	
 	// Clean the questions 
 	forvalues 		i = 1/71 {
 	replace			q`i' = "" if q`i' == "X" | q`i' == "."
 	destring		q`i', replace
 	}
	
	
// 	save "$output/panel_clean.dta", replace
	
	// save a version to allow % of postive response 
	forvalues i = 1/71 {
	  replace			q`i' = 0 if q`i' < 4 
	  replace			q`i' = 1 if q`i' >= 4 

	}
	save "$output/panel_clean_dummy.dta", replace

	* Outputs: 
	** Cleaned Panel Data
	* Cleaned 2020 Data
	* % of Positive Responses by agency
		* by sex, minority, age group, seniority
	* % of Positive Responses by subagency
	* identified by size
	* All the above by Average Score 
	