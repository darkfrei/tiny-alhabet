--local out = io.open("file.bin", "wb")
--local str = string.char(72,101,108,108,111,10) -- "Hello\n"
--out:write(str)
--out:close()

--local nfile = assert(io.open("b.bmp", "w"))

--66 77 102 0 0 0 0 0 0 0 54 0 0 0 40 0 0 0 4   0 0 0  4 0 0 0 1 0 24 0 0 0 0 0 0 0 0 0 196 14 0 0 196 14 0 0 0 0 0 0 0 0 0 0 -- 4x4
--66 77 54  3 0 0 0 0 0 0 54 0 0 0 40 0 0 0 16  0 0 0 16 0 0 0 1 0 24 0 0 0 0 0 0 0 0 0 196 14 0 0 196 14 0 0 0 0 0 0 0 0 0 0 -- 16x16
--66 77 54 48 0 0 0 0 0 0 54 0 0 0 40 0 0 0 128 0 0 0 32 0 0 0 1 0 24 0 0 0 0 0 0 0 0 0 196 14 0 0 196 14 0 0 0 0 0 0 0 0 0 0 -- 128x32
 print ('first bytes ' .. 66 + 256*77)
 print ('bytes ' .. 54 + 256*3)

local width = 128
local height = 32
local bit_per_pixel = 24
local size = 54 + width*height*(bit_per_pixel/8)

local bmp_header = 
	{
		{1, 19778},
		{3, size},
		{11, 54},
		{15, 40},
		{19, width},
		{23, height},
		{27, 1},
		{29, bit_per_pixel},
		{31, 0},
		{39, 3780},
		{43, 3780}
	}

local t = {}
for i=1,size do t[i] = 0 end

for i, v in pairs (bmp_header) do
	local n = v[1]
	local num = v[2]
	local offset = 0
	while num > 0 do
		local a = num%256
		print (a)
		t[n+offset] = a
		num = (num-a)/256
		offset = offset+1
		print (num)
	end
end

-- body from 55 to the last byte
--for i=55, size do t[i] = math.random(0,255) end


for i=55, size, 6 do 
	t[i] = 255  -- blue
	t[i+1] = 255 -- green
	t[i+2] = 255 -- red
end



function megaunpack (t)
	local str = ""
	local step = 512
	for i = 1, #t, step do
		local min = math.min(i+step-1, #t)
		local s_str = string.char(unpack(t, i, min))
--		print (s_str)
		str = str .. s_str
	end
	return str
end

--local str = string.char(unpack(t))
local str = megaunpack (t)
--print (str)

local out = io.open("my/c.bmp", "w")
out:write(str)
out:close()
