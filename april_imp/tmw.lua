--[[
Model - Mode choice for work tour to usual location
Based on tmw.lua by Siyu Li, Harish Loganathan
Author of the older version: Isabel Viegas
Updated February 23, 2017

This version includes on-demand service and Park-ride as new modes in the model
Created and calibrated by Yifei Xie
Updated: April, 2018
]]



--print("tmw is called\n")

local cons_walk = -0.968 + 0.5
local cons_bike = -4.15
local cons_drive1 = 7
local cons_share2 = -9.3
local cons_share3 = -12.7
local cons_PT = -4.79
local cons_OD = -8 
local cons_PR = -7

local beta_tt_walk = -0.0946
local beta_tt_bike = -0.0566
local beta_tt_drive1 = -0.0474
local beta_tt_share2 = -0.0599
local beta_tt_share3 = -0.0617
local beta_tt_PT = -0.0476
local beta_tt_OD = -0.0474

-- local beta_central_walk = 0
-- local beta_central_bike = 0
-- local beta_central_drive1 = 0
-- local beta_central_share2 = 0
-- local beta_central_share3 = 0
-- local beta_central_PT = 0
-- local beta_central_OD = 0

local beta_parttime_walk = -0.422
local beta_parttime_bike = -0.790
local beta_parttime_drive1 = 0
local beta_parttime_share2 = 0.0477
local beta_parttime_share3 = 0.165
local beta_parttime_PT = -0.145
local beta_parttime_OD = 0
local beta_parttime_PR = 0

local beta_retired_walk = 0
local beta_retired_bike = 0
local beta_retired_drive1 = 0
local beta_retired_share2 = 0
local beta_retired_share3 = 0
local beta_retired_PT = 0
local beta_retired_OD = 0
local beta_retired_PR = 0

local beta_disabled_walk = 0
local beta_disabled_bike = 0
local beta_disabled_drive1 = 0
local beta_disabled_share2 = 0
local beta_disabled_share3 = 0
local beta_disabled_PT = 0
local beta_disabled_OD = 0
local beta_disabled_PR = 0

local beta_homemaker_walk = 0
local beta_homemaker_bike = 0
local beta_homemaker_drive1 = 0
local beta_homemaker_share2 = 0
local beta_homemaker_share3 = 0
local beta_homemaker_PT = 0
local beta_homemaker_OD = 0
local beta_homemaker_PR = 0

local beta_unemployed_walk = 0
local beta_unemployed_bike = 0
local beta_unemployed_drive1 = 0
local beta_unemployed_share2 = 0
local beta_unemployed_share3 = 0
local beta_unemployed_PT = 0
local beta_unemployed_OD = 0
local beta_unemployed_PR = 0

local beta_preschool_walk = 0.617
local beta_preschool_bike = 0
local beta_preschool_drive1 = 0
local beta_preschool_share2 = 1.28
local beta_preschool_share3 = 1.40
local beta_preschool_PT = -0.736
local beta_preschool_OD = 0
local beta_preschool_PR = 0

local beta_studentK8_walk = 0
local beta_studentK8_bike = 0
local beta_studentK8_drive1 = 0
local beta_studentK8_share2 = 0
local beta_studentK8_share3 = 0
local beta_studentK8_PT = 0
local beta_studentK8_OD = 0
local beta_studentK8_PR = 0

local beta_student912_walk = 0
local beta_student912_bike = 0
local beta_student912_drive1 = 0
local beta_student912_share2 = 0
local beta_student912_share3 = 0
local beta_student912_PT = 0
local beta_student912_OD = 0
local beta_student912_PR = 0

local beta_undergraduate_walk = -0.540
local beta_undergraduate_bike = -0.0278
local beta_undergraduate_drive1 = 0
local beta_undergraduate_share2 = 0.383
local beta_undergraduate_share3 = 0.622
local beta_undergraduate_PT = 0.259
local beta_undergraduate_OD = 0
local beta_undergraduate_PR = 0

local beta_graduate_walk = 0.993
local beta_graduate_bike = 0.457
local beta_graduate_drive1 = 0
local beta_graduate_share2 = -0.476
local beta_graduate_share3 = 0.418
local beta_graduate_PT = 0.230
local beta_graduate_OD = 0
local beta_graduate_PR = 0

