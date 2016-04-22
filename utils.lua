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

function utils.max(t)
    local result = -math.huge
    for key,value in pairs(t) do
        if value > result then
            result = value
        end
    end
    return result
end

function utils.min(t)
    local result = math.huge
    for key,value in pairs(t) do
        if value < result then
            result = value
        end
    end
    return result
end

function utils.avg(t)
    local result = 0
    local count = 0
    for key,value in pairs(t) do
        result = result + value
        count = count + 1
    end
    if count > 0 then
        return result / count
    else
        return 0
    end
end

function utils.lineStipple(x1, y1, x2, y2, dash, gap)
    local dash = dash or 5
    local gap  = dash + (gap or 0)
 
    local steep = math.abs(y2-y1) > math.abs(x2-x1)
    if steep then
        x1, y1 = y1, x1
        x2, y2 = y2, x2
    end
    if x1 > x2 then
        x1, x2 = x2, x1
        y1, y2 = y2, y1
    end
 
    local dx = x2 - x1
    local dy = math.abs( y2 - y1 )
    local err = dx / 2
    local ystep = (y1 < y2) and 1 or -1
    local y = y1
    local maxX = x2
    local pixelCount = 0
    local isDash = true
    local lastA, lastB, a, b
 
    for x = x1, maxX do
        pixelCount = pixelCount + 1
        if (isDash and pixelCount == dash) or (not isDash and pixelCount == gap) then
            pixelCount = 0
            isDash = not isDash
            a = steep and y or x
            b = steep and x or y
            if lastA then
                love.graphics.line(lastA, lastB, a, b)
                lastA = nil
                lastB = nil
            else
                lastA = a
                lastB = b
            end
        end
 
        err = err - dy
        if err < 0 then
            y = y + ystep
            err = err + dx
        end
    end
end