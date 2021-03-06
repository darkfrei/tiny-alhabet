function my_serpent (tabl)
	local s = "{"
	for i, v in pairs (tabl) do
		local v2 = v
		if type (v) == 'table' then
			v2 = my_serpent (v)
		end
		s = s .. tostring(i) .. ' = ' .. v2 .. ', ' 
	end
	s = string.sub(s, 1, -3) .. '}'
	return s
end

function toBits(num)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        local rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    return t
end






--print (my_serpent (slots))

--[[            x1   x2    x3    x4
1 1 0 1 -- y1    1    2     0     8
1 0 1 1 -- y2   16    0    64   128
1 0 1 1 -- y3  256    0  1024  2048
1 1 1 1 -- y4 2096 8192 16384 32768
]]

function print_cells (cells, num)
	local g = {}
	for i, cell in pairs (cells) do
		if not g[cell.y] then g[cell.y] = {} end
		if not g[cell.y][cell.x] then g[cell.y][cell.x] = cell.bit end
	end
	
	print ('')
	if num then	print (num)	end
	for y, xs in pairs (g) do
		local y_str = ''
		for x, bit in pairs (xs) do
			y_str = y_str .. bit
		end
		print (y_str)
	end
--	print (my_serpent (cells))
end


function min_amount_neigbours (tabl) -- tabl is candidate to tabls; bit as 0 or 1
	local cells = tabl.cells -- list of cells; every cell contains: x, y, bit
--	print_cells (cells)
--	print(my_serpent (cells))
	local grid = tabl.grid -- grid[x][y] gives bit of this cell
	local min_b = #cells -- black, big enough
	local min_w = #cells -- white
	local shifts = {
			{-1,-1}, {0,-1}, {1,-1}, 
			{-1, 0},		 {1, 0}, 
			{-1, 1}, {0, 1}, {1, 1}} -- neigbours
	for i, cell in pairs (cells) do
		if (cell.bit == 1) then -- only for black cells
			local n_b = 0 -- black
			local n_w = 0 -- white
			for a = 1, 8 do
				local shift = shifts[a]
				local x = cell.x + shift[1]
				local y = cell.y + shift[2]
				if grid[x] and grid[x][y] then
					if (grid[x][y] == 1) then
						n_b = n_b + 1
					else
						n_w = n_w + 1
					end
				end
			end
			if n_b < min_b then min_b = n_b end
			if n_w < min_w then min_w = n_w end
		end
	end
	return {b = min_b, w = min_w}
end

function all_columns_and_rows (cells)
	local xs = {}
	local ys = {}
	for i, cell in pairs (cells) do
		local x = cell.x
		local y = cell.y
		local bit = cell.bit
		if not xs[y] then 
			xs[y] = bit 
		elseif (bit == 1) and (xs[y] == 0) then
			xs[y] = 1
		end
		if not ys[x] then 
			ys[x] = bit 
		elseif (bit == 1) and (ys[x] == 0) then
			ys[x] = 1
		end
	end
	for y, bit in pairs (xs) do
		if bit == 0 then
			return false
		end
	end
	for x, bit in pairs (ys) do
		if bit == 0 then
			return false
		end
	end
	return true
end


--------------- start
--local tabls = {}
local s = 4 -- size, the side of the square field

local sq = s^2 -- 16 slots
local slots = {}
for i = 0, (sq-1) do
	local x = (i)%s + 1
--	local y = i // s
	local y = math.floor (i/s) + 1
--	print ('x:' .. x .. ' y:' .. y)
	table.insert(slots, {x=x,y=y})
end
local tabls_amount = 0
for num = 1, (2^(s^2) - 1) do -- 1 to 65535
	local bits = toBits(num)
	local tabl = {cells = {}, grid = {}}
	for i = 1, sq  do -- all 16 slots
		local bit = bits[i] or 0
		local slot = slots[i]
		local x = slot.x
		local y = slot.y
		tabl.cells[i] = {x=x, y=y, bit=bit}
		if not tabl.grid[x] then tabl.grid[x] = {} end
		tabl.grid[x][y] = bit
	end
	
	local min = min_amount_neigbours (tabl)
	if (min.b > 0) and (min.w > 0) and all_columns_and_rows (tabl.cells) then
		
		print_cells (tabl.cells, num)
		print ('min.b:' .. min.b .. ' min.w:' .. min.w)
--		table.insert (tabls, tabl)
		tabls_amount = tabls_amount + 1
	end
end

print ('tabls_amount:' .. tabls_amount)
-- 6 for s = 2
-- 162 for s = 3
-- 22640 for s = 4
-- 11941010 for s = 5 (too much, less than 33 mio.)

