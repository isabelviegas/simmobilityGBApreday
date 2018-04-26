--[[
Model: Tour Mode - Eduation
Based on: dpb.lua (Siyu Li, Harish Loganathan)
Type: Binary Logit
Author: Isabel Viegas
Crated: January 3, 2017
Updated: July 2, 2017
]]

local cons_walk = -0.356 
local cons_bike = -3.38
local cons_drive1 = 0 
local cons_share2 = -1.29
local cons_share3 = -1.04
local cons_PT = -0.886 

local beta_tt_walk = -0.0814
local beta_tt_bike = -0.0698
local beta_tt_drive1 = 0
local beta_tt_share2 = 0
local beta_tt_share3 = 0
local beta_tt_PT = 0.00436
local beta_tt_car = 0

local beta_cost_walk = 0
local beta_cost_bike = 0
local beta_cost_drive1 = 0
local beta_cost_share2 = 0
local beta_cost_share3 = 0
local beta_cost_car = 0.0432
local beta_cost_PT = 0.00671
local beta_cost = 0

local beta_central_walk = 2.49
local beta_central_bike = 0
local beta_central_drive1 = 0
local beta_central_share2 = 0
local beta_central_share3 = 0
local beta_central_PT = 2.12

local beta_parttime_walk = 0
local beta_parttime_bike = 0
local beta_parttime_drive1 = 0
local beta_parttime_share2 = 0.522
local beta_parttime_share3 = -0.336
local beta_parttime_PT = -0.729

local beta_retired_walk = 0
local beta_retired_bike = 0
local beta_retired_drive1 = 0
local beta_retired_share2 = 0
local beta_retired_share3 = 0
local beta_retired_PT = 0

local beta_homemaker_walk = 0
local beta_homemaker_bike = 0
local beta_homemaker_drive1 = 0
local beta_homemaker_share2 = 0
local beta_homemaker_share3 = 0
local beta_homemaker_PT = 0

local beta_unemployed_walk = 0
local beta_unemployed_bike = 0
local beta_unemployed_drive1 = 0
local beta_unemployed_share2 = 0
local beta_unemployed_share3 = 0
local beta_unemployed_PT = 0

local beta_preschool_walk = 0.617
local beta_preschool_bike = 0
local beta_preschool_drive1 = 0
local beta_preschool_share2 = 1.28
local beta_preschool_share3 = 1.40
local beta_preschool_PT = -0.736

local beta_studentK8_walk = 0
local beta_studentK8_bike = 0
local beta_studentK8_drive1 = 0
local beta_studentK8_share2 = 0
local beta_studentK8_share3 = 0
local beta_studentK8_PT = 0

local beta_student912_walk = 0
local beta_student912_bike = 0
local beta_student912_drive1 = 0
local beta_student912_share2 = 0
local beta_student912_share3 = 0
local beta_student912_PT = 0

local beta_undergraduate_walk = 0
local beta_undergraduate_bike = 1.49
local beta_undergraduate_drive1 = 0
local beta_undergraduate_share2 = -0.457
local beta_undergraduate_share3 = -1.96
local beta_undergraduate_PT = 0

local beta_graduate_walk = 0
local beta_graduate_bike = 0
local beta_graduate_drive1 = 0
local beta_graduate_share2 = 0
local beta_graduate_share3 = 0
local beta_graduate_PT = 0

local beta_otherstudent_walk = 0
local beta_otherstudent_bike = 0
local beta_otherstudent_drive1 = 0
local beta_otherstudent_share2 = 0
local beta_otherstudent_share3 = 0
local beta_otherstudent_PT = 0

-- Age 
local beta_age20_walk = 0
local beta_age20_bike = 0
local beta_age20_drive1 = 0
local beta_age20_share2 = 0
local beta_age20_share3 = 0
local beta_age20_PT = 0

local beta_age2025_walk = 0
local beta_age2025_bike = 0
local beta_age2025_drive1 = 0
local beta_age2025_share2 = 0
local beta_age2025_share3 = 0
local beta_age2025_PT = 0

local beta_age2635_walk = 0
local beta_age2635_bike = 0
local beta_age2635_drive1 = 0
local beta_age2635_share2 = 0
local beta_age2635_share3 = 0
local beta_age2635_PT = 0

local beta_age3650_walk = 0
local beta_age3650_bike = 0
local beta_age3650_drive1 = 0
local beta_age3650_share2 = 0
local beta_age3650_share3 = 0
local beta_age3650_PT = 0

local beta_age5165_walk = 0
local beta_age5165_bike = 0
local beta_age5165_drive1 = 0
local beta_age5165_share2 = 0
local beta_age5165_share3 = 0
local beta_age5165_PT = 0

