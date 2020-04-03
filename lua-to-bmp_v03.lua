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

local save_to = {}


function save_to.bmp (filename, header, data)
		
	local stream = data.stream or {} -- effective bytes, two bytes for color
	
	if data.grayscale_stream then -- 0 is black, 1 is white
		if not (data.x_reverse) then
			for i, number in pairs (data.grayscale_stream) do
				local value = math.floor(number*255) -- three same values [0, 255]
				value = data.negative and (255-value) or value
				table.insert (stream, value)
				table.insert (stream, value)
				table.insert (stream, value)
			end
		else
			for i= #data.grayscale_stream, 1, -1 do
				number = data.grayscale_stream[i]
				local value = math.floor(number*255) -- three same values [0, 255]
				value = data.negative and (255-value) or value
				table.insert (stream, value)
				table.insert (stream, value)
				table.insert (stream, value)
			end
		end
	end
	
	if data.rgb_pixels then -- 0 is black, 1 is white
		for i, pixel in pairs (data.rgb_pixels) do
			table.insert (stream, pixel.b or 0) -- yeah, wrong direction
			table.insert (stream, pixel.g or 0)
			table.insert (stream, pixel.r or 0)
		end
	end
	
	-- stream is ready, it contents numbers in range [0, 255], it will be used as binar symbol number
	-- 
	---------------------------------------------------------------------------------

	local width = header and header.width or 128
	local black_bytes = width%4 -- 0 by w=4, 1 by w=5, 2 by w=6, 3 by w=7, 0 by w=8
	
	local width_bytes_1 = width*3
	local width_bytes_2 = width_bytes_1 + black_bytes
	
	
	local height = header and header.height or 128
	local bit_per_pixel = header and header.bit_per_pixel or 24
	
--	local size = 54 + ((6*width) + black_bytes)*height
	local size = 54 + ((3*width) + black_bytes)*height

	
	
--	127 127 127  127 127 127 0 0 
--  127 127 127  127 127 127 0 0



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
--			print (a)
			t[n+offset] = a
			num = (num-a)/256
			offset = offset+1
--			print (num)
		end
	end

	-- body from 55 to the last byte
	--for i=55, size do t[i] = math.random(0,255) end

		for i=1, #stream do 
			t[i+54] = stream[i]
			
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
	
	local str = string.char(unpack(t, 1, 54)) -- unpack header
	print ('str1:' .. #str)
	print ('t:' .. #t .. ' height:' ..height .. ' width_bytes_1:' .. width_bytes_1 )
	
	
	for line = 1, height do
		local from = (line-1) * width_bytes_1 + 1 +54
		local to = (line) * width_bytes_1 +54
		print ('from:'.. from .. ' to:' .. to)
		str = str .. string.char(unpack(t, from, to))
		local i = black_bytes
		while i > 0 do
			str = str .. string.char(0)
			i = i - 1
		end
	end
	print ('str2:' .. #str)
--	local str = megaunpack (t, 1, 54) -- 
	--print (str)

	local out = io.open(('output/' .. filename .. '.bmp'), "w")
	out:write(str)
	out:close()

end

return save_to