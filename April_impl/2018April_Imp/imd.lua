--[[
Model - Mode/destination choice for intermediate stops
Type - logit
Based on tmdw by Siyu Li, Harish Loganathan
Created by Isabel Viegas on June 4, 2017

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

local beta_cons_walk = 4.79     +0.1
local beta_cons_bike = -1.2  +0.5 +0.5
local beta_cons_drive1 = 2.5
local beta_cons_share2 = -0.653 -0.2 -0.4    -0.5    -1
local beta_cons_share3 = 0.293  +0.2
local beta_cons_PT = -0.44      -0.1 -0.2    -0.5    -1
local beta_cons_OD = -10
local beta_cons_PR = -5              -0.2

local beta_tt_walk = -0.0844
local beta_tt_bike = -0.0903
local beta_tt_car = -0.177
local beta_tt_PT = -0.0983
local beta_tt_OD = beta_tt_car


local beta_cbd_work = 2.57 
local beta_cbd_edu = 0     
local beta_cbd_personal = 1.56  
local beta_cbd_rec = 1.81       
local beta_cbd_shop = 1.62      
local beta_cbd_escort = 1.12    

local beta_cbd_notdrive = -1.32
local beta_cbd_drive1 = -3.38
local beta_cbd_share2 = -2.84
local beta_cbd_share3 = -3.76
local beta_cbd_PT = -2.01
local beta_cbd_OD = (beta_cbd_notdrive+beta_cbd_PT)/2
local beta_cbd_PR = (beta_cbd_notdrive+beta_cbd_PT)/2

local beta_log_work = 0.193
local beta_log_edu = 0
local beta_log_personal = 0.385
local beta_log_rec = 0.276
local beta_log_shop = 0.605
local beta_log_escort = 0.0395

local beta_cost = 0.0110
local beta_employment = 3.27
local beta_shop = 8.33
local beta_Boston = 0
-- local beta_distance_walk = 0

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
	local stoptype = dbparams.stop_type

	-- print("stoptype: ", stoptype)

	local work,edu,personal,rec,shop,escort = 0.0,0.0,0.0,0.0,0.0,0.0
	
	if stoptype == 1 then
		work = 1.0
	elseif stoptype == 2 then
		edu = 1.0
	elseif stoptype == 3 then
		personal = 1.0
	elseif stoptype == 4 then
		rec = 1.0
	elseif stoptype == 5 then
		shop = 1.0	
	elseif stoptype == 6 then
		escort = 1.0
	end

	-- print("work: ", work, " edu: ", edu, " personal: ", personal, " rec: ", rec, " shop: ", shop, " escort:", escort )


	local cost_public_first = {}
	local cost_public_second = {}
	local cost_PT = {}

	local cost_car = {}

	local tt_walk = {}
	local tt_bike = {} 
	local CBD = {}


	local tt_public_first = {}
	local tt_public_second = {}
	local Dist = {}


	local tt_walk = {}
	local tt_bike = {}
	local tt_car = {} 
	local tt_PT = {}
	local tt_PR_PT ={}
	local tt_PR_car = {}
	
	local cost_OD_1={}
	local cost_OD_2={}
	local cost_OD  ={}
	local cost_PR_PT  ={}
	local cost_PR_car ={}

	local EMP = {}
	local POP = {}
	local AREA = {}
	local SHOP = {}
	local TOWN = {}
	local bool_to_number={ [true]=1, [false]=0 }

	local log = math.log
	local exp = math.exp

	for i =1,2727 do
		-- print("i: ", i)
		-- walk
		tt_walk[i] = (dbparams:walk_distance1(i) + dbparams:walk_distance2(i)) * 60 / 3.1
		-- print("tt_walk: ", tt_walk[i])
		-- bike
		tt_bike[i] = (dbparams:walk_distance1(i) + dbparams:walk_distance2(i)) * 60 / 9.6
		-- print("tt_bike: ", tt_bike[i])
		-- car
		tt_car[i] =  dbparams:tt_car_ivt(i)
		-- print("tt_car: ", tt_car[i])
		cost_car[i] = dbparams:cost_car_ERP(i) + dbparams:cost_car_OP(i) + dbparams:cost_car_parking(i)
		-- print("cost_car: ", cost_car[i])
		-- PT

		tt_PT[i] = dbparams:tt_public_ivt(i) + dbparams:tt_public_out(i)
		-- print("tt_PT: ", tt_PT[i])

		cost_PT[i] = dbparams:cost_public(i)
		-- print("cost_PT: ", cost_PT[i])
		--Base fare 2$, Booking fee 1.6$ Per minute 0.2$ per mile 1.29$
		cost_OD_1[i] = 2 + 1.6 + dbparams:tt_car_ivt(i)*0.2 + dbparams:walk_distance1(i)*1.29
		cost_OD_1[i] = math.max(cost_OD_1[i],6.6)
		cost_OD_2[i] = 2 + 1.6 + dbparams:tt_car_ivt(i)*0.2 + dbparams:walk_distance2(i)*1.29
		cost_OD_2[i] = math.max(cost_OD_2[i],6.6)
		cost_OD[i]   = (cost_OD_1[i]+cost_OD_2[i])/2

		tt_PR_PT[i] = dbparams:tt_public_ivt(i) 
		tt_PR_car[i]= dbparams:tt_public_out(i)*5/60
		cost_PR_PT[i] = cost_PT[i]
		cost_PR_car[i]= 3


		CBD[i] = dbparams:central_dummy(i)
		-- print("CBD: ", CBD[i])

		EMP[i] = dbparams:employment(i)
		-- print("EMP: ", EMP[i])
		POP[i] = dbparams:population(i)
		-- print("POP: ", POP[i])
		AREA[i] = dbparams:area(i)
		-- print("AREA: ", AREA[i])
		SHOP[i] = dbparams:shop(i)
		Dist[i] = dbparams:walk_distance1(i) + dbparams:walk_distance2(i)
		TOWN[i] = dbparams:town_id(i)
		
		-- print("Dist: ", Dist[i])

		-- print("i = ", i , ": tt_walk: ", tt_walk[i], " tt_bike: ", tt_bike[i], " tt_car: ", tt_car[i], "cost_car: ", cost_car[i], " tt_PT: ", tt_PT[i], " CBD: ", CBD[i], " EMP: ", EMP[i], " POP: ", POP[i], " AREA: ", AREA[i])
		
	end

	local V_counter = 0

	--utility function for walk
	for i =1,2727 do
		V_counter = V_counter + 1
		utility[V_counter] = beta_cons_walk + tt_walk[i] * beta_tt_walk + 
		(beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + 
		beta_log_shop * shop + beta_log_escort * escort) * 
		log(AREA[i] + exp(beta_employment) * EMP[i]+exp(beta_shop)*SHOP[i]) +
		(beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + 
		beta_cbd_shop * shop + beta_cbd_escort * escort+beta_cbd_notdrive) * CBD[i] + beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility function for bike
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_bike + tt_bike[i] * beta_tt_bike + 
		(beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + 
		beta_log_shop * shop + beta_log_escort * escort) * 
		log(AREA[i] + exp(beta_employment) * EMP[i] + exp(beta_shop)*SHOP[i]) + 
		(beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + 
		beta_cbd_shop * shop + beta_cbd_escort * escort+beta_cbd_notdrive) * CBD[i]+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility function for drive1
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_drive1 + tt_car[i] * beta_tt_car + 
		(beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + 
		beta_log_shop * shop + beta_log_escort * escort) * 
		log(AREA[i] + exp(beta_employment) * EMP[i] + exp(beta_shop)*SHOP[i]) + 
		(beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + 
		beta_cbd_shop * shop + beta_cbd_escort * escort+beta_cbd_drive1) * CBD[i] + beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility function for share2
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share2 + tt_car[i] * beta_tt_car + 
		(beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + 
		beta_log_shop * shop + beta_log_escort * escort) * 
		log(AREA[i] + exp(beta_employment) * EMP[i] + exp(beta_shop)*SHOP[i]) + 
		(beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + 
		beta_cbd_shop * shop + beta_cbd_escort * escort+beta_cbd_share2) * CBD[i] + beta_cost * cost_car[i]/2+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility function for share3
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share3 + tt_car[i] * beta_tt_car + 
		(beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + 
		beta_log_shop * shop + beta_log_escort * escort) * 
		log(AREA[i] + exp(beta_employment) * EMP[i] + exp(beta_shop)*SHOP[i]) + 
		(beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + 
		beta_cbd_shop * shop + beta_cbd_escort * escort+beta_cbd_share3) * CBD[i] + beta_cost * cost_car[i]/3+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility function for PT
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_PT + tt_PT[i] * beta_tt_PT + 
		(beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + 
		beta_log_shop * shop + beta_log_escort * escort) * 
		log(AREA[i] + exp(beta_employment) * EMP[i] + exp(beta_shop)*SHOP[i]) + 
		(beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + 
		beta_cbd_shop * shop + beta_cbd_escort * escort+beta_cbd_PT) * CBD[i] + beta_cost * cost_PT[i]+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--utility function for on demand
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_OD + tt_car[i] * beta_tt_OD +
		(beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + 
		beta_log_shop * shop + beta_log_escort * escort) * 
		log(AREA[i] + exp(beta_employment) * EMP[i] + exp(beta_shop)*SHOP[i]) +
		(beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + 
		beta_cbd_shop * shop + beta_cbd_escort * escort+beta_cbd_OD) * CBD[i] + beta_cost * cost_OD[i]+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end
	--utility function for park and ride
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_PR + tt_PR_PT[i] * beta_tt_PT + tt_PR_car[i] * beta_tt_car+ 
		(beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + 
		beta_log_shop * shop + beta_log_escort * escort) * 
		log(AREA[i] + exp(beta_employment) * EMP[i] + exp(beta_shop)*SHOP[i]) + 
		(beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + 
		beta_cbd_shop * shop + beta_cbd_escort * escort+beta_cbd_PR) * CBD[i] + beta_cost * (cost_PR_car[i]+cost_PR_PT[i])+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
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
		availability[i] = availability[6000]
		availability[i] = 1
	end
	--make availability for park and ride
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
function choose_imd(params,dbparams)
	
	--print("@imd.lua: in choose_imd")
	computeUtilities(params,dbparams) 
	--print("@imd.lua: computed utilities")
	computeAvailabilities(params,dbparams)
	--print("@imd.lua: computed availabilities")

	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	local choice = make_final_choice(probability)
	--print("mode choice: ",choice)
	--print("final choice: ", make_final_choice(probability))
	return make_final_choice(probability)
end

-- function to call from C++ preday simulator for logsums computation
-- params and dbparams tables contain data passed from C++
-- to check variable bindings in params or dbparams, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function compute_logsum_tmdw(params,dbparams)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	return compute_mnl_logsum(utility, availability)
end
