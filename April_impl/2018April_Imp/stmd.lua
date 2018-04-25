--[[
Model: Workbased Subtour Mode Destination
Based on: ttdw.lua (Siyu Li, Harish Loganathan)
Type: Multinomial Logit
Author: Isabel Viegas
Crated: March 2, 2017
Updated: March 23, 2017

This version includes on-demand service as new mode in the model
Created and calibrated by Yifei Xie
Updated: April, 2018
]]

-- COEFFICIENTS
--print("stmd is called\n")
local beta_cons_walk = 2.34+0.5
local beta_cons_bike = -2.33
local beta_cons_drive1 = 0-0.5
local beta_cons_share2 = -1.68       -0.5
local beta_cons_share3 = -2.36 
local beta_cons_PT = -0.849    -0.5  -0.5
local beta_cons_OD = -2

local beta_tt_walk = -0.115
local beta_tt_bike = -0.112
-- local beta_tt_drive1 = 0
-- local beta_tt_share2 = 0
-- local beta_tt_share3 = 0
local beta_tt_car = -0.162
local beta_tt_PT = -0.0870
local beta_tt_OD = beta_tt_car


local beta_employment = 0
local beta_population = 0
local beta_log = 0.272

local beta_cbd_notdrive = 2.02  
local beta_cbd_drive1 = -1.23   
local beta_cbd_share2 = -1.14   
local beta_cbd_share3 = -0.481  
local beta_cbd_PT = 1.65        


local beta_cost = -0.0411
local beta_Boston = 0
-- CHOICE SET
local choice = {}
for i = 1, 2727*7 do 
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

	local cost_OD_1={}
	local cost_OD_2={}
	local cost_OD  ={}

	local tt_walk = {}
	local tt_bike = {}
	local tt_car = {} 
	local tt_PT = {}

	local EMP = {}
	local POP = {}
	local AREA = {}
	local SHOP = {}
	local TOWN = {}
	local log = math.log
	local exp = math.exp
	local bool_to_number={ [true]=1, [false]=0 }

	for i =1,2727 do
		-- walk
		tt_walk[i] = (dbparams:walk_distance1(i) + dbparams:walk_distance2(i)) * 60 / 3.1
		-- print(tt_walk[i])

		-- bike
		tt_bike[i] = (dbparams:walk_distance1(i) + dbparams:walk_distance2(i)) * 60 / 9.6
		-- print(tt_bike)
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
			
		CBD[i] = dbparams:central_dummy(i)

		EMP[i] = dbparams:employment(i)
		POP[i] = dbparams:population(i)
		AREA[i] = dbparams:area(i)
		TOWN[i] = dbparams:town_id(i)
		-- print("i = ", i , ": tt_walk: ", tt_walk[i], " tt_bike: ", tt_bike[i], " tt_car: ", tt_car[i], "cost_car: ", cost_car[i], " tt_PT: ", tt_PT[i], " CBD: ", CBD[i], " EMP: ", EMP[i], " POP: ", POP[i], " AREA: ", AREA[i])
	end

	local exp = math.exp
	local log = math.log

	local V_counter = 0

-- Utility functions for walk 1-2727
	for i =1,2727 do
		V_counter = V_counter + 1
		utility[V_counter] = beta_cons_walk + tt_walk[i]*beta_tt_walk + beta_cbd_notdrive * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i])+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	-- Utility functions for bike 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_bike + tt_bike[i]*beta_tt_bike + beta_cbd_notdrive * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i])+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	-- Utility function for drive 1 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_drive1 + tt_car[i]*beta_tt_car + beta_cbd_drive1 * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i]) + beta_cost * cost_car[i]+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	-- Utility function for share 2 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share2 + tt_car[i]*beta_tt_car + beta_cbd_share2 * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i]) + beta_cost * cost_car[i]/2+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	-- Utility function for share 3 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share3 + tt_car[i]*beta_tt_car + beta_cbd_share3 * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i]) + beta_cost * cost_car[i]/3+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	-- Utility function for PT 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_PT + tt_PT[i]*beta_tt_PT + beta_cbd_notdrive * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i]) + beta_cost * cost_PT[i]+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end
	-- Utility function for on demand 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_OD + tt_car[i]*beta_tt_OD + beta_cbd_notdrive * CBD[i] + 
		beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i]) + beta_cost * cost_OD[i]+ beta_Boston * bool_to_number[ TOWN[i]==0 ]
	end

	--Utility function for park and ride, a fake one because it is currently unavailable for subtour
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = 0
	end

end


-- Availability
local availability = {}
local function computeAvailabilities(params,dbparams)
	for i = 1, 2727*7 do 
		availability[i] = dbparams:availability(i)
	end
	--make availability for park and ride
	for i = 2727*7+1, 2727*8 do
		availability[i] = 0
	end
end

-- SCALE
local scale = 1

function choose_stmd(params,dbparams)
	--print("in stmd")
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	return make_final_choice(probability)
end
