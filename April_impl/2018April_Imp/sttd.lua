--[[
Model: Workbased Subtour Time of Day
Based on: itd.lua (Siyu Li, Harish Loganathan)
Type: Multinomial Logit
Author: Isabel Viegas
Crated: March 21, 2017
Updated: June 23, 2017

Recent calibration done by Yifei Xie
Updated: April, 2018
]]

-- COEFFICIENTS
local beta_dur_1 = -1.36	
local beta_dur_2 = -0.0998
local beta_dur_3 = 0.00611

local beta_arr_1_cos2pi = -5.82
local beta_arr_1_cos4pi = -2.21
local beta_arr_1_cos6pi = -0.788
local beta_arr_1_sin2pi = 1.51
local beta_arr_1_sin4pi = -0.946
local beta_arr_1_sin6pi = -0.775

local beta_dep_1_cos2pi = 4.31
local beta_dep_1_cos4pi = 1.70
local beta_dep_1_cos6pi = -0.235
local beta_dep_1_sin2pi = -1.44
local beta_dep_1_sin4pi = 1.22
local beta_dep_1_sin6pi = 0.279
local beta_dep_1_sin8pi = -1.50

local beta_arr_tt = -0.0110
local beta_dep_tt = -0.116
local beta_tt = 0

local beta_cost_am = 0.382
local beta_cost_op = 0.284
local beta_cost_pm = 0.476

local pi = math.pi
local pow = math.pow
local sin = math.sin
local cos = math.cos

local Begin={}	
local End={}

local choiceset={}
local arrmidpoint = {}
local depmidpoint = {}

for i =1,48 do
	arrmidpoint[i] = i * 0.5 + 2.75
	depmidpoint[i] = i * 0.5 + 2.75
end

for i = 1,1176 do
	choiceset[i] = i
end

local comb = {}
local count = 0

for i=1,48 do
	for j=i,48 do
		count=count+1
		comb[count]={i,j}
	end
end

local function sarr_1(t)
	return beta_arr_1_sin2pi * sin(2*pi*t/24) + beta_arr_1_cos2pi * cos(2*pi*t/24) + beta_arr_1_sin4pi * sin(4*pi*t/24) + beta_arr_1_cos4pi * cos(4*pi*t/24) + beta_arr_1_sin6pi * sin(6*pi*t/24) + beta_arr_1_cos6pi * cos(6*pi*t/24)
end

local function sdep_1(t)
	return beta_dep_1_sin2pi * sin(2*pi*t/24) + beta_dep_1_cos2pi * cos(2*pi*t/24) + beta_dep_1_sin4pi * sin(4*pi*t/24) + beta_dep_1_cos4pi * cos(4*pi*t/24) + beta_dep_1_sin6pi * sin(6*pi*t/24) + beta_dep_1_cos6pi * cos(6*pi*t/24)
end


local utility = {}
local function computeUtilities(params,dbparams)
	local cost_HT1_am = 0 --dbparams.cost -- okay that they are all the same because the binary variables cancel out the ones not being used
	local cost_HT1_op = 0--dbparams.cost
	local cost_HT1_pm = 0--dbparams.cost
	local cost_HT2_am = 0--dbparams.cost
	local cost_HT2_op = 0--dbparams.cost
	local cost_HT2_pm = 0--dbparams.cost
	local TT = 0
	--print("TT: ", TT)


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

		utility[i] = sarr_1(arr) + sdep_1(dep) + beta_dur_1 * dur + beta_dur_2 * pow(dur,2) + beta_dur_3 * pow(dur,3) + 
		beta_arr_tt * TT + beta_dep_tt * TT +
		beta_cost_am * (arr_am * cost_HT1_am + dep_am * cost_HT2_am) +
		beta_cost_op * ((arr_md + arr_nt) * cost_HT1_op + (dep_md + dep_nt) * cost_HT2_op) +
		beta_cost_pm * (arr_pm * cost_HT1_pm + dep_pm * cost_HT2_pm)
	end
end


--availability
local availability = {}
local function computeAvailabilities(dbparams)
	for i = 1,1176 do 
		availability[i] = dbparams:time_window_availability(i)
	end
end

--scale
local scale = 1 -- for all choices

function choose_sttd(params,dbparams)
	-- print("stop tour destination")
	computeUtilities(params,dbparams) 
	computeAvailabilities(dbparams)
	local probability = calculate_probability("mnl", choiceset, utility, availability, scale)
	return make_final_choice(probability)
end
