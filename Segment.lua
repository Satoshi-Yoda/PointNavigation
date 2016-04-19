require "Converter"

Segment = {}
Segment.__index = Segment

Segment.IMAGE = love.graphics.newImage("_pic/0.png")

function Segment.create(number, base)
	local new = {}
	setmetatable(new, Segment)

	new.number = number

	new.x = 0
	new.y = 0
	new.a = 0

	if number == 0 then
		new.length = Converter.ELEMENT_0_LENGTH
	elseif number == 1 then
		new.length = Converter.ELEMENT_1_LENGTH
	elseif number == 2 then
		new.length = Converter.ELEMENT_2_LENGTH
	elseif number == 3 then
		new.length = Converter.ELEMENT_3_LENGTH
	end

	new.image = love.graphics.newImage("_pic/" .. number .. ".png")

	if base ~= nil then
		new.base = base
	else 
		new.base = nil
	end

	return new
end

function Segment:setAngle(angle)
	self.a = angle
end

function Segment:getBasePosition()
	if self.base ~= nil then
		local x, y, a = self.base:getBasePosition()
		x = x + self.base.length * math.sin(a)
		y = y + self.base.length * math.cos(a)
		return x, y, a + self.a
	else
		local x, y, a = Converter.BASE_X, Converter.BASE_Y, self.a
		return x, y, a
	end
end

function Segment:update(dt)

end

function Segment:draw(camera)
	local x, y, a = self:getBasePosition()

	local sx, sy = 0, 0
	if self.number == 0 then
		sx, sy = 30, 30
	elseif self.number == 1 then
		sx, sy = 24, 52
	elseif self.number == 2 then
		sx, sy = 28, 36
	elseif self.number == 3 then
		sx, sy = 59, 59
	end

	love.graphics.draw(self.image, x, y, -a, 1, 1, sx, sy)
end
