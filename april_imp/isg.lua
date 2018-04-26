--[[
Model - intermediate stop generation
Type - MNL
Based on - isg by Siyu Li, Harish Loganathan
Created on June 8, 2017 by Isabel Viegas

Recent calibration done by Yifei Xie
Updated: April, 2018
]]

-- require statements do not work with C++. They need to be commented. The order in which lua files are loaded must be explicitly controlled in C++. 
--require "Logit"

--Estimated values for all betas
--Note= the betas that not estimated are fixed to zero.

local beta_cons_work = -1.68
local beta_cons_edu = -2.55
local beta_cons_personal = -1.70
local beta_cons_rec = -1.68
local beta_cons_shop = -1.73
local beta_cons_escort = -1.69
local beta_cons_quit = 0 + 13.75+1 -- base

local beta_female_work = -0.00165
local beta_female_edu = 0.113
local beta_female_personal = 0.0778
local beta_female_rec = 0.0694
local beta_female_shop = 0.131
local beta_female_escort = 0.116

local beta_window_work_inbound = 0
local beta_window_edu_inbound = 0
local beta_window_personal_inbound = 0
local beta_window_shop_inbound = 0
local beta_window_rec_inbound = 0
local beta_window_escort_inbound = 0

local beta_window_work_outbound = 0
local beta_window_edu_outbound = 0
local beta_window_personal_outbound = 0
local beta_window_shop_outbound = 0
local beta_window_rec_outbound = 0
local beta_window_escort_outbound = 0

local beta_window_1_inbound = 0
local beta_window_2_inbound = 0.128                -0.5 -0.5-0.5
local beta_window_3_inbound = 0.327-0.5            -0.5 -0.5
local beta_window_1_outbound = 15.8   
local beta_window_2_outbound = 0.481+1+1     -1-0.5         
local beta_window_3_outbound = 1.25             

local beta_prime_work_work = 0
local beta_prime_work_edu = 0
local beta_prime_work_personal = 0
local beta_prime_work_rec = 0
local beta_prime_work_shop = 0
local beta_prime_work_escort = 0

local beta_prime_edu_work = -1.09 -6
local beta_prime_edu_edu = -0.158
local beta_prime_edu_personal = -0.792
local beta_prime_edu_rec = -0.607
local beta_prime_edu_shop = -0.890
local beta_prime_edu_escort = -0.741

local beta_prime_personal_work = -2.78 -6
local beta_prime_personal_edu = -1.84
local beta_prime_personal_personal = 0.325
local beta_prime_personal_rec = 0.352
local beta_prime_personal_shop = 0.406
local beta_prime_personal_escort = 0.157

local beta_prime_rec_work = -3.75 -6
local beta_prime_rec_edu = -2.93
local beta_prime_rec_personal = -3.77
local beta_prime_rec_rec = -0.598
local beta_prime_rec_shop = -3.77
local beta_prime_rec_escort = -0.656

local beta_prime_shop_work = -3.04 -6
local beta_prime_shop_edu = 2.23
local beta_prime_shop_personal = -3.07
local beta_prime_shop_rec = 0.183
local beta_prime_shop_shop = 0.148
local beta_prime_shop_escort = 0.00190

local beta_prime_escort_work = -4.84 -6
local beta_prime_escort_edu = -4.03
local beta_prime_escort_personal = -4.87
local beta_prime_escort_rec = -4.88
local beta_prime_escort_shop = -4.87
local beta_prime_escort_escort = -1.93



--choice set
--1 for work; 2 for edu; 3 for shopping; 4 for other; 5 for quit
local choice = {}
choice["make"] = {1,2,3,4,5,6}
choice["quit"] = {7}

