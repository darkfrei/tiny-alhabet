local File = assert(io.open('D:/Lua/ZBS/myprograms/my/a.bmp'))
local bytecode = File:read("*all")
local size = #bytecode

--[[
local bytes = {}
for i = 1, size do
	local byte = bytecode:byte(i)
	table.insert (bytes, byte)
end
local str = ""
for i, v in pairs (bytes) do
	str = str .. ' ' .. v
end
print (str) 
]]

print (("size: " .. size))

local bmp_structure = { 
	typ = {offset = 1, length = 2}, -- returns 19778, magic value for BMP-format
	off_bits = {offset = 11, length = 2}, -- returns 54 bytes, amount of system bytes
	width = {offset = 19, length = 4}, -- returns width in pixels without last black pixel
	height = {offset = 23, length = 4}, -- returns height in pixels
	bit_count = {offset = 29, length = 2}, -- must be 24 bits per color; one byte for subpixel
	compression = {offset = 31, length = 4} -- must me 0
}

function read_bytes (tabl)
	local n = 0
	local offset = tabl.offset or 1
	local length = tabl.length or 1
	for i = 0, (length-1) do
		local byte = bytecode:byte(offset+i) and 256^i * bytecode:byte(offset+i) or 0
		n = n + byte
	end
	return n
end


--print ('bmp_structure.typ: ' .. read_bytes (bmp_structure.typ)) -- always 19778

for name, tabl in pairs (bmp_structure) do
	local value = read_bytes (tabl)
	print (name..': ' .. value)
	tabl.value = value
end

local offset_data = bmp_structure.off_bits.value + 1

print ('offset_data: ' .. offset_data)
local bmp_data_x = {}
local bmp_data_y = {}
local n = 1
local width = bmp_structure.width.value + 1 -- last hidden pixel is black
local height = bmp_structure.height.value
local x = 1
local y = height
for i = offset_data, size, 3 do
	
	local pixel = {}
	local str = ''
	for j, sp in pairs ({'r', 'g', 'b'}) do
		local byte = bytecode:byte(i+3-j) -- wow
		pixel[sp] = byte -- sp is subpixel
		str = str .. sp  .. ':' .. byte .. ' '
	end
	if not bmp_data_x[x] then bmp_data_x[x] = {} end
	if not bmp_data_y[y] then bmp_data_y[y] = {} end
	if not (x == width) then -- without last black pixel 
--		print ('x:' .. x ..  ' y:' .. y .. ' pixel:' .. str)
		bmp_data_x[x][y] = pixel
		bmp_data_y[y][x] = pixel
	end
	x = x + 1
	if x > width then
		x = 1
		y = y-1
	end
	n=n+1
end
print ('n:' .. n)


--for x, ys in pairs (bmp_data_x) do
--	for y, pixel in pairs (ys) do
--		local str = ''
--		for i, sp in pairs ({'r', 'g', 'b'}) do
--			local value = pixel[sp]
--			str = str .. sp .. ':' .. value .. ' '
--		end
--		print ('x:' .. x .. ' y:' .. y .. ' color: ' .. str)
--	end
--end

for y, xs in pairs (bmp_data_y) do
	for x, pixel in pairs (xs) do
		local str = ''
		for i, sp in pairs ({'r', 'g', 'b'}) do
			local value = pixel[sp]
			str = str .. sp .. ':' .. value .. ' '
		end
		print ('x:' .. x .. ' y:' .. y .. ' color: ' .. str)
	end
end




