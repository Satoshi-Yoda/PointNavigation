utils = {}
utils.math = {}

function utils.math.clamp(low, x, high)
	return math.min(math.max(low, x), high)
end

function utils.math.rotate(x, y, angle)
	local rx = x * math.cos(angle) - y * math.sin(angle)
	local ry = x * math.sin(angle) + y * math.cos(angle)
	return rx, ry
end

function utils.math.normalize(x, y, length)
	local l = math.sqrt(x * x + y * y)
	local nx = x * length / l
	local ny = y * length / l
	return nx, ny
end

function utils.math.length(x, y)
	return math.sqrt(x * x + y * y)
end

function utils.math.distance(x1, y1, x2, y2)
	return math.sqrt((x1-x2) * (x1-x2) + (y1-y2) * (y1-y2))
end

function utils.math.sign(x)
	if x > 0 then
		return 1
	elseif x < 0 then
		return -1
	else
		return 0
	end
end