local beta_otherstudent_walk = 0
local beta_otherstudent_bike = 0
local beta_otherstudent_drive1 = 0
local beta_otherstudent_share2 = 0
local beta_otherstudent_share3 = 0
local beta_otherstudent_PT = 0
local beta_otherstudent_OD = 0
local beta_otherstudent_PR = 0
-- Age 
-- local beta_age20_walk = 0
-- local beta_age20_bike = 0
-- local beta_age20_drive1 = 0
-- local beta_age20_share2 = 0
-- local beta_age20_share3 = 0
-- local beta_age20_PT = 0
-- local beta_age20_OD = 0


-- local beta_age2025_walk = 0
-- local beta_age2025_bike = 0
-- local beta_age2025_drive1 = 0
-- local beta_age2025_share2 = 0
-- local beta_age2025_share3 = 0
-- local beta_age2025_PT = 0
-- local beta_age2025_OD = 0


-- local beta_age2635_walk = 0
-- local beta_age2635_bike = 0
-- local beta_age2635_drive1 = 0
-- local beta_age2635_share2 = 0
-- local beta_age2635_share3 = 0
-- local beta_age2635_PT = 0
-- local beta_age2635_OD = 0


-- local beta_age3650_walk = 0
-- local beta_age3650_bike = 0
-- local beta_age3650_drive1 = 0
-- local beta_age3650_share2 = 0
-- local beta_age3650_share3 = 0
-- local beta_age3650_PT = 0
-- local beta_age3650_OD = 0


-- local beta_age5165_walk = 0
-- local beta_age5165_bike = 0
-- local beta_age5165_drive1 = 0
-- local beta_age5165_share2 = 0
-- local beta_age5165_share3 = 0
-- local beta_age5165_PT = 0
-- local beta_age5165_OD = 0


-- local beta_age65_walk = 0
-- local beta_age65_bike = 0
-- local beta_age65_drive1 = 0
-- local beta_age65_share2 = 0
-- local beta_age65_share3 = 0
-- local beta_age65_PT = 0
-- local beta_age65_OD = 0


-- local beta_missingage_walk = 0
-- local beta_missingage_bike = 0
-- local beta_missingage_drive1 = 0
-- local beta_missingage_share2 = 0
-- local beta_missingage_share3 = 0
-- local beta_missingage_PT = 0
-- local beta_missingage_OD = 0


-- Income Variables

local beta_INCOME_walk = 0.0391
local beta_INCOME_bike = 0.0539
local beta_INCOME_drive1 = 0
local beta_INCOME_share2 = 0.0322
local beta_INCOME_share3 = 0.0392
local beta_INCOME_PT = 0.0214
local beta_INCOME_OD = 0
local beta_INCOME_PR = 0

local beta_missingincome_walk = 0
local beta_missingincome_bike = 0
local beta_missingincome_drive1 = 0
local beta_missingincome_share2 = 0
local beta_missingincome_share3 = 0
local beta_missingincome_PT = 0
local beta_missingincome_OD = 0
local beta_missingincome_PR = 0
-- Gender Variables

local beta_female_walk = -0.0927
local beta_female_bike = -1.10
local beta_female_drive1 = 0
local beta_female_share2 = 0.311
local beta_female_share3 = 0.372
local beta_female_PT = -0.107
local beta_female_OD = 0
local beta_female_PR = 0

local beta_missinggender_walk = 0
local beta_missinggender_bike = 0
local beta_missinggender_drive1 = 0
local beta_missinggender_share2 = 0
local beta_missinggender_share3 = 0
local beta_missinggender_PT = 0
local beta_missinggender_OD = 0
local beta_missinggender_PR = 0


-- Transportation-specific Variables

-- local beta_LIC_walk = 0
-- local beta_LIC_bike = 0
-- local beta_LIC_drive1 = 0
-- local beta_LIC_share2 = 0
-- local beta_LIC_share3 = 0
-- local beta_LIC_PT = 0
-- local beta_LIC_OD = 0

