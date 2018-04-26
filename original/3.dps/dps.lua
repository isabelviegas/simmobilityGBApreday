--[[
Model: Day Pattern Stops
Based on: dpb.lua (Siyu Li, Harish Loganathan)
Author: Isabel Viegas
Crated: January 22, 2017
Updated: July 20, 2017
]]

-- COEFFICIENTS

-- Tour Constants
local beta_stop_work = -3.79
local beta_stop_edu = -8.29
local beta_stop_personal = -4.01
local beta_stop_rec = -3.96
local beta_stop_shop = -4.33
local beta_stop_escort = -4.76

-- Person type
-- fulltime as a base
-- work as a base
local beta_parttime_work = 0
local beta_parttime_edu = 0.454
local beta_parttime_personal = 0.194
local beta_parttime_rec = 0.139
local beta_parttime_shop = 0.382
local beta_parttime_escort = 0

local beta_retired_work = 0
local beta_retired_edu = 0.689
local beta_retired_personal = 0.396
local beta_retired_rec = 0.369
local beta_retired_shop = 0.845
local beta_retired_escort = -1.12

local beta_homemaker_work = 0
local beta_homemaker_edu = 0
local beta_homemaker_personal = 0.346
local beta_homemaker_rec = 0.395
local beta_homemaker_shop = 0.893
local beta_homemaker_escort = 0

local beta_unemployed_work = 0
local beta_unemployed_edu = 0
local beta_unemployed_personal = 0.583
local beta_unemployed_rec = 0
local beta_unemployed_shop = 0.698
local beta_unemployed_escort = 0

local beta_preschool_work = 0
local beta_preschool_edu = 3.24
local beta_preschool_personal = -1.38
local beta_preschool_rec = 0
local beta_preschool_shop = 0
local beta_preschool_escort = 0.780

local beta_studentK8_work = 0 
local beta_studentK8_edu = 2.84
local beta_studentK8_personal = -0.455
local beta_studentK8_rec = 0
local beta_studentK8_shop = 0
local beta_studentK8_escort = 0.897

local beta_student912_work = 0
local beta_student912_edu = 3.10
local beta_student912_personal = -0.705
local beta_student912_rec = 0
local beta_student912_shop = -0.511
local beta_student912_escort = 0

local beta_undergraduate_work = 0
local beta_undergraduate_edu = 3.10
local beta_undergraduate_personal = -0.185
local beta_undergraduate_rec = 0
local beta_undergraduate_shop = 0
local beta_undergraduate_escort = -0.428

local beta_graduate_work = 0
local beta_graduate_edu = 0
local beta_graduate_personal = 0
local beta_graduate_rec = 0
local beta_graduate_shop = 0
local beta_graduate_escort = 0

local beta_otherstudent_work = 0
local beta_otherstudent_edu = 0
local beta_otherstudent_personal = 0
local beta_otherstudent_rec = 0
local beta_otherstudent_shop = 0
local beta_otherstudent_escort = 0

-- Age group
-- under 20 and over 65 is a base
-- Work as a base

local beta_age20_work = 0
local beta_age20_edu = 0.964
local beta_age20_personal = -0.263
local beta_age20_rec = 0.231
local beta_age20_shop = -0.314
local beta_age20_escort = -1.12

local beta_age2025_work = 0
local beta_age2025_edu = 1.40
local beta_age2025_personal = -0.432
local beta_age2025_rec = 0.306
local beta_age2025_shop = -0.235
local beta_age2025_escort = -1.45

local beta_age2635_work = 0
local beta_age2635_edu = 1.40
local beta_age2635_personal = -0.144
local beta_age2635_rec = 0
local beta_age2635_shop = -0.202
local beta_age2635_escort = -0.301

local beta_age5165_work = 0
local beta_age5165_edu = 0
local beta_age5165_personal = 0.135
local beta_age5165_rec = 0
local beta_age5165_shop = 0.227
local beta_age5165_escort = -0.824

local beta_age65_work = 0
local beta_age65_edu = 0
local beta_age65_personal = 0
local beta_age65_rec = 0
local beta_age65_shop = 0
local beta_age65_escort = 0 

