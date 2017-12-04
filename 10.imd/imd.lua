--[[
Model: Intermediate Stop Mode Destination
Based on: ttdw.lua (Siyu Li, Harish Loganathan)
Type: Multinomial Logit
Author: Isabel Viegas
Crated: February 6, 2017
Updated: June 23, 2017
]]

-- COEFFICIENTS
local beta_cons_walk = -3.71
local beta_cons_bike = -2.20
local beta_cons_drive1 = 0
local beta_cons_share2 = -0.153
local beta_cons_share3 = 0.493
local beta_cons_PT = 3.76
local beta_cons_carsharing = -2.77 -- not included
local beta_cons_paratransit = -4.12 -- not included
local beta_cons_taxi = -1.96 -- not included
local beta_cons_bikesharing = -6.49 -- not included


local beta_tt_walk = -0.0922
local beta_tt_bike = -0.0916
local beta_tt_drive1 = 0
local beta_tt_share2 = 0
local beta_tt_share3 = 0
local beta_tt_car = -0.193
local beta_tt_PT = -0.119

local beta_cbd = -1.41
local beta_cbd_work = 0
local beta_cbd_edu = 0.709
local beta_cbd_personal = 1.06
local beta_cbd_rec = 0.995
local beta_cbd_shop = 0.387
local beta_cbd_escort = -1.16

local beta_employment_work = 4.07
local beta_employment_edu = -12.2
local beta_employment_personal = -8.17
local beta_employment_rec = 5.95
local beta_employment_shop = -8.55
local beta_employment_escort = 6.09

local beta_log_work = 0.743
local beta_log_edu = -1.44
local beta_log_personal = -0.211
local beta_log_rec = 0.240
local beta_log_shop = -0.268
local beta_log_escort = 0.237

local beta_population_work = -3.92
local beta_population_edu = -10
local beta_population_personal = -6.71
local beta_population_rec = -5.37
local beta_population_shop = -5.80
local beta_population_escort = -5.62

local beta_cost = 0.0127

local beta_distance_walk = 0

-- CHOICE SET
local choice = {}
for i = 1, 2727*6 do 
	choice[i] = i
end