local beta_TRANS_walk = 1.75
local beta_TRANS_bike = 1.59
local beta_TRANS_drive1 = 0
local beta_TRANS_share2 = 0.249
local beta_TRANS_share3 = 0
local beta_TRANS_PT = 3.29
local beta_TRANS_OD = 0
local beta_TRANS_PR = beta_TRANS_PT

-- Number of Vehicles in Household
local beta_zerocar_walk = 0
local beta_zerocar_bike = 1.01
local beta_zerocar_drive1 = 0
local beta_zerocar_share2 = -1.17
local beta_zerocar_share3 = 0
local beta_zerocar_PT = 0.892
local beta_zerocar_OD = beta_zerocar_PT 
local beta_zerocar_PR = beta_zerocar_drive1

local beta_onecar_walk = 1.24
local beta_onecar_bike = 1.91
local beta_onecar_drive1 = 0
local beta_onecar_share2 = 0.532
local beta_onecar_share3 = 1.16
local beta_onecar_PT = 1.53
local beta_onecar_OD = beta_onecar_PT
local beta_onecar_PR = (beta_onecar_PT+beta_onecar_drive1)/2

local beta_twocar_walk = 0
local beta_twocar_bike = 0.942
local beta_twocar_drive1 = 0
local beta_twocar_share2 = 0.448
local beta_twocar_share3 = 1.37
local beta_twocar_PT = 0.595
local beta_twocar_OD = beta_twocar_PT
local beta_twocar_PR = (beta_twocar_PT+beta_twocar_drive1)/2


local beta_threepluscar_walk = 0
local beta_threepluscar_bike = 0
local beta_threepluscar_drive1 = 0
local beta_threepluscar_share2 = 0
local beta_threepluscar_share3 = 0
local beta_threepluscar_PT = 0
local beta_threepluscar_OD = beta_threepluscar_PT
local beta_threepluscar_PR = (beta_threepluscar_PT+beta_threepluscar_drive1)/2


local beta_cost = -0.0621



--choiceset
local choice = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8
}



--choice["PT"] = {1,2,3}
--choice["non-PT"] = {4,5,6,7,8,9}