-- Gender
-- male as a base
-- work as a base
local beta_female_work = 0
local beta_female_edu = 0
local beta_female_personal = 0
local beta_female_rec = 0
local beta_female_shop = 0.252 
local beta_female_escort = 0.198

-- Income
local beta_INCOME_work = 0
local beta_INCOME_edu = -0.0124
local beta_INCOME_personal = -0.0132
local beta_INCOME_rec = 0.00780
local beta_INCOME_shop = 0
local beta_INCOME_escort = 0.0271

local beta_LIC_work = 0
local beta_LIC_edu = -0.631
local beta_LIC_personal = 0.0936
local beta_LIC_rec = 0.149
local beta_LIC_shop = 0
local beta_LIC_escort = 0.956

local beta_TRANS_work = 0
local beta_TRANS_edu = 0
local beta_TRANS_personal = 0
local beta_TRANS_rec = 0
local beta_TRANS_shop = 0
local beta_TRANS_escort = -0.258

-- Additional constants
-- onestop as base
local beta_onestop = 0
local beta_twostops = 1.91
local beta_threestops = 0
local beta_fourstops = 0

-- Combination constants
local beta_workedu_ss = 0
local beta_workpersonal_ss = 1.76
local beta_workrec_ss = 1.46
local beta_workshop_ss = 1.01
local beta_workescort_ss = 2.54
local beta_edupersonal_ss = 1.82
local beta_edurec_ss = 1.99
local beta_edushop_ss = 0.816
local beta_eduescort_ss = 3.48
local beta_personalrec_ss = 1.91
local beta_personalshop_ss = 2.26
local beta_personalescort_ss = 1.38
local beta_recshop_ss = 2.26
local beta_recescort_ss = 1.71
local beta_shopescort_ss = 1.60

-- choiceset 
local choice = {
		{1,0,0,0,0,0},
		{0,1,0,0,0,0},
		{0,0,1,0,0,0},
		{0,0,0,1,0,0},
		{0,0,0,0,1,0},
		{0,0,0,0,0,1},
		{1,1,0,0,0,0},
		{1,0,1,0,0,0},
		{1,0,0,1,0,0},
		{1,0,0,0,1,0},
		{1,0,0,0,0,1},
		{0,1,1,0,0,0},
		{0,1,0,1,0,0},
		{0,1,0,0,1,0},
		{0,1,0,0,0,1},
		{0,0,1,1,0,0},
		{0,0,1,0,1,0},
		{0,0,1,0,0,1},
		{0,0,0,1,1,0},
		{0,0,0,1,0,1},
		{0,0,0,0,1,1},
		{1,1,1,0,0,0},
		{1,1,0,1,0,0},
		{1,1,0,0,1,0},
		{1,1,0,0,0,1},
		{1,0,1,1,0,0},
		{1,0,1,0,1,0},
		{1,0,1,0,0,1},
		{1,0,0,1,1,0},
		{1,0,0,1,0,1},
		{1,0,0,0,1,1},
		{0,1,1,1,0,0},
		{0,1,1,0,1,0},
		{0,1,1,0,0,1},
		{0,1,0,1,1,0},
		{0,1,0,1,0,1},
		{0,1,0,0,1,1},
		{0,0,1,1,1,0},
		{0,0,1,1,0,1},
		{0,0,1,0,1,1},
		{0,0,0,1,1,1},
		{0,0,1,1,1,1},
		{0,1,0,1,1,1},
		{0,1,1,0,1,1},
		{0,1,1,1,0,1},
		{0,1,1,1,1,0},
		{1,0,0,1,1,1},
		{1,0,1,0,1,1},
		{1,0,1,1,0,1},
		{1,0,1,1,1,0},
		{1,1,0,0,1,1},
		{1,1,0,1,0,1},
		{1,1,0,1,1,0},
		{1,1,1,0,0,1},
		{1,1,1,0,1,0},
		{1,1,1,1,0,0}}        

