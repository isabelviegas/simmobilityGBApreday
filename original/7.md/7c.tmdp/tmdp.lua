--[[
Model: Tour Mode Destination - Personal
Based on: tmdw.lua (Siyu Li, Harish Loganathan)
Type: Multinomial Logit
Author: Isabel Viegas
Crated: January 24, 2017
Updated: July  3, 2017
]]

-- COEFFICIENTS
local beta_cons_walk = -0.0967
local beta_cons_bike = -2.99
local beta_cons_drive1 = 0 - 1
local beta_cons_share2 = -1.24
local beta_cons_share3 = -1.64
local beta_cons_PT = -1.39 + 3

local beta_tt_walk = -0.122
local beta_tt_bike = -0.148
local beta_tt_drive1 = 0.105
local beta_tt_share2 = -0.0154
local beta_tt_share3 = -0.0787
local beta_tt_car = 0
local beta_tt_PT = -0.0449

local beta_employment = 0
local beta_area = 0	
local beta_log = 0.489
local beta_population = -11.0
local beta_cbd = 0

local beta_cbd_walk = 0.524
local beta_cbd_bike = 0.279
local beta_cbd_drive1 = -2.11
local beta_cbd_share2 = -0.530
local beta_cbd_share3 = -2.58
local beta_cbd_PT = 0.861

local beta_cost = -0.298

-- CHOICE SET
local choice = {}
for i = 1, 2727*6 do 
	choice[i] = i
end

-- UTILITY
local utility = {}
local function computeUtilities(params,dbparams)
	
	local cost_public_first = {}
	local cost_public_second = {}
	local cost_PT = {}

	local cost_car = {}

	local tt_walk = {}
	local tt_bike = {} 
	local CBD = {}


	local tt_public_first = {}
	local tt_public_second = {}


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

		CBD[i] = dbparams:central_dummy(i)

		EMP[i] = dbparams:employment(i)
		POP[i] = dbparams:population(i)
		AREA[i] = dbparams:area(i)		
	end
	
	local V_counter = 0

	-- Utility function for walk 1-2727
	for i =1,2727 do
		V_counter = V_counter + 1
		utility[V_counter] = beta_cons_walk + tt_walk[i]*beta_tt_walk + beta_cbd_walk * CBD[i] + beta_log * log(EMP[i]+1)
	end

	-- Utility function for bike 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_bike + tt_bike[i]*beta_tt_bike + beta_cbd_bike * CBD[i] + beta_log * log(EMP[i]+1)
	end

	-- Utility function for drive 1 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_drive1 + tt_car[i]*beta_tt_drive1 + beta_cbd_drive1 * CBD[i] + beta_log * log(EMP[i]+1) + beta_cost * cost_car[i]
	end

	-- Utility function for share 2 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share2 + tt_car[i]*beta_tt_share2 + beta_cbd_share2 * CBD[i] + beta_log * log(EMP[i]+1) + beta_cost * cost_car[i]/2
	end

	-- Utility function for share 3 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share3 + tt_car[i]*beta_tt_share3 + beta_cbd_share3 * CBD[i] + beta_log * log(EMP[i]+1) + beta_cost * cost_car[i]/3
	end

	-- Utility function for PT 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_PT + tt_PT[i]*beta_tt_PT + beta_cbd_PT * CBD[i] + beta_log * log(EMP[i]+1) + beta_cost * cost_PT[i]
	end

end


-- AVAILABILITY
local availability = {}
local function computeAvailabilities(params,dbparams)
	for i = 1, 2727*6 do 
		availability[i] = dbparams:availability(i)
	end

	for i = 8182, 13635 do
		availability[i] = 1
	end
end

-- SCALE
local scale = 1 

function choose_tmdp(params,dbparams)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	return make_final_choice(probability)
end

function compute_logsum_tmdp(params,dbparams)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	return compute_mnl_logsum(utility, availability)
end
