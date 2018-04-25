--[[
Model: Number of Tours - Work
Based on: dpb.lua (Siyu Li, Harish Loganathan)
Type: Binary Logit
Author: Isabel Viegas
Crated: November 21, 2016
Updated: July 12, 2017

Recent calibration done by Yifei Xie
Updated: April, 2018
]]

-- COEFFICIENTS
-- one work tour as base
local beta_cons_work2 = -5 -3.9 -- -2.68

-- Person type
-- fulltime as base
local beta_parttime_work2 = 0.230
local beta_retired_work2 = 0
local beta_homemaker_work2 = 0
local beta_unemployed_work2 = 0
local beta_student_work2 = 0

-- Age group
-- adge 36 to 50 as base
-- one work tour as base
local beta_age20_work2 = -0.592
local beta_age2025_work2 = 0.105
local beta_age2635_work2 = -0.633
local beta_age5165_work2 = 0.0804
local beta_age65_work2 = 0.141

-- Gender
-- male as base
local beta_female_work2 = 0

--Personal income
local beta_INCOME_work2 = 0

--Others
local beta_LIC_work2 = 0
local beta_TRANS_work2 = -1.34

local beta_logsumNU_work2 = 0.0226
local beta_logsumU_work2 = 0.958



--choiceset
local choice = {
		1,
		2
}


-- UTILITY
local utility = {}
local function computeUtilities(params) 
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
	local usual = params.fixed_place

	local studentTypeId = params.studentTypeId
	local student_dummy = params.student_dummy
	
	local worklogsum = params:activity_logsum(1)
	local edulogsum = params:activity_logsum(2)
	local personallogsum = params:activity_logsum(3)
	local reclogsum = params:activity_logsum(4)
	local shoplogsum = params:activity_logsum(5)
	local escortlogsum = params:activity_logsum(6)

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

	-- Gender
	local female = 0
	if female_dummy == 0 then
		female = 1
	end
	
	-- Income
	local INCOME = income_mid[income_id]

	-- Transit
	local LIC = 0
	if license == true then
		LIC = 1
	end

	local TRANS = 0
	if transit == true then
		TRANS = 1
	end
	
	utility[1] = 0
	utility[2] = beta_cons_work2 + beta_parttime_work2 * parttime +
	beta_retired_work2 * retired + beta_homemaker_work2 * homemaker +
	beta_unemployed_work2 * unemployed + beta_student_work2 * student +
   	beta_age20_work2 * age20  + beta_age2025_work2 * age2025 + beta_age65_work2 * age65 +
    beta_age2635_work2 * age2635 + beta_age5165_work2 * age5165 +
    beta_INCOME_work2 * INCOME + beta_female_work2 * female +
    beta_LIC_work2 * LIC + beta_TRANS_work2 * TRANS +
    beta_logsumU_work2 * usual * worklogsum + beta_logsumNU_work2 * (1-usual) * worklogsum

end

-- availability
local availability = {1,1}


-- scales
local scale = 1 --for all choices

-- function to call from C++ preday simulator
-- params table contains data passed from C++
-- to check variable bindings in params, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function choose_ntw(params)
	computeUtilities(params) 
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	return make_final_choice(probability)
end
