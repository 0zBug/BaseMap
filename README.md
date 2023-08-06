# BaseMap
```lua
local Map = {" ", "!"}

for i = 97, 122 do
	table.insert(Map, string.char(i))
end

local Base = BaseMap.new(Map)

local String = "basemap is awesome!"
local Encoded = Base.Encode(String)
local Decoded = Base.Decode(Encoded)

print(#String) --> 19
print(#Encoded) --> 17
print(Decoded) --> basemap is awesome!
print(String == Decoded) --> true

local Base = BaseMap.new({"a", "b"})

local String = "abbabababbbbabababaaaababbbababbbbbbaaa"
local Encoded = Base.Encode(String)
local Decoded = Base.Decode(Encoded)

print(#String) --> 39
print(#Encoded) --> 13
print(Decoded) --> abbabababbbbabababaaaababbbababbbbbbaaa
print(String == Decoded) --> true
```