--utility
-- 1 for public bus; 2 for MRT/LRT; 3 for private bus; 4 for drive1;
-- 5 for shared2; 6 for shared3+; 7 for motor; 8 for walk; 9 for taxi
local utility = {}
local function computeUtilities(params,dbparams)
			-- storing data from params table passed into this function locally for use in this function (this is purely for better execution time)
	local person_type_id = params.person_type_id 
	-- print("person_type_id: ", person_type_id)
	local age_id = params.age_id
	-- print("age_id: ", age_id)
	local female_dummy = params.female_dummy
	-- print("female_dummy: ", female_dummy)
	local student_dummy = params.student_dummy
	-- print("student_dummy: ", student_dummy)
	local income_id = params.income_id
	-- print("income_id: ", income_id)
	local income_mid = {0.75,2,3,4.25,6.25,8.75,12.5,20}
	-- print("income_mid: ", income_mid)
	local missing_income = params.missing_income
	-- print("missing_income: ", missing_income)
	local LIC = params.has_driving_licence
	-- print("license: ", license)
	local studentTypeId = params.studentTypeId
	-- print("studentTypeId: ", studentTypeId)
	local transit = params.vanbus_license
	-- print("transit: ", transit)
	local fixedworktime = params.fixed_work_hour
	-- print("fixedworktime: ", fixedworktime)

	-- print("done")
	-- person type and student type related variables
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
	
	
	-- age group related variables
	-- local age20,age2025,age2635,age3650,age5165,age65,missingage = 0,0,0,0,0,0,0
	-- if age_id < 4 then 
	-- 	age20 = 1
	-- elseif age_id == 5 then 
	-- 	age2025 = 1
	-- elseif age_id > 4 and age_id <= 5 then
	-- 	age2635 = 1
	-- elseif age_id > 5 and age_id <= 9 then
	-- 	age3650 = 1
	-- elseif age_id > 9 and age_id <= 12 then
	-- 	age5165 = 1
	-- elseif age_id > 12 then 
	-- 	age65 = 1
	-- end
	-- gender variables
	local female = 0
	if female_dummy == 0 then
		female = 1
	end

	local missinggender = 0
	
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

	local infant = 0

	local CBD = dbparams.central_dummy
	-- print("CBD: ", CBD)

	-- walk travel time
	local d1 = dbparams.walk_distance1
	local d2 = dbparams.walk_distance2
	local tt_walk = math.max(d1,d2)
	-- print("tt_walk: ", tt_walk)

	-- bike travel time
	local tt_ivt_car_first = dbparams.tt_ivt_car_first
	local tt_ivt_car_second = dbparams.tt_ivt_car_second
	local tt_bike = math.max(tt_ivt_car_first,tt_ivt_car_second)
	-- print("tt_bike: ", tt_bike)

	local tt_PT_ivt_first = dbparams.tt_public_ivt_first
	local tt_PT_ivt_second = dbparams.tt_public_ivt_second
	local tt_PT_waiting_first = dbparams.tt_public_waiting_first
	local tt_PT_waiting_second = dbparams.tt_public_waiting_second
	local tt_PT_walk_first =  dbparams.tt_public_walk_first
	local tt_PT_walk_second = dbparams.tt_public_walk_second

	local tt_PT_first = tt_PT_ivt_first + tt_PT_waiting_first + tt_PT_walk_first
	local tt_PT_second = tt_PT_ivt_second + tt_PT_waiting_second + tt_PT_walk_second
	local tt_PT = math.max(tt_PT_first, tt_PT_second)
	-- print("tt_PT:",tt_PT)
	-- car travel time
	local tt_car = math.max(tt_ivt_car_first,tt_ivt_car_second)
	-- print("tt_car: ", tt_car)
	--dbparams.tt_ivt_car_first = AM[(origin,destination)]['car_ivt']
	--dbparams.tt_ivt_car_second = PM[(destination,origin)]['car_ivt']


	local cost_PT_first = dbparams.cost_public_first
	local cost_PT_second = dbparams.cost_public_second

	local costPT = cost_PT_second + cost_PT_first
	-- print("costPT: ", costPT)

	local cost_car_ERP_first = dbparams.cost_car_ERP_first
	local cost_car_ERP_second = dbparams.cost_car_ERP_second
	local cost_car_OP_first = dbparams.cost_car_OP_first
	local cost_car_OP_second = dbparams.cost_car_OP_second
	local cost_car_parking = dbparams.cost_car_parking

	local costCar = cost_car_ERP_first + cost_car_ERP_second + cost_car_OP_first + cost_car_OP_second + cost_car_parking 

	--Base fare 2$, Booking fee 1.6$ Per minute 0.2$ per mile 1.29$
	local cost_OD_1 = 2 + 1.6 + tt_ivt_car_first*0.2 + d1*1.29
	cost_OD_1 = math.max(cost_OD_1,6.6)
	local cost_OD_2 = 2 + 1.6 + tt_ivt_car_second*0.2 + d2*1.29
	cost_OD_2 = math.max(cost_OD_2,6.6)
	local cost_OD = math.max(cost_OD_1,cost_OD_2)

	local tt_PR_PT = math.max(dbparams.tt_public_ivt_first, dbparams.tt_public_ivt_second) 
	local tt_PR_car= math.max(dbparams.tt_public_walk_first, dbparams.tt_public_walk_second)*5/60
	local cost_PR_PT = costPT
	local cost_PR_car= 6

	local veh_cat = params.vehicle_ownership_category
	local zerocar = 0
	local onecar = 0
	local twocar = 0
	local threepluscar = 0

	if veh_cat == 0 or veh_cat == 6 or veh_cat == 9 then
		zerocar = 1
		-- print("zerocar")
	elseif veh_cat == 1 or veh_cat == 4 or veh_cat == 7 or veh_cat == 10 then
		onecar = 1
	elseif veh_cat == 2 or veh_cat == 5 or veh_cat == 8 or veh_cat == 11 then
		twocar = 1
	end

	-- utility[1] = cons_walk + beta_tt_walk * tt_walk + beta_central_walk * CBD + beta_parttime_walk * parttime +
	-- beta_retired_walk * retired + beta_homemaker_walk * homemaker +
	-- beta_unemployed_walk * unemployed + 
	-- beta_age20_walk * age20 + beta_age2025_walk * age2025 + beta_age2635_walk * age2635 +
	-- beta_age3650_walk * age3650 + beta_age5165_walk * age5165 + beta_age65_walk * age65 +
	-- beta_missingage_walk * missingage + beta_INCOME_walk * INCOME +
	-- beta_missingincome_walk * missingincome + beta_female_walk * female +
	-- beta_missinggender_walk * missinggender + beta_LIC_walk * LIC +
	-- beta_TRANS_walk * TRANS + beta_zerocar_walk * zerocar +
	-- beta_onecar_walk * onecar + beta_twocar_walk * twocar +
	-- beta_threepluscar_walk * threepluscar +
	-- beta_preschool_walk * preschool +
	-- beta_undergraduate_walk * undergraduate + beta_graduate_walk * graduate + beta_otherstudent_walk * otherstudent

	-- utility[2] = cons_bike + beta_tt_bike * tt_bike + beta_central_bike * CBD + beta_parttime_bike * parttime +
	-- beta_retired_bike * retired + beta_homemaker_bike * homemaker +
	-- beta_unemployed_bike * unemployed + 
	-- beta_age20_bike * age20 + beta_age2025_bike * age2025 + beta_age2635_bike * age2635 +
	-- beta_age3650_bike * age3650 + beta_age5165_bike * age5165 + beta_age65_bike * age65 +
	-- beta_missingage_bike * missingage + beta_INCOME_bike * INCOME +
	-- beta_missingincome_bike * missingincome + beta_female_bike * female +
	-- beta_missinggender_bike * missinggender + beta_LIC_bike * LIC +
	-- beta_TRANS_bike * TRANS + beta_zerocar_bike * zerocar +
	-- beta_onecar_bike * onecar + beta_twocar_bike * twocar +
	-- beta_threepluscar_bike * threepluscar +
	-- beta_preschool_bike * preschool +
	-- beta_undergraduate_bike * undergraduate + beta_graduate_bike * graduate + beta_otherstudent_bike * otherstudent


	-- utility[3] = cons_drive1 + beta_tt_drive1 * tt_car + beta_central_drive1 * CBD + beta_parttime_drive1 * parttime +
	-- beta_retired_drive1 * retired + beta_homemaker_drive1 * homemaker +
	-- beta_unemployed_drive1 * unemployed + 
	-- beta_age20_drive1 * age20 + beta_age2025_drive1 * age2025 + beta_age2635_drive1 * age2635 +
	-- beta_age3650_drive1 * age3650 + beta_age5165_drive1 * age5165 + beta_age65_drive1 * age65 +
	-- beta_missingage_drive1 * missingage + beta_INCOME_drive1 * INCOME +
	-- beta_missingincome_drive1 * missingincome + beta_female_drive1 * female +
	-- beta_missinggender_drive1 * missinggender + beta_LIC_drive1 * LIC +
	-- beta_TRANS_drive1 * TRANS + beta_zerocar_drive1 * zerocar +
	-- beta_onecar_drive1 * onecar + beta_twocar_drive1 * twocar +
	-- beta_threepluscar_drive1 * threepluscar +
	-- beta_cost * costCar+
	-- beta_preschool_drive1 * preschool +
	-- beta_undergraduate_drive1 * undergraduate + beta_graduate_drive1 * graduate + beta_otherstudent_drive1 * otherstudent


	-- utility[4] = cons_share2 + beta_tt_share2 * tt_car + beta_central_share2 * CBD + beta_parttime_share2 * parttime +
	-- beta_retired_share2 * retired + beta_homemaker_share2 * homemaker +
	-- beta_unemployed_share2 * unemployed +
	-- beta_age20_share2 * age20 + beta_age2025_share2 * age2025 + beta_age2635_share2 * age2635 +
	-- beta_age3650_share2 * age3650 + beta_age5165_share2 * age5165 + beta_age65_share2 * age65 +
	-- beta_missingage_share2 * missingage + beta_INCOME_share2 * INCOME +
	-- beta_missingincome_share2 * missingincome + beta_female_share2 * female +
	-- beta_missinggender_share2 * missinggender + beta_LIC_share2 * LIC +
	-- beta_TRANS_share2 * TRANS + beta_zerocar_share2 * zerocar +
	-- beta_onecar_share2 * onecar + beta_twocar_share2 * twocar +
	-- beta_threepluscar_share2 * threepluscar +
	-- beta_cost * costCar/2 + 
	-- beta_preschool_share2 * preschool +
	-- beta_undergraduate_share2 * undergraduate + beta_graduate_share2 * graduate + beta_otherstudent_share2 * otherstudent


	-- utility[5] = cons_share3 + beta_tt_share3 * tt_car + beta_central_share3 * CBD + beta_parttime_share3 * parttime +
	-- beta_retired_share3 * retired + beta_homemaker_share3 * homemaker +
	-- beta_unemployed_share3 * unemployed +
	-- beta_age20_share3 * age20 + beta_age2025_share3 * age2025 + beta_age2635_share3 * age2635 +
	-- beta_age3650_share3 * age3650 + beta_age5165_share3 * age5165 + beta_age65_share3 * age65 +
	-- beta_missingage_share3 * missingage + beta_INCOME_share3 * INCOME +
	-- beta_missingincome_share3 * missingincome + beta_female_share3 * female +
	-- beta_missinggender_share3 * missinggender + beta_LIC_share3 * LIC +
	-- beta_TRANS_share3 * TRANS + beta_zerocar_share3 * zerocar +
	-- beta_onecar_share3 * onecar + beta_twocar_share3 * twocar +
	-- beta_threepluscar_share3 * threepluscar +
	-- beta_cost * costCar/3 +
	-- beta_preschool_share3 * preschool +
	-- beta_undergraduate_share3 * undergraduate + beta_graduate_share3 * graduate + beta_otherstudent_share3 * otherstudent


	-- utility[6] = cons_PT + beta_tt_PT * tt_PT + beta_central_PT * CBD + beta_parttime_PT * parttime +
	-- beta_retired_PT * retired + beta_homemaker_PT * homemaker +
	-- beta_unemployed_PT * unemployed + 
	-- beta_age20_PT * age20 + beta_age2025_PT * age2025 + beta_age2635_PT * age2635 +
	-- beta_age3650_PT * age3650 + beta_age5165_PT * age5165 + beta_age65_PT * age65 +
	-- beta_missingage_PT * missingage + beta_INCOME_PT * INCOME +
	-- beta_missingincome_PT * missingincome + beta_female_PT * female +
	-- beta_missinggender_PT * missinggender + beta_LIC_PT * LIC +
	-- beta_TRANS_PT * TRANS + beta_zerocar_PT * zerocar +
	-- beta_onecar_PT * onecar + beta_twocar_PT * twocar +
	-- beta_threepluscar_PT * threepluscar +
	-- beta_cost * costPT +
	-- beta_preschool_PT * preschool +
	-- beta_undergraduate_PT * undergraduate + beta_graduate_PT * graduate + beta_otherstudent_PT * otherstudent

	-- utility[7] = cons_OD + beta_tt_OD * tt_car + beta_central_OD * CBD + beta_parttime_OD * parttime +
	-- beta_retired_OD * retired + beta_homemaker_OD * homemaker +
	-- beta_unemployed_OD * unemployed + 
	-- beta_age20_OD * age20 + beta_age2025_OD * age2025 + beta_age2635_OD * age2635 +
	-- beta_age3650_OD * age3650 + beta_age5165_OD * age5165 + beta_age65_OD * age65 +
	-- beta_missingage_OD * missingage + beta_INCOME_OD * INCOME +
	-- beta_missingincome_OD * missingincome + beta_female_OD * female +
	-- beta_missinggender_OD * missinggender + beta_LIC_OD * LIC +
	-- beta_TRANS_OD * TRANS + beta_zerocar_OD * zerocar +
	-- beta_onecar_OD * onecar + beta_twocar_OD * twocar +
	-- beta_threepluscar_OD * threepluscar +
	-- beta_cost * costCar/1.5+
	-- beta_preschool_OD * preschool +
	-- beta_undergraduate_OD * undergraduate + beta_graduate_OD * graduate + beta_otherstudent_OD * otherstudent

	-- concise version
	utility[1] = cons_walk + beta_tt_walk * tt_walk + beta_parttime_walk * parttime +
	beta_retired_walk * retired + beta_homemaker_walk * homemaker +
	beta_unemployed_walk * unemployed + 
	beta_INCOME_walk * INCOME +
	beta_missingincome_walk * missingincome + beta_female_walk * female +
	beta_missinggender_walk * missinggender + 
	beta_TRANS_walk * TRANS + beta_zerocar_walk * zerocar +
	beta_onecar_walk * onecar + beta_twocar_walk * twocar +
	beta_threepluscar_walk * threepluscar +
	beta_preschool_walk * preschool +
	beta_undergraduate_walk * undergraduate + beta_graduate_walk * graduate + beta_otherstudent_walk * otherstudent

	utility[2] = cons_bike + beta_tt_bike * tt_bike  + beta_parttime_bike * parttime +
	beta_retired_bike * retired + beta_homemaker_bike * homemaker +
	beta_unemployed_bike * unemployed + 
	beta_INCOME_bike * INCOME +
	beta_missingincome_bike * missingincome + beta_female_bike * female +
	beta_missinggender_bike * missinggender + 
	beta_TRANS_bike * TRANS + beta_zerocar_bike * zerocar +
	beta_onecar_bike * onecar + beta_twocar_bike * twocar +
	beta_threepluscar_bike * threepluscar +
	beta_preschool_bike * preschool +
	beta_undergraduate_bike * undergraduate + beta_graduate_bike * graduate + beta_otherstudent_bike * otherstudent


	utility[3] = cons_drive1 + beta_tt_drive1 * tt_car + beta_parttime_drive1 * parttime +
	beta_retired_drive1 * retired + beta_homemaker_drive1 * homemaker +
	beta_unemployed_drive1 * unemployed + 
	beta_INCOME_drive1 * INCOME +
	beta_missingincome_drive1 * missingincome + beta_female_drive1 * female +
	beta_missinggender_drive1 * missinggender + 
	beta_TRANS_drive1 * TRANS + beta_zerocar_drive1 * zerocar +
	beta_onecar_drive1 * onecar + beta_twocar_drive1 * twocar +
	beta_threepluscar_drive1 * threepluscar +
	beta_cost * costCar+
	beta_preschool_drive1 * preschool +
	beta_undergraduate_drive1 * undergraduate + beta_graduate_drive1 * graduate + beta_otherstudent_drive1 * otherstudent


	utility[4] = cons_share2 + beta_tt_share2 * tt_car + beta_parttime_share2 * parttime +
	beta_retired_share2 * retired + beta_homemaker_share2 * homemaker +
	beta_unemployed_share2 * unemployed +
	beta_INCOME_share2 * INCOME +
	beta_missingincome_share2 * missingincome + beta_female_share2 * female +
	beta_missinggender_share2 * missinggender + 
	beta_TRANS_share2 * TRANS + beta_zerocar_share2 * zerocar +
	beta_onecar_share2 * onecar + beta_twocar_share2 * twocar +
	beta_threepluscar_share2 * threepluscar +
	beta_cost * costCar/2 + 
	beta_preschool_share2 * preschool +
	beta_undergraduate_share2 * undergraduate + beta_graduate_share2 * graduate + beta_otherstudent_share2 * otherstudent


	utility[5] = cons_share3 + beta_tt_share3 * tt_car + beta_parttime_share3 * parttime +
	beta_retired_share3 * retired + beta_homemaker_share3 * homemaker +
	beta_unemployed_share3 * unemployed +
	beta_INCOME_share3 * INCOME +
	beta_missingincome_share3 * missingincome + beta_female_share3 * female +
	beta_missinggender_share3 * missinggender + 
	beta_TRANS_share3 * TRANS + beta_zerocar_share3 * zerocar +
	beta_onecar_share3 * onecar + beta_twocar_share3 * twocar +
	beta_threepluscar_share3 * threepluscar +
	beta_cost * costCar/3 +
	beta_preschool_share3 * preschool +
	beta_undergraduate_share3 * undergraduate + beta_graduate_share3 * graduate + beta_otherstudent_share3 * otherstudent


	utility[6] = cons_PT + beta_tt_PT * tt_PT + beta_parttime_PT * parttime +
	beta_retired_PT * retired + beta_homemaker_PT * homemaker +
	beta_unemployed_PT * unemployed + 
	beta_INCOME_PT * INCOME +
	beta_missingincome_PT * missingincome + beta_female_PT * female +
	beta_missinggender_PT * missinggender + 
	beta_TRANS_PT * TRANS + beta_zerocar_PT * zerocar +
	beta_onecar_PT * onecar + beta_twocar_PT * twocar +
	beta_threepluscar_PT * threepluscar +
	beta_cost * costPT +
	beta_preschool_PT * preschool +
	beta_undergraduate_PT * undergraduate + beta_graduate_PT * graduate + beta_otherstudent_PT * otherstudent

	utility[7] = cons_OD + beta_tt_OD * tt_car + beta_parttime_OD * parttime +
	beta_retired_OD * retired + beta_homemaker_OD * homemaker +
	beta_unemployed_OD * unemployed + 
	beta_INCOME_OD * INCOME +
	beta_missingincome_OD * missingincome + beta_female_OD * female +
	beta_missinggender_OD * missinggender + 
	beta_TRANS_OD * TRANS + beta_zerocar_OD * zerocar +
	beta_onecar_OD * onecar + beta_twocar_OD * twocar +
	beta_threepluscar_OD * threepluscar +
	beta_cost * cost_OD+
	beta_preschool_OD * preschool +
	beta_undergraduate_OD * undergraduate + beta_graduate_OD * graduate + beta_otherstudent_OD * otherstudent

	utility[8] = cons_PR + beta_tt_drive1 * tt_PR_car + 
	beta_TRANS_PR * TRANS + beta_zerocar_PR * zerocar +
	beta_onecar_PR * onecar + beta_twocar_PR * twocar +
	beta_threepluscar_PR * threepluscar +
	beta_cost * (cost_PR_car+cost_PR_PT)
	-- print("tmw utilities: 1: ", utility[1], " 2:", utility[2], " 3:", utility[3], " 4:", utility[4], " 5:", utility[5], " 6:", utility[6])