-- Inclusion of purpose in tour option
local WORK = {1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1}
local EDU = {0,1,0,0,0,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1}
local PERSONAL = {0,0,1,0,0,0,0,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,1,1,0,0,0,1,1,1,0,1,0,1,1,1,0,1,1,1,0,0,0,1,1,1}
local REC = {0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,0,1,1,0,0,1,0,0,1,0,0,1,1,0,1,0,0,1,1,0,1,1,0,1,1,1,0,1,1,1,0,1,1,0,1,1,0,0,1}
local SHOP = {0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,1,0,1,0,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,1,1,1,1,0,1,1,1,0,1,1,0,1,0,1,0}
local ESCORT = {0,0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,1,1,0,0,0,1,0,0,1,0,1,1,0,0,1,0,1,1,0,1,1,1,1,1,1,1,0,1,1,1,0,1,1,0,1,0,0}

-- Number of tours
local OneStop = {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local TwoStops = {0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local ThreeStops = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local FourStops = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

-- Tour interactions 
local WORK_EDU = {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1}
local WORK_PERSONAL = {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1}
local WORK_REC = {0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,0,1,1,0,0,1}
local WORK_SHOP = {0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,1,0,1,0}
local WORK_ESCORT = {0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,0,1,0,0}
local EDU_PERSONAL = {0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1}
local EDU_REC = {0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,1,1,0,0,1}
local EDU_SHOP = {0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,1,1,0,1,0,0,0,0,1,0,1,0,1,0}
local EDU_ESCORT = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,0,1,0,0}
local PERSONAL_REC = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,1,0,0,1,1,0,0,1,1,0,0,0,0,0,1}
local PERSONAL_SHOP = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,1,0}
local PERSONAL_ESCORT = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,1,0,1,0,1,1,0,0,1,1,0,0,0,0,1,0,0}
local REC_SHOP = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,1,1,1,0,0,1,1,0,0,1,0,0,1,0,0,0}
local REC_ESCORT = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,1,1,1,0,1,0,1,0,1,0,0,1,0,0,0,0}
local SHOP_ESCORT = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1,0,0,0,0,0}

-- UTILITY
local utility = {}

