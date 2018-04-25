--[[
Model: Day Pattern Tours
Based on: dpb.lua (Siyu Li, Harish Loganathan)
Author: Isabel Viegas
Crated: January 28, 2017
Updated: August 16, 2017

Recent calibration done by Yifei Xie
Updated: April, 2018
]]

-- COEFFICIENTS

-- Tour Constants
local beta_tour_work = 0 -0.7 + 0.05 - 0.02
local beta_tour_edu = -2.94 + 4 -1 - 0.2
local beta_tour_personal = -2.69 + 0.7 - 0.7 +0.2+0.2
local beta_tour_rec = -3.67 + 1
local beta_tour_shop = -3.72 + 0.5+0.1
local beta_tour_escort = -6.57 + 1.6

-- Person type
-- fulltime as a base
-- work as a base
local beta_parttime_work = 0  
local beta_parttime_edu = 1.68
local beta_parttime_personal = 0.931
local beta_parttime_rec = 0.637
local beta_parttime_shop = 0.720
local beta_parttime_escort = 0.818

local beta_retired_work = 0
local beta_retired_edu = 0.577
local beta_retired_personal = 0.755
local beta_retired_rec = 0.618
local beta_retired_shop = 0.686
local beta_retired_escort = -0.102

local beta_homemaker_work = 0
local beta_homemaker_edu = -0.0737
local beta_homemaker_personal = 0.929
local beta_homemaker_rec = 0.811
local beta_homemaker_shop = 0.823
local beta_homemaker_escort = 1.29

local beta_unemployed_work = 1.14
local beta_unemployed_edu = 0.455
local beta_unemployed_personal = 1.09
local beta_unemployed_rec = 0.662
local beta_unemployed_shop = 0.643
local beta_unemployed_escort = 0.596

local beta_student_work = 0
local beta_student_edu = 1.45
local beta_student_personal = 0.721
local beta_student_rec = 0.690
local beta_student_shop = 0.679
local beta_student_escort = 0.873

local beta_preschool_work = 0
local beta_preschool_edu = 0
local beta_preschool_personal = 0
local beta_preschool_rec = 0
local beta_preschool_shop = 0
local beta_preschool_escort = 0

local beta_studentK8_work = 0 
local beta_studentK8_edu = 1.03
local beta_studentK8_personal = -0.118
local beta_studentK8_rec = 0.618
local beta_studentK8_shop = -0.0876
local beta_studentK8_escort = 0 -- no cases

local beta_student912_work = 0
local beta_student912_edu = 1.25
local beta_student912_personal = -0.0557
local beta_student912_rec = 0.328
local beta_student912_shop = -0.0336
local beta_student912_escort = -1.42

local beta_undergraduate_work = 0
local beta_undergraduate_edu = 0.644
local beta_undergraduate_personal = 0.0770
local beta_undergraduate_rec = -0.0143
local beta_undergraduate_shop = 0.0624
local beta_undergraduate_escort = 0.176

local beta_graduate_work = 0
local beta_graduate_edu = 0.406
local beta_graduate_personal = -0.0737
local beta_graduate_rec = 0.00508
local beta_graduate_shop = 0.0591
local beta_graduate_escort = -0.606

local beta_otherstudent_work = 0
local beta_otherstudent_edu = 0
local beta_otherstudent_personal = 0
local beta_otherstudent_rec = 0
local beta_otherstudent_shop = 0
local beta_otherstudent_escort = 0

-- Age Group
-- age 36-50 as a base
-- work as a base
local beta_age20_work = 0
local beta_age20_edu = 0.896
local beta_age20_personal = -0.340
local beta_age20_rec = 0.454
local beta_age20_shop = -0.390
local beta_age20_escort = -1.15

local beta_age2025_work = 0
local beta_age2025_edu = 0.610
local beta_age2025_personal = -0.437
local beta_age2025_rec = -0.0456
local beta_age2025_shop = -0.466
local beta_age2025_escort = -1.78

local beta_age2635_work = 0
local beta_age2635_edu = -0.706
local beta_age2635_personal = 0.153
local beta_age2635_rec = -0.0750
local beta_age2635_shop = 0.0410
local beta_age2635_escort = -0.775

