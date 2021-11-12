	**********************************************
	**********************************************
	** Public Employment 
	** Created by: Yi Ning Wong on 10/31/2021
	** Modified by: Yi Ning Wong on 10/31/2021
	** Purpose: Create summary stats from appended files, (second iteration)
	**********************************************
	**********************************************
	* General program setup
	*-----------------------------------------------------------------------------
	  clear 						all
	  capture log 			close _all
	  set more 					off
	  set varabbrev 		off, permanently
	  set maxvar 				10000
	  version 					15
	*-----------------------------------------------------------------------------
	* Set globals
	  global 				data "C:/Users/`c(username)'/Documents/Github/public-employment/01_Data"
	  global 				output  "C:/Users/`c(username)'/Documents/Github/public-employment/03_Output"

	*-----------------------------------------------------------------------------
	
	**********************************************
	// By Agency
	//foreach panel in panel_clean_dummy panel_clean {
		use "$output/panel_clean_dummy.dta", clear
		replace yrs_exp = "" if year >= 2013 & year <= 2016
		merge m:1 agency using "$output/all_agencies.dta", nogen
		save "$output/panel_clean_dummy.dta", replace
		order agency q*
		
		// Create a variable for number of observations
		gen N = 1
		
		// leaving if due to COVID 
		gen leaving_covid = 1 if leaving == 1 & leavingc == "A"
		replace leaving_covid = 0 if leaving == 1 & leavingc == "B"

		// not leaving if due to COVID
		gen staying_covid = 1 if leaving == 0 & leavingc == "A"
		replace staying_covid = 0 if leaving == 0 & leavingc == "B"

		// % of positive responses
	 	collapse (mean) leaving leaving_covid staying_covid q1-q71 (sum) N, by(agency name year yrs_exp)
		
		// total average 
// 		egen average = rowmean(q1-q68)
		egen average_core = rowmean(q1-q71)
		
		order agency year average*
		
		export excel "$output/positive_responses_2.xlsx", sheet("By Agency", modify) firstrow(variable)
		
		
		**********************************************
		// By Subagency
		use "$output/panel_clean_dummy.dta", clear
		order agency q*

		
		// Create a variable for number of observations
		gen N = 1

		// leaving if due to COVID 
		gen leaving_covid = 1 if leaving == 1 & leavingc == "A"
		replace leaving_covid = 0 if leaving == 1 & leavingc == "B"

		// not leaving if due to COVID
		gen staying_covid = 1 if leaving == 0 & leavingc == "A"
		replace staying_covid = 0 if leaving == 0 & leavingc == "B"

		// % of positive responses
	 	collapse (mean) leaving leaving_covid staying_covid q1-q71 (sum) N (first) agency name, by(plevel1 year yrs_exp)
		
		// total average 
// 		egen average = rowmean(q1-q68)
		egen average_core = rowmean(q1-q71)
		
		order plevel1 year average*
		
		export excel "$output/positive_responses_2.xlsx", sheet("By Subagency", modify) firstrow(variable)
		
		**********************************************
		// looking at "leaving" as a group
	use "$output/panel_clean_dummy.dta", clear
		order agency q*

		
		// Create a variable for number of observations
		gen N = 1


		// % of positive responses
	 	collapse (mean) q1-q71 (sum) N (first) agency name, by(plevel1 leaving year yrs_exp)
		
		// total average 
// 		egen average = rowmean(q1-q68)
		egen average_core = rowmean(q1-q71)
		
		order plevel1 year average*
		
		export excel "$output/positive_responses_2.xlsx", sheet("By Subagency Leaving", modify) firstrow(variable)
		
		**********************************************
		// looking at "leaving" as a group
		use "$output/panel_clean_dummy.dta", clear
		order agency q*
		
		// Create a variable for number of observations
		gen N = 1


		// % of positive responses
	 	collapse (mean) q1-q71 (sum) N (first) name, by(agency leaving year yrs_exp)
		
		// total average 
// 		egen average = rowmean(q1-q68)
		egen average_core = rowmean(q1-q71)
		
		order agency year average*
		
		export excel "$output/positive_responses_2.xlsx", sheet("By Agency Leaving", modify) firstrow(variable)
		
