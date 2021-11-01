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
	foreach 				file in evs2014_PRDF evs2015_PRDF fevs_2016_prdf FEVS_2017_PRDF FEVS_2018_PRDF FEVS_2019_PRDF_Revised FEVS_2020_PRDF {
		import 				delimited "$data/`file'.csv", clear
		gen 				file = "`file'"
		tostring			*, replace
		
		tempfile			`file'
		save				``file'', replace
	}
	
	foreach file in evs2014_PRDF evs2015_PRDF fevs_2016_prdf FEVS_2017_PRDF FEVS_2018_PRDF FEVS_2019_PRDF_Revised {
		append 				using ``file''
	}
	
	* Compare panel info of 
	* 2020 38 core, 2014-2019 71 questions
	use "C:/Users/`c(username)'/Documents/Github/public-employment/03_Output/panel_temp.dta", clear
	drop 					if file == "FEVS_2020_PRDF"
	rename					file year
	keep agency postwt plevel2 plevel1 level1 year q* dsex dminority dsuper dleaving dagegrp dfedten
	
	** Identify year
	moss year, match("([0-9]+)") regex
	drop year _count _pos1
	rename _match1 year
	destring year, replace
	
	order agency postwt plevel1 plevel2 level1 year dsex dminority dsuper dleaving dagegrp dfedten q*
	replace plevel1 = level1 if plevel1 == ""
	drop level1
	
	// drop questions 72 - 85, which are not included 2016 onwards 
	// Year 2019 includes additional subquestions on government shutdown 
	drop q72-q84
	drop q75*
	drop q59_*
	
	// make demographic responses dummies 
	rename d* *
	rename sex male
	rename fedten yrs_exp
	foreach i in male super { 
		replace `i' = "0" if `i' == "A"
		replace `i' = "1" if `i' == "B"
	}
	replace minority = "0" if minority == "2"
	replace minority = "0" if minority == "B"
	replace minority = "1" if minority == "A"
	replace minority = "" if minority == "."
	replace leaving = "1" if leaving != "A"
	replace leaving = "0" if leaving == "A"
	
	// Make Categories more clear
	// Years of Experience
	replace yrs_exp = "5 or less" if yrs_exp == "A"
	replace yrs_exp = "6 to 14" if yrs_exp == "B"
	replace yrs_exp = "15 plus" if yrs_exp == "C"
	
	// Age Group
	replace agegrp = "Under 40" if agegrp == "A"
	replace agegrp = "40-59" if agegrp == "B"
	replace agegrp = "50-59" if agegrp == "C"
	replace agegrp = "60 or older" if agegrp == "D"
	
	// make numeric
	foreach var in male minority super leaving {
		destring `var', replace
	}
	
	// Clean the questions 
	forvalues 		i = 1/71 {
	replace			q`i' = "" if q`i' == "X" | q`i' == "."
	destring		q`i', replace
	}
	
	
	save "$output/panel_clean.dta", replace
	
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
	