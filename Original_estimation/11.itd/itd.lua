--[[
Model: Intermediate Stop Time of Day
Based on: itd.lua (Siyu Li, Harish Loganathan)
Type: Multinomial Logit
Author: Isabel Viegas
Crated: February 27, 2017
Updated: June 12, 2017
]]

-- COEFFICIENTS
local beta_dur_1_work = -0.993
local beta_dur_2_work = 0
local beta_dur_1_edu = -1.00
local beta_dur_2_edu = 0
local beta_dur_1_personal = -1.66
local beta_dur_2_personal = 0
local beta_dur_1_rec = -1.12
local beta_dur_2_rec = 0
local beta_dur_1_shop = -1.77
local beta_dur_2_shop = 0
local beta_dur_1_escort = -1.99
local beta_dur_2_escort = 0

local beta_arr_1_cos2pi = -4.29
local beta_arr_1_cos4pi = -1.79
local beta_arr_1_cos6pi = -0.335
local beta_arr_1_cos8pi = -0.0642
local beta_arr_1_sin2pi = 3.26
local beta_arr_1_sin4pi = -0.118
local beta_arr_1_sin6pi = 0.0340
local beta_arr_1_sin8pi = 0.237 

local beta_dep_1_cos2pi = 3.55
local beta_dep_1_cos4pi = -2.90
local beta_dep_1_cos6pi = -3.50
local beta_dep_1_cos8pi = -0.538
local beta_dep_1_sin2pi = 0.953
local beta_dep_1_sin4pi = 3.00
local beta_dep_1_sin6pi = -0.758
local beta_dep_1_sin8pi = -1.50

local beta_arr_tt = 0
local beta_dep_tt = 0
local beta_tt = -0.0437

local beta_cost = 0

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

for i = 1,48 do
	choiceset[i] = i
end

-- UTILITY
local utility = {}
local function computeUtilities(params,dbparams)
	local stoptype = dbparams.stop_type
	
	local work,edu,personal,rec,shop,escort = 0,0,0,0,0,0
	
	if stoptype == 1 then
		work = 1
	elseif stoptype == 2 then
		edu = 1
	elseif stoptype == 3 then
		personal = 1
	elseif stoptype == 4 then
		rec = 1
	elseif stoptype == 5 then
		shop = 1	
	elseif stoptype == 6 then
		escort = 1
	end

	local first_bound = dbparams.first_bound
	local second_bound = dbparams.second_bound 

	local high_tod = dbparams.high_tod
	local low_tod = dbparams.low_tod

	local pi = math.pi
	local sin = math.sin
	local cos = math.cos
	local pow = math.pow

	local function sarr_1(t)
		return beta_arr_1_sin2pi * sin(2*pi*t/24) + beta_arr_1_cos2pi * cos(2*pi*t/24) + beta_arr_1_sin4pi * sin(4*pi*t/24) + beta_arr_1_cos4pi * cos(4*pi*t/24) + beta_arr_1_sin6pi * sin(6*pi*t/24) + beta_arr_1_cos6pi * cos(6*pi*t/24) + beta_arr_1_sin8pi * sin(8*pi*t/24) + beta_arr_1_cos8pi * cos(8*pi*t/24)
	end

	local function sdep_1(t)
		return beta_dep_1_sin2pi * sin(2*pi*t/24) + beta_dep_1_cos2pi * cos(2*pi*t/24) + beta_dep_1_sin4pi * sin(4*pi*t/24) + beta_dep_1_cos4pi * cos(4*pi*t/24) + beta_dep_1_sin6pi * sin(6*pi*t/24) + beta_dep_1_cos6pi * cos(6*pi*t/24) + beta_dep_1_sin8pi * sin(8*pi*t/24) + beta_dep_1_cos8pi * cos(8*pi*t/24)
	end


	for i =1,48 do
		local arr = arrmidpoint[i]
		local dep = depmidpoint[i]
		local dur = first_bound*(high_tod-i+1)+second_bound*(i-low_tod+1)
		dur = 0.25 + (dur-1)/2
		utility[i] = sarr_1(arr) + sdep_1(dep) +
		dur * (work * beta_dur_1_work + edu * beta_dur_1_edu + personal * beta_dur_1_personal + rec * beta_dur_1_rec + shop * beta_dur_1_shop + escort * beta_dur_1_escort) + 
		pow(dur,2) * (work * beta_dur_2_work + edu * beta_dur_2_edu + personal * beta_dur_2_personal + rec * beta_dur_2_rec + shop * beta_dur_2_shop + escort * beta_dur_2_escort) + beta_tt * dbparams:TT(i)
	end

end

-- AVAILABUILITY
local availability = {}
local function computeAvailabilities(params,dbparams)
	for i = 1, 48 do 
		availability[i] = dbparams:availability(i)
	end
end

-- SCALE
local scale = 1

function choose_itd(params,dbparams)
	computeUtilities(params,dbparams) 
	computeAvailabilities(params,dbparams)
	local probability = calculate_probability("mnl", choiceset, utility, availability, scale)
	
	prob = 0.0
	for i = 1,48 do
		prob = prob + probability[i]
	end

	if prob < 0.0001 then
		return -1
	else
		return make_final_choice(probability)
	end 
end

