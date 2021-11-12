	**********************************************
	**********************************************
	** Public Employment 
	** Created by: Yi Ning Wong on 10/31/2021
	** Modified by: Yi Ning Wong on 10/31/2021
	** Purpose: Create summary stats from 2020 file
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
		use "$output/2020_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency year average*
		
		export excel "$output/positive_responses_2020.xlsx", sheet("By Agency", modify) firstrow(variable)
		
		
		
	**********************************************
		// By Agency + Gender
		use "$output/2020_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency male year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency male year average*
		
		export excel "$output/positive_responses_2020.xlsx", sheet("By Gender", modify) firstrow(variable)
		
			**********************************************
		// By Agency + race
		use "$output/2020_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency race year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency race year average*
		
		export excel "$output/positive_responses_2020.xlsx", sheet("By Race", modify) firstrow(variable)
		
				**********************************************
		// By Agency + hisp
		use "$output/2020_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency hisp year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency hisp year average*
		
		export excel "$output/positive_responses_2020.xlsx", sheet("By Hispanic", modify) firstrow(variable)
		
		**********************************************
		// By Agency + Minority + Gender
		use "$output/2020_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency race male year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency race year average*
		
		export excel "$output/positive_responses_2020.xlsx", sheet("By Gender and Race", modify) firstrow(variable)
		
		**********************************************
		// By Agency + Seniority
		use "$output/2020_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency super year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency super year average*
		
		export excel "$output/positive_responses_2020.xlsx", sheet("By Seniority", modify) firstrow(variable)

			**********************************************
		// By Agency + Experience
		use "$output/2020_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency year average*
		
		export excel "$output/positive_responses_2020.xlsx", sheet("By Years of Exp", modify) firstrow(variable)
		
		// By Agency + Minority + Gender + Supervisor
		use "$output/2020_clean_dummy.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (sum) N, by(agency)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency race year average*
		
		
************************************************************************************************************
** Export Average Scores
************************************************************************************************************

	// By Agency
	//foreach panel in panel_clean_dummy panel_clean {
		use "$output/2020_clean.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency year average*
		
		export excel "$output/average_responses_2020.xlsx", sheet("By Agency", modify) firstrow(variable)
		
		
		**********************************************
		// By Agency + Race
		use "$output/2020_clean.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency race year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency race year average*
		
		export excel "$output/average_responses.xlsx", sheet("By Race", modify) firstrow(variable)
		
	**********************************************
		// By Agency + Gender
		use "$output/2020_clean.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency male year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency male year average*
		
		export excel "$output/average_responses_2020.xlsx", sheet("By Gender", modify) firstrow(variable)
		
			**********************************************
		// By Agency + Hisp
		use "$output/2020_clean.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency hisp year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency hisp year average*
		
		export excel "$output/average_responses_2020.xlsx", sheet("By Hispanic", modify) firstrow(variable)
		
		**********************************************
		// By Agency + Race + Gender
		use "$output/2020_clean.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency race male year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency race male year average*
		
		export excel "$output/average_responses_2020.xlsx", sheet("By Gender and Race", modify) firstrow(variable)
		
		**********************************************
		// By Agency + Seniority
		use "$output/2020_clean.dta", clear
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency super year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency super year average*
		
		export excel "$output/average_responses_2020.xlsx", sheet("By Seniority", modify) firstrow(variable)

			**********************************************
		// By Agency + Experience
		use "$output/2020_clean.dta", clear
		
		// Create a variable for number of observations
		gen N = 1

		// % of positive responses
	 	collapse (mean) q1-v24 (sum) N, by(agency yrs_exp year)
		
		// total average 
		egen average = rowmean(q1-v24)
		egen average_core = rowmean(q1-q71)
		egen average_covid = rowmean(v21_01-v24)
		
		order agency yrs_exp year average*
		
		export excel "$output/average_responses_2020.xlsx", sheet("By Years of Exp", modify) firstrow(variable)


		
		