local utility = {}
local function computeUtilities(params,dbparams)

	-- NOT USED YET
	-- local student_dummy = params.student_dummy
	local female = params.female_dummy
	-- print("female: ", female)
	-- local worker_dummy = params.worker_dummy
	-- local driver_dummy = dbparams.driver_dummy
	-- local passenger_dummy = dbparams.passenger_dummy
	-- local public_dummy = dbparams.public_dummy
	-- local distance = dbparams.distance
	-- local log_constant = 0.0001
	-- local worklogsum = 0
	-- local edulogsum = 0
	-- local shoplogsum = 0
	-- local otherlogsum = 0
	-- p_700a_930a = dbparams.p_700a_930a
	-- p_930a_1200a = dbparams.p_930a_1200a 
	-- p_300p_530p = dbparams.p_300p_530p
	-- p_530p_730p = dbparams.p_530p_730p
	-- p_730p_1000p = dbparams.p_730p_1000p
	-- p_1000p_700a = dbparams.p_1000p_700a
	local first_stop = dbparams.first_stop
	-- print("first_stop")
	local second_stop = dbparams.second_stop
	-- print("second_stop")
	local three_plus_stop = dbparams.three_plus_stop
	-- print("three_plus_stop")


	-- primary activity
	local tour_type = dbparams.tour_type
	-- print("tour_type:", tour_type)

	local pwork,pedu,ppersonal,prec,pshop,pescort = 0,0,0,0,0,0

	if tour_type == 1 then
		pwork = 1
	end

	if tour_type == 2 then
		pedu = 1
	end

	if tour_type == 3 then
		ppersonal = 1
	end

	if tour_type == 4 then
		prec = 1
	end

	if tour_type == 5 then
		pshop = 1
	end

	if tour_type == 6 then
		prec = 1
	end

	local inbound_window = dbparams.time_window_first_bound
	local outbound_window = dbparams.time_window_second_bound 

	-- print("inbound_window: ",inbound_window,", outbound_window: ",outbound_window)

	local inbound = dbparams.first_bound
	local outbound = dbparams.second_bound

	-- print("inbound: ", inbound, ", outbound: ", outbound)

	-- print("stops: ", first_stop, " ", second_stop, " ", three_plus_stop)
	local stop1,stop2,stop3 = 0,0,0
	if first_stop == 1 then
		stop1 = 1
	end
	if second_stop == 1 then
		stop2 = 1
	end
	if three_plus_stop == 1 then
		stop3 = 1
	end

	-- print("stops: ", stop1, " ", stop2, " ", stop3)


	utility[1] = beta_cons_work +
	inbound_window * beta_window_work_inbound * inbound + outbound_window * beta_window_work_outbound * outbound +
	beta_prime_work_work * pwork + beta_prime_edu_work * pedu + beta_prime_personal_work * ppersonal +
	beta_prime_rec_work * prec + beta_prime_shop_work * pshop + beta_prime_escort_work * pescort +
	inbound * (beta_window_1_inbound * stop1 + beta_window_2_inbound * stop2 + beta_window_3_inbound * stop3) +
	outbound * (beta_window_1_outbound * stop1 + beta_window_2_outbound * stop2 + beta_window_3_outbound * stop3) +
	female * beta_female_work

	utility[2] = beta_cons_edu +
	inbound_window * beta_window_edu_inbound * inbound + outbound_window * beta_window_edu_outbound * outbound +
	beta_prime_work_edu * pwork + beta_prime_edu_edu * pedu + beta_prime_personal_edu * ppersonal +
	beta_prime_rec_edu * prec + beta_prime_shop_edu * pshop + beta_prime_escort_edu * pescort +
	inbound * (beta_window_1_inbound * stop1 + beta_window_2_inbound * stop2 + beta_window_3_inbound * stop3) +
	outbound * (beta_window_1_outbound * stop1 + beta_window_2_outbound * stop2 + beta_window_3_outbound * stop3) +
	female * beta_female_edu

	utility[3] = beta_cons_personal  +
	inbound_window * beta_window_personal_inbound * inbound + outbound_window * beta_window_personal_outbound * outbound +
	beta_prime_work_personal  * pwork + beta_prime_edu_personal  * pedu + beta_prime_personal_personal  * ppersonal +
	beta_prime_rec_personal  * prec + beta_prime_shop_personal  * pshop + beta_prime_escort_personal  * pescort +
	inbound * (beta_window_1_inbound * stop1 + beta_window_2_inbound * stop2 + beta_window_3_inbound * stop3) +
	outbound * (beta_window_1_outbound * stop1 + beta_window_2_outbound * stop2 + beta_window_3_outbound * stop3) +
	female * beta_female_personal

	utility[4] = beta_cons_rec +
	inbound_window * beta_window_rec_inbound * inbound + outbound_window * beta_window_rec_outbound * outbound +
	beta_prime_work_rec * pwork + beta_prime_edu_rec * pedu + beta_prime_personal_rec * ppersonal +
	beta_prime_rec_rec * prec + beta_prime_shop_rec * pshop + beta_prime_escort_rec * pescort +
	inbound * (beta_window_1_inbound * stop1 + beta_window_2_inbound * stop2 + beta_window_3_inbound * stop3) +
	outbound * (beta_window_1_outbound * stop1 + beta_window_2_outbound * stop2 + beta_window_3_outbound * stop3) +
	female * beta_female_rec

	utility[5] = beta_cons_shop +
	inbound_window * beta_window_shop_inbound * inbound + outbound_window * beta_window_shop_outbound * outbound +
	beta_prime_work_shop * pwork + beta_prime_edu_shop * pedu + beta_prime_personal_shop * ppersonal +
	beta_prime_rec_shop * prec + beta_prime_shop_shop * pshop + beta_prime_escort_shop * pescort +
	inbound * (beta_window_1_inbound * stop1 + beta_window_2_inbound * stop2 + beta_window_3_inbound * stop3) +
	outbound * (beta_window_1_outbound * stop1 + beta_window_2_outbound * stop2 + beta_window_3_outbound * stop3) +
	female * beta_female_shop

	utility[6] = beta_cons_escort +
	inbound_window * beta_window_escort_inbound * inbound + outbound_window * beta_window_escort_outbound * outbound +
	beta_prime_work_escort * pwork + beta_prime_edu_escort * pedu + beta_prime_personal_escort * ppersonal +
	beta_prime_rec_escort * prec + beta_prime_shop_escort * pshop + beta_prime_escort_escort * pescort +
	inbound * (beta_window_1_inbound * stop1 + beta_window_2_inbound * stop2 + beta_window_3_inbound * stop3) +
	outbound * (beta_window_1_outbound * stop1 + beta_window_2_outbound * stop2 + beta_window_3_outbound * stop3) +
	female * beta_female_escort

	utility[7] = beta_cons_quit

	-- for i = 1,7 do
	-- 	print("utility isg",i,": ", utility[i])
	-- end

end

--availability
--the logic to determine availability is the same with current implementation
local availability = {}
local function computeAvailabilities(params,dbparams)
	for i = 1, 7 do 
		availability[i] = dbparams:availability(i)
	end
end

--scale
local scale={}
scale["make"] = 4.82
scale["quit"] = 1

-- function to call from C++ preday simulator
-- params and dbparams tables contain data passed from C++
-- to check variable bindings in params or dbparams, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function choose_isg(params,dbparams)
	-- print("choose_isg: in")
	computeUtilities(params,dbparams) 
	-- print("choose_isg: computeUtilities")
	computeAvailabilities(params,dbparams)
	local probability = calculate_probability("nl", choice, utility, availability, scale)
	return make_final_choice(probability)
end

