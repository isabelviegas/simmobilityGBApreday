--[[
Model - Tour time of day for personal tour
Type - MNL
Based on  Siyu Li, Harish Loganathan
Author: Isabel Viegas

Recent calibration done by Yifei Xie
Updated: April, 2018
]]

-- all require statements do not work with C++. They need to be commented. The order in which lua files are loaded must be explicitly controlled in C++. 
--require "Logit"

--Estimated values for all betas
--Note: the betas that not estimated are fixed to zero.

local beta_DUR_1 = -1.98
local beta_DUR_2 = 0.0282
local beta_DUR_3 = 0

local beta_arr_1_cos2pi = -6.86
local beta_arr_1_cos4pi = -3.01
local beta_arr_1_cos6pi = -0.515
local beta_arr_1_sin2pi = 5.33
local beta_arr_1_sin4pi = -0.287
local beta_arr_1_sin6pi = -0.271

local beta_dep_1_cos2pi = 3.81
local beta_dep_1_cos4pi = 3.02
local beta_dep_1_cos6pi = 0.937
local beta_dep_1_sin2pi = -7.39
local beta_dep_1_sin4pi = -1.11
local beta_dep_1_sin6pi = 0.179

local beta_arr_tt = 0
local beta_dep_tt = 0.00857

local beta_cost = 0.00231


local k = 4
local n = 4
local ps = 3
local pi = math.pi

local Begin={}
local End={}
local choiceset={}
local arrmidpoint = {}
local depmidpoint = {}

for i =1,48 do
	Begin[i] = i
	End[i] = i
	arrmidpoint[i] = i * 0.5 + 2.75
	depmidpoint[i] = i * 0.5 + 2.75
end

for i = 1,1176 do
	choiceset[i] = i
end

local comb = {}
local count = 0

for i=1,48 do
	for j=1,48 do
		if j>=i then
			count=count+1
			comb[count]={i,j}
		end
	end
end



local function sarr_1(t)
	t= t+2
	return beta_arr_1_sin2pi * math.sin(2*pi*t/24.) + beta_arr_1_cos2pi * math.cos(2*pi*t/24.) + beta_arr_1_sin4pi * math.sin(4*pi*t/24.) + beta_arr_1_cos4pi * math.cos(4*pi*t/24.) + beta_arr_1_sin6pi * math.sin(6*pi*t/24.) + beta_arr_1_cos6pi * math.cos(6*pi*t/24.)
end

local function sdep_1(t)
	t=t+2
	return beta_dep_1_sin2pi * math.sin(2*pi*t/24.) + beta_dep_1_cos2pi * math.cos(2*pi*t/24.) + beta_dep_1_sin4pi * math.sin(4*pi*t/24.) + beta_dep_1_cos4pi * math.cos(4*pi*t/24.) + beta_dep_1_sin6pi * math.sin(6*pi*t/24.) + beta_dep_1_cos6pi * math.cos(6*pi*t/24.)
end


local utility = {}
local function computeUtilities(params,dbparams) 

	-- local cost_HT1_am = dbparams.cost_HT1_am
	-- local cost_HT1_md = dbparams.cost_HT1_md
	-- local cost_HT1_pm = dbparams.cost_HT1_pm
	-- local cost_HT1_nt = dbparams.cost_HT1_nt
	-- local cost_HT2_am = dbparams.cost_HT2_am
	-- local cost_HT2_md = dbparams.cost_HT2_md
	-- local cost_HT2_pm = dbparams.cost_HT2_pm
	-- local cost_HT2_nt = dbparams.cost_HT2_nt

	-- alternative for only three options
	local cost_HT1_am = dbparams.cost_HT1_am
	local cost_HT1_op = dbparams.cost_HT1_op
	local cost_HT1_pm = dbparams.cost_HT1_pm
	local cost_HT2_am = dbparams.cost_HT2_am
	local cost_HT2_op = dbparams.cost_HT2_op
	local cost_HT2_pm = dbparams.cost_HT2_pm

	local pow = math.pow

	for i =1,1176 do
		local arrid = comb[i][1]
		local depid = comb[i][2]
		local arr = arrmidpoint[arrid]
		local dep = depmidpoint[depid]
		local dur = dep - arr

		local arr_am = 0
		local arr_pm = 0
		local arr_op = 0
		local dep_am = 0
		local dep_pm = 0
		local dep_op = 0

		if arr < 10.5  and  arr > 6.5 then
        	arr_am,arr_md,arr_pm,arr_nt = 1,0,0,0
    	elseif arr < 16.5 and arr > 10.5 then
        	arr_am,arr_md,arr_pm,arr_nt = 0,1,0,0
    	elseif arr < 19.5 and arr > 16.5 then
        	arr_am,arr_md,arr_pm,arr_nt = 0,0,1,0
    	else
        	arr_am,arr_md,arr_pm,arr_nt = 0,0,0,1
        end

    	if dep < 10.5 and dep > 6.5 then 
        	dep_am,dep_md,dep_pm,dep_nt = 1,0,0,0
    	elseif dep < 16.5 and dep > 10.5 then
        	dep_am,dep_md,dep_pm,dep_nt = 0,1,0,0
    	elseif dep < 19.5 and dep > 16.5 then 
        	dep_am,dep_md,dep_pm,dep_nt = 0,0,1,0
    	else
        	dep_am,dep_md,dep_pm,dep_nt = 0,0,0,1
        end

		utility[i] = sarr_1(arr) + sdep_1(dep) + beta_DUR_1 * dur + beta_DUR_2 * pow(dur,2) + beta_DUR_3 * pow(dur,3) + beta_arr_tt * dbparams:TT_HT1(arrid) + beta_dep_tt * dbparams:TT_HT2(depid) + beta_cost * (cost_HT1_am * arr_am + cost_HT1_op * arr_md + cost_HT1_pm * arr_pm + cost_HT1_op * arr_nt + cost_HT2_am * dep_am + cost_HT2_op * dep_md + cost_HT2_pm * dep_pm + cost_HT2_op * dep_nt)
	end
end

--availability
--the logic to determine availability is the same with current implementation
local availability = {}
local function computeAvailabilities(params,dbparams)
	for i = 1, 1176 do 
		availability[i] = params:getTimeWindowAvailabilityTour(i, dbparams.mode)
		-- print("timewindow ", i, ": ", availability[i])
	end
end


--scale
local scale = 1 --for all choices

-- function to call from C++ preday simulator
-- params and dbparams tables contain data passed from C++
-- to check variable bindings in params or dbparams, refer PredayLuaModel::mapClasses() function in dev/Basic/medium/behavioral/lua/PredayLuaModel.cpp
function choose_ttdp(params,dbparams)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	local probability = calculate_probability("mnl", choiceset, utility, availability, scale)
	
	prob = 0.0
	for i = 1,1176 do
		prob = prob + probability[i]
	end

	-- print("probability p:", prob)

	if prob < 0.0001 then
		return -1
	else
		return make_final_choice(probability)
	end 

end

