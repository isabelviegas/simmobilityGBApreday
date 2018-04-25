--[[
Model: Number of Tours - Escort
Based on: dpb.lua (Siyu Li, Harish Loganathan)
Type: Binary Logit
Author: Isabel Viegas
Crated: November 21, 2016
Updated: July 12, 2017
]]

-- COEFFICIENTS
-- one escort tour as base
local beta_cons_escort2 = 0.134

-- Person type
-- fulltime as base
local beta_parttime_escort2 = 0.125
local beta_retired_escort2 = 0.376
local beta_homemaker_escort2 = 0.622
local beta_unemployed_escort2 = 0.788
local beta_student_escort2 = -0.509

-- Student Type
-- not a student as a base
local beta_preschool_escort2 = -0.0747
local beta_studentK8_escort2 = -0.278
local beta_student912_escort2 = -2.72
local beta_undergraduate_escort2 = -0.364
local beta_graduate_escort2 = 0.111
local beta_otherstudent_escort2 = -0.381

-- Age group
-- adge 36 to 50 as base
-- one escort tour as base
-- all gategories turned out to be very insignificant
local beta_age20_escort2 = 0.224
local beta_age2025_escort2 = -0.417
local beta_age2635_escort2 = -0.195
local beta_age5165_escort2 = -0.204
local beta_age65_escort2 = -1.21

-- Gender
-- male as base
local beta_female_escort2 = 0.0856

--Personal income
local beta_INCOME_escort2 = 0

--Others
local beta_LIC_escort2 = 0
local beta_TRANS_escort2 = 0

local beta_logsum_escort2 = -0.0793



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
	local fixedescorttime = params.fixed_escort_hour
	local usual = params.fixed_place

	local studentTypeId = params.studentTypeId
	local student_dummy = params.student_dummy
	
	local escortlogsum = params:activity_logsum(1)
	local escortlogsum = params:activity_logsum(2)
	local escortlogsum = params:activity_logsum(3)
	local reclogsum = params:activity_logsum(4)
	local escortlogsum = params:activity_logsum(5)
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
	utility[2] = beta_cons_escort2 + beta_parttime_escort2 * parttime +
	beta_retired_escort2 * retired + beta_homemaker_escort2 * homemaker +
	beta_unemployed_escort2 * unemployed + beta_student_escort2 * student +
	beta_preschool_escort2 * preschool + beta_studentK8_escort2 * studentK8 +
	beta_student912_escort2 * student912 + beta_undergraduate_escort2 * undergraduate +
	beta_graduate_escort2 * graduate + beta_otherstudent_escort2 * otherstudent +
   	beta_age20_escort2 * age20  + beta_age2025_escort2 * age2025 + beta_age65_escort2 * age65 +
    beta_age2635_escort2 * age2635 + beta_age5165_escort2 * age5165 +
    beta_INCOME_escort2 * INCOME + beta_female_escort2 * female +
    beta_LIC_escort2 * LIC + beta_TRANS_escort2 * TRANS +
    beta_logsum_escort2 *  escortlogsum

end

-- availability
local availability = {1,1}


-- scales
local scale = 1 --for all choices

-- function to call from C++ preday simulator
-- params table contains data passed from C++
-- to check variable bindings in params, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function choose_ntes(params)
	computeUtilities(params) 
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	return make_final_choice(probability)
end




