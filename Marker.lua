require "Converter"

Marker = {}
Marker.__index = Marker

Marker.IMAGE = love.graphics.newImage("_pic/red-point.png")

function Marker.create()
	local new = {}
	setmetatable(new, Marker)

	new.x = 0
	new.y = 0

	return new
end

function Marker:update(dt)
	self.x, self.y = Converter:getPositionForAngles(global.zero.a, global.first.a, global.second.a, global.third.a, 4)
end

function Marker:draw(camera)
	love.graphics.draw(Marker.IMAGE, self.x, self.y, 0, 1, 1, Marker.IMAGE:getWidth()/2, Marker.IMAGE:getHeight()/2)
end
