--[[
Model: Workbased Subtour Mode Destination
Based on: ttdw.lua (Siyu Li, Harish Loganathan)
Type: Multinomial Logit
Author: Isabel Viegas
Crated: March 2, 2017
Updated: March 23, 2017
]]

-- COEFFICIENTS
local beta_cons_walk = 2.34
local beta_cons_bike = -2.33
local beta_cons_drive1 = 0
local beta_cons_share2 = -1.68
local beta_cons_share3 = -2.36
local beta_cons_PT = -0.849

local beta_tt_walk = -0.0993
local beta_tt_bike = -0.107
local beta_tt_drive1 = 0
local beta_tt_share2 = 0
local beta_tt_share3 = 0
local beta_tt_car = -0.154
local beta_tt_PT = -0.0802

local beta_employment = 5.78
local beta_area = 0
local beta_population = -5.56
local beta_cbd = 0
local beta_log = 0.504

local beta_cbd_walk = 0
local beta_cbd_bike = 0
local beta_cbd_drive1 = -0.614308
local beta_cbd_share2 = -2.38894
local beta_cbd_share3 = -2.93768
local beta_cbd_PT = 2.27
local beta_cbd_notdrive = 1.74477

local beta_cost_car = 0
local beta_cost_PT = 0
local beta_cost = 0.0398

-- CHOICE SET
local choice = {}
for i = 1, 1169*6 do 
	choice[i] = i
end