local beta_age5165_work = 0
local beta_age5165_edu = -1.31
local beta_age5165_personal = 0.163
local beta_age5165_rec = -0.131
local beta_age5165_shop = 0.118
local beta_age5165_escort = -0.634

local beta_age65_work = 0
local beta_age65_edu = -1.21
local beta_age65_personal = 0.364
local beta_age65_rec = -0.172
local beta_age65_shop = 0.130
local beta_age65_escort = -1.69

-- Gender
-- male as a base
-- work as a base
local beta_female_work = 0
local beta_female_edu = -0.00779
local beta_female_personal = 0.203
local beta_female_rec = 0.0383
local beta_female_shop = 0.262
local beta_female_escort = 0.128

-- Income
local beta_INCOME_work = 0
local beta_INCOME_edu = 0.0155
local beta_INCOME_personal = -0.00952
local beta_INCOME_rec = 0.0194
local beta_INCOME_shop = 0.00208
local beta_INCOME_escort = 0.0248

-- Transportation
local beta_LIC_work = 0
local beta_LIC_edu = -0.113
local beta_LIC_personal = -0.0715
local beta_LIC_rec = 0.459
local beta_LIC_shop = 0.0842
local beta_LIC_escort = 1.14

local beta_TRANS_work = 0
local beta_TRANS_edu = 0.123
local beta_TRANS_personal = -0.0242
local beta_TRANS_rec = -0.0934
local beta_TRANS_shop = -0.0653
local beta_TRANS_escort = -0.356

-- Additional Constants
-- onetour as a base
local beta_onetour = 0 +3-1-0.5
local beta_twotours = -1.29+0.29+0.2
local beta_threetours = -5.34
local beta_fourtours = -12.2

-- Logsums 
local beta_logsumNU_work = 0.000996
local beta_logsumU_work = -0.000285
local beta_logsum_edu = -0.0343
local beta_logsum_personal = -0.00120
local beta_logsum_rec = 0.0795
local beta_logsum_shop = 0.0882
local beta_logsum_escort = 0.101

-- Combination constants
local beta_workedu_tt = 0
local beta_workpersonal_tt = 1.21
local beta_workrec_tt = 2.19
local beta_workshop_tt = 1.55
local beta_workescort_tt = 2.48
local beta_edupersonal_tt = 1.15
local beta_edurec_tt = 1.61
local beta_edushop_tt = 1.18
local beta_eduescort_tt = 2.53
local beta_personalrec_tt = 2.56
local beta_personalshop_tt = 2.40
local beta_personalescort_tt = 3.08
local beta_recshop_tt = 2.64
local beta_recescort_tt = 3.11
local beta_shopescort_tt = 3.18