end



--availability
--the logic to determine availability is the same with current implementation
local availability = {}
local function computeAvailabilities(params,dbparams)
	local pr_avail = dbparams:getModeAvailability(8)
	if (params.vehicle_ownership_category >= 3) and (params.vehicle_ownership_category <= 5) and (params.has_driving_licence ==1) then

	else
		pr_avail =0
	end
	availability = {
		dbparams:getModeAvailability(1),
		dbparams:getModeAvailability(2),
		dbparams:getModeAvailability(3),
		1,
		1,
		dbparams:getModeAvailability(6),
		1,
		pr_avail

	}
	-- print("tmw availabilities: 1: ", availability[1], " 2:", availability[2], " 3:", availability[3], " 4:", availability[4], " 5:", availability[5], " 6:", availability[6])
	
end

--scale
local scale = 1
--scale["PT"] = 1
--scale["non-PT"] = 1

-- function to call from C++ preday simulator
-- params and dbparams tables contain data passed from C++
-- to check variable bindings in params or dbparams, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function choose_tmw(params,dbparams)
	--print("@choose_tmw")
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	--print("probabilities: ",probability)
	local choice = make_final_choice(probability)
	--print("mode choice: ",choice)
	return make_final_choice(probability)
end

-- function to call from C++ preday simulator for logsums computation
-- params and dbparams tables contain data passed from C++
-- to check variable bindings in params or dbparams, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function compute_logsum_tmw(params,dbparams)
	-- print("@choose_tmw")
	computeUtilities(params,dbparams) 
	-- print("@choose_tmw: computeUtilities")
	computeAvailabilities(params,dbparams)
	-- print("@choose_tmw: computeAvailabilities")
	-- print("@choose_tmw: logsum is ", compute_mnl_logsum(utility, availability))
	return compute_mnl_logsum(utility, availability)
end