local function computeUtilities(params) 
	local person_type_id = params.person_type_id 
	local age_id = params.age_id
	local female_dummy = params.female_dummy
	local student_dummy = params.student_dummy
	local income_id = params.income_id
	local income_mid = {0.75,2,3,4.25,6.25,8.75,12.5,20}
	local missing_income = params.missing_income
	local license = params.has_driving_licence
	local studentTypeId = params.studentTypeId
	local transit = params.vanbus_license
	local fixedworktime = params.fixed_work_hour

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
	local TRANS = 0
	if transit == true then
		TRANS = 1
	end

	

	-- Work related
	local FLEXSCHED = 0
	if fixedworktime == false then
		FLEXSCHED = 1
	end

	local MULTJOBS = 0 
			
	for i = 1,56 do
		utility[i] = beta_stop_work * (WORK[i]) + beta_stop_edu * (EDU[i]) + beta_stop_personal * (PERSONAL[i]) +
        	beta_stop_rec * (REC[i]) + beta_stop_shop * (SHOP[i]) + beta_stop_escort * (ESCORT[i]) +
        	beta_parttime_work * (WORK[i] * parttime) +  beta_parttime_edu * (EDU[i] * parttime) + beta_parttime_personal * (PERSONAL[i] * parttime) +
        	beta_parttime_rec * (REC[i] * parttime) + beta_parttime_shop * (SHOP[i] * parttime) + beta_parttime_escort * (ESCORT[i] * parttime) +
        	beta_retired_work * (WORK[i] * retired) + beta_retired_edu * (EDU[i] * retired) + beta_retired_personal * (PERSONAL[i] * retired) +
	        beta_retired_rec * (REC[i] * retired) + beta_retired_shop * (SHOP[i] * retired) + beta_retired_escort * (ESCORT[i] * retired)  +
	        beta_homemaker_work * (WORK[i] * homemaker) + beta_homemaker_edu * (EDU[i] * homemaker) + beta_homemaker_personal * (PERSONAL[i] * homemaker) +
	        beta_homemaker_rec * (REC[i] * homemaker) + beta_homemaker_shop * (SHOP[i] * homemaker) + beta_homemaker_escort * (ESCORT[i] * homemaker)  +
	        beta_unemployed_work * (WORK[i] * unemployed) + beta_unemployed_edu * (EDU[i] * unemployed) + beta_unemployed_personal * (PERSONAL[i] * unemployed) +
	        beta_unemployed_rec * (REC[i] * unemployed) + beta_unemployed_shop * (SHOP[i] * unemployed) + beta_unemployed_escort * (ESCORT[i] * unemployed) +
	        beta_preschool_work * (WORK[i] * preschool) + beta_preschool_edu * (EDU[i] * preschool) + beta_preschool_personal * (PERSONAL[i] * preschool) +
	        beta_preschool_rec * (REC[i] * preschool) + beta_preschool_shop * (SHOP[i] * preschool) + beta_preschool_escort * (ESCORT[i] * preschool)  +
	        beta_studentK8_work * (WORK[i] * studentK8) + beta_studentK8_edu * (EDU[i] * studentK8) + beta_studentK8_personal * (PERSONAL[i] * studentK8) +
	        beta_studentK8_rec * (REC[i] * studentK8) + beta_studentK8_shop * (SHOP[i] * studentK8) + beta_studentK8_escort * (ESCORT[i] * studentK8)  +
	        beta_student912_work * (WORK[i] * student912) + beta_student912_edu * (EDU[i] * student912) + beta_student912_personal * (PERSONAL[i] * student912) +
	        beta_student912_rec * (REC[i] * student912) + beta_student912_shop * (SHOP[i] * student912) + beta_student912_escort * (ESCORT[i] * student912)  +
	        beta_undergraduate_work * (WORK[i] * undergraduate) + beta_undergraduate_edu * (EDU[i] * undergraduate) + beta_undergraduate_personal * (PERSONAL[i] * undergraduate) +
	        beta_undergraduate_rec * (REC[i] * undergraduate) + beta_undergraduate_shop * (SHOP[i] * undergraduate) + beta_undergraduate_escort * (ESCORT[i] * undergraduate)  +
	        beta_graduate_work * (WORK[i] * graduate) + beta_graduate_edu * (EDU[i] * graduate) + beta_graduate_personal * (PERSONAL[i] * graduate) +
	        beta_graduate_rec * (REC[i] * graduate) + beta_graduate_shop * (SHOP[i] * graduate) + beta_graduate_escort * (ESCORT[i] * graduate)  +
	        beta_otherstudent_work * (WORK[i] * otherstudent) + beta_otherstudent_edu * (EDU[i] * otherstudent) + beta_otherstudent_personal * (PERSONAL[i] * otherstudent) +
	        beta_otherstudent_rec * (REC[i] * otherstudent) + beta_otherstudent_shop * (SHOP[i] * otherstudent) + beta_otherstudent_escort * (ESCORT[i] * otherstudent) +
	        beta_age20_work * (WORK[i] * age20) + beta_age20_edu * (EDU[i] * age20) + beta_age20_personal * (PERSONAL[i] * age20) +
	        beta_age20_rec * (REC[i] * age20) + beta_age20_shop * (SHOP[i] * age20) + beta_age20_escort * (ESCORT[i] * age20)  +
	        beta_age2025_work * (WORK[i] * age2025) + beta_age2025_edu * (EDU[i] * age2025) + beta_age2025_personal * (PERSONAL[i] * age2025) +
	        beta_age2025_rec * (REC[i] * age2025) + beta_age2025_shop * (SHOP[i] * age2025) + beta_age2025_escort * (ESCORT[i] * age2025)  +
	        beta_age2635_work * (WORK[i] * age2635) + beta_age2635_edu * (EDU[i] * age2635) + beta_age2635_personal * (PERSONAL[i] * age2635) +
	        beta_age2635_rec * (REC[i] * age2635) + beta_age2635_shop * (SHOP[i] * age2635) + beta_age2635_escort * (ESCORT[i] * age2635)  +
	        beta_age5165_work * (WORK[i] * age5165) + beta_age5165_edu * (EDU[i] * age5165) + beta_age5165_personal * (PERSONAL[i] * age5165) +
	        beta_age5165_rec * (REC[i] * age5165) + beta_age5165_shop * (SHOP[i] * age5165) + beta_age5165_escort * (ESCORT[i] * age5165)  +
	        beta_age65_work * (WORK[i] * age65) + beta_age65_edu * (EDU[i] * age65) + beta_age65_personal * (PERSONAL[i] * age65) +
	        beta_age65_rec * (REC[i] * age65) + beta_age65_shop * (SHOP[i] * age65) + beta_age65_escort * (ESCORT[i] * age65) +
	        beta_female_work * (WORK[i] * female) + beta_female_edu * (EDU[i] * female) + beta_female_personal * (PERSONAL[i] * female) +
	        beta_female_rec * (REC[i] * female) + beta_female_shop * (SHOP[i] * female) + beta_female_escort * (ESCORT[i] * female)  +
	        beta_INCOME_work * (WORK[i] * INCOME) + beta_INCOME_edu * (EDU[i] * INCOME) + beta_INCOME_personal * (PERSONAL[i] * INCOME) +
	        beta_INCOME_rec * (REC[i] * INCOME) + beta_INCOME_shop * (SHOP[i] * INCOME) + beta_INCOME_escort * (ESCORT[i] * INCOME) +
	        beta_workedu_ss * (WORK_EDU[i]) + beta_workpersonal_ss * (WORK_PERSONAL[i]) + beta_workrec_ss * (WORK_REC[i]) +
	        beta_workshop_ss * (WORK_SHOP[i]) + beta_workescort_ss * (WORK_ESCORT[i]) + beta_edupersonal_ss * (EDU_PERSONAL[i]) +
	        beta_edurec_ss * (EDU_REC[i]) + beta_edushop_ss * (EDU_SHOP[i]) + beta_eduescort_ss * (EDU_ESCORT[i]) +
	        beta_personalrec_ss * (PERSONAL_REC[i]) + beta_personalshop_ss * (PERSONAL_SHOP[i]) + beta_personalescort_ss * (PERSONAL_ESCORT[i]) +
	        beta_recshop_ss * (REC_SHOP[i]) + beta_recescort_ss * (REC_ESCORT[i]) + beta_shopescort_ss * (SHOP_ESCORT[i]) +
	        beta_onestop * (OneStop[i]) + beta_twostops * (TwoStops[i]) +
	        beta_threestops * (ThreeStops[i]) + beta_fourstops * (FourStops[i])	
	end


