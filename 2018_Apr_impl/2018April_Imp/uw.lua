--[[
Model: Usual Work
Based on: uw.lua (Siyu Li, Harish Loganathan)
Type: Binary Logit
Author: Isabel Viegas
Crated: January 31, 2017
Updated: August 18, 2017

Recent calibration done by Yifei Xie
Updated: April, 2018
]]

-- CONSTANS
local beta_cons_usual = 2.42
local beta_cons_unusual = 0

-- PERSON TYPES
local beta_parttime_unusual = 0.472

-- Adult age
-- age 36 to 50 as base
local beta_age20_unusual = -1.20
local beta_age2025_unusual = -0.410
local beta_age2635_unusual = 0
local beta_age5165_unusual = 0
local beta_age65_unusual = 0

-- Gender
local beta_female_unusual = -0.203

-- Income
local beta_INCOME_unusual = 0

local beta_missingincome_unusual = 0

-- Other
local beta_LIC_unusual = 0.913
local beta_TRANS_unusual = 0
local beta_MULTJOBS_unusual = 0.981
local beta_FLEXSCHED_unusual = 0.284

local beta_distance_log_unusual = 0.628

-- CHOICE SET
--1 for usual; 2 for not usual

local choice = {
	1,
	2
}

-- UTILITY
local utility = {}
local function computeUtilities(params,dbparams)
	local pid = params.person_id
	local person_type_id = params.person_type_id 
	local age_id = params.age_id
	local female_dummy = params.female_dummy
	local income_id = params.income_id
	local income_mid = {0.75,2,3,4.25,6.25,8.75,12.5,20}
	local missing_income = params.missing_income
	local license = params.car_license
	local transit = params.vanbus_license
	local fixedworktime = params.fixed_work_hour
	local student_dummy = params.student_dummy
	local studentTypeId = params.studentTypeId

	-- person type related variables
	local fulltime,parttime,disabled,retired,homemaker,unemployed,universitystudent,student515,OtherStudent = 0,0,0,0,0,0,0,0,0
	if person_type_id == 1 then
		fulltime = 1
	elseif person_type_id == 2 then 
		parttime = 1
	elseif person_type_id == 4 then 
		homemaker = 1
	elseif person_type_id == 5 then
		retired = 1
	elseif person_type_id == 6 then
		unemployed = 1
	end

	if studentTypeId == 6 then
		universitystudent = 1
	end 

	if student_dummy == 1 and age_id < 3 then
		student515 = 1
	end

	if student_dummy == 1 and universitystudent < 1 and student515 < 1 then
		OtherStudent = 1
	end 
	
	-- age group related variables
	local age20,age2025,age2635,age3650,age5165,age65,missingage = 0,0,0,0,0,0,0
	if age_id < 4 then 
		age20 = 1
	elseif age_id == 5 then 
		age2025 = 1
	elseif age_id > 4 and age_id <= 5 then
		age2635 = 1
	elseif age_id > 5 and age_id <= 9 then
		age3650 = 1
	elseif age_id > 9 and age_id <= 12 then
		age5165 = 1
	elseif age_id > 12 then 
		age65 = 1
	end

	-- gender variables
	local female = 0
	if female_dummy == 0 then
		female = 1
	end
	
	-- income related variables
	local INCOME = income_mid[income_id]
	local missingincome = 0
	if missing_income == 1 then
		missingincome = 1
	end

		-- transit variables
	local LIC = 0
	if license == true then
		LIC = 1
	end

	local TRANS = 0
	if transit == true then
		TRANS = 1
	end

	-- work related variables
	local FLEXSCHED = 0
	if fixedworktime == false then
		FLEXSCHED = 1
	end

	local MULTJOBS = 0 
	local WORKDist = 1


	utility[2] = beta_cons_unusual + beta_INCOME_unusual * INCOME +
    beta_age20_unusual * age20 + beta_age2025_unusual * age2025 +
    beta_age2635_unusual * age2635 + beta_age5165_unusual * age5165 +
    beta_age65_unusual * age65 +
    beta_parttime_unusual * parttime +
    beta_female_unusual * female +
    beta_LIC_unusual * LIC + beta_TRANS_unusual * TRANS +
    beta_distance_log_unusual * math.log(WORKDist) + beta_MULTJOBS_unusual * MULTJOBS +
    beta_FLEXSCHED_unusual * FLEXSCHED
	utility[1] = beta_cons_usual
end

-- AVAILABILITY
local availability={1,1}

-- SCALE
local scale = 1 --for all choices

function choose_uw(params,dbparams)
	computeUtilities(params,dbparams) 
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	return make_final_choice(probability)
end

