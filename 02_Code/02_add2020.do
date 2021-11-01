	**********************************************
	**********************************************
	** Public Employment 
	** Created by: Yi Ning Wong on 10/31/2021
	** Modified by: Yi Ning Wong on 10/31/2021
	** Purpose: Add 2020 Analysis
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

	*-----------------------------------------------------------------------------'
			import 				delimited "$data/FEVS_2020_PRDF.csv", clear
			gen						year = 2020
			
			// no minority question, but race question in 2020
			keep agency postwt year q* dsex drno dhisp dsuper dleaving* dagegrp dfedten v*
			
			*for COVID questions - assign different variable names 
			rename q58 q58_c

			forval i = 60/64 {
			  rename q`i' q`i'_c
			}
			
			forval i = 1/6 {
			  rename q59_0`i' q59_0`i'_c
			}
			
			
			// make numeric
			forval		i = 1/38 {
			  tostring		q`i', replace
			  replace			q`i' = "" if q`i' == "X" | q`i' == "."
				destring		q`i', replace
	}
	
			// new question, non covid related
			drop q11
	
			// make consistent demographic variables 
			rename d* *
			
			rename sex male
			rename fedten yrs_exp
			foreach i in male super { 
				replace `i' = "0" if `i' == "A"
				replace `i' = "1" if `i' == "B"
			}
			
			foreach i in a b c {
			replace leaving`i' = "1" if leaving`i' != "A"
			replace leaving`i' = "0" if leaving`i' == "A"
			}
			
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
			foreach var in male super leavinga leavingb leavingc {
				destring `var', replace
			}
			
			// make question numbers align with other years
			rename q38 q71
			rename q37 q70
			rename q36 q69
			rename q35 q65
			rename q34 q64
			rename q33 q63
			rename q32 q62
			rename q31 q61
			rename q30 q60
			rename q29 q58
			rename q28 q56
			rename q27 q54
			rename q26 q53
			rename q25 q52
			rename q24 q51
			rename q23 q49
			rename q22 q48
			rename q21 q47
			rename q20 q45
			rename q19 q42
			rename q18 q41 
			rename q17 q40
			rename q16 q39
			rename q15 q35
			rename q14 q31 
			rename q13 q29
			rename q12 q24 
			rename q10 q23 
			rename q9 q20
			rename q8 q17
			rename q7 q12
			rename q6 q11
			rename q4 q6
			rename q3 q4 	
			rename q2 q3 
			
			// destring other covid questions
			foreach i in 58 60 61 61 62 63 64 {
			  tostring 		q`i'_c, replace
			  replace			q`i'_c = "" if q`i'_c == "X" | q`i'_c == "."
				destring		q`i'_c, replace
			}
			
			rename rno race
			
			save "$output/2020_clean.dta", replace
			
			// create a version compatible with previous years and not including covid questions
			keep q1-q71 agency race hisp agegrp super yrs_exp male leaving* postwt year
			
			append using "$output/panel_clean.dta"
			
			save "$output/panel_clean.dta", replace
			
			// create a full 2020 version with covid questions
			use "$output/2020_clean.dta", clear
			
			// with covid questions
			foreach var of varlist v1-v20 {
			  tostring 		`var', replace
			  replace			`var' = "" if `var' == "X" | `var' == "."
				destring		`var', replace

		}
		
		foreach var in v23 v24 {
			 replace			`var' = "" if `var' == "X" | `var' == "." | `var' == "Y" 
			 destring		`var', replace
							}


		
		// save final 2020 version
		save "$output/2020_clean.dta", replace

		// create a dummy version		
			foreach var of varlist q1-q58_c {
			replace			`var' = 0 if `var' < 4 
			replace			`var' = 1 if `var' >= 4 

		}
				
			
		foreach var of varlist q60_c-q64_c {
	  replace			`var' = 0 if `var' < 4 
	  replace			`var' = 1 if `var' >= 4 

	}
	
		foreach var of varlist v23-v24 {
			replace			`var' = 0 if `var' < 4 
			replace			`var' = 1 if `var' >= 4 

	}

	save "$output/2020_clean_dummy.dta", replace
	
	use "$output/2020_clean_dummy.dta", clear
	
	append using "$output/panel_clean_dummy.dta"
	
	// drop covid questions
	drop v* q*_0*_c *_c
			
	save "$output/panel_clean_dummy.dta", replace

			
			
			
