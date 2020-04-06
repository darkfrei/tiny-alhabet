local save_to = require ('lua-to-bmp_v04')
		
local width = 98 -- it works up to 98x98, but I cannot make it bigger
local height = 98


local grayscale = {}

local gradient_length = width

for i = 1, (width*height) do
--	table.insert (grayscale, math.random())
--	table.insert (grayscale, (i-1)/(width*height))
	table.insert (grayscale, ((i-1)%width)/(width-1)) -- gradient
end

--print (unpack (grayscale, 1, width))

local y = 1

for i = 1, (height*width) do
	local x = (i-1)%width + 1
	local s = width
	local color = ((i-1)%s)/(s-1)
	print (x .. ' ' .. y .. ' ' .. color)
	if x == y then -- diagonal
		grayscale[i] = 1-color
	end
	
	-- preparing for the next cycle
	if (x+1) > width then
		y = y+1
	end
end




--for i = 1, (width*height) do
--	x = ((i)%(width))+1
--	if x == y then
--		if x < (width/4) then
--			grayscale[i] = 1
--		else
--			grayscale[i] = 0
--		end
--	end
--	if (x+1) > width then
--		y = y+1
--	end
--end



--local from = (width*(height-2)+5) -- first pixel on last line
--local to = (width*height) -- last pixel

--for i = from, to do -- smooth gradient on the last line
--	local gray = (i-from)/(2*width) -- exactly one white pixel and exactly one black pixel
--	grayscale[i] = 1-gray
--end

save_to.bmp ('my_random_' .. width .. 'x' .. height, {width=width, height=height, bit_per_pixel=24}, 
			{grayscale_stream = grayscale, negative = true, stream_reverse = false, y_reverse = true})