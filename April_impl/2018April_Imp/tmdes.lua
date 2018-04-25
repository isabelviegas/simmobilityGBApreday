--[[
Model - Mode/destination choice for shopping tour to unusual location
Type - logit
Based on tmdw by Siyu Li, Harish Loganathan
Author of the older version: Isabel Viegas
Updated February 23, 2017

This version 
1. Includes on-demand service and Park-ride as new modes in the model
2. Includes town parameter and re-structured the cbd parameters to be mode-specific to address space distribution mismatch
Created and calibrated by Yifei Xie
Updated: April, 2018
]]

-- all require statements do not work with C++. They need to be commented. The order in which lua files are loaded must be explicitly controlled in C++. 
--require "Logit"

--Estimated values for all betas
--Note: the betas that not estimated are fixed to zero.

--!! see the documentation on the definition of AM,PM and OP table!!


local beta_cons_walk = 16.75
local beta_cons_bike = -2.73
local beta_cons_drive1 = 4.5
local beta_cons_share2 = 5.8  
local beta_cons_share3 = 5.64
local beta_cons_PT = 5.52     -1
local beta_cons_OD = -15 --on demand
local beta_cons_PR = 1.52


local beta_tt_slow = -0.118
local beta_tt_drive1 = -0.00215
local beta_tt_share2 = -0.176
local beta_tt_share3 = -0.236
local beta_tt_PT = -0.0527
local beta_tt_OD = beta_tt_drive1

local beta_employment = 0
local beta_log = 0.355

local beta_cbd_notdrive = 0.444  
local beta_cbd_car = -0.897       
local beta_cbd_PT = -1.08         
local beta_cbd_OD = (beta_cbd_PT + beta_cbd_notdrive)/2
local beta_cbd_PR = (beta_cbd_PT + beta_cbd_notdrive)/2

local beta_cost = -0.181

local beta_Boston = 0
--choice set
local choice = {}
for i = 1, 2727*8 do 
	choice[i] = i
end

