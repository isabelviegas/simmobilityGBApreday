--[[
Model: Number of Tours - Rec
Based on: dpb.lua (Siyu Li, Harish Loganathan)
Type: Binary Logit
Author: Isabel Viegas
Crated: November 21, 2016
Updated: July 12, 2017
]]

-- COEFFICIENTS
-- one rec tour as base
local beta_cons_rec2 = -2.85
local beta_cons_rec3 = -5.97

-- Person type
-- fulltime as base
local beta_parttime_rec2 = 0.469
local beta_retired_rec2 = 0.685
local beta_homemaker_rec2 = 0.562
local beta_unemployed_rec2 = 0.761
local beta_student_rec2 = 0.102

local beta_parttime_rec3 = 1.15
local beta_retired_rec3 = -0.171
local beta_homemaker_rec3 = 1.75
local beta_unemployed_rec3 = 1.97
local beta_student_rec3 = 1.11

-- Student Type
-- not a student as a base
local beta_preschool_rec2 = -0.583
local beta_studentK8_rec2 = 0.232
local beta_student912_rec2 = 0.227
local beta_undergraduate_rec2 = -0.107
local beta_graduate_rec2 = -0.484
local beta_otherstudent_rec2 = -9.69

local beta_preschool_rec3 = -0.583
local beta_studentK8_rec3 = -1.07
local beta_student912_rec3 = -0.476
local beta_undergraduate_rec3 = -0.790
local beta_graduate_rec3 = 1.82
local beta_otherstudent_rec3 = -9.69

-- Age group
-- adge 36 to 50 as base
-- one rec tour as base
local beta_age20_rec2 = 0
local beta_age2025_rec2 = 0
local beta_age2635_rec2 = 0
local beta_age5165_rec2 = 0 
local beta_age65_rec2 = 0 

local beta_age20_rec3 = 0
local beta_age2025_rec3 = 0
local beta_age2635_rec3 = 0
local beta_age5165_rec3 = 0 
local beta_age65_rec3 = 0

-- Gender
-- male as base
local beta_female_rec2 = 0.0877
local beta_female_rec3 = 0.0877

--Personal income
local beta_INCOME_rec2 = 0.00650
local beta_INCOME_rec3 = 0.0884

--Others
local beta_LIC_rec2 = 0.285
local beta_TRANS_rec2 = 0

local beta_LIC_rec3 = -0.230
local beta_TRANS_rec3 = 0

local beta_logsum_rec2 = 0.0755
local beta_logsum_rec3 = 0.0936



--choiceset
local choice = {
		1,
		2,
		3
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
	local fixedrectime = params.fixed_rec_hour
	local usual = params.fixed_place

	local studentTypeId = params.studentTypeId
	local student_dummy = params.student_dummy
	
	local reclogsum = params:activity_logsum(1)
	local reclogsum = params:activity_logsum(2)
	local reclogsum = params:activity_logsum(3)
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
	utility[2] = beta_cons_rec2 + beta_parttime_rec2 * parttime +
	beta_retired_rec2 * retired + beta_homemaker_rec2 * homemaker +
	beta_unemployed_rec2 * unemployed + beta_student_rec2 * student +
	beta_preschool_rec2 * preschool + beta_studentK8_rec2 * studentK8 +
	beta_student912_rec2 * student912 + beta_undergraduate_rec2 * undergraduate +
	beta_graduate_rec2 * graduate + beta_otherstudent_rec2 * otherstudent +
   	beta_age20_rec2 * age20  + beta_age2025_rec2 * age2025 + beta_age65_rec2 * age65 +
    beta_age2635_rec2 * age2635 + beta_age5165_rec2 * age5165 +
    beta_INCOME_rec2 * INCOME + beta_female_rec2 * female +
    beta_LIC_rec2 * LIC + beta_TRANS_rec2 * TRANS +
    beta_logsum_rec2 *  reclogsum
    utility[2] = beta_cons_rec3 + beta_parttime_rec3 * parttime +
	beta_retired_rec3 * retired + beta_homemaker_rec3 * homemaker +
	beta_unemployed_rec3 * unemployed + beta_student_rec3 * student +
	beta_preschool_rec3 * preschool + beta_studentK8_rec3 * studentK8 +
	beta_student912_rec3 * student912 + beta_undergraduate_rec3 * undergraduate +
	beta_graduate_rec3 * graduate + beta_otherstudent_rec3 * otherstudent +
   	beta_age20_rec3 * age20  + beta_age2025_rec3 * age2025 + beta_age65_rec3 * age65 +
    beta_age2635_rec3 * age2635 + beta_age5165_rec3 * age5165 +
    beta_INCOME_rec3 * INCOME + beta_female_rec3 * female +
    beta_LIC_rec3 * LIC + beta_TRANS_rec3 * TRANS +
    beta_logsum_rec3 *  reclogsum

end

-- availability
local availability = {1,1,1}


-- scales
local scale = 1 --for all choices

-- function to call from C++ preday simulator
-- params table contains data passed from C++
-- to check variable bindings in params, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function choose_ntr(params)
	computeUtilities(params) 
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	return make_final_choice(probability)
end



