
local File = assert(io.open('output/4_5254.bmp', 'rb'))

--	black pixels per row:
--		1	2	3	0	1	2	3	0	1
--
--	size in bytes by width and height in pixels:
--  h\w	1	2	3	4	5	6	7	8	9
-- _____________________________________________
--|	1	58	62	66	66	70	74	78	78
--|	2	62	70	78	78	86	94	102	102
--|	3	66	78	90	90	102	114			
--|	4	70	86		102					166
--|	5	74	94			134
--|	6	78	102				174
--|_____________________________________________

local bytecode = File:read("*all")
--local bytecode = File:read("*a")
--File:close()
local size = #bytecode
print ("size: " .. size)

-----------------
local bytes = {}
local str = ""
for i = 1, size do
	local byte = bytecode:byte(i)
	str = str .. ' ' .. byte
	table.insert (bytes, byte)
end
print (str) 
-----------------

local bmp_structure = { 
	typ = {offset = 1, length = 2}, -- returns 19778, magic value for BMP-format
--	off_bytes = {offset = 11, length = 2}, -- returns 54 bytes, amount of system bytes
	off_bytes = {offset = 11, length = 1}, -- returns 54 bytes, amount of system bytes
	width = {offset = 19, length = 4}, -- returns width in pixels without last black pixel(s)
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

local offset_data = bmp_structure.off_bytes.value + 1

print ('offset_data: ' .. offset_data)
local bmp_data_x = {}
local bmp_data_y = {}
local n = 0
local width = bmp_structure.width.value
local height = bmp_structure.height.value
local n_pixels = width * height
print ('n_pixels:' .. n_pixels)
local x = 1
--local y = height
local y = 1
local bit_count = bmp_structure.bit_count.value

function get_24_bit_data (bytecode, offset_data, size, width, height)
	local pixels = {}
	local x = 1
	local y = height
	for i = offset_data, size, 3 do
		local pixel = {}
		local str = ''
		for j, sp in pairs ({'r', 'g', 'b'}) do
			local byte = bytecode:byte(i+3-j) or 0 -- wow
			pixel[sp] = byte -- sp is subpixel
			str = str .. sp  .. ':' .. byte .. ' '
		end
		pixel.x = x
		pixel.y = y
		if y > 0 then
			table.insert (pixels, pixel)
--			print ('x:' .. x .. ' y:' .. y .. ' str: ' .. str)
			x = x + 1
			if x > width then
				x = 1
				y = y-1
			end
		end
	end
	print ('#pixels:' .. #pixels)
	return pixels
end

if bit_count == 24 then
	print ('24 bit color')
	bmp_data_x = get_24_bit_data (bytecode, offset_data, size, width, height)
	
elseif bit_count == 8 then
	print ('8 bit color')
	
end