end

--availability
local availability = {}
local function computeAvailabilities(params)
	-- storing data from params table passed into this function locally for use in this function (this is purely for better execution time)
	local person_type_id = params.person_type_id
	local somestudent = 0
	if person_type_id == 7 or person_type_id == 8 or person_type_id == 9 then
		somestudent = 1
	end

	for i = 1,56 do
		-- For Full time student (person_type_id=4): All alternatives are available.
		-- For other person type: only alternatives with EduT=0 (i.e. choice[i][2] = 0) are available to them
		if somestudent == 1 then
			availability[i] = 1
		else
			if choice[i][2] == 0 then 
				availability[i] = 1
			else
				availability[i] = 0
			end
		end
	end
end

-- scales
local scale = 1 -- for all choices

-- function to call from C++ preday simulator
-- params table contains data passed from C++
-- to check variable bindings in params, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function choose_dps(params)
	computeUtilities(params) 
	computeAvailabilities(params)
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	idx = make_final_choice(probability)
	return choice[idx]
end

-- function to call from C++ preday simulator for logsums computation
-- params table contain person data passed from C++
-- to check variable bindings in params, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function compute_logsum_dps(params)
	computeUtilities(params) 
	computeAvailabilities(params)
	return compute_mnl_logsum(utility, availability)
end