-- Choiceset 
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
local OneTour = {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local TwoTours = {0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local ThreeTours = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local FourTours = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

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
	local pid = params.person_id
	local person_type_id = params.person_type_id 
	local age_id = params.age_id
	local female_dummy = params.female_dummy
	local student_dummy = params.student_dummy
	local income_id = params.income_id
	local income_mid = {0.75,2,3,4.25,6.25,8.75,12.5,20}
	local missing_income = params.missing_income
	local license = params.car_license
	local studentTypeId = params.studentTypeId
	local transit = params.vanbus_license
	local fixedworktime = params.fixed_work_hour

	local usual = params.fixed_place

	local worklogsum = params:activity_logsum(1)
	local edulogsum = params:activity_logsum(2)
	local personallogsum = params:activity_logsum(3)
	local reclogsum = params:activity_logsum(4)
	local shoplogsum = params:activity_logsum(5)
	local escortlogsum = params:activity_logsum(6)
	
	-- Person type and student type related variables
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
	
	-- Age group related variables
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
		utility[i] = beta_tour_work * (WORK[i]) + beta_tour_edu * (EDU[i]) + beta_tour_personal * (PERSONAL[i]) +
        beta_tour_rec * (REC[i]) + beta_tour_shop * (SHOP[i]) + beta_tour_escort * (ESCORT[i])+
        beta_parttime_work * (WORK[i] * parttime) +  beta_parttime_edu * (EDU[i] * parttime) + beta_parttime_personal * (PERSONAL[i] * parttime) +
        beta_parttime_rec * (REC[i] * parttime) + beta_parttime_shop * (SHOP[i] * parttime) + beta_parttime_escort * (ESCORT[i] * parttime) +
        beta_retired_work * (WORK[i] * retired) + beta_retired_edu * (EDU[i] * retired) + beta_retired_personal * (PERSONAL[i] * retired) +
        beta_retired_rec * (REC[i] * retired) + beta_retired_shop * (SHOP[i] * retired) + beta_retired_escort * (ESCORT[i] * retired)  +
        beta_homemaker_work * (WORK[i] * homemaker) + beta_homemaker_edu * (EDU[i] * homemaker) + beta_homemaker_personal * (PERSONAL[i] * homemaker) +
        beta_homemaker_rec * (REC[i] * homemaker) + beta_homemaker_shop * (SHOP[i] * homemaker) + beta_homemaker_escort * (ESCORT[i] * homemaker)  +
        beta_unemployed_work * (WORK[i] * unemployed) + beta_unemployed_edu * (EDU[i] * unemployed) + beta_unemployed_personal * (PERSONAL[i] * unemployed) +
        beta_unemployed_rec * (REC[i] * unemployed) + beta_unemployed_shop * (SHOP[i] * unemployed) + beta_unemployed_escort * (ESCORT[i] * unemployed)  +
        beta_student_work * (WORK[i] * student) + beta_student_edu * (EDU[i] * student) + beta_student_personal * (PERSONAL[i] * student) +
        beta_student_rec * (REC[i] * student) + beta_student_shop * (SHOP[i] * student) + beta_student_escort * (ESCORT[i] * student)  +
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
        beta_otherstudent_rec * (REC[i] * otherstudent) + beta_otherstudent_shop * (SHOP[i] * otherstudent) + beta_otherstudent_escort * (ESCORT[i] * otherstudent)  +
        beta_age20_work * (WORK[i] * age20) + beta_age20_edu * (EDU[i] * age20) + beta_age20_personal * (PERSONAL[i] * age20) +
        beta_age20_rec * (REC[i] * age20) + beta_age20_shop * (SHOP[i] * age20) + beta_age20_escort * (ESCORT[i] * age20)  +
        beta_age2025_work * (WORK[i] * age2025) + beta_age2025_edu * (EDU[i] * age2025) + beta_age2025_personal * (PERSONAL[i] * age2025) +
        beta_age2025_rec * (REC[i] * age2025) + beta_age2025_shop * (SHOP[i] * age2025) + beta_age2025_escort * (ESCORT[i] * age2025)  +
        beta_age2635_work * (WORK[i] * age2635) + beta_age2635_edu * (EDU[i] * age2635) + beta_age2635_personal * (PERSONAL[i] * age2635) +
        beta_age2635_rec * (REC[i] * age2635) + beta_age2635_shop * (SHOP[i] * age2635) + beta_age2635_escort * (ESCORT[i] * age2635)  +
        beta_age5165_work * (WORK[i] * age5165) + beta_age5165_edu * (EDU[i] * age5165) + beta_age5165_personal * (PERSONAL[i] * age5165) +
        beta_age5165_rec * (REC[i] * age5165) + beta_age5165_shop * (SHOP[i] * age5165) + beta_age5165_escort * (ESCORT[i] * age5165)  +
        beta_age65_work * (WORK[i] * age65) + beta_age65_edu * (EDU[i] * age65) + beta_age65_personal * (PERSONAL[i] * age65) +
        beta_age65_rec * (REC[i] * age65) + beta_age65_shop * (SHOP[i] * age65) + beta_age65_escort * (ESCORT[i] * age65)  +
        beta_female_work * (WORK[i] * female) + beta_female_edu * (EDU[i] * female) + beta_female_personal * (PERSONAL[i] * female) +
        beta_female_rec * (REC[i] * female) + beta_female_shop * (SHOP[i] * female) + beta_female_escort * (ESCORT[i] * female)  +
        beta_INCOME_work * (WORK[i] * INCOME) + beta_INCOME_edu * (EDU[i] * INCOME) + beta_INCOME_personal * (PERSONAL[i] * INCOME) +
        beta_INCOME_rec * (REC[i] * INCOME) + beta_INCOME_shop * (SHOP[i] * INCOME) + beta_INCOME_escort * (ESCORT[i] * INCOME)  +
        beta_LIC_work * (WORK[i] * LIC) + beta_LIC_edu * (EDU[i] * LIC) + beta_LIC_personal * (PERSONAL[i] * LIC) +
        beta_LIC_rec * (REC[i] * LIC) + beta_LIC_shop * (SHOP[i] * LIC) + beta_LIC_escort * (ESCORT[i] * LIC)  +
        beta_TRANS_work * (WORK[i] * TRANS) + beta_TRANS_edu * (EDU[i] * TRANS) + beta_TRANS_personal * (PERSONAL[i] * TRANS) +
        beta_TRANS_rec * (REC[i] * TRANS) + beta_TRANS_shop * (SHOP[i] * TRANS) + beta_TRANS_escort * (ESCORT[i] * TRANS)  +
        beta_workedu_tt * (WORK_EDU[i]) + beta_workpersonal_tt * (WORK_PERSONAL[i]) + beta_workrec_tt * (WORK_REC[i]) +
        beta_workshop_tt * (WORK_SHOP[i]) + beta_workescort_tt * (WORK_ESCORT[i]) + beta_edupersonal_tt * (EDU_PERSONAL[i]) +
        beta_edurec_tt * (EDU_REC[i]) + beta_edushop_tt * (EDU_SHOP[i]) + beta_eduescort_tt * (EDU_ESCORT[i]) +
        beta_personalrec_tt * (PERSONAL_REC[i]) + beta_personalshop_tt * (PERSONAL_SHOP[i]) + beta_personalescort_tt * (PERSONAL_ESCORT[i]) +
        beta_recshop_tt * (REC_SHOP[i]) + beta_recescort_tt * (REC_ESCORT[i]) + beta_shopescort_tt * (SHOP_ESCORT[i]) +
        beta_onetour * (OneTour[i]) + beta_twotours * (TwoTours[i]) +
        beta_threetours * (ThreeTours[i]) + beta_fourtours * (FourTours[i]) +
        (beta_logsumU_work * usual * worklogsum + beta_logsumNU_work * (1-usual) * worklogsum) * (WORK[i]) +
        beta_logsum_edu * edulogsum * EDU[i] + beta_logsum_personal * personallogsum * PERSONAL[i] +
        beta_logsum_rec * reclogsum * REC[i] + beta_logsum_shop * shoplogsum * SHOP[i] + beta_logsum_escort * escortlogsum * ESCORT[i]
	end
end

--availability
local availability = {}
local function computeAvailabilities(params)
	-- storing data from params table passed into this function locally for use in this function (this is purely for better execution time)
	local student_dummy = params.student_dummy

	-- make education tour only available for students
	for i = 1,56 do
		if student_dummy == 1 then
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
function choose_dpt(params)
	computeUtilities(params) 
	computeAvailabilities(params)
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	for i = 1,56 do
	end
	idx = make_final_choice(probability)
	return choice[idx]
end

-- function to call from C++ preday simulator for logsums computation
-- params table contain person data passed from C++
-- to check variable bindings in params, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function compute_logsum_dpt(params)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	local num_tours = 0
	for cno,prob in pairs(probability) do
		if cno <= 4 then
			num_tours = num_tours + prob
		elseif cno <= 10 then
			num_tours = num_tours + (2*prob)
		elseif cno <= 14 then
			num_tours = num_tours + (3*prob)
		end
	end
	local return_table = {}
	return_table[1] = compute_mnl_logsum(utility, availability)
	return_table[2] = 2 * num_tours --expected number of primary trips = 2*expected number of tours
	return return_table
end
