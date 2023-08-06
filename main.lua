local BaseMap = {}

local function Lookup(Table)
	local Lookup = {}
	
	for Index, Value in next, Table do
		Lookup[Value] = Index
	end
	
	return Lookup
end

function BaseMap.new(Map)
	local N = #Map + 1
	local LookupMap = Lookup(Map)

	local Max, Total, Limit = 0, 0
	
	repeat 
	    Max = Max + 1
	    Total = Total + N ^ Max
	    Limit = Total >= 0x10FFFF
	until Limit
	
	Max = Max - 1
	
	local Base = {}
	
	function Base.Encode(String)
		return string.gsub(String, "." .. string.rep(".?", Max - 1), function(String)
			local Number = 0
			
			for Index = 1, Max do
				local Cut = string.sub(String, Index, Index)
				
				if Cut ~= "" then
					Number = Number + LookupMap[Cut] * N ^ (Index - 1)
				end
			end

			return utf8.char(Number)
		end)
	end
	
	function Base.Decode(String)
		return string.gsub(String, "([%z\1-\127\194-\244][\128-\191]*)", function(String)
			local Number
		
		    for i = 1, #String do
		        local c = string.byte(String, i)
		
		        Number = (i == 1) and bit32.band(c, (2 ^ (8 - (c < 0x80 and 1 or c < 0xE0 and 2 or c < 0xF0 and 3 or c < 0xF8 and 4 or c < 0xFC and 5 or c < 0xFE and 6)) - 1)) or (bit32.lshift(Number, 6) + bit32.band(c, 0x3F))
		    end
		    
		    local Decoded = {}
		    
			for Index = 1, Max do
				local n = math.floor((Number / (N ^ (Index - 1))) % N)
				
				table.insert(Decoded, Map[n])
				
				Number = Number - n
			end
			
			return table.concat(Decoded)
		end)
	end
	
	return Base
end

return BaseMap
