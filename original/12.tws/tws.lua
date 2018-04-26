--[[
Model: Work Subtour Generation
Based on: tws.lua (Siyu Li, Harish Loganathan)
Type: Binary Logit
Author: Isabel Viegas
Crated: January 28, 2017
Updated: June 20, 2017
]]

-- COEFFICIENTS
local beta_cons_NQ = -2.66
local beta_window_NQ = 0.188
local beta_parttime_NQ = -0.644
local beta_age20_NQ = -1.19
local beta_age2025_NQ = -0.493 
local beta_age2635_NQ = -0.275
local beta_age5165_NQ = 0
local beta_age5165_NQ = 0.0649
local beta_age65_NQ = 0.125
local beta_female_NQ = -0.236
local beta_income_NQ = 0.00964
local beta_missingincome_NQ = -0.100
local beta_first_NQ = 0.0722
local beta_LIC_NQ = 0.451
local beta_TRANS_NQ = 0.200
local beta_MULTJOBS_NQ = -0.298
local beta_FLEXSCHED_NQ = 0.0389
local beta_walk_NQ = 0.287
local beta_bike_NQ = 0.167
local beta_drive1_NQ = 0
local beta_share2_NQ = 0.231
local beta_share3_NQ = -0.0890
local beta_PT_NQ = -0.202
local beta_CBD_NQ = 0.270


-- CHOICE SET
-- 1 for non-quit; 2 for quit
local choice = {1,2}

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
	local cbd_dummy = (dbparams.cbd_dummy==1)

	local first = dbparams.first_of_multiple
	local mode = dbparams.mode_choice

	local parttime = 0
	if person_type_id == 2 then 
		parttime = 1
	end 

	local MULTJOBS = 0
	
	local age20,age2025,age2635,age3650,age5165,age65,missingage = 0,0,0,0,0,0,0
	if age_id == 1 then 
		age20 = 1
	elseif age_id == 2 then 
		age2025 = 1
	elseif age_id == 3 then
		age2635 = 1
	elseif age_id == 4 then
		age3650 = 1
	elseif age_id == 5 then
		age5165 = 1
	elseif age_id == 6 then 
		age65 = 1
	elseif age_id == 7 then
		missingage = 1
	end

	local female = 0
	if female_dummy == 0 then
		female = 1
	end

	local walk,bike,drive1,share2,share3,PT = 0,0,0,0,0,0
	if mode == 1 then
		walk = 1
	elseif mode == 2 then
		bike = 1
	elseif mode == 3 then
		drive1 = 1
	elseif mode == 4 then
		share2 = 1
	elseif mode == 5 then
		share3 = 1
	elseif mode == 6 then
		PT = 1
	end

	local LIC = 0
	if license == true then
		LIC = 1
	end

	local TRANS = 0
	if transit == true then
		TRANS = 1
	end

	local FLEXSCHED = 0
	if fixedworktime == false then
		FLEXSCHED = 1
	end

	local CBD = 0
	if cbd_dummy == 0 then
		CBD = 1
	end


	utility[1] = beta_cons_NQ + beta_parttime_NQ * parttime + beta_age20_NQ * age20 + beta_age2025_NQ * age2025 + beta_age2635_NQ * age2635 + beta_age5165_NQ * age5165 + beta_age65_NQ * age65 + 
				beta_female_NQ * female  + beta_income_NQ * income_mid[income_id] +  beta_missingincome_NQ * missing_income + beta_first_NQ * first + beta_LIC_NQ * LIC + beta_TRANS_NQ * TRANS + beta_CBD_NQ * CBD + 
				beta_walk_NQ * walk + beta_bike_NQ * bike + beta_PT_NQ * PT + beta_share2_NQ * share2 + beta_share3_NQ * share3
	utility[2] = 0

end

-- AVAILABILITY
-- both are always available; simulator will delete generated tour if there is not time available
local availability = {1,1}

-- SCALE
local scale = 1

function choose_tws(params,dbparams)
	computeUtilities(params,dbparams) 
	local probability = calculate_probability("mnl", choice, utility, availability)
	return make_final_choice(probability)
end