-- UTILITY
local utility = {}
local function computeUtilities(params,dbparams)
	local stoptype = dbparams.stop_type
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

	local EMP = {}
	local POP = {}
	local AREA = {}
	local SHOP = {}

	local log = math.log
	local exp = math.exp

	for i =1,2727 do
		-- walk
		tt_walk[i] = (dbparams:walk_distance1(i) + dbparams:walk_distance2(i)) * 60 / 3.1
		-- bike
		tt_bike[i] = (dbparams:walk_distance1(i) + dbparams:walk_distance2(i)) * 60 / 9.6
		-- car
		tt_car[i] =  dbparams:tt_car_ivt(i)
		cost_car[i] = dbparams:cost_car_ERP(i) + dbparams:cost_car_OP(i) + dbparams:cost_car_parking(i)
		-- PT
		tt_PT[i] = dbparams:tt_public_ivt(i) + dbparams:tt_public_out(i)
		cost_PT[i] = dbparams:cost_public(i)
		CBD[i] = dbparams:central_dummy(i)
		EMP[i] = dbparams:employment(i)
		POP[i] = dbparams:population(i)
		AREA[i] = dbparams:area(i)
		Dist[i] = dbparams:walk_distance1(i) + dbparams:walk_distance2(i)
	end

	local V_counter = 0

	-- Utility function for walk
	for i =1,2727 do
		V_counter = V_counter + 1
		utility[V_counter] = beta_cons_walk + tt_walk[i] * beta_tt_walk + (beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + beta_log_shop * shop + beta_log_escort * escort) * log(AREA[i] + (exp(beta_employment_work) * work + exp(beta_employment_edu) * edu + exp(beta_employment_personal) * personal + exp(beta_employment_rec) * rec + exp(beta_employment_shop) * shop + exp(beta_employment_escort) * escort) * EMP[i] + (exp(beta_population_work) * work + exp(beta_population_edu) * edu + exp(beta_population_personal) * personal + exp(beta_population_rec) * rec + exp(beta_population_shop) * shop + exp(beta_population_escort) * escort) * POP[i]) + (beta_cbd + beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + beta_cbd_shop * shop + beta_cbd_escort * escort) * CBD[i] + beta_distance_walk * Dist[i]
	end

	-- Utility function for bike
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_bike + tt_bike[i] * beta_tt_bike + (beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + beta_log_shop * shop + beta_log_escort * escort) * log(AREA[i] + (exp(beta_employment_work) * work + exp(beta_employment_edu) * edu + exp(beta_employment_personal) * personal + exp(beta_employment_rec) * rec + exp(beta_employment_shop) * shop + exp(beta_employment_escort) * escort) * EMP[i] + (exp(beta_population_work) * work + exp(beta_population_edu) * edu + exp(beta_population_personal) * personal + exp(beta_population_rec) * rec + exp(beta_population_shop) * shop + exp(beta_population_escort) * escort) * POP[i]) + (beta_cbd + beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + beta_cbd_shop * shop + beta_cbd_escort * escort) * CBD[i]
	end

	-- Utility function for drive1
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_drive1 + tt_car[i] * beta_tt_car + (beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + beta_log_shop * shop + beta_log_escort * escort) * log(AREA[i] + (exp(beta_employment_work) * work + exp(beta_employment_edu) * edu + exp(beta_employment_personal) * personal + exp(beta_employment_rec) * rec + exp(beta_employment_shop) * shop + exp(beta_employment_escort) * escort) * EMP[i] + (exp(beta_population_work) * work + exp(beta_population_edu) * edu + exp(beta_population_personal) * personal + exp(beta_population_rec) * rec + exp(beta_population_shop) * shop + exp(beta_population_escort) * escort) * POP[i]) + (beta_cbd + beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + beta_cbd_shop * shop + beta_cbd_escort * escort) * CBD[i] + beta_cost * cost_car[i]
	end

	-- Utility function for share2
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share2 + tt_car[i] * beta_tt_car + (beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + beta_log_shop * shop + beta_log_escort * escort) * log(AREA[i] + (exp(beta_employment_work) * work + exp(beta_employment_edu) * edu + exp(beta_employment_personal) * personal + exp(beta_employment_rec) * rec + exp(beta_employment_shop) * shop + exp(beta_employment_escort) * escort) * EMP[i] + (exp(beta_population_work) * work + exp(beta_population_edu) * edu + exp(beta_population_personal) * personal + exp(beta_population_rec) * rec + exp(beta_population_shop) * shop + exp(beta_population_escort) * escort) * POP[i]) + (beta_cbd + beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + beta_cbd_shop * shop + beta_cbd_escort * escort) * CBD[i] + beta_cost * cost_car[i]/2
	end

	-- Utility function for share3
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share3 + tt_car[i] * beta_tt_car + (beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + beta_log_shop * shop + beta_log_escort * escort) * log(AREA[i] + (exp(beta_employment_work) * work + exp(beta_employment_edu) * edu + exp(beta_employment_personal) * personal + exp(beta_employment_rec) * rec + exp(beta_employment_shop) * shop + exp(beta_employment_escort) * escort) * EMP[i] + (exp(beta_population_work) * work + exp(beta_population_edu) * edu + exp(beta_population_personal) * personal + exp(beta_population_rec) * rec + exp(beta_population_shop) * shop + exp(beta_population_escort) * escort) * POP[i]) + (beta_cbd + beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + beta_cbd_shop * shop + beta_cbd_escort * escort) * CBD[i] + beta_cost * cost_car[i]/3
	end

	-- Utility function for PT
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_PT + tt_PT[i] * beta_tt_PT + (beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + beta_log_shop * shop + beta_log_escort * escort) * log(AREA[i] + (exp(beta_employment_work) * work + exp(beta_employment_edu) * edu + exp(beta_employment_personal) * personal + exp(beta_employment_rec) * rec + exp(beta_employment_shop) * shop + exp(beta_employment_escort) * escort) * EMP[i] + (exp(beta_population_work) * work + exp(beta_population_edu) * edu + exp(beta_population_personal) * personal + exp(beta_population_rec) * rec + exp(beta_population_shop) * shop + exp(beta_population_escort) * escort) * POP[i]) + (beta_cbd + beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + beta_cbd_shop * shop + beta_cbd_escort * escort) * CBD[i] + beta_cost * cost_PT[i]
	end

	-- Utility function for carsharing (not included)
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_carsharing + tt_car[i] * beta_tt_car + (beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + beta_log_shop * shop + beta_log_escort * escort) * log(AREA[i] + (exp(beta_employment_work) * work + exp(beta_employment_edu) * edu + exp(beta_employment_personal) * personal + exp(beta_employment_rec) * rec + exp(beta_employment_shop) * shop + exp(beta_employment_escort) * escort) * EMP[i] + (exp(beta_population_work) * work + exp(beta_population_edu) * edu + exp(beta_population_personal) * personal + exp(beta_population_rec) * rec + exp(beta_population_shop) * shop + exp(beta_population_escort) * escort) * POP[i]) + (beta_cbd + beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + beta_cbd_shop * shop + beta_cbd_escort * escort) * CBD[i]
	end

	-- Utility function for paratransit (not included)
	for i=1,2727 do
		V_counter = V_counter+1
		utility[V_counter] = beta_cons_paratransit + tt_car[i] * beta_tt_PT + (beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + beta_log_shop * shop + beta_log_escort * escort) * log(AREA[i] + (exp(beta_employment_work) * work + exp(beta_employment_edu) * edu + exp(beta_employment_personal) * personal + exp(beta_employment_rec) * rec + exp(beta_employment_shop) * shop + exp(beta_employment_escort) * escort) * EMP[i] + (exp(beta_population_work) * work + exp(beta_population_edu) * edu + exp(beta_population_personal) * personal + exp(beta_population_rec) * rec + exp(beta_population_shop) * shop + exp(beta_population_escort) * escort) * POP[i]) + (beta_cbd + beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + beta_cbd_shop * shop + beta_cbd_escort * escort) * CBD[i]
	end

	-- Utility function for taxi (not included)
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_taxi + tt_car[i] * beta_tt_car + (beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + beta_log_shop * shop + beta_log_escort * escort) * log(AREA[i] + (exp(beta_employment_work) * work + exp(beta_employment_edu) * edu + exp(beta_employment_personal) * personal + exp(beta_employment_rec) * rec + exp(beta_employment_shop) * shop + exp(beta_employment_escort) * escort) * EMP[i] + (exp(beta_population_work) * work + exp(beta_population_edu) * edu + exp(beta_population_personal) * personal + exp(beta_population_rec) * rec + exp(beta_population_shop) * shop + exp(beta_population_escort) * escort) * POP[i]) + (beta_cbd + beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + beta_cbd_shop * shop + beta_cbd_escort * escort) * CBD[i]
	end

	-- Utility function for bikesharing (not included)
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_bikesharing + tt_bike[i] * beta_tt_bike + (beta_log_work * work + beta_log_edu * edu + beta_log_personal * personal + beta_log_rec * rec + beta_log_shop * shop + beta_log_escort * escort) * log(AREA[i] + (exp(beta_employment_work) * work + exp(beta_employment_edu) * edu + exp(beta_employment_personal) * personal + exp(beta_employment_rec) * rec + exp(beta_employment_shop) * shop + exp(beta_employment_escort) * escort) * EMP[i] + (exp(beta_population_work) * work + exp(beta_population_edu) * edu + exp(beta_population_personal) * personal + exp(beta_population_rec) * rec + exp(beta_population_shop) * shop + exp(beta_population_escort) * escort) * POP[i]) + (beta_cbd + beta_cbd_work * work + beta_cbd_edu * edu + beta_cbd_personal * personal + beta_cbd_rec * rec + beta_cbd_shop * shop + beta_cbd_escort * escort) * CBD[i]
	end
end


-- AVAILABILITY
local availability = {}
local function computeAvailabilities(params,dbparams)
	for i = 1, 2727*6 do 
		availability[i] = dbparams:availability(i)
	end

	for i = 8182, 13635 do
		availability[i] = availability[6000]
		availability[i] = 1
	end

end

-- SCALE
local scale = 1 

function choose_imd(params,dbparams)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	return make_final_choice(probability)
end

function compute_logsum_tmdw(params,dbparams)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	return compute_mnl_logsum(utility, availability)
end