-- UTILITY
local utility = {}
local function computeUtilities(params,dbparams)
	local female_dummy = params.female_dummy
	local mode_work_bus = dbparams.mode_to_work == 1 and 1 or 0
	local mode_work_mrt = dbparams.mode_to_work == 2 and 1 or 0
	local mode_work_private_bus = dbparams.mode_to_work == 3 and 1 or 0
	local mode_work_drive1 = dbparams.mode_to_work == 4 and 1 or 0
	local mode_work_share2 = dbparams.mode_to_work == 5 and 1 or 0
	local mode_work_share3 = dbparams.mode_to_work == 6 and 1 or 0
	local mode_work_motor = dbparams.mode_to_work == 7 and 1 or 0
	local mode_work_walk = dbparams.mode_to_work == 8 and 1 or 0

	local cost_bus = {}
	local cost_mrt = {}
	local cost_private_bus = {}
	local cost_drive1 = {}
	local cost_share2 = {}
	local cost_share3 = {}
	local cost_motor = {}
	local cost_taxi={}
	local cost_taxi_1 = {}
	local cost_taxi_2 = {}

	local central_dummy={}

	local tt_bus = {}
	local tt_mrt = {}
	local tt_private_bus = {}
	local tt_drive1 = {}
	local tt_share2 = {}
	local tt_share3 = {}
	local tt_motor = {}
	local tt_walk = {}
	local tt_taxi = {}
	local tt_car_ivt = {}
	local tt_public_ivt = {}
	local tt_public_out = {}

	local employment = {}
	local population = {}
	local area = {}
	local shop = {}

	local d1 = {}
	local d2 = {}

	for i =1,2727 do
		cost_bus[i] = dbparams:cost_public_first(i) + dbparams:cost_public_second(i)
		cost_mrt[i] = cost_bus[i]
		cost_private_bus[i] = cost_bus[i]

		cost_drive1[i] = dbparams:cost_car_ERP_first(i)+dbparams:cost_car_ERP_second(i)+dbparams:cost_car_OP_first(i)+dbparams:cost_car_OP_second(i)+dbparams:cost_car_parking(i)
		cost_share2[i] = dbparams:cost_car_ERP_first(i)+dbparams:cost_car_ERP_second(i)+dbparams:cost_car_OP_first(i)+dbparams:cost_car_OP_second(i)+dbparams:cost_car_parking(i)/2
		cost_share3[i] = dbparams:cost_car_ERP_first(i)+dbparams:cost_car_ERP_second(i)+dbparams:cost_car_OP_first(i)+dbparams:cost_car_OP_second(i)+dbparams:cost_car_parking(i)/3
		cost_motor[i] = 0.5*(dbparams:cost_car_ERP_first(i)+dbparams:cost_car_ERP_second(i)+dbparams:cost_car_OP_first(i)+dbparams:cost_car_OP_second(i))+0.65*dbparams:cost_car_parking(i)
		
		central_dummy[i] = dbparams:central_dummy(i)
		d1[i] = dbparams:walk_distance1(i)
		d2[i] = dbparams:walk_distance2(i)

		cost_taxi_1[i] = 3.4+((d1[i]*(d1[i]>10 and 1 or 0)-10*(d1[i]>10 and 1 or 0))/0.35+(d1[i]*(d1[i]<=10 and 1 or 0)+10*(d1[i]>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_first(i) + central_dummy[i]*3
		cost_taxi_2[i] = 3.4+((d2[i]*(d2[i]>10 and 1 or 0)-10*(d2[i]>10 and 1 or 0))/0.35+(d2[i]*(d2[i]<=10 and 1 or 0)+10*(d2[i]>10 and 1 or 0))/0.4)*0.22+ dbparams:cost_car_ERP_second(i) + central_dummy[i]*3
		cost_taxi[i] = cost_taxi_1[i] + cost_taxi_2[i]

		tt_car_ivt[i] = dbparams:tt_car_ivt_first(i) + dbparams:tt_car_ivt_second(i)
		tt_public_ivt[i] = dbparams:tt_public_ivt_first(i) + dbparams:tt_public_ivt_second(i)
		tt_public_out[i] = dbparams:tt_public_out_first(i) + dbparams:tt_public_out_second(i)

		tt_bus[i] = tt_public_ivt[i]+ tt_public_out[i]
		tt_mrt[i] = tt_public_ivt[i]+ tt_public_out[i]
		tt_private_bus[i] = tt_car_ivt[i]
		tt_drive1[i] = tt_car_ivt[i] + 1.0/6
		tt_share2[i] = tt_car_ivt[i] + 1.0/6
		tt_share3[i] = tt_car_ivt[i] + 1.0/6
		tt_motor[i] = tt_car_ivt[i] + 1.0/6
		tt_walk[i] = (d1[i]+d2[i])/5
		tt_taxi[i] = tt_car_ivt[i] + 1.0/6

		employment[i] = dbparams:employment(i)
		population[i] = dbparams:population(i)
		area[i] = dbparams:area(i)
		shop[i] = dbparams:shop(i)
	end

	local exp = math.exp
	local log = math.log

	local V_counter = 0

-- Utility functions for walk 1-2727
	for i =1,2727 do
		V_counter = V_counter + 1
		utility[V_counter] = beta_cons_walk + tt_walk[i]*beta_tt_walk + beta_cbd_notdrive * CBD[i] + beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i]+1)
	end

	-- Utility functions for bike 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_bike + tt_bike[i]*beta_tt_bike + beta_cbd_notdrive * CBD[i] + beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i])
	end

	-- Utility function for drive 1 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_drive1 + tt_car[i]*beta_tt_car + beta_cbd_drive1 * CBD[i] + beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i]) + beta_cost * cost_car[i]
	end

	-- Utility function for share 2 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share2 + tt_car[i]*beta_tt_car + beta_cbd_share2 * CBD[i] + beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i]) + beta_cost * cost_car[i]/2
	end

	-- Utility function for share 3 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_share3 + tt_car[i]*beta_tt_car + beta_cbd_share3 * CBD[i] + beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i]) + beta_cost * cost_car[i]/3
	end

	-- Utility function for PT 1-2727
	for i=1,2727 do
		V_counter = V_counter +1
		utility[V_counter] = beta_cons_PT + tt_PT[i]*beta_tt_PT + beta_cbd_notdrive * CBD[i] + beta_log * log(AREA[i] + exp(beta_employment)*EMP[i] + exp(beta_population)*POP[i]) + beta_cost * cost_PT[i]
	end

end


-- Availability
local availability = {}
local function computeAvailabilities(params,dbparams)
	for i = 1, 1169*7 do 
		availability[i] = dbparams:availability(i)
	end
end

-- SCALE
local scale = 1

function choose_stmd(params,dbparams)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	local probability = calculate_probability("mnl", choice, utility, availability, scale)
	return make_final_choice(probability)
end
