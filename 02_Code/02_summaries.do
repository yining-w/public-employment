	**********************************************
	**********************************************
	** Public Employment 
	** Created by: Yi Ning Wong on 10/31/2021
	** Modified by: Yi Ning Wong on 10/31/2021
	** Purpose: Create summary stats from appended files
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
	
	**********************************************
	// By Agency
	//foreach panel in panel_clean_dummy panel_clean {
		use "$output/panel_clean_dummy.dta", clear
		order agency q*
		save "$output/panel_clean_dummy.dta", replace
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-q68 (sum) N, by(agency year)
		
		// total average 
		egen average = rowmean(q1-q68)
		egen average_core = rowmean(q1-q71)
		
		order agency year average*
		
		export excel "$output/positive_responses.xlsx", sheet("By Agency", modify) firstrow(variable)
		
		
		**********************************************
		// By Subagency
		use "$output/panel_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-q68 (sum) N, by(plevel1 year)
		
		// total average 
		egen average = rowmean(q1-q68)
		egen average_core = rowmean(q1-q71)
		
		order plevel1 year average*
		
		export excel "$output/positive_responses.xlsx", sheet("By Subagency", modify) firstrow(variable)
		
	**********************************************
		// By Agency + Gender
		use "$output/panel_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-q68 (sum) N, by(agency male year)
		
		// total average 
		egen average = rowmean(q1-q68)
		egen average_core = rowmean(q1-q71)
		
		order agency male year average*
		
		export excel "$output/positive_responses.xlsx", sheet("By Gender", modify) firstrow(variable)
		
			**********************************************
		// By Agency + Minority
		use "$output/panel_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1
		
		// % of positive responses
	 	collapse (mean) q1-q68 (sum) N, by(agency minority year)
		
		// total average 
		egen average = rowmean(q1-q68)
		egen average_core = rowmean(q1-q71)
		
		
		order agency minority year average*
		
		export excel "$output/positive_responses.xlsx", sheet("By Minority", modify) firstrow(variable)
		
		**********************************************
		// By Agency + Minority + Gender
		use "$output/panel_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-q68 (sum) N, by(agency male minority year)
		
		// total average 
		egen average = rowmean(q1-q68)
		egen average_core = rowmean(q1-q71)

		
		order agency minority male year average*
		
		export excel "$output/positive_responses.xlsx", sheet("By Gender and Minority", modify) firstrow(variable)
		
		**********************************************
		// By Agency + Seniority
		use "$output/panel_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-q68 (sum) N, by(agency super year)
		
		// total average 
		egen average = rowmean(q1-q68)
		egen average_core = rowmean(q1-q71)
		
		order agency super year average*
		
		export excel "$output/positive_responses.xlsx", sheet("By Seniority", modify) firstrow(variable)

			**********************************************
		// By Agency + Experience
		use "$output/panel_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-q68 (sum) N, by(agency yrs_exp year)
		
		// total average 
		egen average = rowmean(q1-q68)
		egen average_core = rowmean(q1-q71)
		
		order agency yrs_exp year average*
		
		export excel "$output/positive_responses.xlsx", sheet("By Years of Exp", modify) firstrow(variable)
		
		
************************************************************************************************************
** Export Average Scores
************************************************************************************************************

	// By Agency
	//foreach panel in panel_clean_dummy panel_clean {
		use "$output/panel_clean.dta", clear
		
		order agency q*
		save "$output/panel_clean.dta", replace
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-68 (sum) N, by(agency year)
		
		// total average 
		egen average_core = rowmean(q1-q71)
		egen average = rowmean(q1-q68)
		
		order agency year average*
		
		export excel "$output/average_responses.xlsx", sheet("By Agency", modify) firstrow(variable)
		
		
		**********************************************
		// By Subagency
		use "$output/panel_clean.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-68 (sum) N, by(plevel1 year)
		
		// total average 
		egen average_core = rowmean(q1-q71)
		egen average = rowmean(q1-q68)
		
		order plevel1 year average*
		
		export excel "$output/average_responses.xlsx", sheet("By Subagency", modify) firstrow(variable)
		
	**********************************************
		// By Agency + Gender
		use "$output/panel_clean.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-68 (sum) N, by(agency male year)
		
		// total average 
		egen average_core = rowmean(q1-q71)
		egen average = rowmean(q1-q68)
		
		order agency male year average*
		
		export excel "$output/average_responses.xlsx", sheet("By Gender", modify) firstrow(variable)
		
			**********************************************
		// By Agency + Minority
		use "$output/panel_clean.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-68 (sum) N, by(agency minority year)
		
		// total average 
		egen average_core = rowmean(q1-q71)
		egen average = rowmean(q1-q68)
		
		order agency minority year average*
		
		export excel "$output/average_responses.xlsx", sheet("By Minority", modify) firstrow(variable)
		
		**********************************************
		// By Agency + Minority + Gender
		use "$output/panel_clean.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-68 (sum) N, by(agency gender year)
		
		// total average 
		egen average_core = rowmean(q1-q71)
		egen average = rowmean(q1-q68)
		
		order agency minority gender year average*
		
		export excel "$output/average_responses.xlsx", sheet("By Gender and Minority", modify) firstrow(variable)
		
		**********************************************
		// By Agency + Seniority
		use "$output/panel_clean.dta", clear
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-68 (sum) N, by(agency super year)
		
		// total average 
		egen average_core = rowmean(q1-q71)
		egen average = rowmean(q1-q68)
		
		
		order agency super year average*
		
		export excel "$output/average_responses.xlsx", sheet("By Seniority", modify) firstrow(variable)

			**********************************************
		// By Agency + Experience
		use "$output/panel_clean.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-68 (sum) N, by(agency yrs_exp year)
		
		// total average 
		egen average_core = rowmean(q1-q71)
		egen average = rowmean(q1-q68)
		
		order agency yrs_exp year average*
		
		export excel "$output/average_responses.xlsx", sheet("By Years of Exp", modify) firstrow(variable)


		
		