local beta_age65_walk = 0
local beta_age65_bike = 0
local beta_age65_drive1 = 0
local beta_age65_share2 = 0
local beta_age65_share3 = 0
local beta_age65_PT = 0

local beta_missingage_walk = 0
local beta_missingage_bike = 0
local beta_missingage_drive1 = 0
local beta_missingage_share2 = 0
local beta_missingage_share3 = 0
local beta_missingage_PT = 0


-- Income Variables

local beta_INCOME_walk = 0
local beta_INCOME_bike = 0
local beta_INCOME_drive1 = 0
local beta_INCOME_share2 = 0
local beta_INCOME_share3 = 0
local beta_INCOME_PT = 0

local beta_missingincome_walk = 0
local beta_missingincome_bike = 0
local beta_missingincome_drive1 = 0
local beta_missingincome_share2 = 0
local beta_missingincome_share3 = 0
local beta_missingincome_PT = 0

-- Gender Variables

local beta_female_walk = 0
local beta_female_bike = -1.27
local beta_female_drive1 = 0
local beta_female_share2 = 0
local beta_female_share3 = 0
local beta_female_PT = -0.314

local beta_missinggender_walk = 0
local beta_missinggender_bike = 0
local beta_missinggender_drive1 = 0
local beta_missinggender_share2 = 0
local beta_missinggender_share3 = 0
local beta_missinggender_PT = 0

-- Transportation-specific Variables

local beta_LIC_walk = 1.32
local beta_LIC_bike = 0
local beta_LIC_drive1 = 0
local beta_LIC_share2 = 1.46
local beta_LIC_share3 = 0
local beta_LIC_PT = 0

local beta_TRANS_walk = 1.26
local beta_TRANS_bike = 0
local beta_TRANS_drive1 = 0
local beta_TRANS_share2 = 0
local beta_TRANS_share3 = 0
local beta_TRANS_PT = 1.20

-- Number of Vehicles in Household
local beta_zerocar_walk = 0
local beta_zerocar_bike = 1.05
local beta_zerocar_drive1 = 0
local beta_zerocar_share2 = -1.20
local beta_zerocar_share3 = 0
local beta_zerocar_PT = 0.761

local beta_onecar_walk = 1.13
local beta_onecar_bike = 1.40
local beta_onecar_drive1 = 0
local beta_onecar_share2 = 0.272
local beta_onecar_share3 = 0.843
local beta_onecar_PT = 0.600

local beta_twocar_walk = 0.360
local beta_twocar_bike = 0.767
local beta_twocar_drive1 = 0
local beta_twocar_share2 = 0.459
local beta_twocar_share3 = 1.08
local beta_twocar_PT = 0.376

local beta_threepluscar_walk = 0
local beta_threepluscar_bike = 0
local beta_threepluscar_drive1 = 0
local beta_threepluscar_share2 = 0
local beta_threepluscar_share3 = 0
local beta_threepluscar_PT = 0



-- CHOICE SET
local choice = {
		1,
		2,
		3,
		4,
		5,
		6,
}