--utility
-- 1 for public bus; 2 for MRT/LRT; 3 for private bus; 4 for drive1;
-- 5 for shared2; 6 for shared3+; 7 for motor; 8 for walk; 9 for taxi
local utility = {}
local function computeUtilities(params,dbparams)

	local cost_public_first = {}
	local cost_public_second = {}
	local tt_public_first = {}
	local tt_public_second = {}

	local cost_OD_1={}
	local cost_OD_2={}
	local cost_OD  ={}

	local cost_PT = {}
	local cost_car = {}
	local cost_PR_PT={}
	local cost_PR_car={}

	local tt_walk = {}
	local tt_bike = {} 
	local CBD = {}


	local tt_walk = {}
	local tt_bike = {}
	local tt_car = {} 
	local tt_PT = {}
	local tt_PR_PT={}
	local tt_PR_car={}

	local EMP = {}
	local POP = {}
	local AREA = {}
	local SHOP = {}
	local TOWN = {}
	local bool_to_number={ [true]=1, [false]=0 }



	local log = math.log
	local exp = math.exp

	for i =1,2727 do
		-- walk
		tt_walk[i] = (dbparams:walk_distance1(i) + dbparams:walk_distance2(i)) * 30 / 3.1

		-- bike
		tt_bike[i] = (dbparams:walk_distance1(i) + dbparams:walk_distance2(i)) * 30 / 9.6

		-- car
		tt_car[i] = (dbparams:tt_car_ivt_first(i) + dbparams:tt_car_ivt_second(i))/2
		cost_car[i] = (dbparams:cost_car_ERP_first(i) + dbparams:cost_car_ERP_second(i) + dbparams:cost_car_OP_first(i) + dbparams:cost_car_OP_second(i)+dbparams:cost_car_parking(i))/2
		
		-- PT
		tt_public_first[i] = dbparams:tt_public_ivt_first(i) + dbparams:tt_public_out_first(i)
		tt_public_second[i] = dbparams:tt_public_ivt_second(i) + dbparams:tt_public_out_second(i)

		tt_PT[i] = (tt_public_first[i] + tt_public_second[i])/2
		cost_public_first[i] = dbparams:cost_public_first(i)
		cost_public_second[i] = dbparams:cost_public_second(i)
		cost_PT[i] = (cost_public_first[i] + cost_public_second[i])/2

		--Base fare 2$, Booking fee 1.6$ Per minute 0.2$ per mile 1.29$
		cost_OD_1[i] = 2 + 1.6 + dbparams:tt_car_ivt_first(i)*0.2 + dbparams:walk_distance1(i)*1.29
		cost_OD_1[i] = math.max(cost_OD_1[i],6.6)
		cost_OD_2[i] = 2 + 1.6 + dbparams:tt_car_ivt_second(i)*0.2 + dbparams:walk_distance2(i)*1.29
		cost_OD_2[i] = math.max(cost_OD_2[i],6.6)
		cost_OD[i]   = (cost_OD_1[i]+cost_OD_2[i])/2

		tt_PR_PT[i] = ( dbparams:tt_public_ivt_first(i) + dbparams:tt_public_ivt_second(i) )/2
		tt_PR_car[i]= ( dbparams:tt_public_out_first(i) + dbparams:tt_public_out_second(i) )/2 *5/60
		cost_PR_PT[i] = cost_PT[i]
		cost_PR_car[i]= 3

		CBD[i] = dbparams:central_dummy(i)

		EMP[i] = dbparams:employment(i)
		POP[i] = dbparams:population(i)
		AREA[i] = dbparams:area(i)
		TOWN[i] = dbparams:town_id(i)
		-- print("i = ", i , ": tt_walk: ", tt_walk[i], " tt_bike: ", tt_bike[i], " tt_car: ", tt_car[i], "cost_car: ", cost_car[i], " tt_PT: ", tt_PT[i], " CBD: ", CBD[i], " EMP: ", EMP[i], " POP: ", POP[i], " AREA: ", AREA[i])
		
	end

	-- print("Created tts, costs, cbd, emp, pop, and area")

	local V_counter = 0

	--utility function for walk 1-1092
	for i =1,2727 do
		V_counter = V_counter + 1
		utility[V_counter] = beta_cons_walk + tt_walk[i]*beta_tt_slow + beta_cbd_notdrive * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)* EMP[i]) + beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility function for bike 1-1092
	for i=1,2727 do
		V_counter = V_counter + 1
		utility[V_counter] = beta_cons_bike + tt_bike[i]*beta_tt_slow + beta_cbd_notdrive * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)* EMP[i]) + beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility function for drive 1 1-1092
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_drive1 + tt_car[i]*beta_tt_drive1 + beta_cbd_car * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)* EMP[i]) + beta_cost * cost_car[i] + beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility function for share 2 1-1092
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share2 + tt_car[i]*beta_tt_share2 + beta_cbd_car * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)* EMP[i]) + beta_cost * cost_car[i]/2 + beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility function for share 3 1-1092
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share3 + tt_car[i]*beta_tt_share3 + beta_cbd_car * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)* EMP[i]) + beta_cost * cost_car[i]/3 + beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility function for PT 1-1092
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_PT + tt_PT[i]*beta_tt_PT + beta_cbd_PT * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)* EMP[i]) + beta_cost * cost_PT[i]+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility for on demand
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_OD + tt_car[i]*beta_tt_OD + beta_cbd_OD * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)* EMP[i]) + beta_cost * cost_OD[i]+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility for PR
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_PR + tt_PR_car[i]*beta_tt_drive1 + tt_PR_PT[i]*beta_tt_PT+  beta_cbd_PR * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)* EMP[i]) + beta_cost * (cost_PR_PT[i] + cost_PR_car[i]) + beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end
end


--availability
--the logic to determine availability is the same with current implementation
local availability = {}
local function computeAvailabilities(params,dbparams)
	for i = 1, 2727*7 do 
		availability[i] = dbparams:availability(i)
	end

	for i = 8182, 13635 do
		-- availability[i] = availability[6000]
		availability[i] = 1
	end
	
	for i = 2727,8181 do
		availability[i] = 0
	end

	-- make availability for park and ride
	for i = 2727*7+1, 2727*8 do
		if (params.vehicle_ownership_category >= 3) and (params.vehicle_ownership_category <= 5) and (params.has_driving_licence ==1) then
			availability[i] = dbparams:availability(i)
		else
			availability[i] =0
		end
	end
	-- print("avail drive 1: ", availability[6000])
	-- print("avail share 2: ", availability[9000])
	-- print("avail share 3: ", availability[12000])
end

--scale
local scale = 1 --for all choices

-- function to call from C++ preday simulator
-- params and dbparams tables contain data passed from C++
-- to check variable bindings in params or dbparams, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function choose_tmdes(params,dbparams)
	-- print("@tmdes.lua: in choose_tmdes")
	computeUtilities(params,dbparams) 
	-- print("@tmdes.lua: computed utilities")
	computeAvailabilities(params,dbparams)
	-- print("@tmdes.lua: computed availabilities")
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	-- local choice = make_final_choice(probability)
	-- print("mode choice: ",choice)
	return make_final_choice(probability)
end

-- function to call from C++ preday simulator for logsums computation
-- params and dbparams tables contain data passed from C++
-- to check variable bindings in params or dbparams, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function compute_logsum_tmdes(params,dbparams)
	-- print("@tmdes.lua: in choose_tmdes")
	computeUtilities(params,dbparams) 
	-- print("@tmdes.lua: computed utilities")
	computeAvailabilities(params,dbparams)
	-- print("@tmdes.lua: computed availabilities")
	return compute_mnl_logsum(utility, availability)
end
