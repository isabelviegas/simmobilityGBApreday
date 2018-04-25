--[[
Model: Day Pattern Travel
Based on: dpb.lua (Siyu Li, Harish Loganathan)
Type: Binary Logit
Author: Isabel Viegas
Created: January 31, 2017
Updated: August 18, 2017

Recent calibration done by Yifei Xie
Updated: April, 2018
]]

-- COEFFICIENTS
local cons_travel = -10.67 - 15

local beta_parttime_travel = -3.31
local beta_retired_travel = 2.66
local beta_homemaker_travel = -1.30
local beta_unemployed_travel = 4.25
local beta_student_travel = 2.08

local beta_preschool_travel = 0
local beta_studentK8_travel = 2.79
local beta_student912_travel = -3.33
local beta_undergraduate_travel = 0.79
local beta_graduate_travel = 1.78
local beta_otherstudent_travel = 0

local beta_age20_travel = -2.76
local beta_age2025_travel = -4.76
local beta_age2635_travel = -0.73
local beta_age5165_travel = 3.17
local beta_age65_travel = -5.09

local beta_female_travel = 2.76
local beta_INCOME_travel = 0


local beta_dptlogsum_travel = 14.33
local beta_dpslogsum_travel = -13.91

-- CHOICE SET
-- 1 for notravel; 2 for travel
local choice = {1, 2}

-- UTILITY
local utility = {}
local function computeUtilities(params) 
local person_type_id = params.person_type_id 
	local age_id = params.age_id
	local female_dummy = params.female_dummy
	local income_id = params.income_id
	local income_mid = {0.75,2,3,4.25,6.25,8.75,12.5,20}
	local missing_income = params.missing_income
	local license = params.has_driving_licence
	local studentTypeId = params.studentTypeId
	local transit = params.vanbus_license
	local fixedworktime = params.fixed_work_hour

	local dpt_logsum = params.dptour_logsum
	local dps_logsum = params.dpstop_logsum

	-- Person type and student type
	local fulltime,parttime,student,homemaker,retired,unemployed,preschool,studentK8,student912,undergraduate,graduate,otherstudent = 0,0,0,0,0,0,0,0,0,0,0,0
	
	if person_type_id == 1 then
		fulltime = 1
	elseif person_type_id == 2 then 
		parttime = 1
	elseif person_type_id == 3 then
		student = 1
	elseif person_type_id == 4 then 
		homemaker = 1
	elseif person_type_id == 5 then
		retired = 1
	elseif person_type_id == 6 then
		unemployed = 1
	end

	if studentTypeId == 1 then
		preschool = 1
	elseif studentTypeId == 2 then
		studentK8 = 1
	elseif studentTypeId == 3 then
		student912 = 1
	elseif studentTypeId == 4 then
		undergraduate = 1
	elseif studentTypeId == 5 then
		graduate = 1
	elseif studentTypeId == 6 then
		otherstudent = 1
	end 
	
	-- Age group 
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
	
	-- Income
	local INCOME = income_mid[income_id]

	-- Gender 
	local female = 0
	if female_dummy == 0 then
		female = 1
	end

	-- License
	local LIC = 0
	if license == true then
		LIC = 1
	end

	-- Transit pass
	local TRANS = 0
	if transit == true then
		TRANS = 1
	end

	-- Work related 
	local FLEXSCHED = 0
	if fixedworktime == false then
		FLEXSCHED = 1
	end
			
	utility[1] = 0
			
	utility[2] = cons_travel + beta_parttime_travel * parttime + beta_retired_travel * retired + 
	beta_homemaker_travel * homemaker + beta_unemployed_travel * unemployed +
	beta_preschool_travel * preschool + beta_studentK8_travel * studentK8 + beta_student912_travel * student912 +
	beta_undergraduate_travel * undergraduate + beta_graduate_travel * graduate + beta_otherstudent_travel * otherstudent +
	beta_age20_travel * age20 + beta_age2025_travel * age2025 +
	beta_age2635_travel * age2635 + beta_age5165_travel * age5165 +
	beta_age65_travel * age65 + beta_female_travel * female +
	beta_INCOME_travel * INCOME +
	beta_dptlogsum_travel * dpt_logsum + beta_dpslogsum_travel * dps_logsum
	-- print("not travel:", utility[1], "travel:", utility[2])

end

--availability
local availability = {1,1}

--scale
local scale = 1

-- function to call from C++ preday simulator
-- params table contains data passed from C++
-- to check variable bindings in params, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function choose_dpb(params)
	computeUtilities(params) 
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	idx = make_final_choice(probability)
	return choice[idx]
end

-- function to call from C++ preday simulator for logsums computation
-- params table contain person data passed from C++
-- to check variable bindings in params, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function compute_logsum_dpb(params)
	computeUtilities(params) 
	return compute_mnl_logsum(utility, availability)
end