-- UTILITY
local utility = {}
local function computeUtilities(params,dbparams)
	local person_type_id = params.person_type_id 
	local age_id = params.age_id
	local female_dummy = params.female_dummy
	local student_dummy = params.student_dummy
	local income_id = params.income_id
	local income_mid = {0.75,2,3,4.25,6.25,8.75,12.5,20}
	local missing_income = params.missing_income
	local LIC = params.has_driving_licence
	local studentTypeId = params.studentTypeId
	local transit = params.vanbus_license
	local fixedworktime = params.fixed_work_hour

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
	
	local female = 0.0
	if female_dummy == 0 then
		female = 1
	end

	local missinggender = 0
	
	local INCOME = income_mid[income_id]
	local missingincome = 0
	if missing_income == true then
		missingincome = 1
	end

	local LIC = 0
	if license == true then
		LIC = 1
	end

	local TRANS = 0
	if transit == true then
		TRANS = 1
	end

	local CBD = dbparams.central_dummy

	local d1 = dbparams.walk_distance1
	local d2 = dbparams.walk_distance2
	local tt_walk = math.max(d1,d2)

	local tt_ivt_car_first = dbparams.tt_ivt_car_first
	local tt_ivt_car_second = dbparams.tt_ivt_car_second
	local tt_bike = math.max(tt_ivt_car_first,tt_ivt_car_second)

	local tt_PT_ivt_first = dbparams.tt_public_ivt_first
	local tt_PT_ivt_second = dbparams.tt_public_ivt_second
	local tt_PT_waiting_first = dbparams.tt_public_waiting_first
	local tt_PT_waiting_second = dbparams.tt_public_waiting_second
	local tt_PT_walk_first =  dbparams.tt_public_walk_first
	local tt_PT_walk_second = dbparams.tt_public_walk_second

	local tt_PT_first = tt_PT_ivt_first + tt_PT_waiting_first + tt_PT_walk_first
	local tt_PT_second = tt_PT_ivt_second + tt_PT_waiting_second + tt_PT_walk_second
	local tt_PT = math.max(tt_PT_first, tt_PT_second)

	local tt_car = math.max(tt_ivt_car_first,tt_ivt_car_second)

	local veh_cat = params.vehicle_ownership_category
	local zerocar = 0
	local onecar = 0
	local twocar = 0
	local threepluscar = 0

	if veh_cat == 0 or veh_cat == 6 or veh_cat == 9 then
		zerocar = 1
	elseif veh_cat == 1 or veh_cat == 4 or veh_cat == 7 or veh_cat == 10 then
		onecar = 1
	elseif veh_cat == 2 or veh_cat == 5 or veh_cat == 8 or veh_cat == 11 then
		twocar = 1
	end

	local infant = 0

	local cost_PT_first = dbparams.cost_public_first
	local cost_PT_second = dbparams.cost_public_second

	local costPT = cost_PT_second + cost_PT_first

	local cost_car_ERP_first = dbparams.cost_car_ERP_first
	local cost_car_ERP_second = dbparams.cost_car_ERP_second
	local cost_car_OP_first = dbparams.cost_car_OP_first
	local cost_car_OP_second = dbparams.cost_car_OP_second
	local cost_car_parking = dbparams.cost_car_parking

	local costCar = cost_car_ERP_first + cost_car_ERP_second + cost_car_OP_first + cost_car_OP_second + cost_car_parking 

	utility[1] = cons_walk + beta_tt_walk * tt_walk + beta_central_walk * CBD + beta_parttime_walk * parttime +
	beta_retired_walk * retired +  beta_homemaker_walk * homemaker +
	beta_unemployed_walk * unemployed + 
	beta_age20_walk * age20 + beta_age2025_walk * age2025 + beta_age2635_walk * age2635 +
	beta_age3650_walk * age3650 + beta_age5165_walk * age5165 + beta_age65_walk * age65 +
	beta_INCOME_walk * INCOME +
	beta_missingincome_walk * missingincome + beta_female_walk * female +
	beta_missinggender_walk * missinggender + beta_LIC_walk * LIC +
	beta_TRANS_walk * TRANS +
	beta_zerocar_walk * zerocar +
	beta_onecar_walk * onecar + beta_twocar_walk * twocar +
	beta_threepluscar_walk * threepluscar +
	beta_preschool_walk * preschool +
	beta_undergraduate_walk * undergraduate + beta_graduate_walk * graduate + beta_otherstudent_walk * otherstudent

	utility[2] = cons_bike + beta_tt_bike * tt_bike + beta_central_bike * CBD + beta_parttime_bike * parttime +
	beta_retired_bike * retired + beta_homemaker_bike * homemaker +
	beta_unemployed_bike * unemployed + 
	beta_age20_bike * age20 + beta_age2025_bike * age2025 + beta_age2635_bike * age2635 +
	beta_age3650_bike * age3650 + beta_age5165_bike * age5165 + beta_age65_bike * age65 +
	beta_missingage_bike * missingage + beta_INCOME_bike * INCOME +
	beta_missingincome_bike * missingincome + beta_female_bike * female +
	beta_missinggender_bike * missinggender + beta_LIC_bike * LIC +
	beta_TRANS_bike * TRANS +
	beta_zerocar_bike * zerocar +
	beta_onecar_bike * onecar + beta_twocar_bike * twocar +
	beta_threepluscar_bike * threepluscar +
	beta_preschool_bike * preschool +
	beta_undergraduate_bike * undergraduate + beta_graduate_bike * graduate + beta_otherstudent_bike * otherstudent

	utility[3] = cons_drive1 + beta_tt_car * tt_car + beta_central_drive1 * CBD + beta_parttime_drive1 * parttime +
	beta_retired_drive1 * retired + beta_homemaker_drive1 * homemaker +
	beta_unemployed_drive1 * unemployed + 
	beta_age20_drive1 * age20 + beta_age2025_drive1 * age2025 + beta_age2635_drive1 * age2635 +
	beta_age3650_drive1 * age3650 + beta_age5165_drive1 * age5165 + beta_age65_drive1 * age65 +
	beta_missingage_drive1 * missingage + beta_INCOME_drive1 * INCOME +
	beta_missingincome_drive1 * missingincome + beta_female_drive1 * female +
	beta_missinggender_drive1 * missinggender + beta_LIC_drive1 * LIC +
	beta_TRANS_drive1 * TRANS +
	beta_cost_car * costCar +
	beta_zerocar_drive1 * zerocar +
	beta_onecar_drive1 * onecar + beta_twocar_drive1 * twocar +
	beta_threepluscar_drive1 * threepluscar +
	beta_preschool_drive1 * preschool +
	beta_undergraduate_drive1 * undergraduate + beta_graduate_drive1 * graduate + beta_otherstudent_drive1 * otherstudent

	utility[4] = cons_share2 + beta_tt_car * tt_car + beta_central_share2 * CBD + beta_parttime_share2 * parttime +
	beta_retired_share2 * retired + beta_homemaker_share2 * homemaker +
	beta_unemployed_share2 * unemployed + 
	beta_age20_share2 * age20 + beta_age2025_share2 * age2025 + beta_age2635_share2 * age2635 +
	beta_age3650_share2 * age3650 + beta_age5165_share2 * age5165 + beta_age65_share2 * age65 +
	beta_missingage_share2 * missingage + beta_INCOME_share2 * INCOME +
	beta_missingincome_share2 * missingincome + beta_female_share2 * female +
	beta_missinggender_share2 * missinggender + beta_LIC_share2 * LIC +
	beta_TRANS_share2 * TRANS +
	beta_cost_car * costCar/2 +
	beta_zerocar_share2 * zerocar +
	beta_onecar_share2 * onecar + beta_twocar_share2 * twocar +
	beta_threepluscar_share2 * threepluscar +
	beta_preschool_share2 * preschool +
	beta_undergraduate_share2 * undergraduate + beta_graduate_share2 * graduate + beta_otherstudent_share2 * otherstudent


	utility[5] = cons_share3 + beta_tt_car * tt_car + beta_central_share3 * CBD + beta_parttime_share3 * parttime +
	beta_retired_share3 * retired + beta_homemaker_share3 * homemaker +
	beta_unemployed_share3 * unemployed +
	beta_age20_share3 * age20 + beta_age2025_share3 * age2025 + beta_age2635_share3 * age2635 +
	beta_age3650_share3 * age3650 + beta_age5165_share3 * age5165 + beta_age65_share3 * age65 +
	beta_missingage_share3 * missingage + beta_INCOME_share3 * INCOME +
	beta_missingincome_share3 * missingincome + beta_female_share3 * female +
	beta_missinggender_share3 * missinggender + beta_LIC_share3 * LIC +
	beta_TRANS_share3 * TRANS +
	beta_cost_car * costCar/3 +
	beta_zerocar_share3 * zerocar +
	beta_onecar_share3 * onecar + beta_twocar_share3 * twocar +
	beta_threepluscar_share3 * threepluscar +
	beta_preschool_share3 * preschool +
	beta_undergraduate_share3 * undergraduate + beta_graduate_share3 * graduate + beta_otherstudent_share3 * otherstudent

	utility[6] = cons_PT + beta_tt_PT * tt_PT + beta_central_PT * CBD + beta_parttime_PT * parttime +
	beta_retired_PT * retired + beta_homemaker_PT * homemaker +
	beta_unemployed_PT * unemployed + 
	beta_age20_PT * age20 + beta_age2025_PT * age2025 + beta_age2635_PT * age2635 +
	beta_age3650_PT * age3650 + beta_age5165_PT * age5165 + beta_age65_PT * age65 +
	beta_missingage_PT * missingage + beta_INCOME_PT * INCOME +
	beta_missingincome_PT * missingincome + beta_female_PT * female +
	beta_missinggender_PT * missinggender + beta_LIC_PT * LIC +
	beta_TRANS_PT * TRANS +
	beta_cost_PT * costPT +
	beta_zerocar_PT * zerocar +
	beta_onecar_PT * onecar + beta_twocar_PT * twocar +
	beta_threepluscar_PT * threepluscar +
	beta_preschool_PT * preschool +
	beta_undergraduate_PT * undergraduate + beta_graduate_PT * graduate + beta_otherstudent_PT * otherstudent

end



-- AVAILABILITY
local availability = {}
local function computeAvailabilities(params,dbparams)
	
	availability = {
		dbparams:getModeAvailability(1),
		dbparams:getModeAvailability(2),
		dbparams:getModeAvailability(3),
		1,
		1,
		dbparams:getModeAvailability(6)
	}
end

-- SCALE
local scale = 1

function choose_tme(params,dbparams)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	local choice = make_final_choice(probability)
	return make_final_choice(probability)
end

function compute_logsum_tme(params,dbparams)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	return compute_mnl_logsum(utility, availability)
end
